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


	IBOutlet NSButton    *iPhoneCheckbox;
	IBOutlet NSButton    *blackberryCheckbox;
	IBOutlet NSButton    *activateFormatterCheckbox;


	
}

- (id)initWithBundle:(NSBundle *)bundle;

- (void) mainViewDidLoad;

- (IBAction)iPhoneClicked:(id)sender;
- (IBAction)blackberryClicked:(id)sender;
- (IBAction)activateClicked:(id)sender;

@end
