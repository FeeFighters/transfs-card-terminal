//
//  HistoryDetailViewController.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/24/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "HistoryDetailViewController.h"


@implementation HistoryDetailViewController

@synthesize transaction;

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

- (void)viewWillAppear:(BOOL)animated {
	[firstName setText:[transaction firstName]];
	[lastName setText:[transaction lastName]];
	[amount setText:[NSString stringWithFormat:@"$%.2f", [[transaction moneyAmount] dollars]]];

	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[date setText:[dateFormatter stringFromDate:transaction.date]];

	[transactionId setText:[transaction authorizationId]];
	[sanitizedCardNumber setText:[transaction sanitizedCardNumber]];

	if (transaction.status == TransactionVoided) {
		[voidResponseLabel setText:@"Transaction Voided."];
		[voidResponseLabel setHidden:false];
		[voidTransactionButton setHidden:true];
	} else {
		[voidResponseLabel setHidden:true];
		[voidTransactionButton setHidden:false];
	}

	[super viewWillAppear:animated];
}


- (IBAction) voidButtonClick:(id)sender
{
	UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:@"Void Transaction?"
													   delegate:self
											  cancelButtonTitle:nil
										 destructiveButtonTitle:@"Cancel"
											  otherButtonTitles:nil];
	[alert addButtonWithTitle:@"Yes, Void!"];

	[alert showInView:self.tabBarController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex==0) //Cancel
	{
	}
	else if (buttonIndex==1)
	{
		[voidResponseLabel setText:@"Transaction Voided."];
		[voidResponseLabel setHidden:false];
		[voidTransactionButton setHidden:true];
		[NSThread detachNewThreadSelector:@selector(voidTransactionThread) toTarget:self withObject:nil];
	}
}

- (void) voidTransactionThread
{
	[NSThread sleepForTimeInterval:0.5];

	BillingGateway *gateway = [(TransFS_Card_TerminalAppDelegate*)[[UIApplication sharedApplication] delegate] setupGateway];
	[transaction voidTransaction:gateway];

	if (transaction.status == TransactionVoided) {
		[voidResponseLabel setText:@"Transaction Voided."];
		[voidResponseLabel setHidden:false];
	} else {
		[voidResponseLabel setText:[transaction errorMessages]];
		[voidResponseLabel setHidden:false];
		[voidTransactionButton setHidden:false];
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
