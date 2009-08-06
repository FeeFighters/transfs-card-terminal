//
//  ChargeCardCvvViewController.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TransFS_Card_TerminalAppDelegate.h"
#import "ChargeViewController.h"
#import "ChargeCardCvvViewController.h"
#import "NSStringAdditions.h"

@implementation ChargeCardCvvViewController

@synthesize cvvLabel, number;

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
	self.navigationItem.title = @"CVV Code";

	UIBarButtonItem* nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(goToNextStep)];
	[self.navigationItem setRightBarButtonItem:nextButton animated:YES];
}

// Go to the next data-entry step
- (void) goToNextStep {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"avsEnabled"]) {
		UIViewController* nextViewController = [(ChargeViewController*)[(TransFS_Card_TerminalAppDelegate*)[[UIApplication sharedApplication] delegate] chargeViewController] chargeAddressViewController];
		[self.navigationController pushViewController:nextViewController animated:true];
	}
	else {
		UIViewController* nextViewController = [(TransFS_Card_TerminalAppDelegate*)[[UIApplication sharedApplication] delegate] chargeViewController];
		[self.navigationController popToViewController:nextViewController animated:true];
	}
}

// Clear data for this form
- (void) clearData {
	cvvLabel.text = @"";
	number = [[NSMutableString alloc] init];
}

- (void) keypadNumberPressed:(int)num button:(UIButton*)sender
{
	[number appendFormat:@"%d", num];
	[cvvLabel setText:number];
}

- (void) keypadBackspacePressed:(UIButton*)sender
{
	if (![NSString isBlank:number])
		[number deleteCharactersInRange:NSMakeRange([number length]-1, 1)];
	[cvvLabel setText:number];
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
