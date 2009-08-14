//
//  HistoryDetailViewController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/24/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transaction.h"

@interface HistoryDetailViewController : UIViewController <UIActionSheetDelegate> {
	Transaction* transaction;
	
	IBOutlet UILabel* firstName;
	IBOutlet UILabel* lastName;	
	IBOutlet UILabel* sanitizedCardNumber;
	IBOutlet UILabel* date;
	IBOutlet UILabel* amount;
	IBOutlet UILabel* transactionId;	
	
	IBOutlet UILabel* voidResponseLabel;	
	IBOutlet UIButton* voidTransactionButton;		
}

@property(nonatomic, retain) Transaction* transaction;

- (IBAction) voidButtonClick:(id)sender;
- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void) voidTransactionThread;

@end
