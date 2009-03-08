//
//  GeneralSettingsViewController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GeneralSettingsViewController : UIViewController <UIActionSheetDelegate> {
	IBOutlet UISwitch* avsEnabled;
}

@property(retain, nonatomic) IBOutlet UISwitch* avsEnabled;

- (IBAction) settingsClearHistoryPressed:(id)sender;

@end
