//
//  TransactionTableViewCell.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TransactionTableViewCell : UITableViewCell {
	IBOutlet UILabel* name;
	IBOutlet UILabel* amount;	
	IBOutlet UILabel* date;
}

@property(retain, nonatomic) IBOutlet UILabel* name;
@property(retain, nonatomic) IBOutlet UILabel* amount;	
@property(retain, nonatomic) IBOutlet UILabel* date;

@end
