//
//  NSURLRequest+IgnoreSSL.m
//  VisitReporting
//
//  Created by Deepak Kumar on 1/16/13.
//  Copyright (c) 2013 Deepak Kumar. All rights reserved.
//

#import "NSURLRequest+IgnoreSSL.h"

@implementation NSURLRequest (IgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}

@end
