//
//  StorePreferences.m
//  Coupit
//
//  Created by Vikas_headspire on 06/05/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "StorePreferences.h"


@implementation StorePreferences

@dynamic mID;
@dynamic mStoreID;
@dynamic mStoreName;
@dynamic mGeoCoordinate;
@dynamic mZip;
@dynamic mDistanceAway;
@dynamic mNotificationEnabled;
@dynamic mEntityType;
@dynamic mBrandName;
@dynamic mBrandID;

-(void) storePreferencesWithDict:(NSDictionary *)pDict {
    

    self.mID    = [pDict objectForKey:@"id"];
    self.mStoreID = [pDict objectForKey:@"storeId"];
    self.mStoreName =  [pDict objectForKey:@"storeName"];
    self.mGeoCoordinate = [pDict objectForKey:@"geoCoordinate"];
    self.mNotificationEnabled = [pDict objectForKey:@"notificationEnabled"];
    self.mZip = [pDict objectForKey:@"zip"];
    self.mDistanceAway = [pDict objectForKey:@"distanceAway"];
    self.mBrandID = [pDict objectForKey:@"brandId"];
    self.mBrandName = [pDict objectForKey:@"brandName"];
    self.mEntityType = [pDict objectForKey:@"entityType"];
    
    
}
@end
