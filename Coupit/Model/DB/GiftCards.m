//
//  GiftCards.m
//  Coupit
//
//  Created by Deepak Kumar on 4/8/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "GiftCards.h"
#import "DateUtil.h"

@implementation GiftCards

@dynamic mBackImage;
@dynamic mBarCode;
@dynamic mBrandID;
@dynamic mDescription;
@dynamic mDirectoryState;
@dynamic mDisplayName;
@dynamic mFrontImage;
@dynamic mID;
@dynamic mImageWithoutBarcode;
@dynamic mLastModified;
@dynamic mLegalUrl;
@dynamic mLongPromoText;
@dynamic mPoints;
@dynamic mSavings;
@dynamic mSequenceNo;
@dynamic mShortPromoText;
@dynamic mThumbNail;
@dynamic mValidFrom;
@dynamic mBarcodeType;
@dynamic mValidTill;


- (void) giftCardWithDict:(NSDictionary *)pDict
{
    self.mBackImage         =  [pDict objectForKey:@"backImage"];
    self.mBarCode           =  [pDict objectForKey:@"barcode"];
    self.mBarcodeType       =  [pDict objectForKey:@"barcodeType"];
    
    self.mDescription       =  [pDict objectForKey:@"description"];
    self.mDisplayName       =  [pDict objectForKey:@"displayName"];
    self.mFrontImage        =  [pDict objectForKey:@"frontImage"];
    
    self.mID                =  [NSNumber numberWithInteger:[[pDict objectForKey:@"id"] integerValue]];
    self.mBrandID           =  [NSNumber numberWithInteger:[[pDict objectForKey:@"brandId"] integerValue]];
    self.mPoints            =  [NSNumber numberWithInteger:[[pDict objectForKey:@"points"] integerValue]];
    self.mSavings           =  [NSNumber numberWithInteger:[[pDict objectForKey:@"savings"] integerValue]];
    self.mSequenceNo        =  [NSNumber numberWithInteger:[[pDict objectForKey:@"sequenceNo"] integerValue]];
    self.mDirectoryState    =  [NSNumber numberWithInteger:[[pDict objectForKey:@"directoryState"] integerValue]];

    
    self.mImageWithoutBarcode  =  [pDict objectForKey:@"imageWithoutBarcode"];
    self.mLegalUrl          =  [pDict objectForKey:@"legalUrl"];
    
    self.mLongPromoText     =  [pDict objectForKey:@"longPromoText"];
    self.mShortPromoText    =  [pDict objectForKey:@"shortPromoText"];
    self.mThumbNail         =  [pDict objectForKey:@"thumbNail"];
    
    self.mLastModified      =  [DateUtil dateObjectForRFC3339DateTimeString:[pDict objectForKey:@"lastModified"]];
    self.mValidTill         =  [DateUtil dateObjectForRFC3339DateTimeString:[pDict objectForKey:@"validTill"]];
    self.mValidFrom         =  [DateUtil dateObjectForRFC3339DateTimeString:[pDict objectForKey:@"validFrom"]];
}


@end
