//
//  NSString+Validation.m
//  Coupit
//
//  Created by Canopus 4 on 20/05/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)

-(BOOL)isValidEmail
{
    static NSString *emailRegularExpression = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegularExpression];
    
    return [emailPredicate evaluateWithObject:self];
}

@end
