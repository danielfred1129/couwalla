//
//  DataManager.h
//  VisitReporting
//
//  Created by AtreeTech on 06/01/13.
//  Copyright (c) 2013 Deepak Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RewardCard.h"
#import "Coupon.h"
#import "StorePreferences.h"
#import "MyCoupons.h"

@interface DataManager : NSObject
{

}


+ (DataManager *) getInstance;

@property (nonatomic, retain) NSMutableArray *mCouponGroupArray;
@property (nonatomic, retain) NSMutableArray *mCategoriesArray;
@property (nonatomic, retain) NSMutableArray *mCouponBrandArray;
@property (nonatomic, retain) NSMutableArray *mCouponQueryArray;

@property (nonatomic, retain) NSMutableArray *mNearMeStoreArray;
@property (nonatomic, retain) NSMutableArray *mBrandsArray;

@property (nonatomic, retain) NSMutableArray *mStoreCheckInCouponArray;
@property (nonatomic, retain) NSMutableArray *mBrandCheckInCouponArray;
@property (nonatomic, retain) NSMutableArray *mKeywordCouponArray;
@property (nonatomic, retain) NSMutableArray *mPathArray;

@property (nonatomic, retain) NSMutableArray *mGiftCardsArray;
@property (nonatomic, retain) NSMutableArray *mAdvertsArray;
@property (nonatomic, retain) NSMutableArray *mStoresArray;
@property (nonatomic, retain) NSMutableArray *mMapStoreLocationArray;
@property (nonatomic, retain) NSMutableArray *mStoresLocationArray;

@property (nonatomic, retain) Coupon *mObjCouponDetail;
//@property (nonatomic, retain) Coupon *mObjCouponAddToTagDetail;
//@property (nonatomic, retain) Coupon *mDownloadCoupon;
@property (nonatomic, retain) MyCoupons *mDownloadCoupon;
@property (nonatomic, retain) MyCoupons *mObjCouponAddToTagDetail;


@property (nonatomic, retain) NSString *mDeviceToken;
@property (nonatomic, retain) NSString *mCouponShareURL;
@property (nonatomic, retain) NSMutableArray *mCouponPreferences;
@property (nonatomic, retain) StorePreferences *mObjStorePreferences;

@property (nonatomic, retain) NSMutableArray *mSolrCouponsArray;
@property (nonatomic, retain) NSMutableArray *mRedeemCouponResponseArray;




// Global Setting
- (NSString *) getContentURL;
- (NSString *) getSupportURL;
- (NSString *) getLogoURL;
- (NSString *) getLegalURL;
- (NSString *) getAdTimer;

- (RewardCard *) getRewardCardObject;
- (NSDate *)couponExpireDate:(NSDate *)pCouponValidity;
- (NSDate *)myCouponExpireDate:(NSInteger)pDaysToAdd;
- (BOOL)couponRequest;
- (BOOL)storeCheckIn:(NSString *)pStoreID;

@end
