//
//  NumberKeypadWithDone_Implementation.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/6/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

static UIResponder* keyboardWithDoneControl = nil;
static UIButton *doneButton = nil;

- (void)keyboardWillShow:(NSNotification *)note {
    // create custom button
    if (doneButton == nil) {
			doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
	    doneButton.frame = CGRectMake(0, 163, 106, 53);
	    doneButton.adjustsImageWhenHighlighted = NO;
	    if ([[[UIDevice currentDevice] systemVersion] hasPrefix:@"3"]) {
	        [doneButton setImage:[UIImage imageNamed:@"DoneUp3.png"] forState:UIControlStateNormal];
	        [doneButton setImage:[UIImage imageNamed:@"DoneDown3.png"] forState:UIControlStateHighlighted];
	    } else {
	        [doneButton setImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
	        [doneButton setImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
	    }
	    [doneButton addTarget:self action:@selector(keyboardDoneButton:) forControlEvents:UIControlEventTouchUpInside];
		}

	doneButton.hidden = false;
    // locate keyboard view
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    UIView* keyboard;
    for(int i=0; i<[tempWindow.subviews count]; i++) {
        keyboard = [tempWindow.subviews objectAtIndex:i];
        // keyboard view found; add the custom button to it
        if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
            [keyboard addSubview:doneButton];
    }
}

// Callback for done button on numeric keypad
- (void)keyboardDoneButton:(id)sender {
    [keyboardWithDoneControl resignFirstResponder];
}

- (void)initKeyboardWithDone:(UIResponder*)control {
	keyboardWithDoneControl = control;
	[[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
}

- (void)finishKeyboardWithDone {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	doneButton.hidden = true;
}

