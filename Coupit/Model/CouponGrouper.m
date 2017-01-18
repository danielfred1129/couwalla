//
//  CouponGrouper.m
//  Coupit
//
//  Created by Deepak Kumar on 3/8/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "CouponGrouper.h"
#import "MyCoupons.h"

@interface CouponGrouper()
-(void)addCoupon:(MyCoupons *)pCoupon forGID:(NSString *)pGID;
@end

@implementation CouponGrouper {
    NSMutableDictionary *mCouponByGIDs;
}

@synthesize mGroupIDs;

-(id)init {
    self = [super init];
    if (self) {
        mCouponByGIDs = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void) setCoupons:(NSArray *)pCoupons;
{
    [mCouponByGIDs removeAllObjects];
    
    for (MyCoupons *tCoupon in pCoupons) {
        //[self addCoupon:tCoupon forGID:[tCoupon.mBrandId stringValue]];
        ////NSLog(@"---- mBrandName:%@", tCoupon.mBrandName);
        [self addCoupon:tCoupon forGID:tCoupon.mBrandName];
    }
}

- (void)addCoupon:(MyCoupons *)pCoupon forGID:(NSString *)pGID
{    NSMutableArray* array = [mCouponByGIDs objectForKey:pGID];
    if (!array) {
        array = [NSMutableArray array];
        [mCouponByGIDs setObject:array forKey:pGID];
    }
    [array addObject:pCoupon];
}

- (NSArray *) getCouponListForGroupID:(NSString*)mGroupID;
{
    return [mCouponByGIDs objectForKey:mGroupID];
}

- (NSArray *) getAllGroupIDs
{
    return [mCouponByGIDs allKeys];
}


- (NSInteger) getCouponSavingForGroupID:(NSString*)mGroupID
{
    NSInteger tSavingAmount = 0;
    for (MyCoupons *tCoupon in [self getCouponListForGroupID:mGroupID]) {
        tSavingAmount = tSavingAmount + [tCoupon.mSavings integerValue];
    }
    return tSavingAmount;
}


@end
