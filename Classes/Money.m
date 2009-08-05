//
//  Money.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 7/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Money.h"
#import "objCFixes.h"

@implementation Money

@synthesize cents;

- (id) initWithCents:(int)_cents
{
	self.cents = MakeInt(_cents);
	return self;
}

- (id) initWithDollars:(float)dollars
{
	self.cents = MakeInt(dollars * 100);
	return self;
}

- (float) dollars
{
	return [self.cents floatValue]/100.0;
}

+ (id) moneyWithCents:(int)cents
{
	return [[Money alloc]	initWithCents:cents];
}
+ (id) moneyWithDollars:(float)dollars
{
	return [[Money alloc]	initWithDollars:dollars];
}


-(id)copyWithZone:(NSZone *)zone
{
    Money *copy = [[[self class] allocWithZone: zone] init];
    copy.cents = [self.cents copy];
    return copy;
}

@end
