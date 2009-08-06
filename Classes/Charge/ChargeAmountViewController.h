//
//  ChargeAmountViewController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberKeypadView.h"

@interface ChargeAmountViewController : UIViewController <NumberKeypadDelegate> {
	NSMutableString* number;
	IBOutlet UITextField* numberField;
}

@property(nonatomic, retain) IBOutlet UITextField* numberField;
@property(nonatomic, retain) NSMutableString* number;

- (void) keypadNumberPressed:(int)number button:(UIButton*)sender;
- (void) keypadBackspacePressed:(UIButton*)sender;
- (void) keypadPeriodPressed:(UIButton*)sender;

- (void) goToNextStep;
- (void) clearData;

@end
