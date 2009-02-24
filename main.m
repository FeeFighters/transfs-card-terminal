//
//  main.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/2/09.
//  Copyright TransFS.com 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <stdlib.h>

int main(int argc, char *argv[]) {
	srandom( time(NULL) );	
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}

