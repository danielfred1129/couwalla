//
//  Location.m
//  Coupit
//
//  Created by Deepak Kumar on 4/4/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "Location.h"
#import "Subscriber.h"
#import "NSString_extras.h"
#import "countdownManager.h"

static Location *sharedInstance = nil;

@implementation Location{
	CLLocationManager *mLocationManager;
    CLLocation *mCurrentLocation;
    
    NSString *mLatitude;
    NSString *mLongitude;
}


#pragma mark singleton class method
+ (Location *) getInstance
{
	@synchronized(self)
	{
		if(sharedInstance == nil)
		{
			sharedInstance = [[self alloc] init];
		}
	}
	
	return sharedInstance;
}

+ (id) allocWithZone:(NSZone*)zone
{
	@synchronized(self)
	{
		if(sharedInstance == nil)
		{
			sharedInstance = [super allocWithZone:zone];
			return sharedInstance;
		}
	}
	return nil;
}

- (id) init
{
	self = [super init];
	
	if (self != nil) {
        mLocationManager = [CLLocationManager new];
        mLocationManager.delegate = self;
        
        mLatitude = [NSString new];
        mLongitude = [NSString new];
	}
	return self;
}

- (id)copyWithZone:(NSZone*)zone
{
	return self;
}

- (void) calculateCurrentLocation
{
    if (mLocationManager)
    {
        [mLocationManager startUpdatingLocation];
    }
}

- (CLLocation *) getCurrentLocation
{
    return mCurrentLocation;
}

- (NSString *)getDistanceFromCurrentLocationInMiles:(NSString *)pLocation
{
    CLLocationCoordinate2D tCoordinates = [pLocation makeLocationCoordinate2D];
    CLLocation *tStoreLocation = [[CLLocation alloc] initWithLatitude:tCoordinates.latitude longitude:tCoordinates.longitude];
    CLLocation *tCurrentLocation = [self getCurrentLocation];

    // distance in meter
    CLLocationDistance distance = [tStoreLocation distanceFromLocation:tCurrentLocation];
    
    return [NSString stringWithFormat:@"%1.2f miles away", 0.621371*(distance/1000)];
}


// --------------------------------------
// Core Location Delegate Methods
// --------------------------------------
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    [countdownManager shareManeger].userLocationDidUpdate=YES;
    
    mCurrentLocation = newLocation;
    //NSLog(@"Lat:%f | Long:%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    mLatitude = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    mLongitude = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    [[NSUserDefaults standardUserDefaults] setObject:mLatitude forKey:@"latvalue"];
    [[NSUserDefaults standardUserDefaults] setObject:mLongitude forKey:@"longvalue"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [mLocationManager stopUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{

}

// --------------------------------------
// User Location
// --------------------------------------
- (NSString *) userLocation;
{
    NSString *tUserLocation;
    LocationPreference tLocationPreference = [[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreference];
    switch (tLocationPreference) {
        case kCurrentLocation:
        {
            // TODO: Vikas/varun check the header value and key
            tUserLocation = [NSString stringWithFormat:@"lat=%@;lng=%@",mLatitude, mLongitude];
            [[NSUserDefaults standardUserDefaults] setInteger:tLocationPreference forKey:kLocationPreference];
            
        }
            break;
        case kHomeLocation:
        {
            NSString *subscriberJSON = [[NSUserDefaults standardUserDefaults] objectForKey:@"subscriber"];
            NSDictionary *dictionary = [subscriberJSON JSONValue];
            Subscriber *tSubscriber = [[Subscriber alloc] init];
            [tSubscriber subscriberWithDict:dictionary];
            //tUserLocation = [NSString stringWithFormat:@"zip:%@",tSubscriber.mZip];
            //NSLog(@"HomeZip :%@",tSubscriber.mZip);
            tUserLocation = [self latLong:tSubscriber.mZip];

        }
            break;
        case kZipPostalCode:
        {
            NSString *tZipCode = [[NSUserDefaults standardUserDefaults] objectForKey:kZipCodeLocation];
            tUserLocation = [self latLong:tZipCode];
            //NSLog(@"ZipPostalCode :%@",tZipCode);
            
        }

            break;
        default:
            break;
    }
    
    return tUserLocation;
}

- (NSString *)latLong :(NSString *)pZipCode
{
    NSString *tLatLong;
    NSString *tZipCode = [pZipCode stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSString *tCountryCode = [[NSUserDefaults standardUserDefaults] stringForKey:kCountryCode];
    NSString *tRequest = [NSString stringWithFormat: @"http://maps.google.com/maps/api/geocode/json?address=%@-:%@&sensor=false", tZipCode,tCountryCode];
    ////NSLog(@"tRequest :%@",tRequest);

    NSDictionary *tGoogleResponse = [[NSString stringWithContentsOfURL: [NSURL URLWithString: tRequest] encoding: NSUTF8StringEncoding error: NULL] JSONValue];
    ////NSLog(@"googleResponse :%@",tGoogleResponse);aschwartz
    NSString *tStatusCode = [tGoogleResponse valueForKey:@"status"];
    if ([tStatusCode isEqualToString:@"OK" ])
    {
        NSDictionary *tResultsDict = [tGoogleResponse valueForKey:  @"results"];
        NSDictionary *tGeometryDict = [tResultsDict valueForKey: @"geometry"];
        NSDictionary *tLocationDict = [tGeometryDict valueForKey: @"location"];
        NSArray *latArray = [tLocationDict valueForKey: @"lat"];
        NSString *latString = [latArray lastObject];
        NSArray *lngArray = [tLocationDict valueForKey: @"lng"];
        NSString *lngString = [lngArray lastObject];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:latString forKey:@"keylat"];
        [prefs setObject:lngString forKey:@"keylon"];
        //NSLog(@"lat: %@\tlon:%@", latString, lngString);
        tLatLong = [NSString stringWithFormat:@"lat=%@;lng=%@",latString, lngString];

    } else {
//        UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Lat Long not found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [tAlertView show];
    }
    
    return tLatLong;

    
}

@end
