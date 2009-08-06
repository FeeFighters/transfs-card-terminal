//
//  ChargeAddressViewController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberKeypadWithDone.h"

@interface ChargeAddressViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, NumberKeypadWithDone, UITextFieldDelegate> {
	IBOutlet UITextField* address;
	IBOutlet UITextField* city;
	IBOutlet UITextField* state;
	IBOutlet UITextField* zipcode;
	IBOutlet UIPickerView* addressPicker;

	NSArray* matchedAddresses;
}

@property(retain, nonatomic) IBOutlet UITextField* address;
@property(retain, nonatomic) IBOutlet UITextField* city;
@property(retain, nonatomic) IBOutlet UITextField* state;
@property(retain, nonatomic) IBOutlet UITextField* zipcode;
@property(retain, nonatomic) IBOutlet UIPickerView* addressPicker;

- (void) goToNextStep;
- (void) clearData;

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;

//UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

//UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end
