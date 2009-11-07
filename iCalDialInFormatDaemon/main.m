#include <CoreFoundation/CoreFoundation.h>
#include <Foundation/Foundation.h>
#include <CalendarStore/CalendarStore.h>
#import "RegexKitLite.h"



#import "../iCalDialInFormat/constants.h"



NSString* extract_single_value_for_regex(NSString *calendarData, NSString* regex)
{       
	
	
	
}



NSString* extract_passcode(NSString *calendarData)
{       
	
	NSString *passcodeRegex   = @"PASS.*CODE[ :]*([0-9]+)";

	NSArray  *capturesArray = NULL;
	
	capturesArray = [[calendarData uppercaseString] arrayOfCaptureComponentsMatchedByRegex:passcodeRegex];
	
	
	
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
			NSString* passcode;
			
			for (id event in events) {
				
				
				
				// CHECK LOCATION FOR PASSCODE
				
				if ( [event location] != nil ) {
					
					passcode=extract_passcode([event location]);					
					
				}
				
				// CHECK NOTES FOR PASSCODE

				if ( [event notes] != nil  ) {
				
					
					passcode=extract_passcode([event notes]);
					
					
				}
				
				NSLog(@"%@-%@", [event title], passcode);
 
				
			}
			
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





