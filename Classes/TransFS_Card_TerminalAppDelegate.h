//
//  TransFS_Card_TerminalAppDelegate.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/2/09.
//  Copyright TransFS.com 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartViewController.h"
#import "CardViewController.h"
#import "ProcessViewController.h"

@interface TransFS_Card_TerminalAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
	IBOutlet StartViewController* startViewController;
	IBOutlet CardViewController* cardViewController;
	IBOutlet ProcessViewController* processViewController;
	
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet StartViewController* startViewController;
@property (nonatomic, retain) IBOutlet CardViewController* cardViewController;
@property (nonatomic, retain) IBOutlet ProcessViewController* processViewController;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
