//
//  Groups.m
//  Coupit
//
//  Created by Deepak Kumar on 3/4/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "Groups.h"


@implementation Groups

@synthesize mGroupType;
@synthesize mName;

- (id)initGroupName:(NSString *)pName groupType:(GroupType)pGroupType
{
    self = [super init];
    if (self) {
        self.mGroupType = pGroupType;
        self.mName = pName;
    }
    return self;
}

@end
