//
//  ChargeTableCardNameCell.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChargeTableCardNameCell : UITableViewCell {
	IBOutlet UILabel* name;
	IBOutlet UILabel* disabledLabel;
}

@property(assign, nonatomic) IBOutlet UILabel* name;
@property(assign, nonatomic) IBOutlet UILabel* disabledLabel;

@end
