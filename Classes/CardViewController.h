//
//  FirstViewController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/2/09.
//  Copyright TransFS.com 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardExpirationPickerDelegate.h"

@interface CardViewController : UIViewController <UIPickerViewDelegate, UITextFieldDelegate> {
	IBOutlet UIImageView* cardTypeImage;
	IBOutlet UITextField* cardNumberField;
	IBOutlet UILabel* cardNumberLabel;	
	IBOutlet UITextField* cvvNumberField;
	IBOutlet UIButton* finishButton;
	IBOutlet UIPickerView* monthPicker;
	IBOutlet UIPickerView* yearPicker;
	IBOutlet CardExpirationPickerDelegate* expDatePickerDelegate;
	IBOutlet UITextField* firstNameField;	
	IBOutlet UITextField* lastNameField;		
}

@property(retain, nonatomic) IBOutlet UIImageView* cardTypeImage;
@property(retain, nonatomic) IBOutlet UITextField* cardNumberField;
@property(retain, nonatomic) IBOutlet UILabel* cardNumberLabel;	
@property(retain, nonatomic) IBOutlet UITextField* cvvNumberField;
@property(retain, nonatomic) IBOutlet UIPickerView* monthPicker;
@property(retain, nonatomic) IBOutlet UIPickerView* yearPicker;
@property(retain, nonatomic) IBOutlet UITextField* firstNameField;	
@property(retain, nonatomic) IBOutlet UITextField* lastNameField;		

- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (IBAction) doneEditingPressed:(id)sender;
- (IBAction) proceedPressed:(id)sender;

@end
