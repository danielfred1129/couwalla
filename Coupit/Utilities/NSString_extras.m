//
//  NSDate_extras.m
//  Socialcast
//
//  Created by Rich Collins on 9/1/09.
//  Copyright 2009 Socialcast. All rights reserved.
//

#import "NSString_extras.h"


@implementation NSString (extras)
	

- (NSString *)percentEncodedString
{
    //return self;
	return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
}



#pragma mark System Time
+ (NSString *) getSystemTimeWithFormatter:(NSString *)pFormatter
{
	// get current date/time
	NSDate *today = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:pFormatter];
	// @"EEEE dd MMM    HH:mm"
	// MM-dd-yy'T'HH:mm:ssZ
	// EE MMM d, YYYY
	// d MMM yyyy
	//NSDateFormatterMediumStyle
	// display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
	NSString *currentTime = [dateFormatter stringFromDate:today];
	return currentTime;
}

- (CLLocationCoordinate2D ) makeLocationCoordinate2D
{
    NSCharacterSet* set = [NSCharacterSet characterSetWithCharactersInString:@"+-"];
    NSRange searchRange = NSMakeRange(2, [self length]-2);
    NSRange range = [self rangeOfCharacterFromSet:set options:nil range:searchRange];
    NSRange longRange = NSMakeRange(range.location, [self length]-range.location-1);
    NSString *tLongitude = [self substringWithRange: longRange];
    NSRange latRange = NSMakeRange(0, range.location);
    NSString *tLatitude = [self substringWithRange: latRange];
    return CLLocationCoordinate2DMake(tLatitude.doubleValue, tLongitude.doubleValue);
}


@end
