//
//  Brands.m
//  Coupit
//
//  Created by Deepak Kumar on 3/4/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "Brands.h"


@implementation Brands

@dynamic mActiveCouponCount;
@dynamic mDescription;
@dynamic mFullImage;
@dynamic mID;
@dynamic mLegalUrl;
@dynamic mName;
@dynamic mThumbnailImage;
@dynamic mType;



-(void) brandsWithDict:(NSDictionary *)pDict
{
    self.mID    = [NSNumber numberWithInteger:[[pDict objectForKey:@"id"]intValue]];
    self.mName  = [pDict objectForKey:@"name"];
    self.mDescription = [pDict objectForKey:@"coupon_description"];
    self.mType = [NSNumber numberWithInteger:[[pDict objectForKey:@"type"]intValue]];;
    self.mThumbnailImage = [pDict objectForKey:@"thumbnailImage"];
    self.mFullImage = [pDict objectForKey:@"fullImage"];
    self.mLegalUrl = [pDict objectForKey:@"legalUrl"];
    self.mActiveCouponCount = [NSNumber numberWithInteger:[[pDict objectForKey:@"activeCouponCount"]intValue]];
}


@end
