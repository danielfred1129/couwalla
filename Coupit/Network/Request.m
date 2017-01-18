//
//  Request.m
//  Coupit
//
//  Created by Deepak Kumar on 6/19/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "Request.h"

@implementation Request
@synthesize mRequestURL, mRequestType;

- (id)initWithRequestURL:(NSString *)pRequest type:(RequestType)pRequestType
{
    self = [super init];
    if (self) {
        self.mRequestType = pRequestType;
        self.mRequestURL = pRequest;
        
    }
    return self;
}
@end
