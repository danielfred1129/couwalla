//
//  SolrCoupons.m
//  Coupit
//
//  Created by VIKAS MISHRA on 15/06/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "SolrCoupons.h"
#import "DateUtil.h"
#import "FileUtils.h"


@implementation SolrCoupons
@synthesize mBarcode;
@synthesize mBarcodeImage;
@synthesize mBarcodeType;
@synthesize mBrandId;
@synthesize mBrandName;
@synthesize mBrandType;
@synthesize mCouponCode;
@synthesize mDescription;
@synthesize mDownloaded;
@synthesize mFavorited;
@synthesize mID;
@synthesize mImageWithBarcode;
@synthesize mImageWithoutBarcode;
@synthesize mLastModified;
@synthesize mLegalUrl;
@synthesize mLongPromoText;
@synthesize mOnlineRedemptionUrl;
@synthesize mPlanned;
@synthesize mSavings;
@synthesize mShortPromoText;
@synthesize mThumbnailImage;
@synthesize mValidTill;


- (void) couponsWithDict:(NSDictionary *)pDict
{
    self.mID                = [NSNumber numberWithInteger:[[pDict objectForKey:@"id"] intValue]];
    self.mSavings           = [NSNumber numberWithInteger:[[pDict objectForKey:@"savings"] intValue]];
    self.mBrandId           = [NSNumber numberWithInteger:[[pDict objectForKey:@"brandId"] intValue]];
    
    self.mDownloaded        = [NSNumber numberWithBool:NO];
    self.mFavorited         = [NSNumber numberWithBool:NO];
    self.mPlanned           = [NSNumber numberWithBool:NO];
    
    self.mShortPromoText    = [pDict objectForKey:@"shortPromoText"];
    self.mBrandName         = [pDict objectForKey:@"brandName"];
    
    self.mLongPromoText     = [pDict objectForKey:@"longPromoText"];
    self.mDescription       = [pDict objectForKey:@"description"];
    self.mCouponCode        = [pDict objectForKey:@"couponCode"];
    self.mBarcode           = [pDict objectForKey:@"barcode"];
    self.mBarcodeType       = [pDict objectForKey:@"barcodeType"];
    self.mThumbnailImage    = [pDict objectForKey:@"thumbnailImage"];
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


@end
