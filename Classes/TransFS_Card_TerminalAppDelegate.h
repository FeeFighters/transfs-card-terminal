//
//  TransFS_Card_TerminalAppDelegate.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/2/09.
//  Copyright TransFS.com 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class Transaction, StartViewController, CardViewController, ProcessViewController;

@interface TransFS_Card_TerminalAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
	IBOutlet StartViewController* startViewController;
	IBOutlet CardViewController* cardViewController;
	IBOutlet ProcessViewController* processViewController;
	
    UIWindow *window;
    UITabBarController *tabBarController;
	
	NSMutableArray* transactionHistory;
    sqlite3 *database; // Opaque reference to the SQLite database.
}

@property (nonatomic, retain) IBOutlet StartViewController* startViewController;
@property (nonatomic, retain) IBOutlet CardViewController* cardViewController;
@property (nonatomic, retain) IBOutlet ProcessViewController* processViewController;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

// Makes the main array of transaction objects available to other objects in the application.
@property (nonatomic, retain) NSMutableArray *transactionHistory;

// Creates a new transaction object with default data.
- (void)addTransaction:(Transaction *)transaction;
- (void)removeTransaction:(Transaction *)transaction;

// Resets the fields to start a fresh transaction
- (void) resetTransactionFields;

@end
