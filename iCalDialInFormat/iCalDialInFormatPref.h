//
//  iCalDialInFormatPref.h
//  iCalDialInFormat
//
//  Created by Ian Brown on 10/25/09.
//  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>


@interface iCalDialInFormatPref : NSPreferencePane 
{

	IBOutlet NSButton    *theCheckbox;
	IBOutlet NSTextField *theTextField;

	
}

- (id)initWithBundle:(NSBundle *)bundle;

- (void) mainViewDidLoad;

@end
