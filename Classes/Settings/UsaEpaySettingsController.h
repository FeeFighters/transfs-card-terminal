//
//  UsaEpaySettingsController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 7/9/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UsaEpaySettingsController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField* sourceKey;
	IBOutlet UISwitch* testMode;
}

@property(retain, nonatomic) IBOutlet UITextField* sourceKey;
@property(retain, nonatomic) IBOutlet UISwitch* testMode;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
