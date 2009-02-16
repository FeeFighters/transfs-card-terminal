//
//  ProcessViewController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/16/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProcessViewController : UIViewController {
	IBOutlet UIButton* processButton;
	IBOutlet UILabel* responseLabel;
	IBOutlet UIActivityIndicatorView* spinner;
}

- (IBAction) processButtonClick:(id)sender;

@end
