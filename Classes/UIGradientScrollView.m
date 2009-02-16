//
//  UIGradientScrollView.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/15/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "UIGradientScrollView.h"


@implementation UIGradientScrollView

@synthesize topColor, midColor, bottomColor, midPosition;

- (void)drawRect:(CGRect)rect {
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGFloat colors[] =
	{
		0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 1.00,
		26.0 / 255.0, 28.0 / 255.0, 50.0 / 255.0, 1.00,
		83.0 / 255.0,  79.0 / 255.0, 100.0 / 255.0, 1.00,
	};
	backgroundGradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
	CGColorSpaceRelease(rgb);		
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorSpaceRelease(colorSpace);
	CGContextDrawLinearGradient(context, backgroundGradient, 
								CGPointMake(self.bounds.origin.x, self.bounds.origin.y), 
								CGPointMake(self.bounds.origin.x, self.bounds.origin.y + self.bounds.size.height), 
								kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
}


- (void) addControlToHitTestList:(UIView*)control
{
	if (hitTestIncludedControls==nil)
		hitTestIncludedControls = [[NSMutableArray alloc] init];
	
	[hitTestIncludedControls addObject:control];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    for (int i=[self.subviews count]-1; i>=0; i--)
    {
		UIView *curView = [self.subviews objectAtIndex:i];
		if ([hitTestIncludedControls containsObject:curView]) {
			CGPoint convertedPoint = [self convertPoint:point toView:curView];
			if ([(UIControl *)curView hitTest:convertedPoint withEvent:event] != nil)
				return [(UIControl *)curView hitTest:convertedPoint withEvent:event];
		}
    }
	
    return self;
}

- (void)dealloc {
    [super dealloc];
}


@end
