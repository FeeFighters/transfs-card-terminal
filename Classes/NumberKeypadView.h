//
//  NumberKeypadView.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/6/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NumberKeypadDelegate
@optional
- (void) keypadNumberPressed:(int)number button:(UIButton*)sender;
- (void) keypadBackspacePressed:(UIButton*)sender;
- (void) keypadPeriodPressed:(UIButton*)sender;
@end


@interface NumberKeypadView : UIView {
	NSMutableArray* keypadButtons;
	IBOutlet id <NSObject, NumberKeypadDelegate> delegate;
}

@property(nonatomic, retain) IBOutlet id <NSObject, NumberKeypadDelegate> delegate;

@end
