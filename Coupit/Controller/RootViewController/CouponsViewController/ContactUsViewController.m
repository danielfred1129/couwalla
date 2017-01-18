//
//  ContactUsViewController.m
//  Coupit
//
//  Created by geniemac5 on 25/10/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "ContactUsViewController.h"
#import "appcommon.h"
#import "jsonparse.h"
#import "countdownManager.h"

static int shouldHide;
static int mSeletedValue;
static int isFirstPresentation;
static LocationPreference tLocationPreference;

@interface ContactUsViewController ()
{
    NSString *imgurl;
    float indexValPassToMethode;
    NSMutableDictionary *arrayContainSeletedItem;
    CLLocationManager *locationManager;
    UIButton* mSettingButton ;
    NSMutableArray *arrayFroButton;
    NSMutableArray *dummyArray;
    NSString *zipValInsideWebService;
    UITextField *myTextField;
    NSString * phoneNO;
}

@end

@implementation ContactUsViewController
@synthesize contactmap,myString1,myString2,locarray, lat, lng, address, name;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self compareLocationByLatitudeAndLongitude];
    [self callWebServiceToGetData];
    isFirstPresentation=1;
    
    arrayFroButton=[[NSMutableArray alloc]initWithObjects:_useCurrentLocationButon,_useHomeZipLocationButton,_useOtherZipLocationCode, nil];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"locationSelectes"];
    
    shouldHide=0;
    arrayContainSeletedItem=[[NSMutableDictionary alloc]init];
    
    mSettingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mSettingButton setImage:[UIImage imageNamed:@"button_setting.png"] forState:UIControlStateNormal];
    
    [mSettingButton sizeToFit];
    [mSettingButton addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc]initWithCustomView:mSettingButton];
    self.navigationItem.rightBarButtonItem = saveBarButton;
    
    
    // Do any additional setup after loading the view from its nib.
    self.title = @"Store Location";
    [self Initialcustomization];
    UIButton *tbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tbackButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tbackButton sizeToFit];
    [tbackButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tBackBar = [[UIBarButtonItem alloc]initWithCustomView:tbackButton];
    self.navigationItem.leftBarButtonItem = tBackBar;
    
    NSUserDefaults *map = [NSUserDefaults standardUserDefaults];
    myString1 = [map stringForKey:@"lat"];
    myString2 = [map stringForKey:@"long"];
    NSString *title = [map stringForKey:@"sname"];
    NSString *addr = [map stringForKey:@"sadr"];
    imgurl = [map stringForKey:@"ilink"];
    mSeletedValue = [[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreference];
    
    [self initialSetUp];
    
}
-(void)initialSetUp
{
    [self customizationForButton];
    
    
    if (mSeletedValue==0)
    {
        [self selectButtonAction:_useCurrentLocationButon];
    }
    else if(mSeletedValue==1)
    {
        NSString *tZipCode = [[NSUserDefaults standardUserDefaults] objectForKey:kZipCodeLocation];
        
        if ([tZipCode length])
        {
            _textFieldHomeZip.text = tZipCode;
            [_textFieldHomeZip setHidden:NO];
            [_labelHomeZipCode setHidden:YES];
            [_useHomeZipLocationButton setImage:[UIImage imageNamed:@"select_checked.png"] forState:UIControlStateNormal];
            tLocationPreference=kHomeLocation;
            [_useHomeZipLocationButton setTitle:@"√" forState:UIControlStateNormal];
            isFirstPresentation=0;
            
        }
        
    }
    else if(mSeletedValue==2)
    {
        
        NSString *tZipCode = [[NSUserDefaults standardUserDefaults] objectForKey:kZipCodeLocation];
        
        if ([tZipCode length])
        {
            _textFieldOtherZip.text = tZipCode;
            [_textFieldOtherZip setHidden:NO];
            [_labelOtherZipCode setHidden:YES];
            [_useOtherZipLocationCode setImage:[UIImage imageNamed:@"select_checked.png"] forState:UIControlStateNormal];
            tLocationPreference=kZipPostalCode;
            [_useOtherZipLocationCode setTitle:@"√" forState:UIControlStateNormal];
            isFirstPresentation=0;
        }
    }
    else
    {
        [self selectButtonAction:_useCurrentLocationButon];
    }
    [[_textFieldOtherZip layer] setBorderWidth:0.5];
    [[_textFieldOtherZip layer]setBorderColor:[UIColor whiteColor].CGColor];
    [[_textFieldHomeZip layer] setBorderWidth:0.5];
    [[_textFieldHomeZip layer]setBorderColor:[UIColor whiteColor].CGColor];
    [countdownManager callWebServiceForLocationUpdate];
    
}
-(void)settingAction
{
    if(!shouldHide)
    {
        self.title=@"Setting";
        
        mSettingButton.frame = CGRectMake(0, 0, 60, 30);
        
        [mSettingButton setImage:[UIImage imageNamed:@"button_save.png"] forState:UIControlStateNormal];
        
        [self.view bringSubviewToFront:self.bgViewForSettingOption];
        self.bgViewForSettingOption.hidden=NO;
        CATransition *Sidetransition=[CATransition animation];
        Sidetransition.duration=0.5;
        Sidetransition.type=kCATransitionMoveIn;
        Sidetransition.subtype=kCATransitionFromBottom;
        [_bgViewForSettingOption.layer addAnimation:Sidetransition forKey:nil];
        
        
    }else
    {
        if([self.title isEqualToString:@"Setting"])
        {
            // perform Action For Save
        }
        
        self.title=@"Store Location";
        mSettingButton.frame = CGRectMake(0, 0, 36, 30);
        [mSettingButton setImage:[UIImage imageNamed:@"button_setting.png"] forState:UIControlStateNormal];
        
        CATransition *Sidetransition=[CATransition animation];
        Sidetransition.duration=0.5;
        Sidetransition.type=kCATransitionPush;
        Sidetransition.subtype=kCATransitionFromTop;
        [_bgViewForSettingOption.layer addAnimation:Sidetransition forKey:nil];
        //        [self.view sendSubviewToBack:self.bgViewForSettingOption];
        self.bgViewForSettingOption.hidden=YES;
        
    }
    
    
    shouldHide=!shouldHide;
    
}
-(void)Initialcustomization
{
    indexValPassToMethode=1;
    [_lblIndex setText:[NSString stringWithFormat:@"%f",indexValPassToMethode]];
    [_lblTotalCoupan setText:[NSString stringWithFormat:@"%lu",(unsigned long)locarray.count]];
    [self extractInformation:indexValPassToMethode];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    static NSString *identifier = @"pin";
    VBAnnotationView *view = (VBAnnotationView *)[self.contactmap dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (view == nil)
    {
        view = [[VBAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [infoButton addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        view.rightCalloutAccessoryView = infoButton;
    }
    
    
    return view;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    // get reference to the annotation to access its data
    annotationclass *myAnnotation = (annotationclass *)view.annotation;
    // deselect the button
    [self.contactmap deselectAnnotation:myAnnotation animated:YES];
}

-(void)infoButtonPressed:(UIButton *)btn
{
    // Create an MKMapItem to pass to the Maps app
    CLLocationCoordinate2D coordinate =
    CLLocationCoordinate2DMake(16.775, -3.009);
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                   addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName:@"My Place"];
    // Pass the map item to the Maps app
    [mapItem openInMapsWithLaunchOptions:nil];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)extractInformation:(float)index
{
    
    NSLog(@"%lu",(unsigned long)locarray.count);
    
    
    if(index==locarray.count)
    {
        //        index=1;
        //        indexValPassToMethode=1;
        [_showNextMapButton setEnabled:NO];
        [_btnBack setEnabled:YES];
        
    }
    else if(index==1)
    {
        [_showNextMapButton setEnabled:YES];
        [_btnBack setEnabled:NO];
        
    }
    else
    {
        [_showNextMapButton setEnabled:YES];
        [_btnBack setEnabled:YES];
        
    }
    
    [_lblIndex setText:[NSString stringWithFormat:@"%.0f",index]];
    
    
    
    NSMutableDictionary *dictForCoupanSelected=[locarray objectAtIndex:indexValPassToMethode-1];
    NSString *add=[dictForCoupanSelected valueForKey:@"address"];
    //        NSString *descripption=[dictForCoupanSelected valueForKey:@"description"];
    NSString *latitude=[dictForCoupanSelected valueForKey:@"latitude"];
    NSString *longitude=[dictForCoupanSelected valueForKey:@"longitude"];
    NSString *storeName=[dictForCoupanSelected valueForKey:@"storename"];
    NSString *storethumbnail=[dictForCoupanSelected valueForKey:@"storethumbnail"];
    NSString *phoneNumber=[dictForCoupanSelected valueForKey:@"phone"];
    
    [self showPinOnMap:latitude Long:longitude address:add storeName:storeName];
    [_imgViewCoupanPhoto setImageWithURL:[NSURL URLWithString:storethumbnail]];
    _lblStoreName.text=storeName;
    [_lblAddress setTitle:add forState:UIControlStateNormal];
    [_lblAddress addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonPhoneNumber setTitle:phoneNumber forState:UIControlStateNormal];
    
    [arrayContainSeletedItem setValue:_lblStoreName.text forKey:@"storeName"];
    [arrayContainSeletedItem setValue:latitude forKey:@"latitude"];
    [arrayContainSeletedItem setValue:longitude forKey:@"longitude"];
    [arrayContainSeletedItem setValue:add forKey:@"address"];
    [arrayContainSeletedItem setValue:storethumbnail forKey:@"image"];
    [arrayContainSeletedItem setValue:@"" forKey:@"storeID"];
    
}

- (IBAction)phoneButtonAction:(UIButton *)sender
{
    phoneNO=sender.currentTitle;
    if(phoneNO.length)
    {
        UIAlertView *alt= [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Call:%@",phoneNO] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"OK",nil] ;
        alt.tag=111;
        [alt show];
    }
}


-(void)showPinOnMap:(NSString *)lati Long:(NSString *)longi address:(NSString *)addressIn storeName:(NSString *)storeName
{
    
    [contactmap removeAnnotations:contactmap.annotations];
    CLLocationCoordinate2D location;
    
    location.latitude = [lati doubleValue];
    location.longitude = [longi doubleValue];
    
    
    //    if([[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreference] && [CLLocationManager authorizationStatus]!=kCLAuthorizationStatusDenied)
    
    [self comPareLocationByLatitudeAndLongitude:location.latitude longi:location.longitude];
    NSLog(@"lati is%@",lati);
    NSLog(@"long is%@",longi);
    
    annotationmap = [[annotationclass alloc] initWithPosition:location];
    [annotationmap setCoordinate:location];
    annotationmap.title = storeName;
    annotationmap.subtitle = addressIn;
    
    //annotationmap.subtitle = mystr2;
    
    MKCoordinateRegion region;
    region.center.latitude = [lati doubleValue];
    region.center.longitude = [longi doubleValue];
    region.span.latitudeDelta = 1;
    region.span.longitudeDelta = 1;
    self.contactmap.region = region;
    
    // add to map
    [self.contactmap addAnnotation:annotationmap];
}

- (IBAction)btnActionForNext:(id)sender {
    
    if (locarray.count!=1 )
    {
        indexValPassToMethode++;
        [_lblIndex setText:[NSString stringWithFormat: @"%f",indexValPassToMethode]];
        [self extractInformation:indexValPassToMethode];
    }
    
}
- (IBAction)btnActionForBack:(id)sender {
    
    if (locarray.count!=1 ) {
        indexValPassToMethode--;
        [_lblIndex setText:[NSString stringWithFormat: @"%f",indexValPassToMethode]];
        [self extractInformation:indexValPassToMethode];
    }
}

- (IBAction)checkInButtonClickAction:(id)sender {
    
    //    StoreListViewController *tStoreListViewController = [[StoreListViewController alloc] initWithNibName:@"StoreListViewController" bundle:nil];
    //    tStoreListViewController.titlestring = [arrayContainSeletedItem valueForKey:@"storeName"];
    //    tStoreListViewController.addressstring = [arrayContainSeletedItem valueForKey:@"address"];
    //    tStoreListViewController.tempstring = [arrayContainSeletedItem valueForKey:@"image"];
    //
    //    tStoreListViewController.storeID = @"121";
    //
    //    tStoreListViewController.latstring = [arrayContainSeletedItem  valueForKey:@"latitude"];
    //
    //    tStoreListViewController.longstring = [arrayContainSeletedItem  valueForKey:@"longitude"];
    //
    //    [self.navigationController pushViewController:tStoreListViewController animated:YES];
    //
}


-(void)comPareLocationByLatitudeAndLongitude:(float)latt longi:(float)longii
{
    double latitude=0,longitude=0;
    
    latitude=latt;
    longitude=longii;
    
    CLLocation *updatedLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    
    [[Location getInstance]calculateCurrentLocation];
    CLLocation *currentLocation = [[Location getInstance]getCurrentLocation];
    
    // CLLocationManager *currentLocation=[self getCurerntLocationLatLong];
    float cuLat= currentLocation.coordinate.latitude;
    float cuLong=currentLocation.coordinate.longitude;
    double userLatitude=0,userLongitude=0;
    
    if(![[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreference])
    {
        userLatitude=cuLat;
        userLongitude=cuLong;
        
        NSLog(@"%f",userLatitude);
        NSLog(@"%f",userLongitude);
    }
    else
    {
        userLatitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"keylat"] doubleValue];
        userLongitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"keylon"] doubleValue];
        
        NSLog(@"%f",userLatitude);
        NSLog(@"%f",userLongitude);
    }
    
    
    CLLocation *snapsLocation = [[CLLocation alloc] initWithLatitude:userLatitude longitude:userLongitude];
    
    CLLocationDistance distance = [updatedLocation distanceFromLocation:snapsLocation];
    
    //_lblDistance.text=[NSString stringWithFormat:@"%.1f miles away",(distance/1609.344)];
    
    _lblDistance.text=[NSString stringWithFormat:@"%1.2f miles away", 0.621371*(distance/1000)];
    
    
}

-(CLLocationManager *)getCurerntLocationLatLong
{
    [locationManager setDelegate:self];
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    float latitude = locationManager.location.coordinate.latitude;
    float longitude = locationManager.location.coordinate.longitude;
    NSLog(@"%f",latitude);
    NSLog(@"%f",longitude);
    return locationManager;
    
}

-(void)customizationForButton
{
    _useCurrentLocationButon.layer.cornerRadius = _useCurrentLocationButon.bounds.size.height/2;
    [_useCurrentLocationButon.layer setBorderWidth:0.5];
    [_useCurrentLocationButon.layer setBorderColor:[UIColor whiteColor].CGColor];
    _useCurrentLocationButon.layer.masksToBounds = YES;
    
    _useHomeZipLocationButton.layer.cornerRadius = _useCurrentLocationButon.bounds.size.height/2;
    [_useHomeZipLocationButton.layer setBorderWidth:0.5];
    [_useHomeZipLocationButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    _useHomeZipLocationButton.layer.masksToBounds = YES;
    
    _useOtherZipLocationCode.layer.cornerRadius = _useCurrentLocationButon.bounds.size.height/2;
    [_useOtherZipLocationCode.layer setBorderWidth:0.5];
    [_useOtherZipLocationCode.layer setBorderColor:[UIColor whiteColor].CGColor];
    _useOtherZipLocationCode.layer.masksToBounds = YES;
    
    
    [_useCurrentLocationButon setTitle:@" " forState:UIControlStateNormal];
    [_useHomeZipLocationButton setTitle:@" " forState:UIControlStateNormal];
    [_useOtherZipLocationCode setTitle:@" " forState:UIControlStateNormal];
}

-(IBAction)selectButtonAction:(UIButton *)sender
{
    tLocationPreference=kCurrentLocation;
    UIButton *button = (UIButton*)sender;
    if(dummyArray==nil) dummyArray=[[NSMutableArray alloc]init];
    [dummyArray removeAllObjects];
    [dummyArray addObjectsFromArray:arrayFroButton];
    
    switch (button.tag) {
            
            
        case 1:
            
            if ([sender.titleLabel.text isEqualToString:@" "]) {
                
                [sender setTitle:@"√" forState:UIControlStateNormal];
                [sender setImage:[UIImage imageNamed:@"select_checked.png"] forState:UIControlStateNormal];
                
                
                [[Location getInstance] calculateCurrentLocation];
                tLocationPreference = kCurrentLocation;
                if(!isFirstPresentation)
                {
                    
                    UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Current location has been updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [tAlert show];
                    
                }
                isFirstPresentation=0;
                
                
                
            }else if ([sender.titleLabel.text isEqualToString:@"√"]) {
                
                //                [sender setTitle:@" " forState:UIControlStateNormal];
                //                [sender setImage:nil forState:UIControlStateNormal];
            }
            
            break;
            
        case 2:
            if ([sender.titleLabel.text isEqualToString:@" "]) {
                
                [sender setTitle:@"√" forState:UIControlStateNormal];
                [sender setImage:[UIImage imageNamed:@"select_checked.png"] forState:UIControlStateNormal];
                [_textFieldHomeZip setHidden:NO];
                [_labelHomeZipCode setHidden:YES];
                
                [_textFieldOtherZip setHidden:YES];
                [_textFieldOtherZip setText:@""];
                [_labelOtherZipCode setHidden:NO];
                
                [self setHomeZip];
                isFirstPresentation=0;
                
                
                
            }else if ([sender.titleLabel.text isEqualToString:@"√"]) {
                
                //                [sender setTitle:@" " forState:UIControlStateNormal];
                //                [sender setImage:nil forState:UIControlStateNormal];
            }
            break;
            
        case 3:
            if ([sender.titleLabel.text isEqualToString:@" "]) {
                
                [sender setTitle:@"√" forState:UIControlStateNormal];
                [sender setImage:[UIImage imageNamed:@"select_checked.png"] forState:UIControlStateNormal];
                [_textFieldOtherZip setHidden:NO];
                [_labelOtherZipCode setHidden:YES];
                
                [_textFieldHomeZip setHidden:YES];
                [_textFieldHomeZip setText:@""];
                [_labelHomeZipCode setHidden:NO];
                
                tLocationPreference = kZipPostalCode;
                isFirstPresentation=0;
                
            }else if ([sender.titleLabel.text isEqualToString:@"√"]) {
                //                [_textFieldOtherZip setHidden:YES];
                //                [_labelOtherZipCode setHidden:NO];
                
                //                [sender setTitle:@" " forState:UIControlStateNormal];
                //                [sender setImage:nil forState:UIControlStateNormal];
            }
            break;
    }
    
    [dummyArray removeObject:sender];
    [self settingForUnSelectedButton:dummyArray];
}

-(void)settingForUnSelectedButton:(NSMutableArray *)btnArray
{
    for (UIButton *btn in btnArray) {
        [btn setImage:[UIImage imageNamed:@"select_none.png"] forState:UIControlStateNormal];
        [btn setTitle:@" " forState:UIControlStateNormal];
    }
}

-(void)setHomeZip
{
    if(!isFirstPresentation)
    {
        
        if([zipValInsideWebService isEqualToString:@"0"] || [zipValInsideWebService isEqualToString:nil])
        {
            
            
        }
        else
        {
            tLocationPreference = kHomeLocation;
            [_textFieldHomeZip setText:zipValInsideWebService];
            [[NSUserDefaults standardUserDefaults]setValue:zipValInsideWebService forKeyPath:@"zipValueinSetting"];
            [[NSUserDefaults standardUserDefaults] setObject:_textFieldHomeZip.text forKey:kZipCodeLocation];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [[[UIAlertView alloc] initWithTitle:nil message:@"Home location has been updated." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
        
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==111)
    {
        if(buttonIndex==1)
        {
            NSString *stringURL = [NSString stringWithFormat:@"tel:%@",phoneNO];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
        }
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setInteger:tLocationPreference forKey:kLocationPreference];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [countdownManager callWebServiceForLocationUpdate];
        
        if (alertView.tag==100)
        {
            [self settingAction];
        }
        else
        {
            [self performSelector:@selector(homeScreen) withObject:nil afterDelay:.1];
        }
    }
    
}

- (void) homeScreen {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate loginViewController:nil loginStatus:YES];
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    static NSCharacterSet *charSet = nil;
    if(!charSet) {
        charSet = [[NSCharacterSet characterSetWithCharactersInString:kNUMERIC] invertedSet];
    }
    NSRange location = [string rangeOfCharacterFromSet:charSet];
    return (location.location == NSNotFound);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (!([textField.text length] == 5 || [textField.text length] == 9))
    {
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:kZipFieldLengthMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlert show];
        //        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kZipCodeLocation];
        //        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    else if ([textField.text isEqualToString:@"00000"]){
        UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"ZipCode not valid." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlertView show];
        //        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kZipCodeLocation];
        //        [[NSUserDefaults standardUserDefaults]synchronize];
        
        textField.text = nil;
        
    }
    else if (![self isValidNumericZip:textField.text])
    {
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"ZipCode not valid." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlert show];
    }
    else {
        if([textField isEqual:_textFieldHomeZip])
        {
            [[NSUserDefaults standardUserDefaults]setValue:_textFieldHomeZip.text forKeyPath:@"zipValueinSetting"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setValue:@"" forKeyPath:@"zipValueinSetting"];
        }
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:kZipCodeLocation];
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Zip Code has been updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        if([textField isEqual:_textFieldOtherZip])
        {
            tAlert.tag=100;
        }
        [tAlert show];
        
        
    }
    
    [textField resignFirstResponder];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)isValidNumericZip:(NSString *)zipCode
{
    BOOL valid;
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:zipCode];
    valid = [alphaNums isSupersetOfSet:inStringSet];
    return valid;
}


#pragma mark- -WebService-
-(void)callWebServiceToGetData
{
    NSString  *userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
    NSMutableDictionary *profileDic = [NSMutableDictionary dictionary];
    if(userkey != nil)  [profileDic setObject:userkey forKey:@"userid"];
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/get_myprofile_data.php?",BASE_URL];
    
    jsonparse *objJsonparse =[[jsonparse alloc]init];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityView startAnimating];
    
    NSDictionary *profileData = [objJsonparse customejsonParsing:urlString bodydata:profileDic];
    NSArray *profilearray = [profileData valueForKey:@"data"];
    
    NSDictionary * dictionary = [profilearray firstObject];
    zipValInsideWebService=[dictionary objectForKey:@"Zip"]?[dictionary objectForKey:@"Zip"]:@"";
}


-(void)showAlertView
{
    if(!isFirstPresentation)
    {
        
        if([zipValInsideWebService isEqualToString:@"0"] || [zipValInsideWebService isEqualToString:nil])
        {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            myAlertView.tag=11;
            
            
            myAlertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
            myTextField = [myAlertView textFieldAtIndex:0];
            myTextField.placeholder=@"Postal/Zip";
            [myAlertView show];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Home location has been updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            [[NSUserDefaults standardUserDefaults]setValue:zipValInsideWebService forKeyPath:@"zipValueinSetting"];
        }
        
        
        
        
        
        
        
        
    }
}
-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if(alertView.tag ==11)
    {
        if([[alertView textFieldAtIndex:0].text length] > 5)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return YES;
}

#pragma mark - distance calculation

-(void)compareLocationByLatitudeAndLongitude
{
    [[Location getInstance]calculateCurrentLocation];
    CLLocation *userLocation = [[Location getInstance]getCurrentLocation];
    double userLatitude=0,userLongitude=0;
    if(![[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreference])
    {
        userLatitude=userLocation.coordinate.latitude;
        userLongitude=userLocation.coordinate.longitude;
        
        
        NSLog(@"%f",userLatitude);
        NSLog(@"%f",userLongitude);
    }
    else
    {
        userLatitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"keylat"] floatValue];
        userLongitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"keylon"] floatValue];
        
        NSLog(@"%f",userLatitude);
        NSLog(@"%f",userLongitude);
    }
    
    
    for (int i =0;i<[locarray count];i++)
    {
        
        [[[locarray objectAtIndex:i]valueForKey:@"latitude"] doubleValue];
        [[[locarray objectAtIndex:i]valueForKey:@"longitude"] doubleValue];
        
        
        CLLocation *updatedLocation = [[CLLocation alloc] initWithLatitude:[[[locarray objectAtIndex:i]valueForKey:@"latitude"] doubleValue] longitude:[[[locarray objectAtIndex:i]valueForKey:@"longitude"] doubleValue]];
        
        CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:userLatitude longitude:userLongitude];
        
        CLLocationDistance distance = [updatedLocation distanceFromLocation:userLocation];
        
        
        [[locarray objectAtIndex:i] setObject:[NSString stringWithFormat:@"%1.2f miles away", 0.621371*(distance/1000)] forKey:@"Distance"];
    }
    
    //    NSSortDescriptor *sort =[NSSortDescriptor sortDescriptorWithKey:@"Distance" ascending:YES];
    //    [tableStoreArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    NSArray *sortedArray = [locarray sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* obj1, NSDictionary* obj2)
                            {
                                return [(NSString *)[obj1 valueForKey:@"Distance"] compare:(NSString *)[obj2 valueForKey:@"Distance"] options:NSNumericSearch];
                            }];
    
    [locarray removeAllObjects];
    [locarray addObjectsFromArray:sortedArray];
}


@end
