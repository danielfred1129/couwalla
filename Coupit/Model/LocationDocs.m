//
//  LocationDocs.m
//  Coupit
//
//  Created by Vikas_headspire on 24/04/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "LocationDocs.h"
#import "DateUtil.h"

@implementation LocationDocs
@synthesize mID,mFullName, mDescription, mThumbnailImage, mFullImage, mLegalUrl, mActiveCouponCount, mLastModified, mBrandId,mBrandType, mBrandName , mLocationID, mGeoCoordinate, mRadius, mAddressLine, mZip, mCity, mState, mCountry, mTimezone;


- (id) initWithDict:(NSDictionary *)pDict
{
    self = [super init];
    if (self) {

    self.mID    = [NSNumber numberWithInteger:[[pDict objectForKey:@"id"] intValue]];
    self.mDescription = [pDict objectForKey:@"description"];
    self.mRadius = [NSNumber numberWithInteger:[[pDict objectForKey:@"radius"]intValue]];
    self.mZip = [pDict objectForKey:@"zip"];
    self.mCity = [pDict objectForKey:@"city"];
    self.mState = [pDict objectForKey:@"state"];
    self.mCountry = [pDict objectForKey:@"country"];
    self.mTimezone = [NSNumber numberWithInteger:[[pDict objectForKey:@"timezone"]intValue]];
    self.mFullName  = [pDict objectForKey:@"fullname"];
    self.mThumbnailImage = [pDict objectForKey:@"thumbnail_image"];
    self.mFullImage = [pDict objectForKey:@"full_image"];
    self.mLegalUrl = [pDict objectForKey:@"legal_url"];
    self.mActiveCouponCount = [NSNumber numberWithInteger:[[pDict objectForKey:@"active_coupon_count"]intValue]];
    self.mLastModified = [DateUtil dateObjectForRFC3339DateTimeString:[pDict objectForKey:@"last_modified"]];
    self.mBrandId = [NSNumber numberWithInteger:[[pDict objectForKey:@"brand_id"] intValue]];
    //self.mBrandType = [pDict objectForKey:@"brand_type"];
    self.mBrandName = [pDict objectForKey:@"brand_name"];
    self.mLocationID = [NSNumber numberWithInteger:[[pDict objectForKey:@"location_id"]intValue]];
    self.mGeoCoordinate = [pDict objectForKey:@"geo_coordinate"];
    self.mAddressLine = [pDict objectForKey:@"address_line"];
        
    }
    
    return self;
}

@end
