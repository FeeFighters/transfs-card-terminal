//
//  ChargeCardExpViewController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardExpirationPickerDelegate.h"

@interface ChargeCardExpViewController : UIViewController <UIPickerViewDelegate> {
	IBOutlet UIPickerView* monthPicker;
	IBOutlet UIPickerView* yearPicker;
	IBOutlet CardExpirationPickerDelegate* expDatePickerDelegate;
}

@property(retain, nonatomic) IBOutlet UIPickerView* monthPicker;
@property(retain, nonatomic) IBOutlet UIPickerView* yearPicker;

- (void) goToNextStep;
- (void) clearData;

@end
