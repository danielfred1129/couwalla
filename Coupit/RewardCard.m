//
//  RewardCard.m
//  Coupit
//
//  Created by Deepak Kumar on 4/7/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "RewardCard.h"
#import "DateUtil.h"


@implementation RewardCard
@synthesize mBackImage, mBarCode, mBarCodeType, mDescription, mFrontImage, mID, mLastModified, mLongPromoText, mPoints, mShortPromoText, mValidFrom, mValidTill;
@synthesize mCardName, mCardType, mCardNumber, mSubscriberId, mSecurityCode;

- (void) rewardCardWithDict:(NSDictionary *)pDict
{
    self.mBackImage         =  [pDict objectForKey:@"backImage"];
    self.mBarCode           =  [pDict objectForKey:@"barcode"];
    self.mBarCodeType       =  [pDict objectForKey:@"barcodeType"];
    
    self.mDescription       =  [pDict objectForKey:@"description"];
    self.mFrontImage        =  [pDict objectForKey:@"frontImage"];
    self.mID                =  [[pDict objectForKey:@"id"] stringValue];
    
    self.mLastModified      =  [pDict objectForKey:@"lastModified"];

    self.mLongPromoText     =  [pDict objectForKey:@"longPromoText"];
    self.mPoints            =  [[pDict objectForKey:@"points"] stringValue];
    self.mShortPromoText    =  [pDict objectForKey:@"shortPromoText"];
    
//    self.mValidTill         =  [pDict objectForKey:@"validTill"];
    self.mValidTill         =  [DateUtil dateObjectForRFC3339DateTimeString:[pDict objectForKey:@"validTill"]];

//    self.mValidFrom         =  [pDict objectForKey:@"validFrom"];
    self.mValidFrom         =  [DateUtil dateObjectForRFC3339DateTimeString:[pDict objectForKey:@"validFrom"]];

    self.mCardNumber        =  [pDict objectForKey:@"cardNo"];
    self.mCardName          =  [pDict objectForKey:@"cardName"];
    self.mCardType          =  [pDict objectForKey:@"cardType"];
    self.mSubscriberId      =  [pDict objectForKey:@"subscriberId"];
    self.mSecurityCode      =  [pDict objectForKey:@"securityCode"];
}

@end
