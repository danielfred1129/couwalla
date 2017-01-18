//
//  APIError.m
//  Coupit
//
//  Created by Vikas_headspire on 06/04/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "APIError.h"

@implementation APIError

@synthesize mErrorCode;
@synthesize mMessage;


- (id) initWithDict:(NSDictionary *)pDict
{
    self.mErrorCode = [NSNumber numberWithInteger:[[pDict objectForKey:@"errorCode"] intValue]];
    self.mMessage = [pDict objectForKey:@"message"];
    return self;
}
@end
