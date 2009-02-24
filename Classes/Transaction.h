//
//  Transaction.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/22/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransFS_Card_TerminalAppDelegate.h"
#import "ProcessViewController.h"
#import "TransFS_Card_TerminalAppDelegate.h"
#import "CreditCard.h"
#import "CardExpirationPickerDelegate.h"
#import "objCFixes.h"
#import "AuthorizeNetGateway.h"
#import "Base.h"

typedef enum {
	TransactionSuccess = 0,
	TransactionError 
} TransactionStatusCodes;

@interface Transaction : NSObject {
	TransFS_Card_TerminalAppDelegate* delegate;
	
	NSString* firstName;
	NSString* lastName;	
	NSString* sanitizedCardNumber;
	float dollarAmount;
	NSString* authorizationId;
	
	TransactionStatusCodes status;
	NSString* errorMessages;
}

@property(readonly) NSString* firstName;
@property(readonly) NSString* lastName;	
@property(readonly) NSString* sanitizedCardNumber;
@property(readonly) float dollarAmount;
@property(readonly) NSString* authorizationId;

@property(readonly) TransactionStatusCodes status;
@property(readonly) NSString* errorMessages;

- (id) init:(TransFS_Card_TerminalAppDelegate*) delegate;


@end
