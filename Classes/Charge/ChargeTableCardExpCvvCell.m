//
//  ChargeTableCardExpDateCell.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "ChargeTableCardExpCvvCell.h"


@implementation ChargeTableCardExpCvvCell

@synthesize chargeView;
@synthesize expDate, cvv, expDisabledLabel, cvvDisabledLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}

- (IBAction) expDateDetailPressed:(id)sender
{
	// Navigation logic may go here. Create and push another view controller.
	[[self.chargeView navigationController] pushViewController:[self.chargeView chargeCardExpViewController] animated:true];
}

- (IBAction) cvvDetailPressed:(id)sender
{
	// Navigation logic may go here. Create and push another view controller.
	[[self.chargeView navigationController] pushViewController:[self.chargeView chargeCardCvvViewController] animated:true];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
