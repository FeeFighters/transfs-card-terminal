//
//  ChargeCardCvvViewController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberKeypadView.h"

@interface ChargeCardCvvViewController : UIViewController <NumberKeypadDelegate> {
	IBOutlet UILabel* cvvLabel;
	NSMutableString* number;
}

@property(nonatomic, retain) IBOutlet UILabel* cvvLabel;
@property(nonatomic, retain) NSMutableString* number;

- (void) keypadNumberPressed:(int)number button:(UIButton*)sender;
- (void) keypadBackspacePressed:(UIButton*)sender;

- (void) goToNextStep;

@end
