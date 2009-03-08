//
//  SettingsTableCell.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsTableCell : UITableViewCell {
	IBOutlet UILabel* label;
}

@property(retain, nonatomic) IBOutlet UILabel* label;

@end
