//
//  StartViewController.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/17/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "StartViewController.h"
#import "RegexKitLite.h"
#import "NSStringAdditions.h"
#import "Transaction.h"
#import "UIScrollViewAdditions.h"

@implementation StartViewController

@synthesize dollarAmountField, dollarAmountLabel;

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
	
	[dollarAmountField setClearButtonMode:UITextFieldViewModeNever];
	[dollarAmountField setDelegate:self];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textFieldDidChange)
												 name:@"UITextFieldTextDidChangeNotification" 
											   object:dollarAmountField];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textFieldDidChange)
												 name:@"UITextFieldTextDidBeginEditingNotification" 
											   object:dollarAmountField];
	[finishButton setHidden:true];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if ([[textField superview] isKindOfClass:[UIScrollView class]])
		savedContentOffset = [(UIScrollView*)[textField superview] scrollToTextField:textField];
	
	if (textField==dollarAmountField) {
		[textField resignFirstResponder];
		[finishButton setHighlighted:true];
		[finishButton setHidden:false];
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if (textField == dollarAmountField) {
		NSString *txt = [[textField text] stringByReplacingCharactersInRange:range withString:string];
		if ([txt length]>7 || [txt length]<=0)
			return NO;
	} 
	return YES;
}

- (void)textFieldDidChange
{
	NSString *origText = [dollarAmountField text];
	NSMutableString *text = [NSMutableString stringWithString:[origText substringWithRange:NSMakeRange(0, [origText length] > 7 ? 7 : [origText length])]];
	[text replaceOccurrencesOfRegex:@"\\." withString:@""];
	[text replaceOccurrencesOfRegex:@"(\\d\\d?)$" withString:@".$1"];
	[dollarAmountLabel setText:text];
}

- (IBAction) doneEditingPressed:(id)sender
{
	if (sender==finishButton) {
		[finishButton setHidden:true];
		[dollarAmountField endEditing:true];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	if ([[textField superview] isKindOfClass:[UIScrollView class]])
		[(UIScrollView*)[textField superview] setContentOffset:savedContentOffset animated:true];
	return YES;
}

- (IBAction) proceedPressed:(id)sender
{
	[delegate goToNextTab];
}



- (IBAction) settingsPressed:(id)sender
{		
	// Now transition to settings
	[[[self.tabBarController view] superview] setBackgroundColor:[UIColor blackColor]];
	[UIView beginAnimations:@"settingsView" context:nil];		//	Begin an animation block.
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:[[self.tabBarController view] superview] cache:true];	//	Set the transition on the container view.
	[[[self.tabBarController view] superview] addSubview:delegate.settingsNavigationController.view];	//	Add the new subview to the container view.
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
