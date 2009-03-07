//
//  ChargeTableAmountCell.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChargeTableAmountCell : UITableViewCell {
	IBOutlet UILabel* amount;
}

@property(nonatomic, retain) IBOutlet UILabel* amount;

@end
