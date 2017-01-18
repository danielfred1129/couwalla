//
//  CouponRedeemViewerViewController.m
//  Coupit
//
//  Created by Raphael Caixeta on 12/20/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "CouponRedeemViewerViewController.h"
#import "ZXingObjC.h"
#import "UIImageView+WebCache.h"
#import "UIColor+AppTheme.h"
#import "PXAlertView+Customization.h"
#import "HUDManager.h"
#import "countdownManager.h"
#import "CouponDetailViewController.h"
#import "MyCouponViewController.h"


#define timerDic [countdownManager shareManeger].timerDictionaryForSingalCoupon

double timeInterval = 1.0f;

@interface CouponRedeemViewerViewController ()

@property(nonatomic, strong, readonly) NSArray *landscapeConstraint;
@property(nonatomic, strong, readonly) NSArray *portraitConstraint;
@property (weak, nonatomic) IBOutlet UILabel *labelForSwitchScreen;

@end



@implementation CouponRedeemViewerViewController
{
    NSMutableDictionary *detailDictionary;
    __weak IBOutlet UIView *barBackgroundview;
    IBOutlet NSLayoutConstraint *heightConstraintForView;
    BOOL isConstraintAdded;
    
    IBOutlet UIView *labelView;
    
    IBOutlet UIView *termsView;
    
    NSArray *arrayOfPortraitConstraints;
    
    //Label's View height constraint
    IBOutlet NSLayoutConstraint *constraintHeightForLabelView;
    
    //Bottom View Constraints
    IBOutlet NSLayoutConstraint *constraintLeadingBottomView;
   
    IBOutlet NSLayoutConstraint *constraintBottomForBottomView;
    
    
    IBOutlet NSLayoutConstraint *logoImageConstraint;
    
     IBOutlet NSLayoutConstraint *promoLongHightConstraint;
    
    IBOutlet NSLayoutConstraint *customerNameHightConstraint;
    ProgressHudPresenter *mHudPresenter;

}

@synthesize couponImage, couponid, namelabel,tacbutton,storenbrandImageView,timeLeftLabel,storenbrandNameLabel,couponDetailLabel,couponSubDetailLabel,offerLabel,validLabel,barcodeNumberlabel;
@synthesize landscapeConstraint = _landscapeConstraint;
@synthesize portraitConstraint = _portraitConstraint;

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
    isConstraintAdded=NO;
    [self.navigationController.navigationBar setTranslucent:NO];
    //[HUDManager showHUDWithText:kHudMassage];
    mHudPresenter = [[ProgressHudPresenter alloc] init];
    [mHudPresenter presentHud];
    barBackgroundview.layer.cornerRadius=10.0f;
    //Back Button.
    UIButton *tbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tbackButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tbackButton sizeToFit];
    [tbackButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tBackBar = [[UIBarButtonItem alloc]initWithCustomView:tbackButton];
    self.navigationItem.leftBarButtonItem = tBackBar;
    
    UIButton *tSearchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tSearchButton.frame = CGRectMake(0, 0, 80, 30);
    [tSearchButton setBackgroundImage:[UIImage imageNamed:@"redeembutton.png"] forState:UIControlStateNormal];
    [tSearchButton addTarget:self action:@selector(redeemNow:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuBarCategory = [[UIBarButtonItem alloc]initWithCustomView:tSearchButton];
    self.navigationItem.rightBarButtonItem = menuBarCategory;
    
    [tacbutton.titleLabel setNumberOfLines:1];
    [tacbutton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [tacbutton.titleLabel setLineBreakMode:NSLineBreakByClipping];
    
    api = [[GREST alloc] init];
    [api setDelegate:self];
    
    NSString *removeid = couponid;
    
    NSDictionary *paramsDictionary=[NSDictionary dictionaryWithObjectsAndKeys:removeid,@"coupon_id", nil];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:paramsDictionary options:0 error:Nil];
    NSString *paramString=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    paramString=[paramString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    [api get:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kCouponDetails, paramString]] with_params:nil contentType:nil with_key:@"couponDetails"];
    [api start];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
    //   [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer invalidate];
}


-(NSArray *)landscapeConstraint
{
    if (_landscapeConstraint == nil)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];

        NSLayoutConstraint *constraint1=[NSLayoutConstraint constraintWithItem:labelView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:labelView.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        
        NSLayoutConstraint *constraint2=[NSLayoutConstraint constraintWithItem:termsView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:labelView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
        
        NSLayoutConstraint *constraint3=[NSLayoutConstraint constraintWithItem:termsView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:labelView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
        
        NSLayoutConstraint *constraint4=[NSLayoutConstraint constraintWithItem:storenbrandImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:
            NSLayoutAttributeLeft multiplier:1.0 constant:-100.0];
       
        
        NSLayoutConstraint *constraint5=[NSLayoutConstraint constraintWithItem:couponDetailLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:labelView attribute:
                                         NSLayoutAttributeHeight multiplier:0.0 constant:0.0];
        
        NSLayoutConstraint *constraint6=[NSLayoutConstraint constraintWithItem:couponSubDetailLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:labelView attribute:
                                         NSLayoutAttributeHeight multiplier:0.0 constant:0.0];
        
        [array addObject:constraint1];
        [array addObject:constraint2];
        [array addObject:constraint3];
        [array addObject:constraint4];
        [array addObject:constraint5];
        [array addObject:constraint6];

        _landscapeConstraint = array;
    }
    
    return _landscapeConstraint;
}

-(NSArray *)portraitConstraint
{
    if (_portraitConstraint == nil)
    {
        _portraitConstraint = [[NSArray alloc] initWithObjects:constraintBottomForBottomView,constraintHeightForLabelView,constraintLeadingBottomView, customerNameHightConstraint,promoLongHightConstraint,logoImageConstraint,nil];
    }

    return _portraitConstraint;
}

-(void)updateViewConstraints
{
    [self.view removeConstraint:heightConstraintForView];
    heightConstraintForView=[NSLayoutConstraint constraintWithItem:barBackgroundview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:(barBackgroundview.frame.size.height/self.view.frame.size.height-10) constant:0.0];
    [self.view addConstraint:heightConstraintForView];
    isConstraintAdded=YES;
    
    BOOL isPortrait = UIInterfaceOrientationIsPortrait(self.interfaceOrientation);
    [self.view removeConstraints:isPortrait ? self.landscapeConstraint : self.portraitConstraint];
    [self.view addConstraints:isPortrait ? self.portraitConstraint : self.landscapeConstraint];
    [super updateViewConstraints];

}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    
    
    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
    {
        self.labelForSwitchScreen.hidden=YES;
    }
    else
    {
        self.labelForSwitchScreen.hidden=NO;
        
    }

    [self.view setNeedsUpdateConstraints];
    
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


-(void)viewWillAppear:(BOOL)animated
{
    
  
    [super viewWillAppear:animated];
    
    int flag = 0 ;
    
    for (int i=0; i<[timerDic count]; i++)
    {
        if([timerDic valueForKey:couponid]!=nil)
        {
            flag=1;
        }
    }
    if(flag==0)
    {
        NSString *strCurrentDate;
        //        NSString *strNewDate;
        NSDate *date = [NSDate date];
        NSDateFormatter *df =[[NSDateFormatter alloc]init];
        [df setDateStyle:NSDateFormatterMediumStyle];
        [df setTimeStyle:NSDateFormatterMediumStyle];
        strCurrentDate = [df stringFromDate:date];
        NSLog(@"Current Date and Time: %@",strCurrentDate);
        int hoursToAdd = 1;
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setHour:hoursToAdd];
        NSDate *newDate= [calendar dateByAddingComponents:components toDate:date options:0];
        [df setDateStyle:NSDateFormatterMediumStyle];
        [df setTimeStyle:NSDateFormatterMediumStyle];
        
        //        strNewDate = [df stringFromDate:newDate];
        //        NSLog(@"New Date and Time: %@",strNewDate);
        
        
        [[Location getInstance]calculateCurrentLocation];
        CLLocation *userLocation = [[Location getInstance]getCurrentLocation];
        NSArray * ary=[NSArray arrayWithObjects:newDate,userLocation,nil];
        [timerDic setObject:ary forKey:couponid];
    }
    
    timeLeftLabel.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GREST Methods

- (void)request_finished:(NSString *)response for_key:(NSString *)request_key
{
    [HUDManager hideHUD];
    [mHudPresenter hideHud];
    NSDictionary *couponDetails = [response JSONValue];
    NSArray *dataArray=[couponDetails objectForKey:@"data"];
    
    detailDictionary=[dataArray firstObject];
    NSLog(@"%@",detailDictionary);
    if([[detailDictionary valueForKey:@"response"] isEqualToString:@"failure"])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:[detailDictionary valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    else
    {
        if([[detailDictionary objectForKey:@"code_type"] isEqualToString:@"couponcode"])
        {
            [actualCodeView setHidden:NO];
            [actualCodeView setText:[NSString stringWithFormat:@"Coupon Code:%@",detailDictionary[@"couponcode"]]];
            [actualCodeView setTextAlignment:NSTextAlignmentCenter];
            [self setupCouponData];
            timeLeftLabel.hidden = NO;

        }
        else
        {
            
            if(![detailDictionary isKindOfClass:[NSNull class]] && detailDictionary!=nil)
            {
                [self setupView];
                [self setupCouponData];
                timeLeftLabel.hidden = NO;
            }
            else
            {
                validLabel.text=@"Coupon Expired";
            }
        }
    }
    
    
}

- (void)request_failed:(NSError *)error for_key:(NSString *)request_key
{
    [HUDManager hideHUD];
    [mHudPresenter hideHud];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Custom Methods

- (NSString *)generateRandomString {
    
    int len = 3;
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
    
}


-(void)setupView
{
    NSString *barcodeType = detailDictionary[@"bar_type"];
    NSString *originalBar = detailDictionary[@"barcodedata"];
    
    if(![barcodeType isEqualToString:@""] && [originalBar isEqualToString:@""])
    {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Couwalla"
                              message:@"Please try again later; this coupon is currently invalid."
                              delegate:self cancelButtonTitle:@"Close"
                              otherButtonTitles:nil];
        [self.navigationController popViewControllerAnimated:YES];
        [alert show];
        
    }
    else
    {
        originalBar = [originalBar stringByReplacingOccurrencesOfString:@"%" withString:@""];
        NSString *barcode = detailDictionary[@"barcodedata"];
        //        barcode = [barcode stringByReplacingOccurrencesOfString:@"%" withString:[self generateRandomString]];
        
        NSError *error = nil;
        ZXBitMatrix *result = [[ZXBitMatrix alloc] init];
        ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
        
        @try
        {
            
            if([barcodeType isEqualToString:@"code39"])
            {
                result = [writer encode:barcode format:kBarcodeFormatCode39 width:320 height:163 error:&error];
            } else if([barcodeType isEqualToString:@"code128"]) {
                result = [writer encode:barcode format:kBarcodeFormatCode128 width:320 height:163 error:&error];
            } else if([barcodeType isEqualToString:@"ean8"]) {
                result = [writer encode:barcode format:kBarcodeFormatEan8 width:320 height:163 error:&error];
            } else if([barcodeType isEqualToString:@"ean13"]) {
                result = [writer encode:barcode format:kBarcodeFormatEan13 width:320 height:163 error:&error];
            } else if([barcodeType isEqualToString:@"codabar"]) {
                result = [writer encode:barcode format:kBarcodeFormatCodabar width:320 height:163 error:&error];
            } else if([barcodeType isEqualToString:@"rss14"]) {
                result = [writer encode:barcode format:kBarcodeFormatRSS14 width:320 height:163 error:&error];
            } else if([barcodeType isEqualToString:@"rssexp"]) {
                result = [writer encode:barcode format:kBarcodeFormatRSSExpanded width:320 height:163 error:&error];
            } else if([barcodeType isEqualToString:@"pdf417"]) {
                result = [writer encode:barcode format:kBarcodeFormatPDF417 width:320 height:163 error:&error];
            } else if([barcodeType isEqualToString:@"qr"]) {
                result = [writer encode:barcode format:kBarcodeFormatQRCode width:320 height:163 error:&error];
            } else if([barcodeType isEqualToString:@"code93"]) {
                result = [writer encode:barcode format:kBarcodeFormatCode93 width:320 height:163 error:&error];
            } else if([barcodeType isEqualToString:@"code128"]) {
                result = [writer encode:barcode format:kBarcodeFormatCode128 width:320 height:163 error:&error];
            } else if([barcodeType isEqualToString:@"upca_upce"])
            {
                result = [writer encode:barcode format:kBarcodeFormatUPCA width:320 height:163 error:&error];
            } else if([barcodeType isEqualToString:@"itf"]) {
                result = [writer encode:barcode format:kBarcodeFormatITF width:320 height:163 error:&error];
            } else if([barcodeType isEqualToString:@"datamatrix"]) {
                result = [writer encode:barcode format:kBarcodeFormatDataMatrix width:320 height:163 error:&error];
            } else if([barcodeType isEqualToString:@"aztec"]) {
                result = [writer encode:barcode format:kBarcodeFormatAztec width:320 height:163 error:&error];
            }
            
            if(result)
            {
                CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
                [couponView setImage:[UIImage imageWithCGImage:image]];
            }
        }
        @catch (NSException *exception)
        {
            //            UIAlertView *alert = [[UIAlertView alloc]
            //                                  initWithTitle:@"Couwalla"
            //                                  message:[NSString stringWithFormat:@"An error occurred while generating this code. %@", barcode]
            //                                  delegate:self cancelButtonTitle:@"Close"
            //                                  otherButtonTitles:nil];
            //            [alert show];
            
            [actualCodeView setHidden:NO];
            [actualCodeView setText:[NSString stringWithFormat:@"Bar Code:%@",detailDictionary[@"barcodedata"]]];
            [actualCodeView setTextAlignment:NSTextAlignmentCenter];
        }
        
    }
    
}

-(void)setupCouponData
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormatter dateFromString:[detailDictionary valueForKey:@"expiry_date"]];
    // //NSLog(@"%@",startDate);
    NSDate *endDate = [NSDate date];
    ////NSLog(@"%@",endDate);
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:endDate
                                                          toDate:startDate
                                                         options:0];
    NSString *str;
    
    if (components.day<0)
    {
        str = @"Coupon Expired";
    }
    else
    {
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        NSString *dateString=[dateFormatter stringFromDate:startDate];
        str = [NSString stringWithFormat:@"Expires on %@", dateString];
    }
    
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:tacbutton.titleLabel.text];
    NSRange rangeTermsAndConditions = [string.string rangeOfString:@"TERMS & CONDITIONS APPLY" options:NSRegularExpressionCaseInsensitive];
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:NSUnderlineStyleSingle],NSUnderlineStyleAttributeName,[UIColor appGreenColor],NSUnderlineColorAttributeName,[UIColor appGreenColor],NSForegroundColorAttributeName, nil];
    [string setAttributes:attribute range:rangeTermsAndConditions];
    tacbutton.titleLabel.attributedText = string;
    
    [storenbrandImageView setImageWithURL:[detailDictionary objectForKey:@"coupon_thumbnail"]];
    
    
//    storenbrandlablename
//    coupondetaillablename
//    offerlable
//    couponsubdetaillabel
//    validlabel
    

    
    storenbrandNameLabel.text   = [detailDictionary objectForKey:@"name"];
    couponDetailLabel.text      = [detailDictionary objectForKey:@"promo_text_long"];
    offerLabel.text             = [detailDictionary objectForKey:@"promo_text_short"];
    couponSubDetailLabel.text   = [detailDictionary objectForKey:@"customer_name"];
    validLabel.text             = str;
    barcodeNumberlabel.text     = [detailDictionary objectForKey:@"barcodedata"];
    
    [validLabel sizeToFit];
}

- (IBAction)actionOnTearmCondition:(id)sender
{

    
    [PXAlertView showAlertWithTitle:@"Terms & Conditions:"
                            message:[detailDictionary objectForKey:@"terms_conditions"]
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
    
    //    @"NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];    [dateFormatter setDateFormat:];     NSDate *startDate = [dateFormatter dateFromString:[detailDictionary valueForKey:]];   lloc] initWithCalendarIdentifier:NSGregorianCalendar];    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit                                                         fromDate:endDate                                                           toDate:startDate                                                          options:0];   NSString *str; if (components.day<0){ str =  }   else    {     [dateFormatter setDateFormat:@];     NSString *dateString=[dateFormatter stringFromDate:startDate];        str = [NSStringstringWithFormat:@teString];     }NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:tacbutton.titleLabel.text];     NSRange rangeTermsAndConditions = [string.string rangeOfString:s:NSRegularExpressionCaseInsensitive];    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:NSUnderlineStyleSingle],NSUnderlineStyleAttributeName,[UIColor appGreenColor],NSUnderlineColorAttributeName,[UIColor appGreenColor],NSForegroundColorAttributeName, nil];   [string setAttributes:attribute range:rangeTermsAndConditions];     tacbutton.titleLabel.attributedText = string;[storenbrandImageView setImageWithURL:[detailDictionary objectForKey:]];    storenbrandNameLabel.text   = [detailDictionary objectForKey:];    couponDetailLabel.text      = [detailDictionary objectForKey:@];     offerLabel.text             = [detailDictionary objectForKey:@];    couponSubDetailLabel.text   = [detailDictionary objectForKey];     validLabel.text             = str;     barcodeNumberlabel.text     = [detailDictionary objectForKey:@    [validLabel sizeToFit];"
}

-(void)backButton:(UIButton *)bt
{
    
    //    NSString * str1 = @"You have";
    //    NSString * str2 = [[timeLeftLabel.text componentsSeparatedByString:@" "] firstObject];
    //    NSString * str3 = @" mins to redeem this coupon. If you leave your current location the coupon will become invalid";
    //     NSString *msg=[NSString stringWithFormat:@"%@ %@ %@",str1,str2,str3];
    //
    
    
    
    [PXAlertView showAlertWithTitle:@""
                            message:@"The countdown to redeem this coupon will continue even if you leave this page.If you leave your current location, this coupon will become invalid."
                        cancelTitle:@"Cancel"
                         otherTitle:@"OK"
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             if (cancelled)
                             {
                                 NSLog(@"%i",buttonIndex);
                                 NSLog(@"Simple Alert View cancelled");
                             }
                             else
                             {
                                 [self.navigationController popViewControllerAnimated:YES];
                                 NSLog(@"Simple Alert View dismissed, but not cancelled");
                             }
                         }];
}

-(void)redeemNow:(UIButton *)btn
{
    [PXAlertView showAlertWithTitle:@""
                            message:@"By clicking OK, You understand that this coupon will be marked as redeemed and permanently removed from your phone."
                        cancelTitle:@"Cancel"
                         otherTitle:@"OK"
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             if (cancelled)
                             {
                                 
                             }
                             else
                             {
                                 [self callRedeemService];
                             }
                         }];
    
}


-(void)callRedeemService
{
    NSMutableDictionary *removeDic = [NSMutableDictionary dictionary];
    
    [removeDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"] forKey:@"userid"];
    [removeDic setObject:couponid forKey:@"couponid"];
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/redeem_coupon.php?",BASE_URL];
    
    jsonparse *objJsonparse =[[jsonparse alloc]init];
    
    NSMutableDictionary * reponseData = [[NSMutableDictionary alloc]init];
    
    reponseData = [objJsonparse customejsonParsing:urlString bodydata:removeDic];
    
    NSString *response = [reponseData valueForKey:@"message"];
    if([[reponseData valueForKey:@"response"] isEqualToString:@"failure"] && [response isEqualToString:@"Coupon already redeemed"])
    {
        NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/remove_from_mycoupon.php?",BASE_URL];
        
        jsonparse *objJsonparse =[[jsonparse alloc]init];
        
        reponseData = [[NSMutableDictionary alloc]init];
        
        reponseData = [objJsonparse customejsonParsing:urlString bodydata:removeDic];
    }
    
    [self performSelector:@selector(message:) withObject:response afterDelay:0.5];
    
}

-(void)message:(NSString *)msg
{
    [PXAlertView showAlertWithTitle:@"Message"
                            message:msg
                        cancelTitle:@"OK"
                         completion:^(BOOL cancelled, NSInteger buttonIndex)
     {
         if (cancelled)
         {
             [self.navigationController popToRootViewControllerAnimated:YES];
//             UIViewController * popVC;
//             for (UIViewController *vc in self.navigationController.viewControllers)
//             {
//                 
////                 
////                 if([vc isKindOfClass:[MyCouponViewController class]])
////                 {
////                     [self.navigationController popToViewController:vc animated:YES];
////                     break;
////                 }
////                 else if([vc isKindOfClass:[CouponDetailViewController class]])
////                 {
////                     [self.navigationController popToViewController:popVC animated:YES];
////                     break;
////                 }
////                 else
////                 {
////                     popVC = vc;
////                 }
//             }
         }
         else
         {
             [self.navigationController popViewControllerAnimated:YES];
         }
     }];
   
}

#pragma mark - timer
-(void)onTick:(NSTimer*)time
{
    NSDate *date = [NSDate date];
    NSDate * date1 = [[timerDic valueForKey:couponid] objectAtIndex:0];
    
    NSTimeInterval currentSec= [date timeIntervalSince1970];
    NSTimeInterval diffSec= [date1 timeIntervalSince1970];
    
    NSTimeInterval duration=(diffSec-currentSec);
    
    NSInteger minutes = floor(duration/60);
    NSInteger seconds = round(duration - minutes * 60);
    
    NSLog(@"..............Minutes = %d",minutes);
    NSLog(@"..............Seconds = %d\n\n",seconds);

    
    
    if([timerDic valueForKey:couponid] && seconds>0)
    {
        
        if(minutes>-1)
        {
            self.timeLeftLabel.text=[NSString stringWithFormat:@"%d:%02d min left", minutes, seconds];
        }
        else
        {
            self.timeLeftLabel.text=@"00:00 min left";
        }
    }
    else
    {
        if(minutes>-1)
        {
            self.timeLeftLabel.text=[NSString stringWithFormat:@"%d:%02d min left", minutes, seconds];
        }
        else
        {
            self.timeLeftLabel.text=@"00:00 min left";
        }
    }
    
    if([self.timeLeftLabel.text isEqualToString:@"00:00 min left"])
    {
        [self callRedeemService];
    }
    
}
@end
