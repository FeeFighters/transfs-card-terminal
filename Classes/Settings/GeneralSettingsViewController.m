//
//  GeneralSettingsViewController.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/28/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "GeneralSettingsViewController.h"
#import "Transaction.h"

@implementation GeneralSettingsViewController

@synthesize avsEnabled, splashScreenEnabled;

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
	[super viewWillAppear:animated];
	[avsEnabled setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"avsEnabled"]];
	[splashScreenEnabled setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"showSplashScreen"]];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[[NSUserDefaults standardUserDefaults] setBool:[avsEnabled isOn] forKey:@"avsEnabled"];
	[[NSUserDefaults standardUserDefaults] setBool:[splashScreenEnabled isOn] forKey:@"showSplashScreen"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction) settingsClearHistoryPressed:(id)sender
{
	UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:@"Clear Transaction History?"
													   delegate:self
											  cancelButtonTitle:nil
										 destructiveButtonTitle:@"No, Cancel"
											  otherButtonTitles:nil];
	[alert addButtonWithTitle:@"Yes, Clear History."];
	[alert showInView:[self view]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex==0) //Cancel
	{
	}
	else if (buttonIndex==1)
	{
		[Transaction deleteAllFromDatabase];
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
