//
//  StoreLocations.h
//  Coupit
//
//  Created by Deepak Kumar on 3/4/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LocationDocs.h"


@interface StoreLocations : NSManagedObject

@property (nonatomic, retain) NSString * mCity;
@property (nonatomic, retain) NSString * mCountry;
@property (nonatomic, retain) NSString * mGeoCoordinate;
@property (nonatomic, retain) NSString * mISO6709GeoCoordinate;
@property (nonatomic, retain) NSString * mState;
@property (nonatomic, retain) NSString * mZip;
@property (nonatomic, retain) NSString * mAddressLine;

@property (nonatomic, retain) NSNumber * mTimezone;
@property (nonatomic, retain) NSNumber * mStoreID;
@property (nonatomic, retain) NSNumber * mLocationID;

@property (nonatomic, retain) NSNumber * mRadius;

- (void) storeLocationsWithDict:(NSDictionary *)pDict;
- (void) storeLocationsWithSolrDict:(NSDictionary *)pDict;


@end
