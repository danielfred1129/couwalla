//
//  StoreGoogleMapViewController.h
//  GoogleMapIntegeration
//
//  Created by Vikas_headspire on 11/03/13.
//  Copyright (c) 2013 Vikas_headspire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "StoreLocations.h"
#import "Stores.h"
#import "LocationDocs.h"
#import "MapKit/MapKit.h"
#import <CoreLocation/CoreLocation.h>

@class StoreGoogleMapViewController;

@protocol StoreGoogleMapViewControllerDelegate
- (void) storeMapViewController:(StoreGoogleMapViewController *)pStoreMap isBack:(BOOL)pValue;

@end


@interface StoreGoogleMapViewController : BaseViewController<GMSMapViewDelegate,CLLocationManagerDelegate>
@property (nonatomic, retain) id <StoreGoogleMapViewControllerDelegate> mDelegate;

- (UIImage*) drawText:(NSString*) text
              inImage:(UIImage*)  image
              atPoint:(CGPoint)   point;
- (void) refreshMarkers;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
