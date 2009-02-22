//
//  ProcessViewController.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/16/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "ProcessViewController.h"
#import "TransFS_Card_TerminalAppDelegate.h"
#import "CreditCard.h"
#import "CardExpirationPickerDelegate.h"
#import "objCFixes.h"
#import "AuthorizeNetGateway.h"
#import "Base.h"

@implementation ProcessViewController

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction) processButtonClick:(id)sender
{
	[processButton setEnabled:false];
	[spinner startAnimating];
	[spinner setHidden:false];
	[responseLabel setText:@""];
	[NSThread detachNewThreadSelector:@selector(processTransactionThread) toTarget:self withObject:nil];
}

- (void) processTransactionThread
{
	[NSThread sleepForTimeInterval:0.5];
	
	NSString *login = [[NSUserDefaults standardUserDefaults] stringForKey:@"login"];
	if ([NSString is_blank:login])
		login = [NSString stringWithString:@""];
	NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];	
	if ([NSString is_blank:password])
		password = [NSString stringWithString:@""];
	bool testMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"testMode"];
	
	if (testMode) [BillingBase setGatewayMode:Test];
	
	TransFS_Card_TerminalAppDelegate* delegate = (TransFS_Card_TerminalAppDelegate*)[[UIApplication sharedApplication] delegate];
	StartViewController *startViewController = [delegate startViewController];
	CardViewController *cardViewController = [delegate cardViewController];
	//ProcessViewController *processViewController = [delegate processViewController];

	int todayYear = [CardExpirationPickerDelegate currentYear];
	BillingCreditCard *card = [[BillingCreditCard alloc] init:[NSDictionary dictionaryWithObjectsAndKeys:
															   nilToEmptyStr([[cardViewController cardNumberField] text]), @"number",
															   (NSNumber*)MakeInt([[cardViewController monthPicker] selectedRowInComponent:0] + 1), @"month",
															   (NSNumber*)MakeInt(todayYear + [[cardViewController yearPicker] selectedRowInComponent:0]), @"year",
															   nilToEmptyStr([[cardViewController firstNameField] text]), @"firstName",
															   nilToEmptyStr([[cardViewController lastNameField] text]), @"lastName",
															   nilToEmptyStr([[cardViewController cvvNumberField] text]), @"verificationValue",
															   nil]];	
	
	if ([card is_valid])
	{
		AuthorizeNetGateway *gateway = [[AuthorizeNetGateway alloc] init:[NSDictionary dictionaryWithObjectsAndKeys:
																		  login, @"login",
																		  password, @"password",
																		  nil]];
		
		NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
//		[options setObject:@"1240 W Monroe Ave. #1" forKey:@"address1"];
//		[options setObject:@"60607" forKey:@"zip"];
//		[options setObject:@"Chicago" forKey:@"city"];
//		[options setObject:@"IL" forKey:@"state"];		
//		
		NSString* dollarTxt = [[startViewController dollarAmountLabel] text];
		int saleAmount = [dollarTxt floatValue] * 100;
		
		@try {
			BillingResponse *response;	
			response = [gateway authorize:MakeInt(saleAmount) creditcard:card options:[NSDictionary dictionaryWithObject:options forKey:@"address"]];
			if (![response is_success])
				[NSException raise:@"Authorize.Net Gateway Error, authorize:" format:[response message]];
			else {
				
				response = [gateway capture:MakeInt(saleAmount) authorization:[response authorization] options:[[NSDictionary alloc] init]];
				if (![response is_success])
					[NSException raise:@"Authorize.Net Gateway Error, capture:" format:[response message]];
				
//				response = [gateway voidAuthorization:[response authorization] options:[[NSDictionary alloc] init]];
//				if (![response is_success])
//					[NSException raise:@"Authorize.Net Gateway Error, void:" format:[response message]];
			}

			[responseLabel setText:@"Transaction Processed Successfully!"];
		}
		@catch (NSException *exception) {
			[responseLabel setText:[exception reason]];
		}
	}
	else 
	{
		NSLog(@"Card Errors: %@", [[[card errors] fullMessages] componentsJoinedByString:@", "]);
		NSString *err = [[[card errors] fullMessages] componentsJoinedByString:@"\n"];
		[responseLabel setText:err];
	}
	
	
	[spinner stopAnimating];
	[processButton setEnabled:true];
	[NSThread exit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
