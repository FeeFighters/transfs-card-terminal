//
//  NumberKeypadWithDone.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 8/1/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NumberKeypadWithDone

- (void)initKeyboardWithDone:(UIResponder*)control;
- (void)finishKeyboardWithDone;

- (void)keyboardWillShow:(NSNotification *)note;
- (void)keyboardDoneButton:(id)sender;

@end
