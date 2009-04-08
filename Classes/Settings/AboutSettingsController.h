//
//  AboutSettingsController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutSettingsController : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView* aboutWebView;
	IBOutlet UIActivityIndicatorView* spinner;
}

- (IBAction) openInSafari:(id)sender;

@end
