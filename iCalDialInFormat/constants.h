/*
 *  constants.h
 *  iCalDialInFormat
 *
 *  Created by Ian Brown on 10/26/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#define FORMAT_FOR_IPHONE  @"formatForIPhone"
#define FORMAT_FOR_BLACKBERRY  @"formatForBlackberry"
#define APP_ID  @"org.hccp.iCalDialInFormatter"
#define IS_ACTIVE @"isActivated"

#define REGEX_PASS_CODE @"PASS.*CODE[ :]*([0-9]+)"
#define REGEX_PARTICIPANT_CODE  @"PARTICIPANT.*CODE[ :]*([0-9]+)"
#define REGEX_PC_ABBREV  @"PC[ :]*([0-9]+)"


#define REGEX_US_PHONE_WITH_COUNTRY_CODE @".*(1-[0-9]{3}-[0-9]{3}-[0-9]{4}).*"
#define REGEX_US_PHONE_NO_COUNTRY_CODE @".*([0-9]{3}-[0-9]{3}-[0-9]{4}).*"
#define REGEX_US_PHONE_NO_COUNTRY_CODE_PARENS @".*(\\([0-9]{3}\\).*[0-9]{3}-[0-9]{4}).*"
#define REGEX_US_PHONE_NO_AREA_CODE @".*([0-9]{3}-[0-9]{4}).*"


#define REGEX_EXTRACT_DIGITS @"(\d+)"