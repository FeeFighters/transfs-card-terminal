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
#import "objCFixes.h"

@interface ZipCode : NSObject
{
	NSString* zipcode;
	NSString* city;
	NSString* state;
	NSString* county;

  // Primary key in the database.
  NSInteger primaryKey;
}

@property(copy, nonatomic) NSString* zipcode;
@property(copy, nonatomic) NSString* city;
@property(copy, nonatomic) NSString* state;
@property(copy, nonatomic) NSString* county;

// Property exposure for primary key and other attributes. The primary key is 'assign' because it is not an object,
// nonatomic because there is no need for concurrent access, and readonly because it cannot be changed without
// corrupting the database.
@property (assign, nonatomic, readonly) NSInteger primaryKey;

// Query for a list of zipcodes
+ (NSArray*) zipcodesByZip:(NSString*)zip fromDatabase:(sqlite3 *)db;

// Finalize (delete) all of the SQLite compiled queries.
+ (void) finalizeStatements;

@end
