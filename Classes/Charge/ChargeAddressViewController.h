//
//  ChargeAddressViewController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChargeAddressViewController : UIViewController {
	IBOutlet UITextField* address;
	IBOutlet UITextField* city;
	IBOutlet UITextField* zipcode;	
}

@property(retain, nonatomic) IBOutlet UITextField* address;
@property(retain, nonatomic) IBOutlet UITextField* city;
@property(retain, nonatomic) IBOutlet UITextField* zipcode;	

@end
