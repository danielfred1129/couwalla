//
//  SolrCoupons.h
//  Coupit
//
//  Created by VIKAS MISHRA on 15/06/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SolrCoupons : NSObject

@property (nonatomic, retain) NSString * mBarcode;
@property (nonatomic, retain) NSString * mBarcodeImage;
@property (nonatomic, retain) NSString * mBarcodeType;
@property (nonatomic, retain) NSNumber * mBrandId;
@property (nonatomic, retain) NSString * mBrandName;
@property (nonatomic, retain) NSString * mBrandType;
@property (nonatomic, retain) NSString * mCouponCode;
@property (nonatomic, retain) NSString * mDescription;
@property (nonatomic, retain) NSNumber * mDownloaded;
@property (nonatomic, retain) NSNumber * mFavorited;
@property (nonatomic, retain) NSNumber * mID;
@property (nonatomic, retain) NSString * mImageWithBarcode;
@property (nonatomic, retain) NSString * mImageWithoutBarcode;
@property (nonatomic, retain) NSDate * mLastModified;
@property (nonatomic, retain) NSString * mLegalUrl;
@property (nonatomic, retain) NSString * mLongPromoText;
@property (nonatomic, retain) NSString * mOnlineRedemptionUrl;
@property (nonatomic, retain) NSNumber * mPlanned;
@property (nonatomic, retain) NSNumber * mSavings;
@property (nonatomic, retain) NSString * mShortPromoText;
@property (nonatomic, retain) NSString * mThumbnailImage;
@property (nonatomic, retain) NSDate * mValidTill;

- (void) couponsWithDict:(NSDictionary *)pDict;


@end
