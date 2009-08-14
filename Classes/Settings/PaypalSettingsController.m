//
//  PaypalSettingsController.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/9/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "PaypalSettingsController.h"
#import "NSStringAdditions.h"

@implementation PaypalSettingsController

@synthesize login, password, signature, testMode;

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
	
	[login setText:[[NSUserDefaults standardUserDefaults] stringForKey:@"paypalLogin"]];
	[password setText:[[NSUserDefaults standardUserDefaults] stringForKey:@"paypalPassword"]];
	[signature setText:[[NSUserDefaults standardUserDefaults] stringForKey:@"paypalSignature"]];	
	[testMode setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"paypalTestMode"]];	
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	if (![NSString isBlank:[login text]])
		[[NSUserDefaults standardUserDefaults] setObject:[login text] forKey:@"paypalLogin"];
	if (![NSString isBlank:[password text]])
		[[NSUserDefaults standardUserDefaults] setObject:[password text] forKey:@"paypalPassword"];
	if (![NSString isBlank:[signature text]])
		[[NSUserDefaults standardUserDefaults] setObject:[signature text] forKey:@"paypalSignature"];
	[[NSUserDefaults standardUserDefaults] setBool:[testMode isOn] forKey:@"paypalTestMode"];
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
