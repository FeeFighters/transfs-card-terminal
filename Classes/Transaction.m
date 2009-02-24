//
//  Transaction.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/22/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "Transaction.h"
#import "ProcessViewController.h"
#import "NSArrayAdditions.h"

@implementation Transaction

@synthesize errorMessages, status;

- (id) init:(TransFS_Card_TerminalAppDelegate*) _delegate
{		
	delegate = _delegate;
	StartViewController *startViewController = [delegate startViewController];
	CardViewController *cardViewController = [delegate cardViewController];
	
	NSString *login = [[NSUserDefaults standardUserDefaults] stringForKey:@"login"];
	if ([NSString is_blank:login])
		login = [NSString stringWithString:@""];
	NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];	
	if ([NSString is_blank:password])
		password = [NSString stringWithString:@""];
	bool testMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"testMode"];
	
	if (testMode) [BillingBase setGatewayMode:Test];
	
	int todayYear = [CardExpirationPickerDelegate currentYear];
	BillingCreditCard *card = [[BillingCreditCard alloc] init:[NSDictionary dictionaryWithObjectsAndKeys:
															   nilToEmptyStr([[cardViewController cardNumberField] text]), @"number",
															   (NSNumber*)MakeInt([[cardViewController monthPicker] selectedRowInComponent:0] + 1), @"month",
															   (NSNumber*)MakeInt(todayYear + [[cardViewController yearPicker] selectedRowInComponent:0]), @"year",
															   nilToEmptyStr([[cardViewController firstNameField] text]), @"firstName",
															   nilToEmptyStr([[cardViewController lastNameField] text]), @"lastName",
															   nilToEmptyStr([[cardViewController cvvNumberField] text]), @"verificationValue",
															   nil]];
	
	// Store sanitized card number that we want to keep around for later
	sanitizedCardNumber = [card displayNumber];
	firstName = [card firstName];
	lastName = [card lastName];
	
	if ([card is_valid])
	{
		AuthorizeNetGateway *gateway = [[AuthorizeNetGateway alloc] init:[NSDictionary dictionaryWithObjectsAndKeys:
																		  login, @"login",
																		  password, @"password",
																		  nil]];
		
		NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
		//		[options setObject:@"1240 W Monroe Ave. #1" forKey:@"address1"];
		//		[options setObject:@"60607" forKey:@"zip"];
		//		[options setObject:@"Chicago" forKey:@"city"];
		//		[options setObject:@"IL" forKey:@"state"];		
		//		
		
		// Store value that we want to keep around for later
		NSString* dollarTxt = [[startViewController dollarAmountLabel] text];
		saleAmount = [dollarTxt floatValue] * 100;
		
		@try {
			BillingResponse *response;	
			response = [gateway authorize:MakeInt(saleAmount) creditcard:card options:[NSDictionary dictionaryWithObject:options forKey:@"address"]];
			if (![response is_success])
				[NSException raise:@"Authorize.Net Gateway Error, authorize:" format:[response message]];
			else {
				
				response = [gateway capture:MakeInt(saleAmount) authorization:[response authorization] options:[[NSDictionary alloc] init]];
				if (![response is_success])
					[NSException raise:@"Authorize.Net Gateway Error, capture:" format:[response message]];
				
				// Store the auth id so that we can void this later
				authorizationId = [response authorization];
				
				//				response = [gateway voidAuthorization:[response authorization] options:[[NSDictionary alloc] init]];
				//				if (![response is_success])
				//					[NSException raise:@"Authorize.Net Gateway Error, void:" format:[response message]];
			}
			
			errorMessages = @"";		
			status = TransactionSuccess;			
		}
		@catch (NSException *exception) {
			errorMessages = [exception reason];		
			status = TransactionError;			
		}
	}
	else 
	{
		NSLog(@"Card Errors: %@", [[[card errors] fullMessages] componentsJoinedByString:@", "]);
		status = TransactionError;
		
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		NSString *curString;
		NSEnumerator *enumerator = [[[card errors] fullMessages] objectEnumerator];
		while (curString = [enumerator nextObject]) {
			[arr addObject:[NSString stringWithFormat:@"• %@", [[curString humanize] capitalizeFirstLetter]]];
		}
		errorMessages = [arr componentsJoinedByString:@"\n"];
	}
	
	return self;
}

@end
