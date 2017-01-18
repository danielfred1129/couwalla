//
//  StorePreferences.h
//  Coupit
//
//  Created by Vikas_headspire on 06/05/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StorePreferences : NSManagedObject

@property (nonatomic, retain) NSNumber * mID;
@property (nonatomic, retain) NSNumber * mStoreID;
@property (nonatomic, retain) NSNumber * mBrandID;
@property (nonatomic, retain) NSNumber * mEntityType;
@property (nonatomic, retain) NSString * mStoreName;
@property (nonatomic, retain) NSString * mBrandName;
@property (nonatomic, retain) NSString * mGeoCoordinate;
@property (nonatomic, retain) NSString * mZip;
@property (nonatomic, retain) NSNumber * mDistanceAway;
@property (nonatomic, retain) NSNumber * mNotificationEnabled;

-(void) storePreferencesWithDict:(NSDictionary *)pDict;
@end
