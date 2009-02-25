//
//  AddressViewController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/21/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransFS_Card_TerminalAppDelegate.h"

@interface AddressViewController : UIViewController {
	
	IBOutlet TransFS_Card_TerminalAppDelegate* delegate;
}

- (IBAction) proceedPressed:(id)sender;

@end
