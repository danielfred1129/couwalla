//
//  StoreGoogleMapViewController.m
//  GoogleMapIntegeration
//
//  Created by Vikas_headspire on 11/03/13.
//  Copyright (c) 2013 Vikas_headspire. All rights reserved.
//

#import "StoreGoogleMapViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FileUtils.h"
#import "StoreLocationItem.h"
#import "Stores.h"
#import "MapOverlayView.h"
#import "RequestHandler.h"
#import "StoreListViewController.h"
#import "NSString_extras.h"

#define kLonChange 0.1
#define kLatChange 0.1

@interface StoreGoogleMapViewController ()
@end

@implementation StoreGoogleMapViewController
{
    GMSMapView *mMapView;
    GMSMarkerOptions *mOptions;
    NSMutableArray *mStoreMarkerArray;
    NSMutableArray *mMarkerArray;
    NSMutableArray *mStoreArray;
    NSMutableArray *mStoreLocationArray;
    
    CLLocationManager *locationManager;
    
    BOOL mIsDataLoading;
    CLLocationCoordinate2D mPreviousLocationCoordinate;
    BOOL mIsCoordinateChanged;
    ProgressHudPresenter *mHudPresenter;

    NSTimer *mMapTimer;
    double mTimeInterval;
}

@synthesize mDelegate,mapView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Store Map";
    self.mapView.delegate=self;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    [locationManager startUpdatingLocation];
    
    
//    mIsCoordinateChanged = NO;
//    mPreviousLocationCoordinate = CLLocationCoordinate2DMake(0, 0);
//    mIsDataLoading = NO;
//    
//    mHudPresenter = [[ProgressHudPresenter alloc] init];
//    mTimeInterval = [NSDate timeIntervalSinceReferenceDate];
//    //NSLog(@"--bhniuewrfn %0.2f", mTimeInterval);
//    
//    //Cancel Button
    UIButton *tlistViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tlistViewButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tlistViewButton sizeToFit];
    [tlistViewButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
//
    UIBarButtonItem *tlistViewMap = [[UIBarButtonItem alloc]initWithCustomView:tlistViewButton];
    self.navigationItem.leftBarButtonItem = tlistViewMap;

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myString1 = [prefs stringForKey:@"keylat"];
    NSString *myString2 = [prefs stringForKey:@"keylon"];
    
    CLLocationCoordinate2D location;
    //img = [prefs stringForKey:@"image"];
    
    location.latitude = [myString1 doubleValue];
    location.longitude = [myString2 doubleValue];
    //NSLog(@"lati is%@",myString1);
    //NSLog(@"long is%@",myString2);
    // annotation

    
    MKCoordinateRegion region;
    region.center.latitude = [myString1 doubleValue];
    region.center.longitude = [myString2 doubleValue];
    region.span.latitudeDelta = 1;
    region.span.longitudeDelta = 1;
    self.mapView.region = region;
    
    //NSLog(@"store map appears");
    
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {

    }
}

- (void) doneButton:(UIBarButtonItem *)pBarButton
{
    [self dismissViewControllerAnimated:YES completion:^{
    [mDelegate storeMapViewController:self isBack:YES];
        
    }];
}
//
//- (void) mapViewDidStopCameraPosition
//{
//    //NSLog(@"Latitude And longitude: %f,%f ", mMapView.camera.target.latitude, mMapView.camera.target.longitude);
//    
//    NSString *tSolrStoresRequestURL = [kSolrStoresMapRequestURL stringByAppendingFormat:@"&pt=%f,%f",mMapView.camera.target.latitude,mMapView.camera.target.longitude];
//
//    [[RequestHandler getInstance] getRequestURL:tSolrStoresRequestURL delegate:self requestType:kSolrStoreRequest];
//    [mHudPresenter presentHud];
//
//}
//
//- (void) mapDraggingStopped
//{
//   double tDifference  = [NSDate timeIntervalSinceReferenceDate] - mTimeInterval;
//    
//    if (tDifference > 1.5) {
//        [mMapTimer invalidate];
//        mMapTimer = nil;
//        [self mapViewDidStopCameraPosition];        
//    }
//}
//
//- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
//{
//    mTimeInterval = [NSDate timeIntervalSinceReferenceDate];
//   // //NSLog(@"-- %0.2f", mTimeInterval);
//    if (mMapTimer == nil) {
//        mMapTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(mapDraggingStopped) userInfo:nil repeats:YES];
//    }
//    
//    
//}
//
//- (void) requestHandler:(RequestHandler *)pRequestHandler withRequestType:(RequestType)pRequestType error:(APIError *)pError
//{
//    // run on main thread only
//    if (![NSThread isMainThread]) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self requestHandler:pRequestHandler withRequestType:pRequestType error:pError];
//        });
//        return;
//    }
//    
//    mIsDataLoading = YES;
//    
//    if (pRequestType == kSolrStoreRequest) {
//        if (!pError) {
//            [mHudPresenter hideHud];
//            [mMapView clear];
//            mStoreMarkerArray = [NSMutableArray new];
//            mStoreArray = [NSMutableArray new];
//            mStoreLocationArray = [NSMutableArray new];
//            mMarkerArray = [NSMutableArray new];
//            // mLocationDocsArray
//            mStoreLocationArray = [[DataManager getInstance] mStoresLocationArray];
//            mStoreArray = [[DataManager getInstance] mStoresArray];
//
//            NSInteger tMarketCounter = 0;
//            for (int i=0; i < mStoreLocationArray.count; i++) {
//                StoreLocations *tStoreLocations = [mStoreLocationArray objectAtIndex:i];
//                
//                GMSMarkerOptions *tMarker = [[GMSMarkerOptions alloc] init];
//                tMarker.position = [tStoreLocations.mISO6709GeoCoordinate makeLocationCoordinate2D];
//                tMarker.title = [NSString stringWithFormat:@"%d", tMarketCounter];
//                tMarketCounter++;
//                
//                Stores *tStores = [mStoreArray objectAtIndex:i];
//                tMarker.snippet = tStoreLocations.mCity;
//                tMarker.accessibilityLabel = @"Go";
//                tMarker.infoWindowAnchor = CGPointMake(0.5, 0.1);
//                
//                UIImage *tBadgeImage = [self drawText:[NSString stringWithFormat:@"%d",[tStores.mActiveCouponCount integerValue]] inImage:[UIImage imageNamed:@"map_pin_blue"] atPoint:CGPointMake(6, 6)];
//                
//                tMarker.icon = tBadgeImage;
//                [mMapView addMarkerWithOptions:tMarker];
//                [mMarkerArray addObject:tMarker];
//                [mStoreMarkerArray addObject:tStores];
//                
//            }
//
//        } else {
//            //NSLog(@"Request Failed:%d | Code:%d | Message:%@",pRequestType, pError.mErrorCode.intValue, pError.mMessage);
//            
//            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Unable to fetch Stores" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [tAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
//            
//        }
//    }
//}
//
//- (void) refreshMarkers
//{
//    NSArray *tMarkerArray = [mMapView markers];
//    for (int i = 0; i < [mStoreMarkerArray count]; i++) {
//        Stores *tStores = [mStoreMarkerArray objectAtIndex:i];
//        id<GMSMarker>tMarker = [tMarkerArray objectAtIndex:i];
//        
//        UIImage *tBadgeImage = [self drawText:[NSString stringWithFormat:@"%d",[tStores.mActiveCouponCount integerValue]] inImage:[UIImage imageNamed:@"map_pin_blue"] atPoint:CGPointMake(6, 6)];
//        
//        tMarker.icon = tBadgeImage;
//    }
//}
//
//
//- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(id<GMSMarker>)marker
//{
//    if (marker != mMapView.selectedMarker) {
//        [self refreshMarkers];
//        
//        NSInteger index = [marker.title integerValue];
//        Stores *tStores = [mStoreMarkerArray objectAtIndex:index];
//        
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:0.125f];  // short animation
//        [mapView animateToLocation:marker.position];
//        [mapView animateToBearing:0];
//        [mapView animateToViewingAngle:0];
//        
//        UIImage *tBadgeImage = [self drawText:[NSString stringWithFormat:@"%d",[tStores.mActiveCouponCount integerValue]] inImage:[UIImage imageNamed:@"map_pin_yellow"] atPoint:CGPointMake(6, 6)];
//        
//        marker.icon = tBadgeImage;
//        [CATransaction commit];
//    }
//    return NO;
//}
//
//
///**
// * Called after a tap gesture at a particular coordinate, but only if a marker
// * was not tapped.  This is called before deselecting any currently selected
// * marker (the implicit action for tapping on the map).
// */
//
//- (UIImage*) drawText:(NSString*)text inImage:(UIImage*)image atPoint:(CGPoint)point
//{
//    UIFont *font = [UIFont boldSystemFontOfSize:15];
//    UIGraphicsBeginImageContext(image.size);
//    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
//    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
//    [[UIColor whiteColor] set];
//    [text drawInRect:CGRectIntegral(rect) withFont:font];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return newImage;
//}
//
//#pragma mark - GMSMapViewDelegate
//
//- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(id<GMSMarker>)marker {
//    
//    NSInteger index = [marker.title integerValue];
//    Stores *tStores = [mStoreMarkerArray objectAtIndex:index];
//
//    MapOverlayView *tMapOverlayView = [[MapOverlayView alloc] initWithNibName:@"MapOverlayView" bundle:nil];
//    NSString *tFileName = [tStores.mThumbnailImage lastPathComponent];
//    NSString *fmtFileName = makeFileName([tStores.mID stringValue], tFileName);
//    if (isFileExists(fmtFileName)) {
//        tMapOverlayView.mImagePath = imageFilePath(fmtFileName);
//    }
//    else{
//        tMapOverlayView.mImagePath = nil;
//    }
//
//    tMapOverlayView.mStoreNameLabel = tStores.mFullName;
//    tMapOverlayView.mActiveCouponCountLabel = [NSString stringWithFormat:@"%d Active coupons", [tStores.mActiveCouponCount integerValue]];
//    
//    NSMutableArray *tStoreLocationArray = [NSMutableArray new];
//    tStoreLocationArray = [[DataManager getInstance] mStoresLocationArray];
//    StoreLocations *tStoreLocations = [tStoreLocationArray objectAtIndex:index];
//    tMapOverlayView.mDistanceLabel = [[Location getInstance] getDistanceFromCurrentLocationInMiles:tStoreLocations.mISO6709GeoCoordinate];
//
//    tMapOverlayView.mAddressLabel = tStoreLocations.mAddressLine;
//
//    return tMapOverlayView.view;
//}
//
//
//- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(id<GMSMarker>)marker
//{
//    NSInteger index = [marker.title integerValue];
//    
//    Stores *tStores = [mStoreArray objectAtIndex:index];
//    StoreLocations *tStoreLocations = [mStoreLocationArray objectAtIndex:index];
//    StoreListViewController *tStoreListViewController = [[StoreListViewController alloc] initWithNibName:@"StoreListViewController" bundle:nil];
//    tStoreListViewController.mStoreLocator = kstoreSelected;
//    [self.navigationController pushViewController:tStoreListViewController animated:YES];
//    tStoreListViewController.mStoreID = tStores.mID;
//    [tStoreListViewController showCouponsForStore:tStores];
//    [tStoreListViewController showLocationForStore:tStoreLocations];
//
//    
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
