//
//  TransFS_Card_TerminalAppDelegate.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/2/09.
//  Copyright TransFS.com 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <AudioToolbox/AudioServices.h>

@class Transaction, StartViewController, CardViewController, ProcessViewController, AddressViewController;
@class AboutSettingsController, EmailSettingsViewController, GeneralSettingsViewController, AuthNetSettingsController;
@class BillingGateway, ChargeViewController;
@class Reachability;

@interface TransFS_Card_TerminalAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
	IBOutlet ChargeViewController* chargeViewController;
	IBOutlet UINavigationController* historyTableNavigationController;

	UIView* splashScreenView;
	UIView* splashScreenTopView;
	UIView* splashScreenBottomView;
	UIView* splashScreenTitleView;
	UIView* splashScreenIconView;
	UITextView* splashScreenPressToBegin;
	UIButton* splashScreenAboutSettings;
	UIActivityIndicatorView* splashScreenSpinner;

	UIWindow *window;
	UITabBarController *tabBarController;

	NSMutableArray* transactionHistory;
	sqlite3 *database; // Opaque reference to the SQLite database.

	SystemSoundID keyboardClickSoundID;

	Reachability* gatewayHostReach;
	bool showSetupMessage;
	bool showSplashScreen;
}

@property (nonatomic, retain) IBOutlet UIView* splashScreenView;
@property (nonatomic, retain) IBOutlet UIView* splashScreenTopView;
@property (nonatomic, retain) IBOutlet UIView* splashScreenBottomView;
@property (nonatomic, retain) IBOutlet UIView* splashScreenTitleView;
@property (nonatomic, retain) IBOutlet UIView* splashScreenIconView;
@property (nonatomic, retain) IBOutlet UITextView* splashScreenPressToBegin;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* splashScreenSpinner;
@property (nonatomic, retain) IBOutlet UIButton* splashScreenAboutSettings;
- (IBAction) aboutSettingsPressed:(id)sender;

@property (nonatomic, retain) IBOutlet ChargeViewController* chargeViewController;
@property (nonatomic, retain) IBOutlet UINavigationController* historyTableNavigationController;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

// Makes the main array of transaction objects available to other objects in the application.
@property (nonatomic, retain) NSMutableArray *transactionHistory;
@property (readonly) sqlite3 *database;
@property (readonly) SystemSoundID keyboardClickSoundID;

- (BillingGateway*) setupGateway;
- (void) setupReachability;

// Creates a new transaction object with default data.
- (void)addTransaction:(Transaction *)transaction;
- (void)removeTransaction:(Transaction *)transaction;


@end
