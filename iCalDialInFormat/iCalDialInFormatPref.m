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



- (NSView*)getCalendarPane {
	
	NSArray* mySubviews = [[self mainView] subviews];
	
	for (id subview in mySubviews) {
		if([[subview className]isEqualToString:@"NSBox"]) {
			return subview;
		}	
	}
	
	return nil;
	

}


- (IBAction)myAction:(id)sender {
	@synchronized(self) {
		NSLog(@"sss4ync for checkbox %i state is  %i", [sender tag],[sender state]);
		
		
		
		[calendars objectAtIndex:[sender tag]];
		NSLog(@"cal array %@", calendars);
		CalCalendar*  cal = [calendars objectAtIndex:[sender tag]];
		NSLog(@"object in cal array: %@", cal);
		NSLog(@"activate calendar %@-%@", [cal uid], [cal title]);
	}
}



- (void) mainViewDidLoad
{
	
	calendars = [[NSMutableArray alloc] initWithArray:[[CalCalendarStore defaultCalendarStore] calendars] copyItems:NO];

	


	
	NSView* calendarListPane = [self getCalendarPane];
	

	int calendarsArrayIndex=0;

	
	for (id cal in calendars) {
		
		
	
	CFPropertyListRef thisCalIsActive=CFPreferencesCopyAppValue([cal uid],  appID );
	
		
		
		
		
	 NSRect frame = NSMakeRect(10, 200 - (calendarsArrayIndex * 30), 100, 15); 
	 NSButton *button = [[NSButton alloc] initWithFrame:frame]; 
	 [button setButtonType:NSSwitchButton];
	 [button setTitle:[cal title]];
	 [button setTag:calendarsArrayIndex];	
	 [button setTarget:self];
	 [button setAction:@selector(myAction:)];
		
	 if ( thisCalIsActive && CFGetTypeID(thisCalIsActive) == CFBooleanGetTypeID()  ) {
			[button setState:CFBooleanGetValue(thisCalIsActive)];
	 } else {
			[button setState:NO];
	 }	
		
		
	 [calendarListPane addSubview:button]; 
	 [button release];
	 calendarsArrayIndex+=1;
	

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
