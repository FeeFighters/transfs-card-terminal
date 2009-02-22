//
//  FirstViewController.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/2/09.
//  Copyright TransFS.com 2009. All rights reserved.
//

#import "CardViewController.h"
#import "UIGradientScrollView.h"
#import "RegexKitLite.h"
#import "CreditCard.h"
#import "CreditCardMethods.h"
#import <stdlib.h>

@implementation CardViewController

@synthesize cardTypeImage, cardNumberLabel;
@synthesize cardNumberField, cvvNumberField, monthPicker, yearPicker, firstNameField, lastNameField;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
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
	[(UIGradientScrollView*)[self view] setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
	[(UIGradientScrollView*)[self view] setScrollEnabled:YES];
	[(UIGradientScrollView*)[self view] setCanCancelContentTouches:NO];
	[(UIGradientScrollView*)[self view] setContentSize:CGSizeMake(240, 700)];
	[(UIGradientScrollView*)[self view] addControlToHitTestList:monthPicker];
	[(UIGradientScrollView*)[self view] addControlToHitTestList:yearPicker];
	[(UIGradientScrollView*)[self view] addControlToHitTestList:finishButton];
	
	[cardNumberField setClearButtonMode:UITextFieldViewModeAlways];
	CGRect r = [cardNumberField frame];
	[cardNumberField setFrame:CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height + 5)];
	[cardNumberField setDelegate:self];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textFieldDidChange)
												 name:@"UITextFieldTextDidChangeNotification" 
											   object:cardNumberField];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textFieldDidChange)
												 name:@"UITextFieldTextDidBeginEditingNotification" 
											   object:cardNumberField];

	[cvvNumberField setClearButtonMode:UITextFieldViewModeAlways];
	[cvvNumberField setDelegate:self];
	
	[finishButton setHidden:true];	
	
	CGRect loc = [monthPicker frame];
	[monthPicker setFrame:CGRectMake(20, loc.origin.y, 150, loc.size.height)];
	[yearPicker setFrame:CGRectMake(171, loc.origin.y, 110, loc.size.height)];	
	
	[firstNameField setDelegate:self];
	[lastNameField setDelegate:self];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if (textField==firstNameField || textField==lastNameField) 
	{
		CGPoint loc = [textField frame].origin;
		loc.x = 0;
		loc.y -= 130;
		[(UIGradientScrollView*)[self view] setContentOffset:loc animated:YES];
	}
	else 
	{
		CGPoint loc = [cvvNumberField frame].origin;
		loc.x = 0;
		loc.y -= 150;
		[finishButton setFrame:CGRectMake(10, 195 + loc.y, 300, 50)];
		[(UIGradientScrollView*)[self view] setContentOffset:loc animated:YES];
		[textField resignFirstResponder];
		[finishButton setHighlighted:true];
		[finishButton setHidden:false];
	}
	[(UIGradientScrollView*)[self view] setScrollEnabled:false];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSString *txt = [[textField text] stringByReplacingCharactersInRange:range withString:string];
	if (textField == cardNumberField) {
		if ([txt length]>16)
			return NO;
	} 
	else if (textField == cvvNumberField) {
		if ([txt length]>4)
			return NO;
	}
	return YES;
}

- (void)textFieldDidChange
{
	NSString *origText = [cardNumberField text];
	NSMutableString *text = [NSMutableString stringWithString:[origText substringWithRange:NSMakeRange(0, [origText length] > 16 ? 16 : [origText length])]];
	[text replaceOccurrencesOfRegex:@"(\\d\\d\\d\\d)" withString:@"$1 "];
	[cardNumberLabel setText:text];
	NSString *type = [BillingCreditCard getTypeWithPartialNumber:origText];
	NSArray *validImages = [NSArray arrayWithObjects:@"visa", @"master", @"discover", @"american_express", nil];
	if ([validImages containsObject:type]) {
		NSString *filename = [NSString stringWithFormat:@"%@.png", type];
		UIImage *image = [UIImage imageNamed:filename];
		[cardTypeImage setImage:image];
	}
	else {
		UIImage *image = [UIImage imageNamed:@"unknown.png"];
		[cardTypeImage setImage:image];
	}
}

- (IBAction) doneEditingPressed:(id)sender
{
	if (sender==finishButton) {
		[finishButton setHidden:true];
		[cardNumberField endEditing:true];
		[cvvNumberField endEditing:true];		
		[(UIGradientScrollView*)[self view] setScrollEnabled:true];		
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	[(UIGradientScrollView*)[self view] setScrollEnabled:true];	
	return YES;
}

- (IBAction) proceedPressed:(id)sender
{
	[[self tabBarController] setSelectedIndex:2];
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
