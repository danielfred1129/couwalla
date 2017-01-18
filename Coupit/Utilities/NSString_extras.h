//
//  NSDate_extras.h
//  Socialcast
//
//  Created by Rich Collins on 9/1/09.
//  Copyright 2009 Socialcast. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (extras)


- (NSString *) percentEncodedString;
+ (NSString *) getSystemTimeWithFormatter:(NSString *)pFormatter;
- (CLLocationCoordinate2D ) makeLocationCoordinate2D;

@end
