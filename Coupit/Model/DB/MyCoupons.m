//
//  MyCoupons.m
//  Coupit
//
//  Created by VIKAS MISHRA on 14/06/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "MyCoupons.h"
#import "DateUtil.h"
#import "FileUtils.h"


@implementation MyCoupons

@dynamic mBarcode;
@dynamic mBarcodeImage;
@dynamic mBarcodeType;
@dynamic mBrandId;
@dynamic mBrandName;
@dynamic mBrandType;
@dynamic mCouponCode;
@dynamic mDescription;
@dynamic mDownloaded;
@dynamic mFavorited;
@dynamic mID;
@dynamic mImageWithBarcode;
@dynamic mImageWithoutBarcode;
@dynamic mLastModified;
@dynamic mLegalUrl;
@dynamic mLongPromoText;
@dynamic mOnlineRedemptionUrl;
@dynamic mPlanned;
@dynamic mSavings;
@dynamic mShortPromoText;
@dynamic mThumbnailImage;
@dynamic mValidTill;
@dynamic mRedeeemSelected;
@dynamic mRedeemStatus;
@dynamic mValidity;
@dynamic mCouponExpireDate;


- (void)couponsWithDict:(NSDictionary *)pDict
{
    //NSLog(@"value%@",[pDict objectForKey:@"id"]);
    //self.mID                = [NSNumber numberWithInteger:[[pDict objectForKey:@"id"] intValue]];
    //self.mID = [NSNumber numberWithInteger:1];
    //self.mSavings           = [NSNumber numberWithInteger:[[pDict objectForKey:@"savings"] intValue]];
    //self.mBrandId           = [NSNumber numberWithInteger:[[pDict objectForKey:@"brandId"] intValue]];
    
//    self.mDownloaded        = [NSNumber numberWithBool:NO];
//    self.mFavorited         = [NSNumber numberWithBool:NO];
//    self.mPlanned           = [NSNumber numberWithBool:NO];
//    self.mRedeeemSelected   = [NSNumber numberWithBool:NO];
//    self.mRedeemStatus      = [NSNumber numberWithBool:NO];
//    
   // self.mShortPromoText    = [pDict objectForKey:@"promo_text_short"];
    //self.mBrandName         = [pDict objectForKey:@"customer_name"];
    
   // self.mLongPromoText     = [pDict objectForKey:@"promo_text_short"];
    //self.mDescription       = [pDict objectForKey:@"coupon_description"];
   // self.mCouponCode        = [pDict objectForKey:@"couponCode"];
   // self.mBarcode           = [pDict objectForKey:@"barcode"];
   // self.mBarcodeType       = [pDict objectForKey:@"barcodeType"];
    //self.mThumbnailImage    = [pDict objectForKey:@"coupon_thumbnail"];
   // self.mImageWithoutBarcode = [pDict objectForKey:@"imageWithoutBarcode"];
   // self.mImageWithBarcode  = [pDict objectForKey:@"imageWithBarcode"];
   // self.mBarcodeImage      = [pDict objectForKey:@"barcodeImage"];
    //self.mBrandType         = [pDict objectForKey:@"brandType"];
   // self.mBrandName         = [pDict objectForKey:@"brandName"];
  //  self.mLegalUrl          = [pDict objectForKey:@"legalUrl"];
    //self.mOnlineRedemptionUrl = [pDict objectForKey:@"onlineRedemptionUrl"];
   // self.mValidity          = [pDict objectForKey:@"validity"];
    
    // //NSLog(@"Section:%d Row:%d", pIndexPath.section, pIndexPath.row);
    //self.mValidTill         = [DateUtil dateObjectForRFC3339DateTimeString:[pDict objectForKey:@"validTill"]];
    //self.mLastModified      = [DateUtil dateObjectForRFC3339DateTimeString:[pDict objectForKey:@"lastModified"]];
    
    
       
}


@end
