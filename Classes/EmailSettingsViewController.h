//
//  EmailSettingsViewController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EmailSettingsViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UISwitch* emailReceiptEnabled;
	IBOutlet UITextField* emailReceiptAddress;	
}

@property(retain, nonatomic) IBOutlet UISwitch* emailReceiptEnabled;
@property(retain, nonatomic) IBOutlet UITextField* emailReceiptAddress;	

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
