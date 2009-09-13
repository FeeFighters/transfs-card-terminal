//
//  Transaction.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/22/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "TransFS_Card_TerminalAppDelegate.h"
#import "ChargeViewController.h"
#import "CreditCard.h"
#import "CardExpirationPickerDelegate.h"
#import "objCFixes.h"
#import "Base.h"
#import "Money.h"
#import "Gateway.h"
#import "GatewayStandardAPI.h"

typedef enum {
	TransactionSuccess = 0,
	TransactionError,
	TransactionVoided
} TransactionStatusCodes;

@interface Transaction : NSObject
{
	NSString* firstName;
	NSString* lastName;
	NSString* sanitizedCardNumber;
	Money* moneyAmount;
	NSString* authorizationId;
	NSDate* date;

	TransactionStatusCodes status;
	NSString* errorMessages;


    // Opaque reference to the underlying database.
    sqlite3 *database;
    // Primary key in the database.
    NSInteger primaryKey;
    // Internal state variables. Hydrated tracks whether attribute data is in the object or the database.
    BOOL hydrated;
    // Dirty tracks whether there are in-memory changes to data which have no been written to the database.
    BOOL dirty;
}

@property(copy, nonatomic) NSString* firstName;
@property(copy, nonatomic) NSString* lastName;
@property(copy, nonatomic) NSString* sanitizedCardNumber;
@property(copy, nonatomic) Money* moneyAmount;
@property(copy, nonatomic) NSString* authorizationId;
@property(copy, nonatomic) NSDate* date;
@property(assign) TransactionStatusCodes status;

@property(retain, nonatomic) NSString* errorMessages;

// Property exposure for primary key and other attributes. The primary key is 'assign' because it is not an object,
// nonatomic because there is no need for concurrent access, and readonly because it cannot be changed without
// corrupting the database.
@property (assign, nonatomic, readonly) NSInteger primaryKey;

// Initialize the Transaction and Process it!
- (id) initAndProcessWithGateway:(BillingGateway*)gateway;
+ (id) transactionAndProcessWithGateway:(BillingGateway*)gateway;

// Void an existing transaction
- (void)voidTransaction:(BillingGateway*)gateway;

// Finalize (delete) all of the SQLite compiled queries.
+ (void)finalizeStatements;

// Creates the object with primary key and title is brought into memory.
- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db;
// Inserts the transaction into the database and stores its primary key.
- (void)insertIntoDatabase:(sqlite3 *)database;

// Brings the rest of the object data into memory. If already in memory, no action is taken (harmless no-op).
- (void)hydrate;
// Flushes all but the primary key out to the database.
- (void)dehydrate;
// Remove the transaction complete from the database. In memory deletion to follow...
- (void)deleteFromDatabase;
+ (void)deleteAllFromDatabase;

@end
