//
//  TransactionTableViewCell.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/24/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "TransactionTableViewCell.h"


@implementation TransactionTableViewCell

@synthesize name, date, amount;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
