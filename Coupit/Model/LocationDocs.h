//
//  LocationDocs.h
//  Coupit
//
//  Created by Vikas_headspire on 24/04/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationDocs : NSObject


@property (nonatomic, retain) NSNumber * mActiveCouponCount;
@property (nonatomic, retain) NSNumber * mBrandId;
@property (nonatomic, retain) NSString * mFullImage;
@property (nonatomic, retain) NSString * mFullName;
@property (nonatomic, retain) NSNumber * mID;
@property (nonatomic, retain) NSDate   * mLastModified;
@property (nonatomic, retain) NSString * mLegalUrl;
@property (nonatomic, retain) NSString * mThumbnailImage;
@property (nonatomic, retain) NSString * mDescription;
@property (nonatomic, retain) NSString * mBrandType;
@property (nonatomic, retain) NSString * mBrandName;
@property (nonatomic, retain) NSString * mCity;
@property (nonatomic, retain) NSString * mCountry;
@property (nonatomic, retain) NSString * mGeoCoordinate;
@property (nonatomic, retain) NSString * mState;
@property (nonatomic, retain) NSString * mZip;
@property (nonatomic, retain) NSString * mAddressLine;

@property (nonatomic, retain) NSNumber * mTimezone;
@property (nonatomic, retain) NSNumber * mLocationID;

@property (nonatomic, retain) NSNumber * mRadius;

- (id) initWithDict:(NSDictionary *)pDict;

@end
