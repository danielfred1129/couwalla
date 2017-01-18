//
//  Stores.m
//  Coupit
//
//  Created by Deepak Kumar on 3/4/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "Stores.h"
#import "DateUtil.h"

@implementation Stores

@dynamic mActiveCouponCount;
@dynamic mBrandId;
@dynamic mFullImage;
@dynamic mFullName;
@dynamic mID;
@dynamic mLastModified;
@dynamic mLegalUrl;
@dynamic mThumbnailImage;
@dynamic mQRCode;
@dynamic mDescription;
@dynamic mBrandType;
@dynamic mBrandName;

- (void) storesWithDict:(NSDictionary *)pDict
{
    self.mID    = [NSNumber numberWithInteger:[[pDict objectForKey:@"id"] intValue]];
    self.mFullName  = [pDict objectForKey:@"fullName"];
    self.mDescription = [pDict objectForKey:@"coupon_description"];
    self.mThumbnailImage = [pDict objectForKey:@"thumbnailImage"];
    self.mFullImage = [pDict objectForKey:@"fullImage"];
    self.mLegalUrl = [pDict objectForKey:@"legalUrl"];
    self.mActiveCouponCount = [NSNumber numberWithInteger:[[pDict objectForKey:@"activeCouponCount"]intValue]];
  //  self.mLastModified = [pDict objectForKey:@"lastModified"];
    self.mBrandId = [NSNumber numberWithInteger:[[pDict objectForKey:@"brandId"] intValue]];
    //self.mBrandType = [pDict objectForKey:@"brandType"];
    self.mBrandName = [pDict objectForKey:@"brandName"];   
}

- (void) storesWithSolrDict:(NSDictionary *)pDict
{
    self.mID    = [NSNumber numberWithInteger:[[pDict objectForKey:@"id"] intValue]];
    self.mDescription = [pDict objectForKey:@"description"];
    self.mFullName  = [pDict objectForKey:@"fullname"];
    self.mThumbnailImage = [pDict objectForKey:@"thumbnail_image"];
    self.mFullImage = [pDict objectForKey:@"full_image"];
    self.mLegalUrl = [pDict objectForKey:@"legal_url"];
    self.mActiveCouponCount = [NSNumber numberWithInteger:[[pDict objectForKey:@"active_coupon_count"]intValue]];
    self.mLastModified = [DateUtil dateObjectForRFC3339DateTimeString:[pDict objectForKey:@"last_modified"]];
    self.mBrandId = [NSNumber numberWithInteger:[[pDict objectForKey:@"brand_id"] intValue]];
    //self.mBrandType = [pDict objectForKey:@"brand_type"];
    self.mBrandName = [pDict objectForKey:@"brand_name"];
}

@end
