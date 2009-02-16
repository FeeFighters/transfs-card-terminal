//
//  UIGradientView.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/2/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "UIGradientView.h"


@implementation UIGradientView

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


- (void)dealloc {
    [super dealloc];
}


@end
