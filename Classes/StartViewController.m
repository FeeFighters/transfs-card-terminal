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
	
	[authNetLogin setDelegate:self];
	[authNetPassword setDelegate:self];	
	[emailReceiptAddress setDelegate:self];
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
	NSString *txt = [[textField text] stringByReplacingCharactersInRange:range withString:string];
	if (textField == dollarAmountField) {
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
	// Load settings into view
	[authNetLogin setText:[[NSUserDefaults standardUserDefaults] stringForKey:@"login"]];
	[authNetPassword setText:[[NSUserDefaults standardUserDefaults] stringForKey:@"password"]];
	[authNetTestMode setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"testMode"]];	
	[emailReceiptEnabled setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"emailReceiptEnabled"]];			
	[emailReceiptAddress setText:[[NSUserDefaults standardUserDefaults] stringForKey:@"emailReceiptAddress"]];
	[avsEnabled setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"avsEnabled"]];			
	
	[aboutWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://transfs.com"]]];
	[settingsView setContentSize:CGSizeMake(320, 800)];
	[settingsView setFrame:CGRectMake(0,0, 320, 480)];	
	[settingsView setScrollEnabled:YES];	
	
	// Now transition to settings
	settingsPreviousView = [[self view] superview];
	UIView* curView = [settingsPreviousView superview];
	[curView setBackgroundColor:[UIColor blackColor]];
	[UIView beginAnimations:@"settingsView" context:nil];		//	Begin an animation block.
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:curView cache:true];	//	Set the transition on the container view.
	[settingsPreviousView removeFromSuperview];	//	Remove the subview from the container view.
	[curView addSubview:settingsView];		//	Add the new subview to the container view.
	[UIView commitAnimations];	
}

- (IBAction) settingsClosePressed:(id)sender
{
	// Apply settings changes
	if (![NSString is_blank:[authNetLogin text]])
		[[NSUserDefaults standardUserDefaults] setObject:[authNetLogin text] forKey:@"login"];
	if (![NSString is_blank:[authNetPassword text]])
		[[NSUserDefaults standardUserDefaults] setObject:[authNetPassword text] forKey:@"password"];
	[[NSUserDefaults standardUserDefaults] setBool:[authNetTestMode isOn] forKey:@"testMode"];	
	[[NSUserDefaults standardUserDefaults] setBool:[emailReceiptEnabled isOn] forKey:@"emailReceiptEnabled"];	
	if (![NSString is_blank:[emailReceiptAddress text]])
		[[NSUserDefaults standardUserDefaults] setObject:[emailReceiptAddress text] forKey:@"emailReceiptAddress"];
	[[NSUserDefaults standardUserDefaults] setBool:[avsEnabled isOn] forKey:@"avsEnabled"];	
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	// Operate on New Settings
	[delegate setAddressTabVisible:[avsEnabled isOn]];
	
	// Load Start view
	UIView* curView = [settingsView superview];
	[curView setBackgroundColor:[UIColor blackColor]];
	[UIView beginAnimations:@"settingsView" context:nil];		//	Begin an animation block.
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:curView cache:true];	//	Set the transition on the container view.
	[settingsView removeFromSuperview];	//	Remove the subview from the container view.
	[curView addSubview:settingsPreviousView];		//	Add the new subview to the container view.
	[UIView commitAnimations];	
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
