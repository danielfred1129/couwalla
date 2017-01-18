//
//  StoreLocatorMap.m
//  GoogleMapIntegeration
//
//  Created by Vikas_headspire on 11/03/13.
//  Copyright (c) 2013 Vikas_headspire. All rights reserved.
//

#import "StoreLocatorMap.h"
#import "StoreLocations.h"
#import "StoreMapOverlayView.h"
#import <QuartzCore/QuartzCore.h>
#import "FileUtils.h"
#import "NSString_extras.h"
#import "Location.h"
#import "annotationclass.h"
#import "MapDetailsViewController.h"

@interface StoreLocatorMap ()

@end

@implementation StoreLocatorMap
//{
//    NSMutableArray *mStorelocationArray;
//    GMSMapView *mMapView;
//    GMSMarkerOptions *mOptions;
//    NSMutableArray *mStoreArray;
//    NSMutableArray *mMarkerArray;
//    NSMutableArray *mLocationMarkerArray;
//
//
//
//}
@synthesize mStoreID;
@synthesize mapView = _mapView;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Store Map Locator";
    //mMarkerArray = [NSMutableArray new];
   // mLocationMarkerArray = [NSMutableArray new];
    
    //Cancel Button
    UIButton *tlistViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tlistViewButton setImage:[UIImage imageNamed:@"btn_list_view"] forState:UIControlStateNormal];
    [tlistViewButton sizeToFit];
    [tlistViewButton addTarget:self action:@selector(dismissButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tlistViewMap = [[UIBarButtonItem alloc]initWithCustomView:tlistViewButton];
    self.navigationItem.rightBarButtonItem = tlistViewMap;
    CLLocation *tCurrentLocation = [[Location getInstance] getCurrentLocation];
    GMSCameraPosition *tCamera = [GMSCameraPosition cameraWithLatitude:tCurrentLocation.coordinate.latitude
                                                             longitude:tCurrentLocation.coordinate.longitude
                                                                  zoom:10];
     NSLog(@"You tapped at %f,%f", tCurrentLocation.coordinate.latitude, tCurrentLocation.coordinate.longitude);
    //mMapView = [GMSMapView mapWithFrame:CGRectZero camera:tCamera];
   // mMapView.myLocationEnabled = YES;
    //mMapView.delegate = self;
    //self.view = mMapView;
    
#pragma mark - IOS Map
    Location *locobject = [Location alloc];
     [self.mapView setDelegate:self];
    CLLocationCoordinate2D location;
//    location.latitude = tCurrentLocation.coordinate.latitude;
//    location.longitude = tCurrentLocation.coordinate.longitude;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myString1 = [prefs stringForKey:@"keylat"];
    NSString *myString2 = [prefs stringForKey:@"keylng"];

    location.latitude = [myString1 doubleValue];
    location.longitude = [myString2 doubleValue];
    // annotation
    annotationclass *ann = [[annotationclass alloc] initWithPosition:location];
    [ann setCoordinate:location];
    ann.title = @"Carpinteria";
    ann.subtitle = @"Surfing beach";
    
    // add to map
    [self.mapView addAnnotation:ann];

    
    

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    view.pinColor = MKPinAnnotationColorPurple;
    view.enabled = YES;
    view.animatesDrop = YES;
    view.canShowCallout = YES;
    
   // UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"palmTree.png"]];
    //view.leftCalloutAccessoryView = imageView;
    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return view;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    // get reference to the annotation to access its data
    annotationclass *myAnnotation = (annotationclass *)view.annotation;
    // deselect the button
    [self.mapView deselectAnnotation:myAnnotation animated:YES];
    // construct string with coordinate information
   // NSString *msg = [@"Location:\n" stringByAppendingFormat:@"%f %f", myAnnotation.coordinate.latitude, myAnnotation.coordinate.longitude];
    // display alert view to the information
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Description" message:Nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
    MapDetailsViewController *details = [[MapDetailsViewController alloc]initWithNibName:@"MapDetailsViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:details animated:YES];
    
}




//- (void) openStoreInGoogleMap:(NSString *)pCoordinates
//{
//    
//    if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"comgooglemaps://"]]) {
//        NSLog(@"comgooglemaps");
//        
//        NSString *url = [NSString stringWithFormat: @"comgooglemaps://?q=%@",
//                         [pCoordinates stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        NSLog(@"comgooglemaps URL %@",url);
//
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//    }
//    else {
//     
//        NSString *url = [NSString stringWithFormat: @"http://maps.google.com/maps?ll=%@",
//                         [pCoordinates stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//    }
//}
//
//- (Stores *) getStoreByID:(NSInteger)pID
//{
//    for (Stores *tStores in mStoreArray) {
//        if (pID == [tStores.mID integerValue])
//        {
//            return tStores;
//        }
//    }
//    return nil;
//}
//
//
//- (StoreLocations *) getStoreLocationByID:(NSInteger)pID
//{
//    for (StoreLocations *tStoreLocations in mStorelocationArray) {
//        if (pID == [tStoreLocations.mStoreID integerValue])
//        {
//            return tStoreLocations;
//        }
//    }
//    return nil;
//}
//
//
//- (void) mapView {
//    
//    NSInteger tMarketCounter = 0;
//    StoreLocations *tStoreLocations = [self getStoreLocationByID:mStoreID];
//    Stores *tStores = [self getStoreByID:mStoreID];
//    GMSMarkerOptions *tMarker = [[GMSMarkerOptions alloc] init];
//    tMarker.position = [tStoreLocations.mISO6709GeoCoordinate makeLocationCoordinate2D];
//    tMarker.title = [NSString stringWithFormat:@"%d", tMarketCounter];
//    tMarketCounter++;
//    tMarker.infoWindowAnchor = CGPointMake(0.4, 0.1);
//    UIImage *tBadgeImage = [self drawText:[NSString stringWithFormat:@"%d",[tStores.mActiveCouponCount integerValue]] inImage:[UIImage imageNamed:@"map_pin_blue"] atPoint:CGPointMake(6, 6)];
//    tMarker.icon = tBadgeImage;
//    [mMapView addMarkerWithOptions:tMarker];
//    [mMarkerArray addObject:tStores];
//    [mLocationMarkerArray addObject:tStoreLocations];
//    mMapView.selectedMarker = [mMapView addMarkerWithOptions:tMarker];
//    
//}
//
//- (void) setStoreLocationWithStoreID:(NSString *)pStoreID {
//    
//    mStoreArray = [NSMutableArray new];
//    mStoreArray = [[DataManager getInstance] mStoresArray];
//    mStorelocationArray = [NSMutableArray new];
//    mStorelocationArray = [[DataManager getInstance] mStoresLocationArray];
//    mStoreID = [pStoreID integerValue];
//    [self mapView];
//    
//}

- (void) dismissButton:(UIBarButtonItem *)pBarButton
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - GMSMapViewDelegate

//- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(id<GMSMarker>)marker {
//    
//    NSInteger index = [marker.title integerValue];
//    Stores *tStore = [mMarkerArray objectAtIndex:index];
//    StoreLocations *tStoreLocations = [mLocationMarkerArray objectAtIndex:index];
//    
//    StoreMapOverlayView *tMapOverlayView = [[StoreMapOverlayView alloc] initWithNibName:@"StoreMapOverlayView" bundle:nil];
//    tMapOverlayView.mStoreNameLabel = tStore.mFullName;
//    tMapOverlayView.mAddressLabel = tStoreLocations.mAddressLine;
//    
//    tMapOverlayView.mDistanceLabel = [[Location getInstance] getDistanceFromCurrentLocationInMiles:tStoreLocations.mISO6709GeoCoordinate];
//
//    NSString *tFileName = [tStore.mThumbnailImage lastPathComponent];
//    NSString *fmtFileName = makeFileName([tStore.mID stringValue], tFileName);
//    if (isFileExists(fmtFileName)) {
//        tMapOverlayView.mImagePath = imageFilePath(fmtFileName);
//    }
//    else {
//        tMapOverlayView.mImagePath = nil;
//    }
//    [tMapOverlayView resignFirstResponder];
//    
//    
//    return tMapOverlayView.view;
//}
//
//- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(id<GMSMarker>)marker
//{
//    if (marker != mMapView.selectedMarker) {
//        NSInteger index = [marker.title integerValue];
//        Stores *tStore = [mMarkerArray objectAtIndex:index];
//        
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:0.125f];  // short animation
//        [mapView animateToLocation:marker.position];
//        [mapView animateToBearing:0];
//        [mapView animateToViewingAngle:0];
//        
//        
//        UIImage *tBadgeImage = [self drawText:[NSString stringWithFormat:@"%d",[tStore.mActiveCouponCount integerValue]] inImage:[UIImage imageNamed:@"map_pin_blue"] atPoint:CGPointMake(6, 6)];
//        
//        marker.icon = tBadgeImage;
//        [CATransaction commit];
//    }
//    return NO;
//}
//
//- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(id<GMSMarker>)marker
//{
//    
//   // if (marker != mMapView.selectedMarker) {
//        NSInteger index = [marker.title integerValue];
//
//        StoreLocations *tLocationDocs = [mLocationMarkerArray objectAtIndex:index];
//        CLLocationCoordinate2D tCoordinate = [tLocationDocs.mISO6709GeoCoordinate makeLocationCoordinate2D];
//        [self openStoreInGoogleMap:[NSString stringWithFormat:@"%f, %f",tCoordinate.latitude, tCoordinate.longitude]];
//    //}
//}
//
//- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
//    
//    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
//}

- (UIImage*) drawText:(NSString*)text inImage:(UIImage*)image atPoint:(CGPoint)point {
    
    UIFont *font = [UIFont boldSystemFontOfSize:15];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    [text drawInRect:CGRectIntegral(rect) withFont:font];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
