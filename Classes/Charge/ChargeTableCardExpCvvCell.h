//
//  ChargeTableCardExpDateCell.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChargeViewController.h"

@interface ChargeTableCardExpCvvCell : UITableViewCell {
	IBOutlet UILabel* expDate;
	IBOutlet UILabel* cvv;
	IBOutlet UILabel* expDisabledLabel;
	IBOutlet UILabel* cvvDisabledLabel;
	IBOutlet UIImageView* cardImage;
	IBOutlet ChargeViewController* chargeView;
}

@property(assign, nonatomic) IBOutlet UILabel* expDate;
@property(assign, nonatomic) IBOutlet UILabel* cvv;
@property(assign, nonatomic) IBOutlet UILabel* expDisabledLabel;
@property(assign, nonatomic) IBOutlet UILabel* cvvDisabledLabel;
@property(assign, nonatomic) IBOutlet UIImageView* cardImage;
@property(assign, nonatomic) IBOutlet ChargeViewController* chargeView;

- (IBAction) expDateDetailPressed:(id)sender;
- (IBAction) cvvDetailPressed:(id)sender;

@end
