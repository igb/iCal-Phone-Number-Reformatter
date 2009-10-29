#include <CoreFoundation/CoreFoundation.h>
#include <Foundation/Foundation.h>

#import "../iCalDialInFormat/constants.h"

int main (int argc, const char * argv[]) {

	CFPropertyListRef iPhoneCheckboxValue;
	CFPropertyListRef blackberryCheckboxValue;
	CFPropertyListRef isActiveValue;



	iPhoneCheckboxValue = CFPreferencesCopyAppValue(FORMAT_FOR_IPHONE,  APP_ID );
	blackberryCheckboxValue = CFPreferencesCopyAppValue(FORMAT_FOR_BLACKBERRY,  APP_ID );
	isActiveValue = CFPreferencesCopyAppValue(IS_ACTIVE,  APP_ID );


    NSLog(@"Formatter is active: %d", CFBooleanGetValue(isActiveValue));



    return 0;
}
