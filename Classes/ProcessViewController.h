//
//  ProcessViewController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/16/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProcessViewController : UIViewController <UIActionSheetDelegate> {
	IBOutlet UIButton* processButton;
	IBOutlet UILabel* responseLabel;
	IBOutlet UILabel* responseInfoLabel;	
	IBOutlet UIActivityIndicatorView* spinner;
}

@property(nonatomic, retain) IBOutlet UILabel* responseLabel;
@property(nonatomic, retain) IBOutlet UILabel* responseInfoLabel;

- (IBAction) processButtonClick:(id)sender;

@end
