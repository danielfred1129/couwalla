//
//  UIColor+AppTheme.m
//  Coupit
//
//  Created by Canopus 4 on 09/05/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "UIColor+AppTheme.h"

@implementation UIColor (AppTheme)

+(UIColor *)colorWithIntegerRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue alpha:(CGFloat)alpha
{
    return [self colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

+(UIColor*)appGreenColor
{
    return [self colorWithIntegerRed:56 green:181 blue:52 alpha:1];
}

+(UIColor*)appGrayColor
{
    return [self colorWithIntegerRed:110 green:110 blue:110 alpha:1];
}

@end
