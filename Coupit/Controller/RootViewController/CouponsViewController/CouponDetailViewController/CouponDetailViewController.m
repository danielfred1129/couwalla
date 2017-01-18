//
//  CouponDetailViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CouponDetailViewController.h"
#import "CouponDescriptionCell.h"
#import "tJSON.h"
#import "FileUtils.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "ContactUsViewController.h"
#import "jsonparse.h"
#import "appcommon.h"
#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "CouponRedeemViewerViewController.h"
#import "UIColor+AppTheme.h"
#import "PXAlertView+Customization.h"

@implementation CouponDetailViewController {
    
    NSString *mDetailText;
    ProgressHudPresenter *mHudPresenter;
    MBProgressHUD *mHud;
    CouponDownloadType mCouponDownloadType;
    Card *mSelectedCard;
    CLLocationManager *locationManager;
    NSString *stringUrl;
    IBOutlet UIButton *termsButton;
    
}

@synthesize mCoupon, mCouponCodeLabel,mLongPromoLabel, mShortPromoLabel, mValidTillLabel, mCouponImageView, mDownloadButton,mCouponNameLabel;
@synthesize mCouponID, mIsNotification,downloadAndShareStatus,mDownloadAndShareButton,mCodeType,mBarcodeImage,mCouponImage,mCouponDescription;

@synthesize comingFromScreen;

@synthesize mCouponPromoTextShort,mCouponPromoTextLong,mCouponName,mCouponExpireDate,latstr,longstr,titlestr,locatarray,adrstr,link,userlat,userlong;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.npree

#pragma mark - GREST Methods

- (void)queue_completed:(BOOL)status failed_request_key:(NSString *)request_key {
    
    //NSLog(@"queue finished");
    
    if(!status)
    {
        [self.termsNConditionsLabel setText:@"Error looking up terms and conditions"];
    }
    
}

- (void)request_finished:(NSString *)response for_key:(NSString *)request_key {
    
    if([request_key isEqualToString:@"terms"])
    {
        
        [self.termsNConditionsLabel setNumberOfLines:0];
        [self.termsNConditionsLabel setText:[NSString stringWithFormat:@"%@", response]];
        [self.termsNConditionsLabel sizeToFit];
        CGRect labelFrame=self.termsNConditionsLabel.frame;
        [self.containerScrollView setContentSize:CGSizeMake(320, CGRectGetMaxY(labelFrame)+60)];
        
        [termsButton setFrame:CGRectMake(0,CGRectGetMaxY(self.termsNConditionsLabel.frame)+10 , 320, 30)];;
        //        [self.termsNConditionsLabel setLineBreakMode:NSLineBreakByWordWrapping];
        //        [self.termsConditionsLabel setNumberOfLines:0];
        
//        [self.mLongPromoLabel setLineBreakMode:NSLineBreakByWordWrapping];
//        [self.mLongPromoLabel setNumberOfLines:0];
//        [self.mLongPromoLabel sizeToFit];
        
        //        CGSize labelSize = [self.termsNConditionsLabel.text sizeWithFont:self.termsConditionsLabel.font constrainedToSize:self.termsConditionsLabel.frame.size lineBreakMode:NSLineBreakByWordWrapping];
        //        CGFloat labelHeight = labelSize.height;
        //
        //        CGSize promoSize = [self.mLongPromoLabel.text sizeWithFont:self.mLongPromoLabel.font constrainedToSize:self.mLongPromoLabel.frame.size lineBreakMode:NSLineBreakByWordWrapping];
        //        CGFloat promoHeight = promoSize.height;
        //
        
        
    }
    if([request_key isEqualToString:@"latlng"])
    {
        NSDictionary *addressDetails = [response JSONValue];
        if(![addressDetails[@"lat"] isEqualToString:@""]) {
            
            gripdLat = addressDetails[@"lat"];
            gripdLng = addressDetails[@"lng"];
            gripdStoreAddress = addressDetails[@"address"];
            gripdStoreName = addressDetails[@"store_name"];
            
        }
        
    }
    
}

#pragma mark - Rest of class

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    
    //userlat = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    
    termsAPI = [[GREST alloc] init];
    [termsAPI setDelegate:self];
    
    gripdLat = @"";
    gripdLng = @"";
    gripdStoreName = @"";
    gripdStoreAddress = @"";
    
    //self.termsConditionsLabel.numberOfLines = 0;
    // self.navigationItem.title = mCouponName;
    self.navigationItem.hidesBackButton = YES;
    
    //mHudPresenter = [[ProgressHudPresenter alloc] init];
    
    //Back Button.
    UIButton *tbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tbackButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tbackButton sizeToFit];
    [tbackButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tBackBar = [[UIBarButtonItem alloc]initWithCustomView:tbackButton];
    self.navigationItem.leftBarButtonItem = tBackBar;
    
    UIButton *tshareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tshareButton setImage:[UIImage imageNamed:@"locationicon"] forState:UIControlStateNormal];
    [tshareButton sizeToFit];
    [tshareButton addTarget:self action:@selector(contact) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tShareBarButton = [[UIBarButtonItem alloc]initWithCustomView:tshareButton];
    self.navigationItem.rightBarButtonItem = tShareBarButton;
    
    // download & share Maverick
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    NSString* str=[[NSString alloc]init];
    str=[prefs stringForKey:@"coupondownloaded"];
    //NSLog(@"array=%@",locatarray);
    
    if([locatarray isKindOfClass:[NSDictionary class]])
    {
        if([[locatarray objectAtIndex:0] containsObject:@"latitude"] && [[locatarray objectAtIndex:0] containsObject:@"longitude"] && [[locatarray objectAtIndex:0] containsObject:@"storename"] && [[locatarray objectAtIndex:0] containsObject:@"address"] && [[locatarray objectAtIndex:0] containsObject:@"storethumbnail"]) {
            latstr = [[locatarray objectAtIndex:0] valueForKey:@"latitude"];
            longstr = [[locatarray objectAtIndex:0] valueForKey:@"longitude"];
            titlestr = [[locatarray objectAtIndex:0] valueForKey:@"storename"];
            adrstr = [[locatarray objectAtIndex:0] valueForKey:@"address"];
            link = [[locatarray objectAtIndex:0] valueForKey:@"storethumbnail"];
        }
    }
    
    //Added the Contact Us button.
    
    if (mCouponID)
    {
        [mHudPresenter presentHud];
        NSString *userid=[[NSString alloc] init];
        NSDictionary *idDict = [NSDictionary dictionaryWithObject:mCouponID forKey:@"id"];
        NSArray *tIDs = [NSArray arrayWithObjects:idDict, nil];
        NSDictionary *couponDict = [NSDictionary dictionaryWithObject:tIDs forKey:@"coupons"];
        NSString *jsonRequest = [couponDict JSONRepresentation];
        //NSLog(@"jsonRequest for Coupon: %@", jsonRequest);
        
        [[RequestHandler getInstance] postRequestwithHostURL:kURL_PostCouponQuery bodyPost:jsonRequest delegate:self requestType:kCouponDetailRequest];
    }
    else
    {
        [self loadCouponDetails];
    }
    
    
    NSUserDefaults *map = [NSUserDefaults standardUserDefaults];
    [map setObject:latstr forKey:@"lat"];
    [map setObject:longstr forKey:@"long"];
    [map setObject:titlestr forKey:@"sname"];
    [map setObject:adrstr forKey:@"sadr"];
    [map setObject:link forKey:@"ilink"];
    [map synchronize];
    
    NSLog(@"%@", mCoupon);
    
    // Disable "Save to my coupons" button when come from my coupons screen
    stringUrl = [NSString stringWithFormat:@"%@",mCouponImage];
    
    if([comingFromScreen isEqualToString:@"MyCouponsScreen"])
    {
        [mDownloadButton setEnabled:NO];
    }
    
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:termsButton.titleLabel.text];
    NSRange rangeTermsAndConditions = [string.string rangeOfString:@"TERMS & CONDITIONS APPLY" options:NSRegularExpressionCaseInsensitive];
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:NSUnderlineStyleSingle],NSUnderlineStyleAttributeName,[UIColor appGreenColor],NSUnderlineColorAttributeName,[UIColor appGreenColor],NSForegroundColorAttributeName, nil];
    [string setAttributes:attribute range:rangeTermsAndConditions];
    termsButton.titleLabel.attributedText = string;
}


-(void)viewWillAppear:(BOOL)animated
{
    
    NSLog(@"Hi. %@", stringUrl);
    [mCouponImageView setImageWithURL:[NSURL URLWithString:stringUrl]];
    
    [termsAPI get:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kTermsConditions, mCouponID]] with_params:nil contentType:nil with_key:@"terms"];
    [termsAPI get:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kLatLng, mCouponID]] with_params:nil contentType:nil with_key:@"latlng"];
    [termsAPI start];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormatter dateFromString:mCouponExpireDate];
    
    NSDate *endDate = [NSDate date];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit fromDate:endDate toDate:startDate options:0];
    
    if(components.day < 0 ) {
        mValidTillLabel.text= @"Coupon Expired";
    } else {
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        NSString *dateString=[dateFormatter stringFromDate:startDate];
        mValidTillLabel.text = [NSString stringWithFormat:@"Expires on %@", dateString];
    }
    
    mCouponNameLabel.text           =   mCouponName;
    mShortPromoLabel.text           =   mCouponPromoTextLong;
    mLongPromoLabel.text            =   mCouponDescription;
    mLongPromoLabel.numberOfLines   =   2;
    if (self.interfaceOrientation != UIInterfaceOrientationPortrait)
    {
        // http://stackoverflow.com/questions/181780/is-there-a-documented-way-to-set-the-iphone-orientation
        // http://openradar.appspot.com/radar?id=697
        // [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait]; // Using the following code to get around apple's static analysis...
        [[UIDevice currentDevice] performSelector:NSSelectorFromString(@"setOrientation:") withObject:(__bridge id)((void*)UIInterfaceOrientationPortrait)];
    }
    
}

- (void)loadCouponDetails {
}

- (void) iconDownloadManager:(IconDownloadManager *)pIconDownloadManager indexPath:(NSIndexPath *)pIndexPath {
    NSString *tFileName = [mCoupon.mImageWithoutBarcode lastPathComponent];
    NSString *fmtFileName = makeFileName([mCoupon.mID stringValue], tFileName);
    [self performSelectorOnMainThread:@selector(displayBanner:) withObject:imageFilePath(fmtFileName) waitUntilDone:NO];
}

- (void) displayBanner:(NSString *)pFilePath{
    [self.mCouponImageView setImage:[UIImage imageWithContentsOfFile:pFilePath]];
}

- (void) shareCouponURLWithID:(NSString *)pID
{
    
}

-(IBAction)downloadAndShare
{
    if(mCouponID==nil)
    {
        mCouponID=[mCoupon valueForKey:@"id"];
    }
    
    NSString *cuponid = mCouponID;
    CouponRedeemViewerViewController *redeemer = [[CouponRedeemViewerViewController alloc]initWithNibName:@"CouponRedeemViewerViewController" bundle:[NSBundle mainBundle]];
    [redeemer setCouponid:cuponid];
    [self.navigationController pushViewController:redeemer animated:YES];
    
    
    //    UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you wish to redeem now?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    //    tAlertView.tag = 2;
    //    [tAlertView show];
    
    // sharing code comment
    
    
    //    NSString* userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
    //    //NSLog(@"%@",userkey);
    //    NSMutableDictionary *loginDic = [NSMutableDictionary dictionary];
    //    [loginDic setObject:userkey forKey:@"userid"];
    //    [loginDic setObject:mCouponID forKey:@"couponid"];
    //
    //    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/addtomycoupons.php?",BASE_URL];
    //
    //    jsonparse *objJsonparse =[[jsonparse alloc]init];
    //
    //    NSMutableDictionary *reponseData = [[NSMutableDictionary alloc]init];
    //
    //    reponseData = [objJsonparse customejsonParsing:urlString bodydata:loginDic];
    //
    //    if (reponseData.count !=0)
    //    {
    //        NSString *response = [reponseData valueForKey:@"response"];
    //
    //
    //        if ([response isEqual:@"Success"])
    //        {
    //
    //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Coupon Added successlly" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //            [alert show];
    //        }
    //        else
    //        {
    //
    //            UIAlertView *sharealert = [[UIAlertView alloc]initWithTitle:@"Coupon was already downloaded" message:@"You want to share the coupon ?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    //            sharealert.tag=1;
    //            [sharealert show];
    //            //[self shareCoupon];
    //        }
    //
    //    }
    
}


- (void) downloadClicked
{
    
    mCouponDownloadType = kNormalDownload;
    
    [self downloadCouponByID];
    self.downloadAndShareStatus=true;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // saving an NSString
    [prefs setObject:[mCoupon.mID stringValue]forKey:@"coupondownloaded"];
    [prefs synchronize];
    
    
}


- (void)shareCoupon {
    NSString *tPostBody = [NSString stringWithFormat:@"{\"id\":\"%@\"}", [mCoupon.mID stringValue]];
    //NSLog(@"Sharing.........");
    UIActionSheet *tActionSheet = [[UIActionSheet alloc]initWithTitle:@"Share Deal"
                                                             delegate:self cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil otherButtonTitles:
                                   @"Email",
                                   @"Facebook",
                                   @"Twitter",
                                   nil];
    tActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [tActionSheet showInView:self.view];
    //[tActionSheet showFromBarButtonItem:sender animated:NO];
    [[RequestHandler getInstance] postRequestwithHostURL:kShareCouponURLRequestURL bodyPost:tPostBody delegate:self requestType:kShareCouponURLRequest];
}

- (IBAction) downloadCoupon:(id)sender
{
    mCouponDownloadType = kNormalDownload;
    [HUDManager showHUDWithText:kHudMassage];
    [self downloadCouponByID];
}

- (IBAction) addToTag:(id)sender
{
    
    
}


-(void)contact
{
    if([locatarray count]==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Messsage" message:@"This is a National Coupon. No specific location available. Please refer to Terms & Conditions for more location details." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        ContactUsViewController *cntct = [[ContactUsViewController alloc]initWithNibName:@"ContactUsViewController" bundle:[NSBundle mainBundle]];
        [cntct setLat:gripdLat];
        [cntct setLng:gripdLng];
        [cntct setName:gripdStoreName];
        [cntct setAddress:gripdStoreAddress];
        cntct.locarray=locatarray;
        [self.navigationController pushViewController:cntct animated:YES];
    }
}



- (void) loyalCardListViewController:(LoyalCardListViewController *)pController selectedCard:(Card *)pCard
{
    //NSLog(@"Selected_Card:%@", pCard.mCardName);
    [pController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    mSelectedCard = pCard;
    //NSLog(@"......:%d",[mCoupon.mID integerValue]);
    [self downloadCouponByID:[mCoupon.mID integerValue]];
    
}


- (void) downloadCouponByID
{
    
    NSString* userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
    //NSLog(@"%@",userkey);
    
    NSLog(@"%@",mCoupon);
    
    
    if(mCouponID==nil)
    {
        mCouponID=[mCoupon valueForKey:@"id"];
    }
    
    NSMutableDictionary *loginDic = [NSMutableDictionary dictionary];
    [loginDic setObject:userkey forKey:@"userid"];
    [loginDic setObject:mCouponID forKey:@"couponid"];
    
    
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/addtomycoupons.php?",BASE_URL];
    
    jsonparse *objJsonparse =[[jsonparse alloc]init];
    
    NSMutableDictionary *reponseData = [[NSMutableDictionary alloc]init];
    
    reponseData = [objJsonparse customejsonParsing:urlString bodydata:loginDic];
    
    [HUDManager hideHUD];
    
    
    if (reponseData.count !=0)
    {
        NSString *response = [reponseData valueForKey:@"response"];
        
        
        if ([response isEqual:@"Success"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Coupon Added Successfully." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
           // This coupon has already been added to My Coupons
            
            if([[reponseData valueForKey:@"message"] isEqualToString:@"Coupon already added"])
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[reponseData valueForKey:@"response"] message:@"This coupon has already been added to My Coupons." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];

            }
            else
            {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[reponseData valueForKey:@"response"] message:[reponseData valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            }
        }
        
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Coupon adding fails!" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    // //NSLog(@"I am in common class%@",reponseData);
    
    
}

- (void) requestHandler:(RequestHandler *)pRequestHandler withRequestType:(RequestType)pRequestType error:(APIError *)pError
{
    
    // run on main thread only
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self requestHandler:pRequestHandler withRequestType:pRequestType error:pError];
        });
        return;
    }
    if (pRequestType == kCouponDownload) {
        if (!pError) {
            [mHudPresenter hideHud];
            [self showSuccessAlert];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate makeSubscriberGetRequestByName];
            self.downloadAndShareStatus=true;
            
            [[LocalyticsSession shared] tagEvent:@"mycoupon" attributes:nil];
            
            [self.mDownloadAndShareButton setTitle:@"Share" forState:UIControlStateNormal ];
            [self.mDownloadAndShareButton setTitle:@"Share" forState:UIControlStateSelected ];
            self.downloadAndShareStatus=false;
            
        } else {
            [mHudPresenter hideHud];
            //NSLog(@"Request Failed:%d | Code:%d | Message:%@",pRequestType, pError.mErrorCode.intValue, pError.mMessage);
            
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Unable to download Coupon" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
        }
    }
    else if (pRequestType == kCouponDetailRequest){
        [mHudPresenter hideHud];
        if ([pError.mErrorCode integerValue] == 4112) {
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Unable to download Coupon" message:pError.mMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
            
        } else {
            mCoupon = [[DataManager getInstance] mObjCouponDetail];
            [self loadCouponDetails];
            
        }
        
    }
    else if (pRequestType == kShareCouponURLRequest){
        
    }
    else if (pRequestType == kCouponDownloadToTag){
        if (!pError) {
            [mHudPresenter hideHud];
            MyCoupons *tCoupon = [[DataManager getInstance] mObjCouponAddToTagDetail];
            
            [[Repository sharedRepository].context insertObject:tCoupon];
            [mSelectedCard addCouponsObject:tCoupon];
            
            NSError *error;
            [[Repository sharedRepository].context save:&error];
            
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Coupon is tagged to your card" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
        } else {
            [mHudPresenter hideHud];
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Unable to download Coupon" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
            
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1)
    {
        if ([alertView cancelButtonIndex] == buttonIndex)
        {
            [self shareCoupon];
        }
    }
    else if(alertView.tag==2)
    {
        {
            if(mCouponID==nil)
            {
                mCouponID=[mCoupon valueForKey:@"id"];
            }
            
            NSString *cuponid = mCouponID;
            NSMutableDictionary *objDic = [NSMutableDictionary dictionary];
            [objDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"] forKey:@"userid"];
            [objDic setObject:cuponid forKey:@"couponid"];
            NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/redeem_coupon.php?",BASE_URL];
            
            jsonparse *objJsonparse =[[jsonparse alloc]init];
            
            NSMutableDictionary* reponseData = [[NSMutableDictionary alloc]init];
            
            reponseData = [objJsonparse customejsonParsing:urlString bodydata:objDic];
            
            NSString *resstr = [reponseData valueForKey:@"message"];
            NSString *respstr =[reponseData valueForKey:@"response"];
            
            
            
            if([respstr isEqualToString:@"failure"])
            {
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Couwalla"
                                      message:reponseData[@"message"]
                                      delegate:self cancelButtonTitle:@"Close"
                                      otherButtonTitles:nil];
                [alert show];
                
            } else if ([respstr isEqualToString:@"Success"])
            {
                
                if(mCodeType == nil)
                {
                    mCodeType = [mCoupon valueForKey:@"code_type"];
                }
                if(mBarcodeImage == nil)
                {
                    mBarcodeImage = [mCoupon valueForKey:@"barcode_image"];
                }
                if (mCouponImage == nil)
                {
                    mCouponImage = [mCoupon valueForKey:@"coupon_image"];
                    
                }
                
                
                if([mCodeType isEqualToString:mBarcodeImage])
                {
                    NSString *stringUrl1 = [NSString stringWithFormat:@"%@",mBarcodeImage];
                    NSURL *url=[[NSURL alloc]initWithString:stringUrl1];
                    NSData *imageData= [[NSData alloc]initWithContentsOfURL:url];
                    UIImage *image = [[UIImage alloc]initWithData:imageData];
                    CouponRedeemViewerViewController *redeemer = [[CouponRedeemViewerViewController alloc] initWithNibName:@"CouponRedeemViewerViewController" bundle:[NSBundle mainBundle]];
                    
                    [redeemer setCouponImage:image];
                    [redeemer setCouponid:cuponid];
                    redeemer.namelabel=[[UILabel alloc]init];
                    
                    redeemer.namelabel.text=[NSString stringWithFormat:@"You Are Redeemed %@" ,mCouponName];
                    
                    [self.navigationController pushViewController:redeemer animated:YES];
                }
                else
                {
                    NSString *stringUrl1 = [NSString stringWithFormat:@"%@",mCouponImage];
                    
                    NSURL *url=[[NSURL alloc]initWithString:stringUrl1];
                    NSData *imageData= [[NSData alloc]initWithContentsOfURL:url];
                    UIImage *image = [[UIImage alloc]initWithData:imageData];
                    
                    CouponRedeemViewerViewController *redeemer = [[CouponRedeemViewerViewController alloc]initWithNibName:@"CouponRedeemViewerViewController" bundle:[NSBundle mainBundle]];
                    
                    [redeemer setCouponImage:image];
                    
                    [redeemer setCouponid:mCouponID];
                    redeemer.namelabel=[[UILabel alloc]init];
                    
                    redeemer.namelabel.text=[NSString stringWithFormat:@"You Are Redeemed %@" ,mCouponName];
                    
                    [self.navigationController pushViewController:redeemer animated:YES];
                }
            }
        }
    }
    else
    {
        if ([alertView cancelButtonIndex] == buttonIndex) {
            
            [self.navigationController popViewControllerAnimated:YES];
            //[mActivityIndicator stopAnimating];
            
        }
    }
    
}

- (void) makeSubscribtionRequest{
    
}

- (void) showSuccessAlert
{
    [mHudPresenter showSuccessHUD];
    [self.mDownloadButton setHidden:YES];
    [self performSelector:@selector(navigateHomeScreen) withObject:nil afterDelay:1];
}

- (void) navigateHomeScreen {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)backButton:(id)sender
{
    if (mIsNotification)
    {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES ];
    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    NSString *tCouponShareURL = [DataManager getInstance].mCouponShareURL;
    
    switch (buttonIndex) {
        case 0: // Email
        {
            //[self fbPostMessage];
            
            //NSLog(@"Email Selected");
            NSString *tImageSource = @"<img src='http://prodlb-905810012.us-east-1.elb.amazonaws.com/couwalla/resources/assets/logo.png' height = '100' width = '250' />";
            NSString *tShareCouponMessage = [NSString stringWithFormat:@"Couwalla Mobile Coupons: \n %@. To get Coupon download Couwalla @ www.couwalla.com \n %@",mCoupon.mShortPromoText,tImageSource];
            if ([MFMailComposeViewController canSendMail])
            {
                MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
                controller.mailComposeDelegate = self;
                [controller setSubject:@"Couwalla"];
                [controller setMessageBody:tShareCouponMessage isHTML:YES];
                
                [self presentViewController:controller animated:YES completion:^{
                    
                }];
            }
            else
            {
                UIAlertView* errorMessage = [[UIAlertView alloc] initWithTitle:@"No local email configure. Kindly setup your email in mail app." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [errorMessage show];
                
            }
            
        }
            break;
        case 1: // Facebook
        {
            NSString *tShareCouponMessage = [NSString stringWithFormat:@"I Just got a great coupon at Couwalla Mobile Coupons-%@.  Download Couwalla Mobile App @",mCoupon.mShortPromoText];
            if([SLComposeViewController instanceMethodForSelector:@selector(isAvailableForServiceType)] != nil)
            {
                if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
                {
                    
                    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                    
                    SLComposeViewControllerCompletionHandler tBlock = ^(SLComposeViewControllerResult result){
                        if (result == SLComposeViewControllerResultCancelled) {
                            
                            //NSLog(@"Cancelled");
                            
                        } else
                            
                        {
                            UIAlertView* errorMessage = [[UIAlertView alloc] initWithTitle:@"Coupon shared successfully" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            ;
                            [errorMessage show];
                        }
                        
                        [controller dismissViewControllerAnimated:YES completion:Nil];
                    };
                    controller.completionHandler = tBlock;
                    
                    [controller setInitialText:tShareCouponMessage];
                    [controller addImage:[UIImage imageNamed:@"ShareLogo@2x.png"]];
                    [controller addURL:[NSURL URLWithString:@"www.couwalla.com"]];
                    [self presentViewController:controller animated:YES completion:Nil];
                    
                }
                else
                {
                    UIAlertView* errorMessage = [[UIAlertView alloc] initWithTitle:@"There are no Facebook accounts configured.You can add or create a Facebook account in Settings." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    ;
                    [errorMessage show];
                }
                
            }
        }
            break;
        case 2: // Twitter
        {
            NSString *tShareCouponMessage = [NSString stringWithFormat:@"I Just got a coupon at Couwalla Mobile Coupons-%@.  Download Couwalla Mobile App @ www.couwalla.com",mCoupon.mShortPromoText];
            
            if([SLComposeViewController instanceMethodForSelector:@selector(isAvailableForServiceType)] != nil)
            {
                if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
                {
                    
                    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                    
                    SLComposeViewControllerCompletionHandler tBlock = ^(SLComposeViewControllerResult result){
                        if (result == SLComposeViewControllerResultCancelled) {
                            
                            //NSLog(@"Cancelled");
                            
                        } else
                            
                        {
                            UIAlertView* errorMessage = [[UIAlertView alloc] initWithTitle:@"Coupon shared successfully" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            ;
                            [errorMessage show];
                        }
                        
                        [controller dismissViewControllerAnimated:YES completion:Nil];
                    };
                    controller.completionHandler = tBlock;
                    [controller setInitialText:tShareCouponMessage];
                    [controller addImage:[UIImage imageNamed:@"ShareLogo@2x.png"]];
                    //[controller addURL:[NSURL URLWithString:@"www.couwalla.com"]];
                    
                    [self presentViewController:controller animated:YES completion:Nil];
                    
                } else {
                    UIAlertView* errorMessage = [[UIAlertView alloc] initWithTitle:@"There are no Twitter accounts configured.You can add or create a Twitter account in Settings." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    ;
                    [errorMessage show];
                    
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)finishedSharing: (BOOL)shared {
    if (shared) {
        //NSLog(@"User successfully shared!");
    } else {
        //NSLog(@"User didn't share.");
    }
}

- (void) fbPostMessage
{
    
    mHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    mHud.labelText = @"Score Posting...";
    
    [FBRequestConnection startForPostStatusUpdate:@"test message"
                                completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                    if (error) {
                                        //NSLog(@"error:%@",error);
                                    }
                                    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                    mHud = nil;
                                    // [self showAlert:currentTimeScore result:result error:error];
                                }];
}

#pragma mark - mailComposeController delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        UIAlertView* errorMessage = [[UIAlertView alloc] initWithTitle:@"Mail sent successfully" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        ;
        [errorMessage show];
    }
    else if (result == MFMailComposeResultFailed) {
        UIAlertView* errorMessage = [[UIAlertView alloc] initWithTitle:@"Mail sending fail" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        ;
        [errorMessage show];
        
    }
    
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)actionOnTermsnCondition:(id)sender {
    
    [PXAlertView showAlertWithTitle:@"Terms & Conditions:"
                            message:self.termsNConditionsLabel.text
                        cancelTitle:@"Accept"
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             if (cancelled)
                             {
                                 NSLog(@"%i",buttonIndex);
                                 NSLog(@"Simple Alert View cancelled");
                             }
                             else
                             {
                                 NSLog(@"Simple Alert View dismissed, but not cancelled");
                             }
                         }];
}

@end
