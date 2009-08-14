//
//  SettingsTableCell.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "SettingsTableCell.h"


@implementation SettingsTableCell

@synthesize label;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
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
