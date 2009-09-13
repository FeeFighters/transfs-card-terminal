//
//  Money.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 7/12/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Money : NSObject <NSCopying> {
	NSNumber* cents;
}

@property(copy, nonatomic) NSNumber* cents;

- (id) initWithCents:(int)cents;
- (id) initWithDollars:(float)dollars;
- (float) dollars;

+ (id) moneyWithCents:(int)cents;
+ (id) moneyWithDollars:(float)dollars;

@end

@interface Money (NSCopying)
-(id)copyWithZone:(NSZone *)zone;
@end
