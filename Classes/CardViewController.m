//
//  FirstViewController.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/2/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "CardViewController.h"


@implementation CardViewController


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
	
	[cardNumberField setClearButtonMode:UITextFieldViewModeAlways];
	[cardNumberField setDelegate:self];
	CGRect r = [cardNumberField frame];
	[cardNumberField setFrame:CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height + 10)];
	
	[finishButton setHidden:true];	
	
	[monthPicker setFrame:CGRectMake(20, 195, 170, 216)];
	[yearPicker setFrame:CGRectMake(191, 195, 110, 216)];	
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	[textField resignFirstResponder];
	[finishButton setHighlighted:true];
	[finishButton setHidden:false];
}

- (IBAction) doneEditingPressed:(id)sender
{
	if (sender==finishButton) {
		[finishButton setHidden:true];
		[cardNumberField endEditing:true];
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
