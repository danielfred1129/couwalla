//
//  Advertisement.m
//  Coupit
//
//  Created by Deepak Kumar on 4/9/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "Advertisement.h"
#import "DateUtil.h"

@implementation Advertisement
@synthesize mID, mAdHyperlink, mAdText, mCouponId, mBannerImage, mLastModified;

- (id) initWithDict:(NSDictionary *)pDict
{
    self = [super init];
    if (self) {
        self.mID                =  [NSNumber numberWithInteger:[[pDict objectForKey:@"id"] integerValue]];
        self.mCouponId          =  [NSNumber numberWithInteger:[[pDict objectForKey:@"couponId"] integerValue]];

        self.mLastModified      =  [DateUtil dateObjectForRFC3339DateTimeString:[pDict objectForKey:@"lastModified"]];

        self.mAdHyperlink       =  [pDict objectForKey:@"adHyperLink"];
        self.mAdText            =  [pDict objectForKey:@"adText"];
        self.mBannerImage       =  [pDict objectForKey:@"coupon_image"];
    }
    return self;
}
@end
