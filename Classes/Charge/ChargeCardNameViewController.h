//
//  ChargeCardNameViewController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChargeCardNameViewController : UIViewController {
	IBOutlet UITextField* firstName;
	IBOutlet UITextField* lastName;
}

@property(assign, nonatomic) IBOutlet UITextField* firstName;
@property(assign, nonatomic) IBOutlet UITextField* lastName;

- (void) goToNextStep;
- (void) clearData;

@end
