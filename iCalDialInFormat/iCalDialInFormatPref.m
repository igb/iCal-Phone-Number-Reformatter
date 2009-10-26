//
//  iCalDialInFormatPref.m
//  iCalDialInFormat
//
//  Created by Ian Brown on 10/25/09.
//  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
//

#import "iCalDialInFormatPref.h"


@implementation iCalDialInFormatPref

CFStringRef appID;

- (void) mainViewDidLoad
{
	
	NSLog(@"here 2000. . .");

}


- (id)initWithBundle:(NSBundle *)bundle {
	if ( ( self = [super initWithBundle:bundle] ) != nil ) {
		appID = CFSTR("org.hccp.iCalDialInFormatter");
	}
	NSLog(@"appID is %@", appID);
	return self;
	
}


@end
