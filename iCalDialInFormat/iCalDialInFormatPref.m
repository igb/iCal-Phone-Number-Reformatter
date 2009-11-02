//
//  iCalDialInFormatPref.m
//  iCalDialInFormat
//
//  Created by Ian Brown on 10/25/09.
//  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
//
#include <CalendarStore/CalendarStore.h>

#import "iCalDialInFormatPref.h"
#import "constants.h"


@implementation iCalDialInFormatPref

CFStringRef appID;


- (IBAction)myAction:(id)sender {
	NSLog(@"in action");
}



- (void) mainViewDidLoad
{
	
	NSArray* calendars=[[CalCalendarStore defaultCalendarStore] calendars];

	
	NSView* calendarListPane;
	
	NSArray* mySubviews = [[self mainView] subviews];

	for (id subview in mySubviews) {
		if([[subview className]isEqualToString:@"NSBox"]) {
			calendarListPane=subview;
		}	
	}

	int offset=0;
	
	for (id cal in calendars) {
	
	NSRect frame = NSMakeRect(10, 300 - offset, 100, 10); 
	NSButton *button = [[NSButton alloc] initWithFrame:frame]; 
	 [button setButtonType:NSSwitchButton];
	[button setTitle:[cal title]];
		[button setTarget:self];
		[button setAction:@selector(myAction:)];
		[calendarListPane addSubview:button]; 
	[button release];
		offset+=40;
	

	}



	
	
	CFPropertyListRef iPhoneCheckboxValue;
	CFPropertyListRef blackberryCheckboxValue;
	CFPropertyListRef isActiveValue;

	

	
	iPhoneCheckboxValue = CFPreferencesCopyAppValue(FORMAT_FOR_IPHONE,  appID );
    if ( iPhoneCheckboxValue && CFGetTypeID(iPhoneCheckboxValue) == CFBooleanGetTypeID()  ) {
        [iPhoneCheckbox setState:CFBooleanGetValue(iPhoneCheckboxValue)];
    } else {
        [iPhoneCheckbox setState:NO];
    }
	
	blackberryCheckboxValue = CFPreferencesCopyAppValue(FORMAT_FOR_BLACKBERRY,  appID );
    if ( blackberryCheckboxValue && CFGetTypeID(blackberryCheckboxValue) == CFBooleanGetTypeID()  ) {
        [blackberryCheckbox setState:CFBooleanGetValue(blackberryCheckboxValue)];
    } else {
        [blackberryCheckbox setState:NO];
    }
	
	
	isActiveValue= CFPreferencesCopyAppValue(IS_ACTIVE,  appID );
    if ( isActiveValue && CFGetTypeID(isActiveValue) == CFBooleanGetTypeID()  ) {
        [activateFormatterCheckbox setState:CFBooleanGetValue(isActiveValue)];
    } else {
        [activateFormatterCheckbox setState:NO];
    }
	
	
}


- (id)initWithBundle:(NSBundle *)bundle {
	if ( ( self = [super initWithBundle:bundle] ) != nil ) {
		appID = APP_ID;
	}
	NSLog(@"appID is %@", appID);
	
	return self;
	
}


- (IBAction)iPhoneClicked:(id)sender
{
    if ( [sender state] )
        CFPreferencesSetAppValue(FORMAT_FOR_IPHONE,
								 kCFBooleanTrue, appID );
    else
        CFPreferencesSetAppValue(FORMAT_FOR_IPHONE,
								 kCFBooleanFalse, appID );
}


- (IBAction)blackberryClicked:(id)sender
{
    if ( [sender state] )
        CFPreferencesSetAppValue(FORMAT_FOR_BLACKBERRY,
								 kCFBooleanTrue, appID );
    else
        CFPreferencesSetAppValue(FORMAT_FOR_BLACKBERRY,
								 kCFBooleanFalse, appID );
}

- (IBAction)activateClicked:(id)sender
{
    if ( [sender state] )
        CFPreferencesSetAppValue(IS_ACTIVE,
								 kCFBooleanTrue, appID );
    else
        CFPreferencesSetAppValue(IS_ACTIVE,
								 kCFBooleanFalse, appID );
}



- (void)didUnselect
{
    CFNotificationCenterRef center;
	
    CFPreferencesAppSynchronize( appID );
	
    center = CFNotificationCenterGetDistributedCenter();
    CFNotificationCenterPostNotification(center,
										 CFSTR("Preferences Changed"), appID, NULL, TRUE);
}


@end
