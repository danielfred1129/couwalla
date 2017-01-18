//
//  StoreLocatorMap.h
//  GoogleMapIntegeration
//
//  Created by Vikas_headspire on 11/03/13.
//  Copyright (c) 2013 Vikas_headspire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Stores.h"
#import "StoreLocations.h"
#import "LocationDocs.h"
#import <MapKit/MapKit.h>
#import "annotationclass.h"
#import "VBAnnotationView.h"

@interface StoreLocatorMap : BaseViewController
{
    NSString *brandstr,*lngtextstr;
    UIImage *img;
    annotationclass *ann;
}
//<GMSMapViewDelegate>
@property (nonatomic) NSInteger mStoreID;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
//-(void) setStoreLocationWithStoreID:(NSString *)pStoreID;
//- (void) openStoreInGoogleMap:(NSString *)pCoordinates;
//
//- (UIImage*) drawText:(NSString*) text
//              inImage:(UIImage*)  image
//              atPoint:(CGPoint)   point;


@end
