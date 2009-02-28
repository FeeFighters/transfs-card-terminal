//
//  ProcessViewController.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/16/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "Transaction.h"
#import <stdlib.h>

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
	NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
	
	[NSThread sleepForTimeInterval:0.5];
	
	Transaction* sale = [Transaction initAndProcessFromCurrentState];
	if ([sale status]==TransactionSuccess)
	{
		[successViewImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"money_%d.png", (random() % 7)+1]]];
		[successViewLabel setText:[NSString stringWithFormat:@"Successfully Charged $%.2f to %@ %@'s Card", [sale dollarAmount], [sale firstName], [sale lastName]]];
		
		savedSubviewforSuccess = [[delegate tabBarController] view];
		UIView* curView = [savedSubviewforSuccess superview];
		[curView setBackgroundColor:[UIColor blackColor]];
		[UIView beginAnimations:@"successView" context:nil];		//	Begin an animation block.
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:curView cache:true];	//	Set the transition on the container view.
		[savedSubviewforSuccess removeFromSuperview];	//	Remove the subview from the container view.
		[curView addSubview:successView];		//	Add the new subview to the container view.
		[UIView commitAnimations];
	}
	else
	{
		[responseLabel setText:[NSString stringWithString:[sale errorMessages]]];
		[responseInfoLabel setHidden:false];
	}
	
	[autoreleasepool release];
	
	[spinner stopAnimating];
	[processButton setEnabled:true];
	[NSThread exit];
}

- (IBAction) startOverButtonClick:(id)sender
{
	[[self tabBarController] setSelectedIndex:0];
	[delegate resetTransactionFields];
	
	UIView* curView = [successView superview];
	[UIView beginAnimations:@"startOver" context:nil];		//	Begin an animation block.
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:curView cache:true];	//	Set the transition on the container view.
	[successView removeFromSuperview];	//	Remove the subview from the container view.
	[curView addSubview:savedSubviewforSuccess];		//	Add the new subview to the container view.
	[UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
