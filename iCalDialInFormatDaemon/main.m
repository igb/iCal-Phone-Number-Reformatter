#include <CoreFoundation/CoreFoundation.h>
#include <Foundation/Foundation.h>
#include <CalendarStore/CalendarStore.h>
#import "RegexKitLite.h"



#import "../iCalDialInFormat/constants.h"

NSString* extract_digits(NSString* data)
{
	NSString*  extractedString = [[NSString alloc] initWithString:@""]; 
	NSArray* numberTokens = [data arrayOfCaptureComponentsMatchedByRegex:@"([0-9]+)"];
	
	for (id token in numberTokens) {
		extractedString=[extractedString stringByAppendingString:[token objectAtIndex:0]];
	}
	
	return extractedString;
	
	

}

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


NSString* extract_single_value_for_regex_strategies(NSString *data, NSArray* strategies) {

	for (id regex in strategies) {
		
		NSString* value=nil;
		
		value=extract_single_value_for_regex(data,	regex);
		
		if (value) {
			return value;
		}
	}
	return nil;
	
	
}


NSString* extract_phonenumber(NSString *calendarData)
{       
	
	
	NSMutableArray* phonenumberStrategies=[[NSMutableArray alloc] init];
	
	[phonenumberStrategies addObject:REGEX_US_PHONE_WITH_COUNTRY_CODE];
	[phonenumberStrategies addObject:REGEX_US_PHONE_NO_COUNTRY_CODE];
	[phonenumberStrategies addObject:REGEX_US_PHONE_NO_COUNTRY_CODE_PARENS];
	[phonenumberStrategies addObject:REGEX_US_PHONE_NO_AREA_CODE];


	
	return extract_single_value_for_regex_strategies(calendarData, phonenumberStrategies);
	
}



NSString* extract_passcode(NSString *calendarData)
{       
	
	
	NSMutableArray* passcodeStrategies=[[NSMutableArray alloc] init];
	
	[passcodeStrategies addObject:REGEX_PASS_CODE];
	[passcodeStrategies addObject:REGEX_PARTICIPANT_CODE];
	[passcodeStrategies addObject:REGEX_PC_ABBREV];
	
	return extract_single_value_for_regex_strategies(calendarData, passcodeStrategies);
		
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
		NSLog(@"is active for cal %@ %@", [cal title], CFPreferencesCopyAppValue([cal uid], APP_ID));
		
		if (CFBooleanGetValue(isActiveValue) && CFPreferencesCopyAppValue([cal uid], APP_ID) != nil && CFBooleanGetValue(CFPreferencesCopyAppValue([cal uid], APP_ID))) {
			
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
			
			for (id event in events) {
				
				NSString* passcode=nil;
				NSString* phonenumber=nil;
				
				NSMutableArray* calendar_data = [[NSMutableArray alloc] init];
				
				if ([event location] != nil) {
					[calendar_data addObject:[event location]];
				}
				
				if ([event notes] != nil) {
					[calendar_data addObject:[event notes]];
				}
				
				for (id data in calendar_data) {
					
					if (phonenumber == nil) {
						phonenumber=extract_phonenumber(data);	
					}
						
					if (phonenumber != nil) {
						if (passcode == nil) {
							passcode=extract_passcode(data);
						}
					}									
				}
				
				if(phonenumber != nil) {
					NSLog(@"PHONE: %@ %@", [event startDate], phonenumber);

				}
				
				if(passcode != nil) {
					NSLog(@"FOUNDEVENT: %@ %@", [event startDate], passcode);
				}
				
				if (phonenumber != nil && passcode != nil ) {
					
					NSString* phoneString=extract_digits(phonenumber);
					NSString* passcodeString=extract_digits(passcode);
					
					NSLog(@"String: %@,%@", phoneString, passcodeString);
				
				}
 
				
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





