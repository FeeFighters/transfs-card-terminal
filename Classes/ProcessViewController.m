//
//  ProcessViewController.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/16/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "Transaction.h"

@implementation ProcessViewController

@synthesize responseLabel, responseInfoLabel;

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

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction) processButtonClick:(id)sender
{
	UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:@"Process Transaction?" 
													   delegate:self 
											  cancelButtonTitle:nil 
										 destructiveButtonTitle:@"Cancel"
											  otherButtonTitles:nil];
	[alert addButtonWithTitle:@"Proceed!"];
	
//	UIImageView *greenButton = (UIView*)[[alert subviews] objectAtIndex:2];
//	UIImage *image = [greenButton image];
//	CGImageRef cgimage = [image cgimage];
//	
//	CGContextSetBlendMode(context, kCGBlendModeMultiply);
//	CGContextSetFillColorWithColor(context, kCGColorWhite);
//	CGContextFillRect(context, 
//	//[greenButton setOpaque:false];
	
	[alert showInView:[self view]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex==0) //Cancel
	{
		[processButton setEnabled:true];
		[spinner stopAnimating];
		[spinner setHidden:true];
		[responseLabel setText:@"Transaction Cancelled."];
	}
	else if (buttonIndex==1)
	{
		[processButton setEnabled:false];
		[spinner startAnimating];
		[spinner setHidden:false];
		[responseLabel setText:@""];
		[responseInfoLabel setHidden:true];		
		[NSThread detachNewThreadSelector:@selector(processTransactionThread) toTarget:self withObject:nil];
	}
}

- (void) processTransactionThread
{
	[NSThread sleepForTimeInterval:0.5];
	
	TransFS_Card_TerminalAppDelegate* delegate = (TransFS_Card_TerminalAppDelegate*)[[UIApplication sharedApplication] delegate];
	Transaction* sale = [[Transaction alloc] init:delegate];
	if ([sale status]==TransactionSuccess)
	{
		[responseLabel setText:@"Transaction Processed Successfully!"];		
	}
	else
	{
		[responseLabel setText:[sale errorMessages]];
		[responseInfoLabel setHidden:false];
	}
	
	[spinner stopAnimating];
	[processButton setEnabled:true];
	[NSThread exit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
