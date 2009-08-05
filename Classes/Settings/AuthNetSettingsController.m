//
//  AuthNetSettingsController.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AuthNetSettingsController.h"
#import "NSStringAdditions.h"

@implementation AuthNetSettingsController

@synthesize authNetLogin, authNetPassword, authNetTestMode;

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

	[authNetLogin setText:[[NSUserDefaults standardUserDefaults] stringForKey:@"authNetLogin"]];
	[authNetPassword setText:[[NSUserDefaults standardUserDefaults] stringForKey:@"authNetPassword"]];
	[authNetTestMode setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"authNetTestMode"]];	
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	if (![NSString isBlank:[authNetLogin text]])//
		[[NSUserDefaults standardUserDefaults] setObject:[authNetLogin text] forKey:@"authNetLogin"];
	if (![NSString isBlank:[authNetPassword text]])
		[[NSUserDefaults standardUserDefaults] setObject:[authNetPassword text] forKey:@"authNetPassword"];
	[[NSUserDefaults standardUserDefaults] setBool:[authNetTestMode isOn] forKey:@"authNetTestMode"];
	[[NSUserDefaults standardUserDefaults] synchronize];	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
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
