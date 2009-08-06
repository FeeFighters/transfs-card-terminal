//
//  ChargeAddressViewController.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TransFS_Card_TerminalAppDelegate.h"
#import "ChargeViewController.h"
#import "ChargeAddressViewController.h"
#import "ZipCode.h"

@implementation ChargeAddressViewController

#import "NumberKeypadWithDone_Implementation.h"

@synthesize address, city, zipcode, state, addressPicker;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
	    // Custom initialization
	}
	return self;
}
*/

// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView {
//}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
/*
- (void)viewDidLoad {
	[super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	//self.navigationItem.prompt = @"TransFS.com Card Terminal";
	self.navigationItem.title = @"Address";
	[address becomeFirstResponder];

	UIBarButtonItem* nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(goToNextStep)];
	[self.navigationItem setRightBarButtonItem:nextButton animated:YES];
}

// Go to the next data-entry step
- (void) goToNextStep {
	UIViewController* nextViewController = [(TransFS_Card_TerminalAppDelegate*)[[UIApplication sharedApplication] delegate] chargeViewController];
	[self.navigationController popToViewController:nextViewController animated:true];
}

// Clear data for this form
- (void) clearData {
	address.text = @"";
	city.text = @"";
	state.text = @"";
	zipcode.text = @"";
	addressPicker.hidden = true;
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	if (textField == zipcode) {
		[self initKeyboardWithDone:zipcode];
	}
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (textField == zipcode) {
		if ([textField.text length] > 4) {
			sqlite3* database = [(TransFS_Card_TerminalAppDelegate*)[[UIApplication sharedApplication] delegate] database];
			matchedAddresses = [ZipCode zipcodesByZip:textField.text fromDatabase:database];
			[addressPicker reloadAllComponents];
			addressPicker.hidden = false;
			if ([matchedAddresses count] > 0) {
				[self pickerView:addressPicker didSelectRow:0 inComponent:0];
			}
		}
		[self finishKeyboardWithDone];
	}
	else {
		[textField resignFirstResponder];
	}

}

/*
	UIPickerViewDataSource
*/
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if (matchedAddresses)
		return [matchedAddresses count];
	return 0;
}

/*
	UIPickerViewDelegate
*/
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	ZipCode* zip = [matchedAddresses objectAtIndex:row];
	return [NSString stringWithFormat:@"%@, %@", zip.city, zip.state];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	ZipCode* zip = [matchedAddresses objectAtIndex:row];
	city.text = zip.city;
	state.text = zip.state;
}

@end
