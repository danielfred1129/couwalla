//
//  Coupon.h
//  Coupit
//
//  Created by Deepak Kumar on 3/4/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Coupon : NSManagedObject

@property (nonatomic, retain) NSNumber *mID;
@property (nonatomic, retain) NSNumber *mSavings;
@property (nonatomic, retain) NSNumber *mBrandId;

@property (nonatomic, retain) NSNumber *mFavorited;
@property (nonatomic, retain) NSNumber *mDownloaded;
@property (nonatomic, retain) NSNumber *mPlanned;
@property (nonatomic, retain) NSNumber *mHotDeal;
@property (nonatomic, retain) NSNumber *mTodaysDeal;


@property (nonatomic, retain) NSDate *mLastModified;
@property (nonatomic, retain) NSDate *mValidTill;

@property (nonatomic, retain) NSString *mBarcode;
@property (nonatomic, retain) NSString *mBarcodeImage;
@property (nonatomic, retain) NSString *mBarcodeType;
@property (nonatomic, retain) NSString *mBrandName;
@property (nonatomic, retain) NSString *mBrandType;
@property (nonatomic, retain) NSString *mCouponCode;
@property (nonatomic, retain) NSString *mDescription;
@property (nonatomic, retain) NSString *mImageWithBarcode;
@property (nonatomic, retain) NSString *mImageWithoutBarcode;
@property (nonatomic, retain) NSString *mLegalUrl;
@property (nonatomic, retain) NSString *mLongPromoText;
@property (nonatomic, retain) NSString *mShortPromoText;
@property (nonatomic, retain) NSString *mThumbnailImage;
@property (nonatomic, retain) NSString *mOnlineRedemptionUrl;

@property (nonatomic, retain) UIImage *mIconImage;


- (void) couponsWithDict:(NSDictionary *)pDict;
- (void) solrCouponsWithDict:(NSDictionary *)pDict;

- (void) refreshImage;

@end
