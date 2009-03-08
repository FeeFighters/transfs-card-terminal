//
//  SettingsTabBarController.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SettingsTabBarController.h"
#import "GeneralSettingsViewController.h"
#import "AuthNetSettingsController.h"
#import "EmailSettingsViewController.h"
#import "NSStringAdditions.h"

@implementation SettingsTabBarController

- (void) loadSettings
{
	// Load settings into view
	[appDelegate.authNetSettingsController.authNetLogin setText:[[NSUserDefaults standardUserDefaults] stringForKey:@"login"]];
	[appDelegate.authNetSettingsController.authNetPassword setText:[[NSUserDefaults standardUserDefaults] stringForKey:@"password"]];
	[appDelegate.authNetSettingsController.authNetTestMode setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"testMode"]];	
	[appDelegate.emailSettingsController.emailReceiptEnabled setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"emailReceiptEnabled"]];			
	[appDelegate.emailSettingsController.emailReceiptAddress setText:[[NSUserDefaults standardUserDefaults] stringForKey:@"emailReceiptAddress"]];
	[appDelegate.generalSettingsController.avsEnabled setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"avsEnabled"]];
}

- (void) saveSettings
{
	// Apply settings changes
	if (![NSString is_blank:[appDelegate.authNetSettingsController.authNetLogin text]])//
		[[NSUserDefaults standardUserDefaults] setObject:[appDelegate.authNetSettingsController.authNetLogin text] forKey:@"login"];
	if (![NSString is_blank:[appDelegate.authNetSettingsController.authNetPassword text]])
		[[NSUserDefaults standardUserDefaults] setObject:[appDelegate.authNetSettingsController.authNetPassword text] forKey:@"password"];
	[[NSUserDefaults standardUserDefaults] setBool:[appDelegate.authNetSettingsController.authNetTestMode isOn] forKey:@"testMode"];
	[[NSUserDefaults standardUserDefaults] setBool:[appDelegate.emailSettingsController.emailReceiptEnabled isOn] forKey:@"emailReceiptEnabled"];	
	if (![NSString is_blank:[appDelegate.emailSettingsController.emailReceiptAddress text]])
		[[NSUserDefaults standardUserDefaults] setObject:[appDelegate.emailSettingsController.emailReceiptAddress text] forKey:@"emailReceiptAddress"];
	[[NSUserDefaults standardUserDefaults] setBool:[appDelegate.generalSettingsController.avsEnabled isOn] forKey:@"avsEnabled"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	// Operate on New Settings
	[appDelegate setAddressTabVisible:[appDelegate.generalSettingsController.avsEnabled isOn]];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
	[self loadSettings];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{ 
	self.navigationItem.title = viewController.navigationItem.title;
}

- (IBAction) settingsClosePressed:(id)sender
{
	[self saveSettings];
	
	// Load Start view
	[[appDelegate.settingsNavigationController.view superview] setBackgroundColor:[UIColor blackColor]];
	[UIView beginAnimations:@"settingsView" context:nil];		//	Begin an animation block.
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:[appDelegate.settingsNavigationController.view superview] cache:true];	//	Set the transition on the container view.
	[appDelegate.settingsNavigationController.view removeFromSuperview];	//	Remove the subview from the container view.
	[UIView commitAnimations];	
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
