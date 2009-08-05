//
//  UsaEpaySettingsController.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 7/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UsaEpaySettingsController.h"
#import "NSStringAdditions.h"

@implementation UsaEpaySettingsController

@synthesize sourceKey, testMode;

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

	[sourceKey setText:[[NSUserDefaults standardUserDefaults] stringForKey:@"usaEpaySourceKey"]];
	[testMode setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"usaEpayTestMode"]];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	if (![NSString isBlank:[sourceKey text]])
		[[NSUserDefaults standardUserDefaults] setObject:[sourceKey text] forKey:@"usaEpaySourceKey"];
	[[NSUserDefaults standardUserDefaults] setBool:[testMode isOn] forKey:@"usaEpayTestMode"];
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
