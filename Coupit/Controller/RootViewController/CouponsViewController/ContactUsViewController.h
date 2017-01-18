//
//  ContactUsViewController.h
//  Coupit
//
//  Created by geniemac5 on 25/10/13.
//  Copyright (c) 2013 Home. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
//#import ""
#import "annotationclass.h"
#import "VBAnnotationView.h"
#import "StoreListViewController.h"
#import "UIImageView+WebCache.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
@interface ContactUsViewController : BaseViewController<CLLocationManagerDelegate>
{
    annotationclass *annotationmap;
    NSString *lat, *lng, *name, *address;
}

@property(nonatomic, retain) NSString *lat, *lng, *name, *address;
@property (strong, nonatomic) IBOutlet UIView *bgViewForSettingOption;
@property (strong, nonatomic) IBOutlet UILabel *lblIndex;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@property (weak, nonatomic) IBOutlet MKMapView *contactmap;
@property(nonatomic,retain) NSString *myString1,*myString2;
@property(nonatomic,retain)NSMutableArray *locarray;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalCoupan;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIButton *showNextMapButton;
@property (strong, nonatomic) IBOutlet UILabel *lblStoreName;
@property (strong, nonatomic) IBOutlet UILabel *lblNoOfCoupanActive;
@property (strong, nonatomic) IBOutlet UIButton *lblAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblDistance;
@property (strong, nonatomic) IBOutlet UIButton *buttonPhoneNumber;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewCoupanPhoto;
@property (strong, nonatomic) IBOutlet UITextField *textFieldOtherZip;
@property (strong, nonatomic) IBOutlet UITextField *textFieldHomeZip;

@property (strong, nonatomic) IBOutlet UILabel *labelOtherZipCode;
@property (strong, nonatomic) IBOutlet UILabel *labelHomeZipCode;

@property (strong, nonatomic) IBOutlet UIButton *useCurrentLocationButon;
@property (strong, nonatomic) IBOutlet UIButton *useHomeZipLocationButton;
@property (strong, nonatomic) IBOutlet UIButton *useOtherZipLocationCode;
-(IBAction)selectButtonAction:(UIButton *)sender;


@end
