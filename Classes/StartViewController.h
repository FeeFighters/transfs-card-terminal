//
//  StartViewController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/17/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StartViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField* dollarAmountField;
	IBOutlet UILabel* dollarAmountLabel;		
	IBOutlet UIButton* finishButton;
}

@property(retain, nonatomic) IBOutlet UITextField* dollarAmountField;
@property(retain, nonatomic) IBOutlet UILabel* dollarAmountLabel;

- (void)textFieldDidChange;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (IBAction) doneEditingPressed:(id)sender;
- (IBAction) proceedPressed:(id)sender;

@end
