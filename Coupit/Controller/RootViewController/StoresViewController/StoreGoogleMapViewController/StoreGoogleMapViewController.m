//
//  StoreGoogleMapViewController.m
//  GoogleMapIntegeration
//
//  Created by Vikas_headspire on 11/03/13.
//  Copyright (c) 2013 Vikas_headspire. All rights reserved.
//

#import "StoreGoogleMapViewController.h"


@interface StoreGoogleMapViewController ()

@end

@implementation StoreGoogleMapViewController
{
    GMSMapView *mapView;
    GMSMarkerOptions *mOptions;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)loadView {
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.8683
                                                            longitude:151.2086
                                                                 zoom:8];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    
    mOptions = [[GMSMarkerOptions alloc] init];
    mOptions.position = CLLocationCoordinate2DMake(-33.8683, 151.2086);
    mOptions.title = @"Sydney trhvnam dfddsfd dfdsa dsfdsv";
    mOptions.snippet = @"Australia";
    mOptions.accessibilityLabel = @"Go";
    mOptions.infoWindowAnchor = CGPointMake(0.5, 0.1);
    mOptions.icon = [UIImage imageNamed:@"map_pin_yellow"];

    [mapView addMarkerWithOptions:mOptions];
    
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(id<GMSMarker>)marker
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
