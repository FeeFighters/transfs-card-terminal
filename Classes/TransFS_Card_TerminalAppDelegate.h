//
//  TransFS_Card_TerminalAppDelegate.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/2/09.
//  Copyright TransFS.com 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "ChargeViewController.h"

@class Transaction, StartViewController, CardViewController, ProcessViewController, AddressViewController;
@class AboutSettingsController, EmailSettingsViewController, GeneralSettingsViewController, AuthNetSettingsController;

@interface TransFS_Card_TerminalAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
	IBOutlet ChargeViewController* chargeViewController;
	IBOutlet UINavigationController* historyTableNavigationController;	
	
    UIWindow *window;
    UITabBarController *tabBarController;
	IBOutlet UITabBar* tabBar;
	
	NSMutableArray* transactionHistory;
    sqlite3 *database; // Opaque reference to the SQLite database.
}

@property (nonatomic, retain) IBOutlet ChargeViewController* chargeViewController;
@property (nonatomic, retain) IBOutlet UINavigationController* historyTableNavigationController;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UITabBar* tabBar;

// Makes the main array of transaction objects available to other objects in the application.
@property (nonatomic, retain) NSMutableArray *transactionHistory;
@property (readonly) sqlite3 *database;

// Creates a new transaction object with default data.
- (void)addTransaction:(Transaction *)transaction;
- (void)removeTransaction:(Transaction *)transaction;


@end
