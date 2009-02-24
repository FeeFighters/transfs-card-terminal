//
//  TransFS_Card_TerminalAppDelegate.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/2/09.
//  Copyright TransFS.com 2009. All rights reserved.
//

#import "TransFS_Card_TerminalAppDelegate.h"
#import "StartViewController.h"
#import "CardViewController.h"
#import "ProcessViewController.h"
#import "Transaction.h"

// Private interface for AppDelegate - internal only methods.
@interface TransFS_Card_TerminalAppDelegate (Private)
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)initializeDatabase;
@end

@implementation TransFS_Card_TerminalAppDelegate

@synthesize startViewController, cardViewController, processViewController;
@synthesize window;
@synthesize tabBarController;
@synthesize transactionHistory;

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	// The application ships with a default database in its bundle. If anything in the application
	// bundle is altered, the code sign will fail. We want the database to be editable by users, 
	// so we need to create a copy of it in the application's Documents directory.     
	[self createEditableCopyOfDatabaseIfNeeded];
	// Call internal method to initialize database connection
	[self initializeDatabase];
	
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
}


// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	
}

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
    NSMutableArray *transactionHistoryArray = [[NSMutableArray alloc] init];
    self.transactionHistory = transactionHistoryArray;
    [transactionHistoryArray release];
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

- (void) resetTransactionFields
{
	[[startViewController dollarAmountField] setText:@"."];
	[startViewController textFieldDidChange];
}

- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

