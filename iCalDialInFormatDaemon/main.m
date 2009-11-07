#include <CoreFoundation/CoreFoundation.h>
#include <Foundation/Foundation.h>
#include <CalendarStore/CalendarStore.h>
#import "RegexKitLite.h"



#import "../iCalDialInFormat/constants.h"



NSString* extract_single_value_for_regex(NSString *data, NSString* regex)
{       
	
	NSArray  *capturesArray = NULL;
	
	capturesArray = [[data uppercaseString] arrayOfCaptureComponentsMatchedByRegex:regex];
	
	
	
	if ([capturesArray count] !=1) {
		return nil;
	} else {
		
		NSArray* results=[capturesArray objectAtIndex:0];
		if ([results count] !=2) {
			return nil;
		} else {
			return [results objectAtIndex:1];
		}
	}
	
	
}



NSString* extract_passcode(NSString *calendarData)
{       
	
	
	NSMutableArray* passcodeStrategies=[[NSMutableArray alloc] init];
	
	[passcodeStrategies addObject:REGEX_PASS_CODE];
	[passcodeStrategies addObject:REGEX_PARTICIPANT_CODE];
	[passcodeStrategies addObject:REGEX_PC_ABBREV];
	
	
	for (id regex in passcodeStrategies) {
	
		NSString* passcode=nil;
	
		passcode=extract_single_value_for_regex(calendarData,	regex);
	
		if (passcode) {
			return passcode;
		}
	}
	return nil;
		
}


int main (int argc, const char * argv[]) {
	
	NSAutoreleasePool	 *autoreleasepool = [[NSAutoreleasePool alloc] init];
	
	
	CFPropertyListRef iPhoneCheckboxValue;
	CFPropertyListRef blackberryCheckboxValue;
	CFPropertyListRef isActiveValue;
	
	
	
	iPhoneCheckboxValue = CFPreferencesCopyAppValue(FORMAT_FOR_IPHONE,  APP_ID );
	blackberryCheckboxValue = CFPreferencesCopyAppValue(FORMAT_FOR_BLACKBERRY,  APP_ID );
	isActiveValue = CFPreferencesCopyAppValue(IS_ACTIVE,  APP_ID );
	
	NSArray* calendars = [[CalCalendarStore defaultCalendarStore] calendars];
	
	
	
	for (id cal in calendars) {
		if (CFBooleanGetValue(isActiveValue) && CFPreferencesCopyAppValue([cal uid], APP_ID)) {
			
			NSLog(@"Formatter is active: %d", CFBooleanGetValue(isActiveValue));
			NSLog(@"Running with active cal: %@", [cal title]);
			
			NSMutableArray* calArray = [[NSMutableArray alloc] init];
			[calArray addObject:cal];
			
			
			// do thread work
			// Create a predicate to fetch all events for this year
			NSInteger year = [[NSCalendarDate date] yearOfCommonEra];
			
			NSDate *startDate = [[NSCalendarDate dateWithYear:year month:1 day:1 hour:0 minute:0 second:0 timeZone:nil] retain];
			NSDate *endDate = [[NSCalendarDate dateWithYear:year month:12 day:31 hour:23 minute:59 second:59 timeZone:nil] retain];
			NSPredicate *eventsForThisYear = [CalCalendarStore eventPredicateWithStartDate:startDate endDate:endDate
																				 calendars:calArray];
			
			
			// Fetch all events for this year
			NSArray *events = [[CalCalendarStore defaultCalendarStore] eventsWithPredicate:eventsForThisYear];
			id myEvent;
			int count=0;
			for (id event in events) {
				
				NSString* passcode=nil;

				
				// CHECK LOCATION FOR PASSCODE
				
				if ( [event location] != nil ) {
					
					passcode=extract_passcode([event location]);					
					
				}
				
				// CHECK NOTES FOR PASSCODE

				if ( [event notes] != nil  ) {
				
					
					passcode=extract_passcode([event notes]);
					
					
				}
				
				if(passcode != nil) {
					NSLog(@"FOUNDEVENT: %@-%@", [event title], passcode);
					count++;
				}
 
				
			}
			NSLog(@"found %i events with passcode", count);
			
			//((CalCalendarItem*)myEvent).title=@"BTS"; 
			
			//NSLog(@"%@", [myEvent location]);
			
			
			//NSError *calError;
			//if ([[CalCalendarStore defaultCalendarStore] saveEvent:myEvent span:CalSpanThisEvent error:&calError] == NO){
			//}
			
			
			
			
		}
	}	
	
	[autoreleasepool release];
	
    return 0;
}





