//
//  Location.h
//  Coupit
//
//  Created by Deepak Kumar on 4/4/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Location : NSObject<CLLocationManagerDelegate>


+ (Location *) getInstance;
- (void) calculateCurrentLocation;

- (NSString *) userLocation;
- (CLLocation *) getCurrentLocation;
- (NSString *) getDistanceFromCurrentLocationInMiles:(NSString *)pLocation;

@end
