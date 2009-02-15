//
//  CardExpirationPickerDelegate.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CardExpirationPickerDelegate : NSObject <UIPickerViewDataSource, UIPickerViewDelegate> {

	IBOutlet UIPickerView *monthPicker;
	IBOutlet UIPickerView *yearPicker;
	
@private	
	NSMutableArray *months;
	NSMutableArray *years;	
}

- (id) init;

//UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

//UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;


@end
