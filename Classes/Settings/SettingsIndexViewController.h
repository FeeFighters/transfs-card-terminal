//
//  SettingsIndexViewController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutSettingsController.h"
#import "GeneralSettingsViewController.h"
#import "EmailSettingsViewController.h"
#import "AuthNetSettingsController.h"

@interface SettingsIndexViewController : UITableViewController {
	IBOutlet AboutSettingsController* aboutSettingsController;
	IBOutlet GeneralSettingsViewController* generalSettingsController;
	IBOutlet EmailSettingsViewController* emailSettingsController;
	IBOutlet AuthNetSettingsController* authNetSettingsController;
	
	int selectedGatewayIndex;
}

@property (nonatomic, retain) IBOutlet AboutSettingsController* aboutSettingsController;
@property (nonatomic, retain) IBOutlet GeneralSettingsViewController* generalSettingsController;
@property (nonatomic, retain) IBOutlet EmailSettingsViewController* emailSettingsController;
@property (nonatomic, retain) IBOutlet AuthNetSettingsController* authNetSettingsController;

@property(assign) int selectedGatewayIndex;

@end
