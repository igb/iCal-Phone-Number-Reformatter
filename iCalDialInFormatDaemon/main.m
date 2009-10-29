#include <CoreFoundation/CoreFoundation.h>
#include <Foundation/Foundation.h>
#include <CalendarStore/CalendarStore.h>


#import "../iCalDialInFormat/constants.h"

int main (int argc, const char * argv[]) {

	CFPropertyListRef iPhoneCheckboxValue;
	CFPropertyListRef blackberryCheckboxValue;
	CFPropertyListRef isActiveValue;



	iPhoneCheckboxValue = CFPreferencesCopyAppValue(FORMAT_FOR_IPHONE,  APP_ID );
	blackberryCheckboxValue = CFPreferencesCopyAppValue(FORMAT_FOR_BLACKBERRY,  APP_ID );
	isActiveValue = CFPreferencesCopyAppValue(IS_ACTIVE,  APP_ID );
	if (CFBooleanGetValue(isActiveValue)) {

		NSLog(@"Formatter is active: %d", CFBooleanGetValue(isActiveValue));
	
		NSAutoreleasePool	 *autoreleasepool = [[NSAutoreleasePool alloc] init];
		// do thread work
		// Create a predicate to fetch all events for this year
		NSInteger year = [[NSCalendarDate date] yearOfCommonEra];
		NSDate *startDate = [[NSCalendarDate dateWithYear:year month:1 day:1 hour:0 minute:0 second:0 timeZone:nil] retain];
		NSDate *endDate = [[NSCalendarDate dateWithYear:year month:12 day:31 hour:23 minute:59 second:59 timeZone:nil] retain];
		NSPredicate *eventsForThisYear = [CalCalendarStore eventPredicateWithStartDate:startDate endDate:endDate
																		 calendars:[[CalCalendarStore defaultCalendarStore] calendars]];
	
		// Fetch all events for this year
		NSArray *events = [[CalCalendarStore defaultCalendarStore] eventsWithPredicate:eventsForThisYear];
		
		for (id event in events) {
			NSLog(@"%@", [event notes]);
				}
		
		
		[autoreleasepool release];

	}


    return 0;
}
