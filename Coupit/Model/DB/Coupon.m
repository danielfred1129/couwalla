//
//  Coupon.m
//  Coupit
//
//  Created by Deepak Kumar on 3/4/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "Coupon.h"
#import "DateUtil.h"
#import "FileUtils.h"

@implementation Coupon

@dynamic mBarcode;
@dynamic mBarcodeImage;
@dynamic mBarcodeType;
@dynamic mBrandId;
@dynamic mBrandName;
@dynamic mBrandType;
@dynamic mCouponCode;
@dynamic mDescription;
@dynamic mID;
@dynamic mImageWithBarcode;
@dynamic mImageWithoutBarcode;
@dynamic mFavorited;
@dynamic mLastModified;
@dynamic mLegalUrl;
@dynamic mLongPromoText;
@dynamic mSavings;
@dynamic mShortPromoText;
@dynamic mThumbnailImage;
@dynamic mValidTill;
@dynamic mDownloaded;
@dynamic mPlanned;
@dynamic mHotDeal;
@dynamic mTodaysDeal;
@dynamic mOnlineRedemptionUrl;
@synthesize mIconImage;


- (void) couponsWithDict:(NSDictionary *)pDict
{
    self.mID                = [NSNumber numberWithInteger:[[pDict objectForKey:@"id"] intValue]];
    self.mSavings           = [NSNumber numberWithInteger:[[pDict objectForKey:@"savings"] intValue]];
    self.mBrandId           = [NSNumber numberWithInteger:[[pDict objectForKey:@"brandId"] intValue]];
    
    self.mDownloaded        = [NSNumber numberWithBool:NO];
    self.mFavorited         = [NSNumber numberWithBool:NO];
    self.mPlanned           = [NSNumber numberWithBool:NO];
    
    self.mShortPromoText    = [pDict objectForKey:@"shortPromoText"];
    self.mBrandName         = [pDict objectForKey:@"name"];

    self.mLongPromoText     = [pDict objectForKey:@"longPromoText"];
    self.mDescription       = [pDict objectForKey:@"coupon_description"];
    self.mCouponCode        = [pDict objectForKey:@"couponCode"];
    self.mBarcode           = [pDict objectForKey:@"barcode"];
    self.mBarcodeType       = [pDict objectForKey:@"barcodeType"];
    self.mThumbnailImage    = [pDict objectForKey:@"coupon_image"];
    self.mImageWithoutBarcode = [pDict objectForKey:@"imageWithoutBarcode"];
    self.mImageWithBarcode  = [pDict objectForKey:@"imageWithBarcode"];
    self.mBarcodeImage      = [pDict objectForKey:@"barcodeImage"];
    //self.mBrandType         = [pDict objectForKey:@"brandType"];
    self.mBrandName         = [pDict objectForKey:@"brandName"];
    self.mLegalUrl          = [pDict objectForKey:@"legalUrl"];
    self.mOnlineRedemptionUrl = [pDict objectForKey:@"onlineRedemptionUrl"];
    
    // //NSLog(@"Section:%d Row:%d", pIndexPath.section, pIndexPath.row);
    self.mValidTill         = [DateUtil dateObjectForRFC3339DateTimeString:[pDict objectForKey:@"validTill"]];
    self.mLastModified      = [DateUtil dateObjectForRFC3339DateTimeString:[pDict objectForKey:@"lastModified"]];

}

- (void) solrCouponsWithDict:(NSDictionary *)pDict {
    self.mID                = [NSNumber numberWithInteger:[[pDict objectForKey:@"id"] intValue]];
    self.mSavings           = [NSNumber numberWithInteger:[[pDict objectForKey:@"savings"] intValue]];
    self.mBrandId           = [NSNumber numberWithInteger:[[pDict objectForKey:@"brand_id"] intValue]];
    
    self.mDownloaded        = [NSNumber numberWithBool:NO];
    self.mFavorited         = [NSNumber numberWithBool:NO];
    self.mPlanned           = [NSNumber numberWithBool:NO];
    self.mHotDeal           = [NSNumber numberWithBool:NO];
    self.mTodaysDeal        = [NSNumber numberWithBool:NO];

    
    self.mShortPromoText    = [pDict objectForKey:@"short_promo_text"];
    self.mBrandName         = [pDict objectForKey:@"name"];
    
    self.mLongPromoText     = [pDict objectForKey:@"long_promo_text"];
    self.mDescription       = [pDict objectForKey:@"coupon_description"];
    self.mCouponCode        = [pDict objectForKey:@"couponCode"];
    self.mBarcode           = [pDict objectForKey:@"barcode"];
    self.mBarcodeType       = [pDict objectForKey:@"barcodeType"];
    self.mThumbnailImage    = [pDict objectForKey:@"coupon_image"];
    self.mImageWithoutBarcode = [pDict objectForKey:@"image_without_barcode_id"];
    self.mImageWithBarcode  = [pDict objectForKey:@"imageWithBarcode"];
    self.mBarcodeImage      = [pDict objectForKey:@"barcodeImage"];
    //self.mBrandType         = [pDict objectForKey:@"brandType"];
    self.mLegalUrl          = [pDict objectForKey:@"legal_url"];
    self.mOnlineRedemptionUrl = [pDict objectForKey:@"onlineRedemptionUrl"];
    
    // //NSLog(@"Section:%d Row:%d", pIndexPath.section, pIndexPath.row);
    self.mValidTill         = [DateUtil dateObjectForRFC3339DateTimeString:[pDict objectForKey:@"valid_till"]];
    self.mLastModified      = [DateUtil dateObjectForRFC3339DateTimeString:[pDict objectForKey:@"last_modified"]];

}

- (void) refreshImage
{
    NSString *tFileName = [self.mThumbnailImage lastPathComponent];
    NSString *fmtFileName = makeFileName([self.mID stringValue], tFileName);
    
    self.mIconImage = [UIImage new];
    if (isFileExists(fmtFileName)) {
        self.mIconImage     = [UIImage imageWithContentsOfFile:imageFilePath(fmtFileName)];;
    }
    else{
        self.mIconImage     = [UIImage imageNamed:@"CouponsHomeDefaultImage@2x.png"];
    }
}



@end
