//
//  UIScrollViewAdditions.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/25/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "UIScrollViewAdditions.h"


@implementation UIScrollView (TransFSAdditions)

+ (int) scrollOffsetForKeyboardType:(UIKeyboardType)keyboardType
{
	if (keyboardType==UIKeyboardTypeNumberPad)
		return 300;
	if (keyboardType==UIKeyboardTypeEmailAddress)
		return 300;
	if (keyboardType==UIKeyboardTypeASCIICapable)
		return 300;
	if (keyboardType==UIKeyboardTypePhonePad)
		return 300;
	if (keyboardType==UIKeyboardTypeURL)
		return 300;
	if (keyboardType==UIKeyboardTypeNamePhonePad)
		return 300;
	
	return 300;
}

- (CGPoint) scrollToTextField:(UITextField*)control
{
	return [self scrollToControl:control forKeyboard:[control keyboardType] withOffset:0];
}

- (CGPoint) scrollToTextField:(UITextField*)control withOffset:(NSInteger)offset
{
	return [self scrollToControl:control forKeyboard:[control keyboardType] withOffset:offset];
}

- (CGPoint) scrollToControl:(UIControl*)control forKeyboard:(UIKeyboardType)keyboardType
{
	return [self scrollToControl:control forKeyboard:keyboardType withOffset:0];
}

- (CGPoint) scrollToControl:(UIControl*)control forKeyboard:(UIKeyboardType)keyboardType withOffset:(NSInteger)offset
{
	CGPoint saved = [self contentOffset];
	CGPoint loc = [control frame].origin;
	loc.x = 0;
	loc.y -= [self frame].size.height;
	loc.y += [UIScrollView scrollOffsetForKeyboardType:keyboardType];
	loc.y += offset;
	[self setContentOffset:loc animated:YES];
	return saved;
}

@end
