//
//  IpAddress.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 8/6/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "IpAddress.h"

@implementation IpAddress

+ (NSString *) stringFromIpAddress {
	char iphone_ip[255];
	strcpy(iphone_ip,"127.0.0.1"); // if everything fails
	NSHost* myhost =[NSHost currentHost];
	if (myhost)
	{
		NSString *ad = [myhost address];
		if (ad)
			strcpy(iphone_ip,[ad cStringUsingEncoding: NSISOLatin1StringEncoding]);
	}
	return [NSString stringWithFormat:@"%s",iphone_ip]; 
}

@end