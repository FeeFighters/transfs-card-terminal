//
//  ChargeTableAddressCell.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChargeTableAddressCell : UITableViewCell {
	IBOutlet UILabel* address;
	IBOutlet UILabel* city;
	IBOutlet UILabel* zip;	
	IBOutlet UILabel* disabledLabel;	
}

@property(nonatomic, retain) IBOutlet UILabel* address;
@property(nonatomic, retain) IBOutlet UILabel* city;
@property(nonatomic, retain) IBOutlet UILabel* zip;
@property(nonatomic, retain) IBOutlet UILabel* disabledLabel;

@end
