//
//  FirstViewController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/2/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardExpirationPickerDelegate.h"

@interface CardViewController : UIViewController <UIPickerViewDelegate, UITextFieldDelegate> {
	IBOutlet UITextField* cardNumberField;
	IBOutlet UIButton* finishButton;
	IBOutlet UIPickerView* monthPicker;
	IBOutlet UIPickerView* yearPicker;
	IBOutlet CardExpirationPickerDelegate* expDatePickerDelegate;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (IBAction) doneEditingPressed:(id)sender;

@end
