//
//  LoyaltyCard.m
//  Coupit
//
//  Created by Vikas_headspire on 08/04/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "LoyaltyCard.h"

@implementation LoyaltyCard

@synthesize mBackImageLocal, mFrontImageLocal, mID, mCardType, mIsFlip;

- (id)init
{
    self = [super init];
    if (self) {
        mIsFlip = NO;
    }
    return self;
}


@end
