//
//  ChargeTableCardCell.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChargeTableCardNumberCell : UITableViewCell {
	IBOutlet UILabel* number;
	IBOutlet UIImageView* cardImage;
	IBOutlet UILabel* disabledLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* number;
@property(nonatomic, retain) IBOutlet UILabel* disabledLabel;
@property(assign, nonatomic) IBOutlet UIImageView* cardImage;

@end
