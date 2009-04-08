//
//  AboutSettingsController.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AboutSettingsController.h"


@implementation AboutSettingsController

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[spinner startAnimating];
	[aboutWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://jkrall.github.com/transfs-card-terminal"]]];	
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	// [[NSUserDefaults standardUserDefaults] synchronize];		
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[spinner stopAnimating];	
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[spinner stopAnimating];
	[[[UIAlertView alloc] initWithTitle:@"About TransFS Card Terminal" message:@"Couldn't open TransFS.com web address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}
	
- (void) openInSafari:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://transfs.com"]];
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
