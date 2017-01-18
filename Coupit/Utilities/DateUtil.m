//
//  DateUtil.m
//  VerizonAppStore
//
//  Created by Deepak Kumar on 08/06/11.
//  COPYRIGHT © 2011 ALCATEL-LUCENT. ALL RIGHTS RESERVED.
//

#import "DateUtil.h"


@implementation DateUtil

+ (NSString *)userVisibleDateTimeStringForRFC3339DateTimeString:(NSString *)rfc3339DateTimeString
// Returns a user-visible date time string that corresponds to the
// specified RFC 3339 date time string. Note that this does not handle
// all possible RFC 3339 date time strings, just one of the most common
// styles.
{
    NSString *          userVisibleDateTimeString;
    NSDateFormatter *   rfc3339DateFormatter;
    NSLocale *          enUSPOSIXLocale;
    NSDate *            date;
    NSDateFormatter *   userVisibleDateFormatter;
    
    userVisibleDateTimeString = nil;
    
    // Convert the RFC 3339 date time string to an NSDate.
    
    rfc3339DateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
    enUSPOSIXLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
    
    [rfc3339DateFormatter setLocale:enUSPOSIXLocale];
    [rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
    [rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    date = [rfc3339DateFormatter dateFromString:rfc3339DateTimeString];
    if (date != nil) {
        
        // Convert the NSDate to a user-visible date string.
        
        userVisibleDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        assert(userVisibleDateFormatter != nil);
        
        
        [userVisibleDateFormatter setDateFormat:@"MM-dd-yyyy"];
        //[userVisibleDateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        userVisibleDateTimeString = [userVisibleDateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}

+ (NSDate *)dateObjectForRFC3339DateTimeString:(NSString *)rfc3339DateTimeString
// Returns a user-visible date time string that corresponds to the
// specified RFC 3339 date time string. Note that this does not handle
// all possible RFC 3339 date time strings, just one of the most common
// styles.
{
    NSDateFormatter *   rfc3339DateFormatter;
    NSLocale *          enUSPOSIXLocale;
    NSDate *            date;
        
    date = nil;
    
    // Convert the RFC 3339 date time string to an NSDate.
    
    rfc3339DateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
    enUSPOSIXLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
    // 2013-04-06T00:00:00+0000
    [rfc3339DateFormatter setLocale:enUSPOSIXLocale];
    //[rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'+'SSSS"];
    [rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"];
    [rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    date = [rfc3339DateFormatter dateFromString:rfc3339DateTimeString];
    
    return date;
}

// -------------
+ (NSString *) dateInCustomFormat:(NSString *)rfc3339DateTimeString
// Returns a user-visible date time string that corresponds to the
// specified RFC 3339 date time string. Note that this does not handle
// all possible RFC 3339 date time strings, just one of the most common
// styles.
{
    NSString *          userVisibleDateTimeString;
    NSDateFormatter *   rfc3339DateFormatter;
    NSLocale *          enUSPOSIXLocale;
    NSDate *            date;
    NSDateFormatter *   userVisibleDateFormatter;
    
    userVisibleDateTimeString = nil;
    
    // Convert the RFC 3339 date time string to an NSDate.
    
    rfc3339DateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
    enUSPOSIXLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
    
    [rfc3339DateFormatter setLocale:enUSPOSIXLocale];
    //[rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
    [rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    [rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    date = [rfc3339DateFormatter dateFromString:rfc3339DateTimeString];
    if (date != nil) {
        
        // Convert the NSDate to a user-visible date string.
        
        userVisibleDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        assert(userVisibleDateFormatter != nil);
        
        
        [userVisibleDateFormatter setDateFormat:@"MMM dd, yyyy"];
        //[userVisibleDateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        userVisibleDateTimeString = [userVisibleDateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}

@end
