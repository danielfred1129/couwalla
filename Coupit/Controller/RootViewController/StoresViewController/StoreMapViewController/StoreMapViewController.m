//
//  StoreMapViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "StoreMapViewController.h"
#import "StoreLocationItem.h"
#import "Stores.h"



@implementation StoreMapViewController
{
    UIView *mGestureView;
    UIButton *mMenuButton;
    NSMutableArray *mStoreLocationArray;
    NSMutableArray *mStoreArray;
    
}
@synthesize mMapView,mLocationManager,mStoreLocations;



#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Store";
    mMapView.showsUserLocation = YES;
    
    
    mStoreLocationArray = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchAllStoresLocations:nil]];
    mStoreArray = [[NSMutableArray alloc]initWithArray:[[Repository sharedRepository]fetchAllStores:nil]];
   
    for ( int i=0; i < mStoreLocationArray.count; i++) {
     mStoreLocations = [mStoreLocationArray objectAtIndex:i];
          
        NSString * tGeoCoordinate = mStoreLocations.mGeoCoordinate;
        NSCharacterSet* set = [NSCharacterSet characterSetWithCharactersInString:@"+-"];
        NSRange searchRange = NSMakeRange(2, [tGeoCoordinate length]-2);
        NSRange range = [tGeoCoordinate rangeOfCharacterFromSet:set options:nil range:searchRange];
       // //NSLog(@"%i Location",range.location );
        NSRange longRange = NSMakeRange(range.location, [tGeoCoordinate length]-range.location-1);
        NSString *tLongitude = [tGeoCoordinate substringWithRange: longRange];
        //NSLog(@"tGeoCoordinate :%f",[tLongitude floatValue]);
        NSRange latRange = NSMakeRange(0, range.location);
        NSString *tLatitude = [tGeoCoordinate substringWithRange: latRange];
        //NSLog(@"tGeoCoordinate :%f",[tLatitude floatValue]);
        
        CLLocationCoordinate2D theCoordinate;
        theCoordinate.latitude = tLatitude.doubleValue;
        theCoordinate.longitude = tLongitude.doubleValue;
        Stores *tstores = [mStoreArray objectAtIndex:i];
        StoreLocationItem* myAnnotation=[[StoreLocationItem alloc] initWithName:tstores.mFullName Address:mStoreLocations.mAddressLine Coordinate:theCoordinate];
//        myAnnotation.coordinate=theCoordinate;
//        myAnnotation.title = tstores.mFullName;
//        myAnnotation.subtitle=mStoreLocations.mAddressLine;
        [mMapView addAnnotation:myAnnotation];
     }

    //Cancel Button
    UIButton *tlistViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tlistViewButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tlistViewButton sizeToFit];
    [tlistViewButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tlistViewMap = [[UIBarButtonItem alloc]initWithCustomView:tlistViewButton];
    self.navigationItem.leftBarButtonItem = tlistViewMap;

    
   self.mMapView.delegate = self;
   [self.mMapView setShowsUserLocation:YES];
    
    //Instantiate a location object.
    mLocationManager = [[CLLocationManager alloc] init];
    
    //Make this controller the delegate for the location manager.
    [mLocationManager setDelegate:self];
    
    //Set some parameters for the location object.
    //[mlocationManager setDistanceFilter:kCLDistanceFilterNone];
    //[mlocationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    CLLocationCoordinate2D currentLocation;
    currentLocation.latitude = 40.742718;
    currentLocation.longitude= -74.275566;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(currentLocation, 5*METERS_PER_MILE, 5*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [mMapView regionThatFits:viewRegion];
    [mMapView setRegion:adjustedRegion animated:YES];
    

}



-(void)showGestureView {
	if (![self.view.subviews containsObject:mGestureView]) {
		[self.view addSubview:mGestureView];
	}
}

-(void)hideGestureView {
	if ([self.view.subviews containsObject:mGestureView]) {
		[mGestureView removeFromSuperview];
	}
}

-(void)menuButtonSelected {
	mMenuButton.selected = YES;
}

-(void)menuButtonUnselected {
	mMenuButton.selected = NO;
}



- (void) doneButton:(UIBarButtonItem *)pBarButton
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - MKMapViewDelegate methods.
/*
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    MKCoordinateRegion region;
    region = MKCoordinateRegionMakeWithDistance(mlocationManager.location.coordinate,10000,10000);
    
    
    [mv setRegion:region animated:YES];
}
*/



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"StoreLocationItem";
    if ([annotation isKindOfClass:[StoreLocationItem class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.image = [UIImage imageNamed:@"map_pin_blue"];
        annotationView.enabled = YES;
        annotationView.canShowCallout=YES;
        
        UIButton* tRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tRightButton setImage:[UIImage imageNamed:@"btn_check_int"] forState:UIControlStateNormal];
        [tRightButton sizeToFit];
        //[rightButton setTitle:annotation.title forState:UIControlStateNormal];
        [tRightButton addTarget:self
                         action:@selector(checkIn:)
               forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = tRightButton;
        
        UIImageView *profileIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        annotationView.leftCalloutAccessoryView = profileIconView;
        return annotationView;
    }
    
    return nil;    
}

-(void)checkIn:(id)sender
{
    
    
}



- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    view.image = [UIImage imageNamed:@"map_pin_yellow"];
    view.enabled = YES;
    
    
    
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    view.image = [UIImage imageNamed:@"map_pin_blue"];
    view.enabled = YES;
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}





@end

