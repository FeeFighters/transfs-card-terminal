//
//  ChargeCardNumberViewController.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TransFS_Card_TerminalAppDelegate.h"
#import "ChargeViewController.h"
#import "ChargeCardNumberViewController.h"
#import "NSStringAdditions.h"
#import "CreditCard.h"
#import "CreditCardMethods.h"

@implementation ChargeCardNumberViewController

@synthesize numberLabel, number;

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
 	[super viewDidLoad];
	number = [[NSMutableString alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	//	self.navigationItem.prompt = @"TransFS.com Card Terminal";
	self.navigationItem.title = @"Number";

	UIBarButtonItem* nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(goToNextStep)];
	[self.navigationItem setRightBarButtonItem:nextButton animated:YES];
}

// Go to the next data-entry step
- (void) goToNextStep {
	UIViewController* nextViewController = [(ChargeViewController*)[(TransFS_Card_TerminalAppDelegate*)[[UIApplication sharedApplication] delegate] chargeViewController] chargeCardExpViewController];
	[self.navigationController pushViewController:nextViewController animated:true];
}

// Clear data for this form
- (void) clearData {
	numberLabel.text = @"";
	number = [[NSMutableString alloc] init];
}

- (void) keypadNumberPressed:(int)num button:(UIButton*)sender
{
	if ([number length] < [BillingCreditCard expectedCardNumberLength:number]) {
		[number appendFormat:@"%d", num];
		[numberLabel setText:[BillingCreditCard number:number withSeperator:@" "]];
	}
}

- (void) keypadBackspacePressed:(UIButton*)sender
{
	if (![NSString isBlank:number])
		[number deleteCharactersInRange:NSMakeRange([number length]-1, 1)];
	[numberLabel setText:[BillingCreditCard number:number withSeperator:@" "]];
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
