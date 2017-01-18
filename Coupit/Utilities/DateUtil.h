//
//  DateUtil.h
//  VerizonAppStore
//
//  Created by Deepak Kumar on 08/06/11.
//  COPYRIGHT © 2011 ALCATEL-LUCENT. ALL RIGHTS RESERVED.
//

#import <Foundation/Foundation.h>


@interface DateUtil : NSObject {
    
}
+ (NSString *)userVisibleDateTimeStringForRFC3339DateTimeString:(NSString *)rfc3339DateTimeString;
+ (NSDate *)dateObjectForRFC3339DateTimeString:(NSString *)rfc3339DateTimeString;
+ (NSString *) dateInCustomFormat:(NSString *)rfc3339DateTimeString;

@end
