//
//  StartViewController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/17/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransFS_Card_TerminalAppDelegate.h"

@interface StartViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate> {
	IBOutlet UITextField* dollarAmountField;
	IBOutlet UILabel* dollarAmountLabel;		
	IBOutlet UIButton* finishButton;
	
	IBOutlet UIScrollView* settingsView;
	UIView* settingsPreviousView;
	IBOutlet UIWebView* aboutWebView;
		
	IBOutlet UITextField* authNetLogin;
	IBOutlet UITextField* authNetPassword;
	IBOutlet UISwitch* authNetTestMode;
	IBOutlet UISwitch* avsEnabled;
	IBOutlet UISwitch* emailReceiptEnabled;
	IBOutlet UITextField* emailReceiptAddress;	
	
	CGPoint savedContentOffset;
	
	IBOutlet TransFS_Card_TerminalAppDelegate* delegate;
}

@property(retain, nonatomic) IBOutlet UITextField* dollarAmountField;
@property(retain, nonatomic) IBOutlet UILabel* dollarAmountLabel;

- (void)textFieldDidChange;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (IBAction) doneEditingPressed:(id)sender;
- (IBAction) proceedPressed:(id)sender;
- (IBAction) settingsPressed:(id)sender;
- (IBAction) settingsClosePressed:(id)sender;
- (IBAction) settingsClearHistoryPressed:(id)sender;

@end
