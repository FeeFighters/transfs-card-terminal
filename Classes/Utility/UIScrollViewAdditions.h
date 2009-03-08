//
//  UIScrollViewAdditions.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/25/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIScrollView (TransFSAdditions)

//	To use these additions, add the following into your textfield delegate methods:
//
//	- (void)textFieldDidBeginEditing:(UITextField *)textField
//	{
//		if ([[textField superview] isKindOfClass:[UIScrollView class]])
//			savedContentOffset = [(UIScrollView*)[textField superview] scrollToTextField:textField];
//	}
//
//	- (BOOL)textFieldShouldReturn:(UITextField *)textField
//	{
//		[textField resignFirstResponder];
//		if ([[textField superview] isKindOfClass:[UIScrollView class]])
//			[(UIScrollView*)[textField superview] setContentOffset:savedContentOffset animated:true];
//		return YES;
//	}

- (CGPoint) scrollToTextField:(UITextField*)control;
- (CGPoint) scrollToTextField:(UITextField*)control withOffset:(NSInteger)offset;
- (CGPoint) scrollToControl:(UIControl*)control forKeyboard:(UIKeyboardType)keyboardType;
- (CGPoint) scrollToControl:(UIControl*)control forKeyboard:(UIKeyboardType)keyboardType withOffset:(NSInteger)offset;

@end
