//
//  ZipCode.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 8/5/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "ZipCode.h"
#import "NSArrayAdditions.h"
#import <sqlite3.h>

// Static variables for compiled SQL queries. This implementation choice is to be able to share a one time
// compilation of each query across all instances of the class. Each time a query is used, variables may be bound
// to it, it will be "stepped", and then reset for the next usage. When the application begins to terminate,
// a class method will be invoked to "finalize" (delete) the compiled queries - this must happen before the database
// can be closed.
static sqlite3_stmt *query_statement = nil;

@implementation ZipCode

@synthesize zipcode, city, state, county, primaryKey;

// Finalize (delete) all of the SQLite compiled queries.
+ (void)finalizeStatements {
    if (query_statement) {
        sqlite3_finalize(query_statement);
        query_statement = nil;
    }
}

// Query for a list of zipcodes
+ (NSArray*) zipcodesByZip:(NSString*)zip fromDatabase:(sqlite3 *)database
{
  if (query_statement == nil) {
      NSString *sql = [NSString stringWithFormat:@"SELECT zip, city, state, county FROM zips WHERE zip='%@';", zip];
      if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &query_statement, NULL) != SQLITE_OK) {
          NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
      }
  }

	NSMutableArray* zipCodes = [[NSMutableArray alloc] init];
	char *str;

 	while( query_statement && SQLITE_ROW==sqlite3_step(query_statement) ){
		ZipCode* z = [[ZipCode alloc] init];

		str = (char *)sqlite3_column_text(query_statement, 0);
    z.zipcode = (str) ? [NSString stringWithUTF8String:str] : @"";

		str = (char *)sqlite3_column_text(query_statement, 1);
    z.city = (str) ? [NSString stringWithUTF8String:str] : @"";

		str = (char *)sqlite3_column_text(query_statement, 2);
    z.state = (str) ? [NSString stringWithUTF8String:str] : @"";

		str = (char *)sqlite3_column_text(query_statement, 3);
    z.county = (str) ? [NSString stringWithUTF8String:str] : @"";

		[zipCodes addObject:z];
	}

  // Reset the query for the next use.
  sqlite3_reset(query_statement);

	return zipCodes;
}


@end
