//
//  AuthNetSettingsController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AuthNetSettingsController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField* authNetLogin;
	IBOutlet UITextField* authNetPassword;
	IBOutlet UISwitch* authNetTestMode;
}

@property(retain, nonatomic) IBOutlet UITextField* authNetLogin;
@property(retain, nonatomic) IBOutlet UITextField* authNetPassword;
@property(retain, nonatomic) IBOutlet UISwitch* authNetTestMode;


- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
