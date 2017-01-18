//
//  NSURLRequest+IgnoreSSL.h
//  VisitReporting
//
//  Created by Deepak Kumar on 1/16/13.
//  Copyright (c) 2013 Deepak Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (IgnoreSSL)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;

@end
