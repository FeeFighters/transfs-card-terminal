//
//  Transaction.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/22/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "Transaction.h"
#import "Response.h"
#import "ChargeViewController.h"
#import "NSArrayAdditions.h"
#import "IpAddress.h"
#import <sqlite3.h>

// Static variables for compiled SQL queries. This implementation choice is to be able to share a one time
// compilation of each query across all instances of the class. Each time a query is used, variables may be bound
// to it, it will be "stepped", and then reset for the next usage. When the application begins to terminate,
// a class method will be invoked to "finalize" (delete) the compiled queries - this must happen before the database
// can be closed.
static sqlite3_stmt *insert_statement = nil;
static sqlite3_stmt *init_statement = nil;
static sqlite3_stmt *delete_statement = nil;
static sqlite3_stmt *deleteall_statement = nil;
static sqlite3_stmt *hydrate_statement = nil;
static sqlite3_stmt *dehydrate_statement = nil;

@implementation Transaction

@synthesize status, errorMessages;

// Finalize (delete) all of the SQLite compiled queries.
+ (void)finalizeStatements {
    if (insert_statement) {
        sqlite3_finalize(insert_statement);
        insert_statement = nil;
    }
    if (init_statement) {
        sqlite3_finalize(init_statement);
        init_statement = nil;
    }
    if (delete_statement) {
        sqlite3_finalize(delete_statement);
        delete_statement = nil;
    }
    if (deleteall_statement) {
        sqlite3_finalize(deleteall_statement);
        deleteall_statement = nil;
    }
    if (hydrate_statement) {
        sqlite3_finalize(hydrate_statement);
        hydrate_statement = nil;
    }
    if (dehydrate_statement) {
        sqlite3_finalize(dehydrate_statement);
        dehydrate_statement = nil;
    }
}

// Creates the object with primary key
- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db {
    if (self = [super init]) {
        primaryKey = pk;
        database = db;
		[self hydrate];
    }
    return self;
}

- (void)insertIntoDatabase:(sqlite3 *)db {
    database = db;
    // This query may be performed many times during the run of the application. As an optimization, a static
    // variable is used to store the SQLite compiled byte-code for the query, which is generated one time - the first
    // time the method is executed by any Book object.
    if (insert_statement == nil) {
        static char *sql = "INSERT INTO transactions (firstName, lastName, cents, date, status) VALUES(?,?,?,?,?)";
        if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
    sqlite3_bind_text(insert_statement, 1, [firstName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement, 2, [lastName UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(insert_statement, 3, [[moneyAmount cents] intValue]);
	sqlite3_bind_double(insert_statement, 4, [date timeIntervalSince1970]);
	sqlite3_bind_int(insert_statement, 5, (int)status);
    int success = sqlite3_step(insert_statement);
    // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
    sqlite3_reset(insert_statement);
    if (success == SQLITE_ERROR) {
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
    } else {
        // SQLite provides a method which retrieves the value of the most recently auto-generated primary key sequence
        // in the database. To access this functionality, the table should have a column declared of type
        // "INTEGER PRIMARY KEY"
        primaryKey = sqlite3_last_insert_rowid(database);
    }
    // All data for the transaction is already in memory, but has not be written to the database
    // Mark as hydrated to prevent empty/default values from overwriting what is in memory
    hydrated = YES;
}

- (id) initAndProcessWithGateway:(BillingGateway*)gateway
{
	TransFS_Card_TerminalAppDelegate* delegate = (TransFS_Card_TerminalAppDelegate*)[[UIApplication sharedApplication] delegate];
	ChargeAmountViewController* chargeAmountViewController = delegate.chargeViewController.chargeAmountViewController;
	ChargeCardNameViewController* chargeCardNameViewController = delegate.chargeViewController.chargeCardNameViewController;
	ChargeCardNumberViewController* chargeCardNumberViewController = delegate.chargeViewController.chargeCardNumberViewController;
	ChargeCardExpViewController* chargeCardExpViewController = delegate.chargeViewController.chargeCardExpViewController;
	ChargeCardCvvViewController* chargeCardCvvViewController = delegate.chargeViewController.chargeCardCvvViewController;
	ChargeAddressViewController* chargeAddressViewController = delegate.chargeViewController.chargeAddressViewController;

	int todayYear = [CardExpirationPickerDelegate currentYear];
	BillingCreditCard *card = [[BillingCreditCard alloc] init:[NSDictionary dictionaryWithObjectsAndKeys:
															   nilToEmptyStr(chargeCardNumberViewController.number), @"number",
															   (NSNumber*)MakeInt([chargeCardExpViewController.monthPicker selectedRowInComponent:0] + 1), @"month",
															   (NSNumber*)MakeInt(todayYear + [chargeCardExpViewController.yearPicker selectedRowInComponent:0]), @"year",
															   nilToEmptyStr(chargeCardNameViewController.firstName.text), @"firstName",
															   nilToEmptyStr(chargeCardNameViewController.lastName.text), @"lastName",
															   nilToEmptyStr(chargeCardCvvViewController.number), @"verificationValue",
															   nil]];

	// Store sanitized card number that we want to keep around for later
	self.sanitizedCardNumber = [NSString stringWithString:[card displayNumber]];
	self.firstName = [NSString stringWithString:[card firstName]];
	self.lastName = [NSString stringWithString:[card lastName]];

	if ([card is_valid])
	{
		NSMutableDictionary *addressOptions = [[NSMutableDictionary alloc] init];

		bool avsEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"avsEnabled"];
		if (avsEnabled) {
			[addressOptions setObject:nilToEmptyStr(chargeAddressViewController.address.text) forKey:@"address1"];
			[addressOptions setObject:nilToEmptyStr(chargeAddressViewController.zipcode.text) forKey:@"zip"];
			[addressOptions setObject:nilToEmptyStr(chargeAddressViewController.city.text) forKey:@"city"];
			[addressOptions setObject:nilToEmptyStr(chargeAddressViewController.state.text) forKey:@"state"];
			[addressOptions setObject:nilToEmptyStr(@"US") forKey:@"country"];
			[addressOptions setObject:nilToEmptyStr([NSString stringWithFormat:@"%@ %@", nilToEmptyStr(chargeCardNameViewController.firstName.text), nilToEmptyStr(chargeCardNameViewController.lastName.text)])
                         forKey:@"name"];
		}

		NSMutableDictionary *authorizeOptions = [NSMutableDictionary dictionaryWithObject:addressOptions forKey:@"address"];
		if (avsEnabled) {
			[authorizeOptions setObject:addressOptions forKey:@"shippingAddress"];
		}
		[authorizeOptions setObject:nilToEmptyStr([IpAddress stringFromIpAddress]) forKey:@"ip"];

		// Store value that we want to keep around for later
		NSString* dollarTxt = chargeAmountViewController.number;
		self.moneyAmount = [Money moneyWithDollars:[dollarTxt floatValue]];

		@try {
			BillingResponse *response;
			response = [gateway authorize:self.moneyAmount creditcard:card options:authorizeOptions];
			if (![response is_success])
				[NSException raise:@"Authorize.Net Gateway Error, authorize:" format:[response message]];
			else {

				response = [gateway capture:self.moneyAmount authorization:[response authorization] options:[[NSDictionary alloc] init]];
				if (![response is_success])
					[NSException raise:@"Authorize.Net Gateway Error, capture:" format:[response message]];

				// Store the auth id so that we can void this later
				self.authorizationId = [NSString stringWithString:[response authorization]];
			}

			self.errorMessages = @"";
			self.status = TransactionSuccess;
			self.date = [NSDate date];
			[delegate addTransaction:self];
		}
		@catch (NSException *exception) {
			self.errorMessages = [NSString stringWithString:[exception reason]];
			self.status = TransactionError;
		}
	}
	else
	{
		NSLog(@"Card Errors: %@", [[[card errors] fullMessages] componentsJoinedByString:@", "]);
		self.status = TransactionError;

		NSMutableArray *arr = [[NSMutableArray alloc] init];
		NSString *curString;
		NSEnumerator *enumerator = [[[card errors] fullMessages] objectEnumerator];
		while (curString = [enumerator nextObject]) {
			[arr addObject:[NSString stringWithFormat:@"• %@", [[curString humanize] capitalizeFirstLetter]]];
		}
		self.errorMessages = [NSString stringWithString:[arr componentsJoinedByString:@"\n"]];
	}

	return self;
}

+ (id) transactionAndProcessWithGateway:(BillingGateway*)gateway
{
	return [[Transaction alloc] initAndProcessWithGateway:gateway];
}



- (void)voidTransaction:(BillingGateway*)gateway
{
	@try {
		BillingResponse *response = [gateway voidAuthorization:self.authorizationId options:[[NSDictionary alloc] init]];
		if (![response is_success])
			[NSException raise:@"Authorize.Net Gateway Error, void:" format:[response message]];

		self.errorMessages = @"";
		self.status = TransactionVoided;
		self.date = [NSDate date];
	}
	@catch (NSException *exception) {
		self.errorMessages = [exception reason];
		self.status = TransactionError;
	}
}


- (void)deleteFromDatabase {
    // Compile the delete statement if needed.
    if (delete_statement == nil) {
        const char *sql = "DELETE FROM transactions WHERE pk=?";
        if (sqlite3_prepare_v2(database, sql, -1, &delete_statement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
    // Bind the primary key variable.
    sqlite3_bind_int(delete_statement, 1, primaryKey);
    // Execute the query.
    int success = sqlite3_step(delete_statement);
    // Reset the statement for future use.
    sqlite3_reset(delete_statement);
    // Handle errors.
    if (success != SQLITE_DONE) {
        NSAssert1(0, @"Error: failed to delete from database with message '%s'.", sqlite3_errmsg(database));
    }
}

+ (void)deleteAllFromDatabase {
	sqlite3* database = [(TransFS_Card_TerminalAppDelegate*)[[UIApplication sharedApplication] delegate] database];
    // Compile the delete statement if needed.
    if (deleteall_statement == nil) {
        const char *sql = "DELETE FROM transactions";
        if (sqlite3_prepare_v2(database, sql, -1, &deleteall_statement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
    // Execute the query.
    int success = sqlite3_step(deleteall_statement);
    // Reset the statement for future use.
    sqlite3_reset(deleteall_statement);
    // Handle errors.
    if (success != SQLITE_DONE) {
        NSAssert1(0, @"Error: failed to delete all from database with message '%s'.", sqlite3_errmsg(database));
    }
	[[(TransFS_Card_TerminalAppDelegate*)[[UIApplication sharedApplication] delegate] transactionHistory] removeAllObjects];
}

// Brings the rest of the object data into memory. If already in memory, no action is taken (harmless no-op).
- (void)hydrate {
    // Check if action is necessary.
    if (hydrated) return;
    // Compile the hydration statement, if needed.
    if (hydrate_statement == nil) {
        const char *sql = "SELECT firstName, lastName, cents, authorizationId, sanitizedCardNumber, date, status FROM transactions WHERE pk=?";
        if (sqlite3_prepare_v2(database, sql, -1, &hydrate_statement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
    // Bind the primary key variable.
    sqlite3_bind_int(hydrate_statement, 1, primaryKey);
    // Execute the query.
    int success =sqlite3_step(hydrate_statement);
    if (success == SQLITE_ROW) {
        char *str;

		str = (char *)sqlite3_column_text(hydrate_statement, 0);
        self.firstName = (str) ? [NSString stringWithUTF8String:str] : @"";

        str = (char *)sqlite3_column_text(hydrate_statement, 1);
        self.lastName = (str) ? [NSString stringWithUTF8String:str] : @"";

		int cents = sqlite3_column_int(hydrate_statement, 2);
        self.moneyAmount = [Money moneyWithCents:cents];

        str = (char *)sqlite3_column_text(hydrate_statement, 3);
        self.authorizationId = (str) ? [NSString stringWithUTF8String:str] : @"";

        str = (char *)sqlite3_column_text(hydrate_statement, 4);
        self.sanitizedCardNumber = (str) ? [NSString stringWithUTF8String:str] : @"";

        self.date = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(hydrate_statement, 5)];

		self.status = (TransactionStatusCodes)sqlite3_column_int(hydrate_statement, 6);

    } else {
        // The query did not return
        self.firstName = @"Unknown";
        self.lastName = @"";
        self.moneyAmount = [Money moneyWithCents:0];
        self.authorizationId = @"";
        self.sanitizedCardNumber = @"Unknown";
    }

    // Reset the query for the next use.
    sqlite3_reset(hydrate_statement);
    // Update object state with respect to hydration.
    hydrated = YES;
}

// Flushes all but the primary key and title out to the database.
- (void)dehydrate {
    if (dirty) {
        // Write any changes to the database.
        // First, if needed, compile the dehydrate query.
        if (dehydrate_statement == nil) {
            const char *sql = "UPDATE transactions SET firstName=?, lastName=?, cents=?, authorizationId=?, sanitizedCardNumber=?, date=?, status=? WHERE pk=?";
            if (sqlite3_prepare_v2(database, sql, -1, &dehydrate_statement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            }
        }
        // Bind the query variables.
        sqlite3_bind_text(dehydrate_statement, 1, [firstName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(dehydrate_statement, 2, [lastName UTF8String], -1, SQLITE_TRANSIENT);
		int cents = [[moneyAmount cents] intValue];
        sqlite3_bind_int(dehydrate_statement, 3, cents);
        sqlite3_bind_text(dehydrate_statement, 4, [authorizationId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(dehydrate_statement, 5, [sanitizedCardNumber UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_double(dehydrate_statement, 6, [date timeIntervalSince1970]);
        sqlite3_bind_int(dehydrate_statement, 7, (int)status);
        sqlite3_bind_int(dehydrate_statement, 8, primaryKey);
        // Execute the query.
        int success = sqlite3_step(dehydrate_statement);
        // Reset the query for the next use.
        sqlite3_reset(dehydrate_statement);
        // Handle errors.
        if (success != SQLITE_DONE) {
            NSAssert1(0, @"Error: failed to dehydrate with message '%s'.", sqlite3_errmsg(database));
        }
        // Update the object state with respect to unwritten changes.
        dirty = NO;
    }
    // Release member variables to reclaim memory. Set to nil to avoid over-releasing them
    // if dehydrate is called multiple times.
    [firstName release];
    firstName = nil;
    [lastName release];
    lastName = nil;
    [authorizationId release];
    authorizationId = nil;
    [sanitizedCardNumber release];
    sanitizedCardNumber = nil;
    // Update the object state with respect to hydration.
    hydrated = NO;
}



#pragma mark Properties
// Accessors implemented below. All the "get" accessors simply return the value directly, with no additional
// logic or steps for synchronization. The "set" accessors attempt to verify that the new value is definitely
// different from the old value, to minimize the amount of work done. Any "set" which actually results in changing
// data will mark the object as "dirty" - i.e., possessing data that has not been written to the database.
// All the "set" accessors copy data, rather than retain it. This is common for value objects - strings, numbers,
// dates, data buffers, etc. This ensures that subsequent changes to either the original or the copy don't violate
// the encapsulation of the owning object.

#define storeAttr(attrName) if ((!attrName && !aString) || (attrName && aString && [attrName isEqualToString:aString])) return; \
	dirty = YES; \
	[attrName release]; \
	attrName = [aString copy]; \


- (NSInteger)primaryKey {
    return primaryKey;
}

- (NSString *)lastName {
    return lastName;
}
- (void)setLastName:(NSString *)aString {
	storeAttr(lastName);
}

- (NSString *)firstName {
    return firstName;
}
- (void)setFirstName:(NSString *)aString {
	storeAttr(firstName);
}

- (Money*)moneyAmount {
    return moneyAmount;
}
- (void)setMoneyAmount:(Money*)aMoney {
	if ((!moneyAmount && !aMoney) ||
	    (moneyAmount && aMoney && ([moneyAmount.cents intValue]==[aMoney.cents intValue]))
	    ) return;
  dirty = YES;
  [moneyAmount release];
  moneyAmount = [aMoney copy];
}

- (NSString *)authorizationId {
    return authorizationId;
}
- (void)setAuthorizationId:(NSString *)aString {
	storeAttr(authorizationId);
}

- (NSString *)sanitizedCardNumber {
    return sanitizedCardNumber;
}
- (void)setSanitizedCardNumber:(NSString *)aString {
	storeAttr(sanitizedCardNumber);
}

- (NSDate *)date {
    return date;
}
- (void)setDate:(NSDate *)aDate {
    if ((!date && !aDate) || (date && aDate && [date isEqualToDate:aDate])) return;
    dirty = YES;
    [date release];
    date = [aDate copy];
}

- (TransactionStatusCodes)status {
    return status;
}
- (void)setStatus:(TransactionStatusCodes)aVal {
	if (status == aVal) return;
	dirty = YES;
	status = aVal;
}



@end
