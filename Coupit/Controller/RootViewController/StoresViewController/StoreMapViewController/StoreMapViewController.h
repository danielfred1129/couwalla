//
//  StoreMapViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "StoreLocations.h"

#define METERS_PER_MILE 1609.344


@interface StoreMapViewController : BaseViewController<MKMapViewDelegate,CLLocationManagerDelegate>

@property(nonatomic, retain) IBOutlet MKMapView *mMapView;
@property(nonatomic, retain) CLLocationManager *mLocationManager;
@property(nonatomic ,retain) StoreLocations *mStoreLocations;


-(void)showGestureView;
-(void)hideGestureView;
-(void)menuButtonSelected;
-(void)menuButtonUnselected;
- (void) openStoreInGoogleMap:(NSString *)pCoordinates;



@end
