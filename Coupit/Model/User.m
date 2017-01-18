//
//  User.m
//  Coupit
//
//  Created by Deepak Kumar on 4/29/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize mUserName, mEmailID, mAge, mZipCode, mPassword;

- (id)init
{
    self = [super init];
    if (self) {
        self.mUserName = @"";
    }
    return self;
}
@end
