//
//  StoreLocations.m
//  Coupit
//
//  Created by Deepak Kumar on 3/4/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "StoreLocations.h"

@implementation StoreLocations

@dynamic mCity;
@dynamic mCountry;
@dynamic mGeoCoordinate;
@dynamic mISO6709GeoCoordinate;
@dynamic mStoreID;
@dynamic mRadius;
@dynamic mState;
@dynamic mTimezone;
@dynamic mZip;
@dynamic mAddressLine;
@dynamic mLocationID;


- (void) storeLocationsWithDict:(NSDictionary *)pDict
{
    
    self.mGeoCoordinate = [pDict objectForKey:@"geoCoordinate"];
    self.mISO6709GeoCoordinate = [pDict objectForKey:@"geoCoordinate"];
    self.mAddressLine = [pDict objectForKey:@"addressLine"];
    self.mZip = [pDict objectForKey:@"zip"];
    self.mCity = [pDict objectForKey:@"city"];
    self.mState = [pDict objectForKey:@"state"];
    self.mCountry = [pDict objectForKey:@"country"];

    self.mRadius = [NSNumber numberWithInteger:[[pDict objectForKey:@"radius"]intValue]];
    self.mTimezone = [NSNumber numberWithInteger:[[pDict objectForKey:@"timezone"]intValue]];
    self.mStoreID = [NSNumber numberWithInteger:[[pDict objectForKey:@"parentId"]intValue]];
    self.mLocationID = [NSNumber numberWithInteger:[[pDict objectForKey:@"id"]intValue]];

 
}

- (void) storeLocationsWithSolrDict:(NSDictionary *)pDict
{
    self.mRadius = [NSNumber numberWithInteger:[[pDict objectForKey:@"radius"]intValue]];
    self.mZip = [pDict objectForKey:@"zip"];
    self.mCity = [pDict objectForKey:@"city"];
    self.mState = [pDict objectForKey:@"state"];
    self.mCountry = [pDict objectForKey:@"country"];
    self.mTimezone = [NSNumber numberWithInteger:[[pDict objectForKey:@"timezone"]intValue]];
    self.mLocationID = [NSNumber numberWithInteger:[[pDict objectForKey:@"location_id"]intValue]];
    self.mGeoCoordinate = [pDict objectForKey:@"geo_coordinate"];
    self.mISO6709GeoCoordinate = [self convertSolrGeoCoordinateToISO6709GeoCoordinate:[pDict objectForKey:@"geo_coordinate"]];
    self.mAddressLine = [pDict objectForKey:@"address_line"];
    self.mStoreID = [NSNumber numberWithInteger:[[pDict objectForKey:@"id"]intValue]];
}


- (NSString *) convertSolrGeoCoordinateToISO6709GeoCoordinate: (NSString *) solrGeoCoordinate {
    // replace ',-' with '-'
    // replace ',' with '+'
    // replace '++' with '+'
    // if char at '0' is not '+' then prepend '+' (at 0th position)
    // append '/' at the end of the string
    
    NSMutableString *tISO6709GeoCoordinate = [NSMutableString stringWithString: solrGeoCoordinate];
    if ([tISO6709GeoCoordinate rangeOfString:@",-"].location != NSNotFound) {
        [tISO6709GeoCoordinate replaceCharactersInRange: [tISO6709GeoCoordinate rangeOfString: @",-"] withString: @"-"];
    } else if ([tISO6709GeoCoordinate rangeOfString:@","].location != NSNotFound) {
        [tISO6709GeoCoordinate replaceCharactersInRange: [tISO6709GeoCoordinate rangeOfString: @","] withString: @"+"];
    } else if ([tISO6709GeoCoordinate rangeOfString:@",+"].location != NSNotFound) {
        [tISO6709GeoCoordinate replaceCharactersInRange: [tISO6709GeoCoordinate rangeOfString: @",+"] withString: @"+"];
    } else if ([tISO6709GeoCoordinate rangeOfString:@"++"].location != NSNotFound) {
        [tISO6709GeoCoordinate replaceCharactersInRange: [tISO6709GeoCoordinate rangeOfString: @"++"] withString: @"+"];
    }
    
    if (![tISO6709GeoCoordinate hasPrefix:@"+"]) {
        [tISO6709GeoCoordinate insertString: @"+" atIndex: 0];
    }
    
    //NSLog(@"Location Key :%@",tISO6709GeoCoordinate);
    return tISO6709GeoCoordinate;
}
 


@end
