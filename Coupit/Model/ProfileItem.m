//
//  ProfileItem.m
//  Coupit
//
//  Created by Deepak Kumar on 2/5/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "ProfileItem.h"

@implementation ProfileItem
@synthesize mTitle, mValue, mIsUpdate, mServerKey;

- (id)initWithTitle:(NSString *)pTitle value:(NSString *)pValue serverKey:(NSString *)pKey
{
    self = [super init];
    if (self) {
        self.mIsUpdate = NO;
        self.mTitle = pTitle;
        self.mValue = pValue;
        self.mServerKey = pKey;
    }
    return self;
}

-(NSString *)description
{
    NSMutableString *string = [[NSMutableString alloc] initWithString:[super description]];

    [string appendFormat:@"%@: %@, ",self.mTitle, self.mValue];

    return string;
}

@end
