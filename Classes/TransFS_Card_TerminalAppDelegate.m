//
//  TransFS_Card_TerminalAppDelegate.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/2/09.
//  Copyright TransFS.com 2009. All rights reserved.
//

#import "TransFS_Card_TerminalAppDelegate.h"
#import "Transaction.h"
#import "ZipCode.h"
#import "SettingsIndexViewController.h"
#import "AuthorizeNetGateway.h"
#import "PaypalGateway.h"
#import "UsaEpayGateway.h"
#import "Reachability.h"


// Private interface for AppDelegate - internal only methods.
@interface TransFS_Card_TerminalAppDelegate (Private)
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)initializeDatabase;
- (void)startSplashAnim:(id)obj;
- (void)splashScreenAnimDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@implementation TransFS_Card_TerminalAppDelegate

@synthesize historyTableNavigationController, chargeViewController;

@synthesize window, tabBarController;
@synthesize splashScreenView, splashScreenTopView, splashScreenBottomView, splashScreenTitleView, splashScreenIconView;
@synthesize splashScreenSpinner, splashScreenPressToBegin, splashScreenAboutSettings;
@synthesize transactionHistory, database, keyboardClickSoundID;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	// Set up the text that we'll show in the splash screen
	bool showSetupMessage = [[NSUserDefaults standardUserDefaults] boolForKey:@"showSetupMessage"];
	if (showSetupMessage) {
		splashScreenSpinner.hidden = true;
		splashScreenIconView.hidden = true;
		splashScreenAboutSettings.hidden = false;
		splashScreenPressToBegin.hidden = false;
		[[NSUserDefaults standardUserDefaults] setBool:false forKey:@"showSetupMessage"];
		tabBarController.selectedIndex = 2;
	}
	else {
		splashScreenAboutSettings.hidden = true;
		splashScreenPressToBegin.hidden = true;
		splashScreenIconView.hidden = false;
		splashScreenSpinner.hidden = false;
	}

	// Add the views that we'll need, if showSplashScreen setting
	bool showSplashScreen = [[NSUserDefaults standardUserDefaults] boolForKey:@"showSplashScreen"];
	if (showSplashScreen) {
		[window addSubview:splashScreenView];
		[window insertSubview:tabBarController.view belowSubview:splashScreenView];
	} else {
		[window addSubview:tabBarController.view];
	}

	// The application ships with a default database in its bundle. If anything in the application
	// bundle is altered, the code sign will fail. We want the database to be editable by users,
	// so we need to create a copy of it in the application's Documents directory.
	[self createEditableCopyOfDatabaseIfNeeded];
	// Call internal method to initialize database connection
	[self initializeDatabase];

	CFURLRef tockSoundFileURLRef = CFBundleCopyResourceURL(CFBundleGetBundleWithIdentifier(CFSTR("com.apple.UIKit")),
													   CFSTR ("Tock"), CFSTR("aiff"), NULL);
	AudioServicesCreateSystemSoundID(tockSoundFileURLRef, &keyboardClickSoundID);

	gatewayHostReach = NULL;
	[self setupReachability];

	// Kick off a delayed animation to get rid of the splash screen
	if (showSetupMessage || !showSplashScreen) {
		// do nothing
	} else {
		[self performSelector:@selector(startSplashAnim:) withObject:nil afterDelay:2.0];
	}
}

- (IBAction) aboutSettingsPressed:(id)sender
{
	[self startSplashAnim:nil];
}

- (void)startSplashAnim:(id)obj
{
	[UIView beginAnimations:nil context:NULL];
	{
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.5];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(splashScreenAnimDidStop:finished:context:)];
		//splashScreenView.alpha = 0.0;
		int slideDown = (620 - splashScreenBottomView.center.y);
		splashScreenTopView.center = CGPointMake(splashScreenTopView.center.x, -100);
		splashScreenBottomView.center = CGPointMake(splashScreenBottomView.center.x, splashScreenBottomView.center.y + slideDown);
		splashScreenTitleView.center = CGPointMake(-160, splashScreenTitleView.center.y + slideDown);
		splashScreenIconView.center = CGPointMake(480, splashScreenIconView.center.y + slideDown);
		splashScreenSpinner.alpha = 0.0;
	}
	[UIView commitAnimations];
}

- (void)splashScreenAnimDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	[splashScreenView removeFromSuperview];
}

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {

}
*/
/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/



// Creates a writable copy of the bundled default database in the application Documents directory.
- (void)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"transactionHistory.sql"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"transactionHistory.sql"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

// Open the database connection and retrieve minimal information for all objects.
- (void)initializeDatabase {
    self.transactionHistory = [[NSMutableArray alloc] init];
    // The database is stored in the application bundle.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"transactionHistory.sql"];
    // Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT pk FROM transactions";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            // We "step" through the results - once for each row.
            while (sqlite3_step(statement) == SQLITE_ROW) {
                // The second parameter indicates the column index into the result set.
                int primaryKey = sqlite3_column_int(statement, 0);
                // We avoid the alloc-init-autorelease pattern here because we are in a tight loop and
                // autorelease is slightly more expensive than release. This design choice has nothing to do with
                // actual memory management - at the end of this block of code, all the book objects allocated
                // here will be in memory regardless of whether we use autorelease or release, because they are
                // retained by the books array.
                Transaction *transaction = [[Transaction alloc] initWithPrimaryKey:primaryKey database:database];
                [transactionHistory addObject:transaction];
                [transaction release];
            }
        }
        // "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
    } else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
        // Additional error handling, as appropriate...
    }
}

// Save all changes to the database, then close it.
- (void)applicationWillTerminate:(UIApplication *)application {
    // Save changes.
    [transactionHistory makeObjectsPerformSelector:@selector(dehydrate)];
    [Transaction finalizeStatements];
    [ZipCode finalizeStatements];
    // Close the database.
    if (sqlite3_close(database) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
    }
}

// Insert a new book into the database and add it to the array of books.
- (void)addTransaction:(Transaction *)transaction {
    // Create a new record in the database and get its automatically generated primary key.
    [transaction insertIntoDatabase:database];
    [transactionHistory addObject:transaction];
}

// Remove a specific transaction from the array of transactions and also from the database.
- (void)removeTransaction:(Transaction *)transaction {
    // Delete from the database first. The transaction knows how to do this (see Transaction.m)
    [transaction deleteFromDatabase];
    [transactionHistory removeObject:transaction];
}

- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}


- (BillingGateway*) setupGateway
{
	int gatewayIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"gatewayId"];
	bool testMode = true;
	BillingGateway* gateway;

	if (gatewayIndex == authNet) {

		NSString *login = [[NSUserDefaults standardUserDefaults] stringForKey:@"authNetLogin"];
		if ([NSString isBlank:login]) login = @"";
		NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"authNetPassword"];
		if ([NSString isBlank:password]) password = @"";
		testMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"authNetTestMode"];

		gateway = [[AuthorizeNetGateway alloc] init:[NSDictionary dictionaryWithObjectsAndKeys:
																		  login, @"login",
																		  password, @"password",
																		  nil]];

	}
	else if (gatewayIndex == paypal) {

		NSString *login = [[NSUserDefaults standardUserDefaults] stringForKey:@"paypalLogin"];
		if ([NSString isBlank:login]) login = @"";
		NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"paypalPassword"];
		if ([NSString isBlank:password]) password = @"";
		NSString *signature = [[NSUserDefaults standardUserDefaults] stringForKey:@"paypalSignature"];
			if ([NSString isBlank:signature]) signature = @"";
		testMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"paypalTestMode"];

		gateway = [[PaypalGateway alloc] init:[NSDictionary dictionaryWithObjectsAndKeys:
																		  login, @"login",
																		  password, @"password",
																		  signature, @"signature",
																		  nil]];

	}
	else {			/* if (gatewayIndex == usaEpay) { */

		NSString *sourcekey = [[NSUserDefaults standardUserDefaults] stringForKey:@"usaEpaySourceKey"];
		if ([NSString isBlank:sourcekey]) sourcekey = @"";
		testMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"usaEpayTestMode"];

		gateway = [[UsaEpayGateway alloc] init:[NSDictionary dictionaryWithObjectsAndKeys:
																		  sourcekey, @"login",
																		  nil]];

	}

	if (testMode) [BillingBase setGatewayMode:Test];

	return gateway;
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);

  NetworkStatus netStatus = [curReach currentReachabilityStatus];
  //BOOL connectionRequired= [curReach connectionRequired];

	if (netStatus == NotReachable) {
		[self.chargeViewController.processButton setTitle:@"You must be connected to the internet to process transactions."
                                             forState:UIControlStateNormal];
		self.chargeViewController.processButton.titleLabel.font = [UIFont systemFontOfSize: 14];
		self.chargeViewController.processButton.titleLabel.textAlignment = UITextAlignmentCenter;
		[self.chargeViewController.processButton setTitleColor:[UIColor redColor]
                                                  forState:UIControlStateNormal];
		self.chargeViewController.processButton.enabled = NO;
	}
	else {
		[self.chargeViewController.processButton setTitle:@"Process Transaction"
                                             forState:UIControlStateNormal];
		self.chargeViewController.processButton.titleLabel.font = [UIFont systemFontOfSize: 18];
		[self.chargeViewController.processButton setTitleColor:[UIColor colorWithRed:50.0/256.0 green:79.0/256.0 blue:133.0/256.0 alpha:1.0]
                                                  forState:UIControlStateNormal];
		self.chargeViewController.processButton.enabled = YES;
	}
}

- (void) setupReachability
{
	int gatewayIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"gatewayId"];
	NSString *url = [[self setupGateway] endpointUrl];

	// Try to reach the outside world, just to spin up the network if it exists
	[NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://transfs.com/transfs-card-terminal/about"]
                           encoding:NSASCIIStringEncoding
                              error:NULL];

	// Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
	// method "reachabilityChanged" will be called.
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];

	//Change the host name here to change the server your monitoring
	if (gatewayHostReach) [gatewayHostReach release];
	gatewayHostReach = [[Reachability reachabilityWithHostName: url] retain];
	[gatewayHostReach startNotifer];
}



@end

