//
//  UIGradientScrollView.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIGradientScrollView : UIScrollView {
	CGGradientRef backgroundGradient;
	UIColor *topColor;
	UIColor *midColor;
	UIColor *bottomColor;	
	float midPosition;
	
	NSMutableArray *hitTestIncludedControls;
}

@property (nonatomic, retain) UIColor *topColor;
@property (nonatomic, retain) UIColor *midColor;
@property (nonatomic, retain) UIColor *bottomColor;
@property (assign) float midPosition;

- (void) addControlToHitTestList:(UIView*)control;

@end
