//
//  CouponGrouper.h
//  Coupit
//
//  Created by Deepak Kumar on 3/8/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponGrouper : NSObject

@property(nonatomic, strong, readonly) NSArray *mGroupIDs;

- (void) setCoupons:(NSArray *)pCoupons;
- (NSArray *) getCouponListForGroupID:(NSString*)mGroupID;
- (NSArray *) getAllGroupIDs;

- (NSInteger) getCouponSavingForGroupID:(NSString*)mGroupID;


// forType:(SortType)pSortType;


@end
