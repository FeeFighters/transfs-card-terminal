//
//  EmailSettingsViewController.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/28/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "EmailSettingsViewController.h"
#import "NSStringAdditions.h"

@implementation EmailSettingsViewController

@synthesize emailReceiptAddress, emailReceiptName, emailReceiptCopy;

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
	[emailReceiptName setText:[[NSUserDefaults standardUserDefaults] stringForKey:@"emailReceiptName"]];
	[emailReceiptAddress setText:[[NSUserDefaults standardUserDefaults] stringForKey:@"emailReceiptAddress"]];
	[emailReceiptCopy setText:[[[NSUserDefaults standardUserDefaults] stringForKey:@"emailReceiptCopy"]
														  stringByReplacingOccurrencesOfString:@"__LF__"
													                              withString:@"\n"]];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	if (![NSString isBlank:[emailReceiptName text]])
		[[NSUserDefaults standardUserDefaults] setObject:[emailReceiptName text] forKey:@"emailReceiptName"];
	if (![NSString isBlank:[emailReceiptAddress text]])
		[[NSUserDefaults standardUserDefaults] setObject:[emailReceiptAddress text] forKey:@"emailReceiptAddress"];
	if (![NSString isBlank:[emailReceiptCopy text]])
		[[NSUserDefaults standardUserDefaults] setObject:[emailReceiptCopy text] forKey:@"emailReceiptCopy"];
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
