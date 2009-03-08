//
//  SettingsTabBarController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransFS_Card_TerminalAppDelegate.h"

@interface SettingsTabBarController : UITabBarController <UITabBarControllerDelegate> {
	IBOutlet TransFS_Card_TerminalAppDelegate* appDelegate;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

- (IBAction) settingsClosePressed:(id)sender;

@end
