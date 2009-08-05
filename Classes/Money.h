//
//  Money.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 7/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
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

@protocol CreditCardFormatting
-(id)copyWithZone:(NSZone *)zone;
@end
