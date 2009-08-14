//
//  PaypalSettingsController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/9/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PaypalSettingsController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField* login;
	IBOutlet UITextField* password;
	IBOutlet UITextField* signature;	
	IBOutlet UISwitch* testMode;
}

@property(retain, nonatomic) IBOutlet UITextField* login;
@property(retain, nonatomic) IBOutlet UITextField* password;
@property(retain, nonatomic) IBOutlet UITextField* signature;
@property(retain, nonatomic) IBOutlet UISwitch* testMode;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
