//
//  EmailSettingsViewController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/28/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EmailSettingsViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField* emailReceiptName;
	IBOutlet UITextField* emailReceiptAddress;
	IBOutlet UITextView* emailReceiptCopy;
}

@property(retain, nonatomic) IBOutlet UITextField* emailReceiptName;
@property(retain, nonatomic) IBOutlet UITextField* emailReceiptAddress;
@property(retain, nonatomic) IBOutlet UITextView* emailReceiptCopy;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
