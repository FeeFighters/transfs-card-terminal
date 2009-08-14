//
//  ChargeViewController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChargeAmountViewController.h"
#import "ChargeCardNumberViewController.h"
#import "ChargeCardNameViewController.h"
#import "ChargeCardExpViewController.h"
#import "ChargeCardCvvViewController.h"
#import "ChargeAddressViewController.h"
#import "Transaction.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface ChargeViewController : UIViewController <UITableViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
	IBOutlet UITableView* tableView;

	IBOutlet ChargeAmountViewController* chargeAmountViewController;
	IBOutlet ChargeCardNameViewController* chargeCardNameViewController;
	IBOutlet ChargeCardNumberViewController* chargeCardNumberViewController;
	IBOutlet ChargeCardExpViewController* chargeCardExpViewController;
	IBOutlet ChargeCardCvvViewController* chargeCardCvvViewController;
	IBOutlet ChargeAddressViewController* chargeAddressViewController;

	IBOutlet UIButton* processButton;
	IBOutlet UIActivityIndicatorView* spinner;
	IBOutlet UIView* successView;
	IBOutlet UIImageView* successViewImage;
	IBOutlet UILabel* successViewLabel;
	IBOutlet UIView* failureView;
	IBOutlet UILabel* responseLabel;
	UIView *savedSubviewforSuccess;
	IBOutlet UIButton* sendReceiptButton;

	Transaction* recentSale;

	IBOutlet UIView* clearDataFlashView;
}

@property(retain, nonatomic) IBOutlet ChargeAmountViewController* chargeAmountViewController;
@property(retain, nonatomic) IBOutlet ChargeCardNameViewController* chargeCardNameViewController;
@property(retain, nonatomic) IBOutlet ChargeCardNumberViewController* chargeCardNumberViewController;
@property(retain, nonatomic) IBOutlet ChargeCardExpViewController* chargeCardExpViewController;
@property(retain, nonatomic) IBOutlet ChargeCardCvvViewController* chargeCardCvvViewController;
@property(retain, nonatomic) IBOutlet ChargeAddressViewController* chargeAddressViewController;
@property(retain, nonatomic) IBOutlet UITableView* tableView;
@property(retain, nonatomic) IBOutlet UIView* clearDataFlashView;

- (IBAction) processButtonClick:(id)sender;
- (IBAction) goBackButtonClick:(id)sender;
- (IBAction) startOverButtonClick:(id)sender;
- (IBAction) sendReceiptButtonClick:(id)sender;

- (void) clearData;

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;

@end
