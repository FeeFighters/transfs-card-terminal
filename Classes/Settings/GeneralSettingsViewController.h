//
//  GeneralSettingsViewController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/28/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GeneralSettingsViewController : UIViewController <UIActionSheetDelegate> {
	IBOutlet UISwitch* avsEnabled;
	IBOutlet UISwitch* splashScreenEnabled;
}

@property(retain, nonatomic) IBOutlet UISwitch* avsEnabled;
@property(retain, nonatomic) IBOutlet UISwitch* splashScreenEnabled;

- (IBAction) settingsClearHistoryPressed:(id)sender;

@end
