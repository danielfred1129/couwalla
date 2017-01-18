//
//  NSNull+json.m
//  Coupit
//
//  Created by Hashim on 27/06/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "NSNull+json.h"

@implementation NSNull (JSON)

-(NSString*)text
{
    return @"";
}


-(void)_fastCharacterContents
{
}

- (BOOL)isEqualToString:(NSString *)aString;
{
    return NO;
}

- (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement
{
    return @"";
}

- (NSUInteger)length
{
    return 0;
}

- (NSInteger)integerValue
{
    return 0;
}

- (CGFloat)floatValue
{
    return 0;
}

-(NSString*)stringValue
{
    return @"";
}

- (NSArray *)componentsSeparatedByString:(NSString *)separator
{
    return @[];
}

- (id)objectForKey:(id)key
{
    return nil;
}

- (BOOL)boolValue
{
    return NO;
}

@end
