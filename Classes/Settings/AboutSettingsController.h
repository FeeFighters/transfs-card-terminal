//
//  AboutSettingsController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/28/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutSettingsController : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView* aboutWebView;
	IBOutlet UIActivityIndicatorView* spinner;
	IBOutlet UILabel* versionLabel;
}

- (IBAction) openInSafari:(id)sender;

@end
