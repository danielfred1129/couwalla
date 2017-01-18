//
//  RedeemAllViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RedeemAllViewController.h"
#import "MyCouponsCell.h"
#import "Coupon.h"
#import "FileUtils.h"
#import "WebViewController.h"
#import "AppDelegate.h"
#import "Card.h"
#import "MyCoupons.h"
#import "RedeemAllCell.h"
#import "PXAlertView+Customization.h"
#import "countdownManager.h"
#import "appcommon.h"

#define kAlertViewOne 1
#define kAlertViewTwo 2

#define timerDic [countdownManager shareManeger].timerDictionaryForSingalCoupon


@implementation RedeemAllViewController
{
    UIView *mGestureView;
    NSInteger mCategoryID;
    NSInteger mDeleteButtonIndex;
    NSInteger mSelectedRedeemIndex;
    ProgressHudPresenter *mHudPresenter;
    NSInteger mCouponIndex;
    
    UIView *mTempButtonsView;
    NSArray* mIndexArray;
    NSMutableArray *mRedeemCouponArray;
    NSMutableArray *mRedeemCouponID;
    NSTimer *timer;
    
    
}

double timeInter= 1.0f;

@synthesize  mTableView, mTimerUIView ,mTinerValue,timeLeftLabel;
@synthesize mDelegate, mRedeemAllSelection;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mCategoryID = 0;
    
    [self getCouponsData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasComeInForeground:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    NSDate *tRedeemTime = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:tRedeemTime forKey:@"RedeemCouponTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    mTempButtonsView = [[UIView alloc] init];
    [mTimerUIView setHidden:NO];
    
    
    //Back Button.
    UIButton *tbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tbackButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tbackButton sizeToFit];
    [tbackButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tBackBar = [[UIBarButtonItem alloc]initWithCustomView:tbackButton];
    self.navigationItem.leftBarButtonItem = tBackBar;
    
    UIButton *tSearchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tSearchButton.frame = CGRectMake(0, 0, 65, 30);
    [tSearchButton setBackgroundImage:[UIImage imageNamed:@"redeembutton.png"] forState:UIControlStateNormal];
    [tSearchButton addTarget:self action:@selector(redeemAllAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuBarCategory = [[UIBarButtonItem alloc]initWithCustomView:tSearchButton];
    self.navigationItem.rightBarButtonItem = menuBarCategory;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:timeInter target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
    
    // [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

-(void)redeemAllAction:(id)sender
{
    [PXAlertView showAlertWithTitle:@""
                            message:@"By clicking OK, You understand that this coupons will be marked as redeemed and permanently removed from your phone."
                        cancelTitle:@"Cancel"
                         otherTitle:@"OK"
                         completion:^(BOOL cancelled, NSInteger buttonIndex)
     {
         if (cancelled)
         {
             
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [HUDManager showHUDWithText:kHudMassage];
             });
             [self callRedeemService];
         }
     }];
}

-(void)callRedeemService
{
    for (int i = 0; i < [mRedeemCouponID count]; i++)
    {
        NSMutableDictionary *removeDic = [NSMutableDictionary dictionary];
        
        [removeDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"] forKey:@"userid"];
        [removeDic setObject:[mRedeemCouponID objectAtIndex:i] forKey:@"couponid"];
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
        NSLog(@"%@",response);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [HUDManager hideHUD];
        [self.navigationController popViewControllerAnimated:YES];
    });
    
    
    // [self performSelector:@selector(message:) withObject:response afterDelay:0.5];
    
}

//-(void)message:(NSString *)msg
//{
//    [PXAlertView showAlertWithTitle:@"Message"
//                            message:msg
//                        cancelTitle:@"OK"
//                         completion:^(BOOL cancelled, NSInteger buttonIndex)
//     {
//         if (cancelled)
//         {
//             [self.navigationController popViewControllerAnimated:YES];
//         }
//         else
//         {
//             [self.navigationController popViewControllerAnimated:YES];
//         }
//     }];
//}




-(void)backButton:(id)sender
{
//    NSString * str1 = @"You have";
//    NSString * str2 = [[timeLeftLabel.text componentsSeparatedByString:@" "] firstObject];
//    NSString * str3 = @" mins to redeem this coupons. If you leave your current location the coupons will become invalid";
//    NSString *msg=[NSString stringWithFormat:@"%@ %@ %@",str1,str2,str3];
    
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


- (void)appHasComeInForeground:(id)sender
{
    //NSLog(@"Application is in ForeGround");
    
    NSDate *tRedeemTime = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"RedeemCouponTime"];
    NSDate *tCurrentTime = [NSDate date];
    NSTimeInterval timeDifference = [tCurrentTime timeIntervalSinceDate:tRedeemTime];
    
    NSInteger ti = (NSInteger)timeDifference;
    //NSInteger timeInMinutes = (ti / 60) % 60;
    
    if (ti > 3600)
    {
        UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Your Coupon Redeemption time is finished" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        tAlertView.tag = 2;
        [tAlertView show];
    }
}

- (void) redeemAllCoupons:(NSMutableArray *)pCoupons
{
    mRedeemCouponArray = [NSMutableArray new];
    mRedeemCouponID    = [NSMutableArray new];
    if (mRedeemCouponArray)
    {
        [mRedeemCouponArray removeAllObjects];
    }
    
    if (mRedeemAllSelection == kRedeemAllFromMyCoupon) {
        [mRedeemCouponArray addObjectsFromArray:pCoupons];
        
    } else if (mRedeemAllSelection == KRedeemAllFromPlanner)
    {
        [mRedeemCouponArray addObjectsFromArray:pCoupons];
    }
    for (int i = 0; i < [mRedeemCouponArray count]; i++)
    {
        MyCoupons *tCoupon = [mRedeemCouponArray objectAtIndex:i];
        [mRedeemCouponID addObject:[tCoupon valueForKey:@"id"]];
    }
    
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

    [[Location getInstance]calculateCurrentLocation];
    CLLocation *userLocation = [[Location getInstance]getCurrentLocation];
    for (int i=0;i<[mRedeemCouponID count]; i++)
    {
        
        NSArray * ary=[NSArray arrayWithObjects:newDate,userLocation,nil];
        [timerDic setObject:ary forKey:[mRedeemCouponID objectAtIndex:i]];
    }
    
}


- (void)redeemCouponRequest
{
    [mHudPresenter presentHud];
    NSString *tRedeemCouponID = [NSString new];
    for (int i = 0; i < [mRedeemCouponID count]; i++)
    {
        NSString *tCouponID = [mRedeemCouponID objectAtIndex:i];
        if (i == [mRedeemCouponID count] -1)
        {
            tRedeemCouponID = [tRedeemCouponID stringByAppendingFormat:@"%d", tCouponID.integerValue];
        }
        else{
            tRedeemCouponID = [tRedeemCouponID stringByAppendingFormat:@"%d,", tCouponID.integerValue];
        }
    }
    NSString *tPostBody = [NSString stringWithFormat:@"[%@]", tRedeemCouponID];
    CLLocation *tCurrentLocation = [[Location getInstance] getCurrentLocation];
    NSString *tRedeemAllCouponQuery = [kURL_RedeemAllCoupon stringByAppendingFormat:@"?lat=%f&lng=%f",tCurrentLocation.coordinate.latitude,tCurrentLocation.coordinate.longitude];
    //NSLog(@"tSolrStoresRequestURL--------:%@",tRedeemAllCouponQuery);
    
    [[RequestHandler getInstance] postRequestwithHostURL:tRedeemAllCouponQuery bodyPost:tPostBody delegate:self requestType:kRedeemAllCouponRequest];
}





- (IBAction)couponRedeem:(id)sender
{
    UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please make sure you are done with Coupon. Coupon will be deleted immediately." delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"No", nil];
    tAlertView.tag = 1;
    [tAlertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView cancelButtonIndex] == buttonIndex) {
        if (alertView.tag == 1)
        {
            for (int i = 0; i < [mRedeemCouponArray count]; i++)
            {
                MyCoupons *tCoupon = [mRedeemCouponArray objectAtIndex:i];
                [[Repository sharedRepository] deleteMyCouponsByID:[tCoupon valueForKey:@"id"]];
                NSError *error = nil;
                [[Repository sharedRepository].context save:&error];
            }
            [self redeemCouponRequest];
        }
        else if (alertView.tag == 2)
        {
            for (int i = 0; i < [mRedeemCouponArray count]; i++) {
                MyCoupons *tCoupon = [mRedeemCouponArray objectAtIndex:i];
                
                NSManagedObjectContext *tContext = [Repository sharedRepository].context;
                NSFetchRequest *tRequest = [[NSFetchRequest alloc] init];
                [tRequest setEntity:[NSEntityDescription entityForName:@"MyCoupons" inManagedObjectContext:tContext]];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mID == %@", [tCoupon valueForKey:@"id"]];
                [tRequest setPredicate:predicate];
                
                NSError *error = nil;
                NSArray *tRowDataArray = [tContext executeFetchRequest:tRequest error:&error];
                NSManagedObject *tDeleteTheRow = [tRowDataArray objectAtIndex:0];
                [tContext deleteObject:tDeleteTheRow];
                [[Repository sharedRepository].context save:&error];
                
            }
            [mTimerUIView setHidden:YES];
            [mRedeemCouponArray removeAllObjects];
            [mTableView reloadData];
            [mDelegate redeemListViewController:self isBack:YES];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *msg = [[[mRedeemCouponArray objectAtIndex:indexPath.row] valueForKey:@"details"] valueForKey:@"name"];
    CGFloat height = [msg sizeWithFont:[UIFont boldSystemFontOfSize:20] constrainedToSize:CGSizeMake(144, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
    
    return (height + 117) > 143 ?  (height + 117) : 143;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [mRedeemCouponArray count];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return mTimerUIView;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"RedeemAllCell";
    RedeemAllCell *cell = (RedeemAllCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.hideLabel.hidden=YES;
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RedeemAll" owner:self options:nil];
        cell = (RedeemAllCell *)[topLevelObjects objectAtIndex:0];
    }
    [cell.barImageView setImage:nil];
    if([[[[mRedeemCouponArray objectAtIndex:indexPath.row] valueForKey:@"details"] valueForKey:@"BarcodeImageAvailable"]isEqualToString:@"YES"])
    {
        [cell.barImageView setImage:[[[mRedeemCouponArray objectAtIndex:indexPath.row] valueForKey:@"details"] valueForKey:@"BarcodeImage"]];
    }
    else if([[[[mRedeemCouponArray objectAtIndex:indexPath.row] valueForKey:@"details"] valueForKey:@"BarcodeImageAvailable"]isEqualToString:@"NO"])
    {
        cell.hideLabel.hidden=NO;
        
        if([[[[mRedeemCouponArray objectAtIndex:indexPath.row] valueForKey:@"details"] objectForKey:@"code_type"] isEqualToString:@"couponcode"])
        {
            [cell.hideLabel setText:[NSString stringWithFormat:@"Coupon Code:%@",[[[mRedeemCouponArray objectAtIndex:indexPath.row] valueForKey:@"details"] valueForKey:@"couponcode"]]];
        }
        else
        {
            [cell.hideLabel setText:[NSString stringWithFormat:@"Bar Code:%@",[[[mRedeemCouponArray objectAtIndex:indexPath.row] valueForKey:@"details"] valueForKey:@"barcodedata"]]];
        }
        
        
       [cell.hideLabel setTextAlignment:NSTextAlignmentCenter];

    }
    
    
     cell.barNumberLabel.text=[[[mRedeemCouponArray objectAtIndex:indexPath.row] valueForKey:@"details"] valueForKey:@"barcodedata"];
    
    NSString *msg = [[[mRedeemCouponArray objectAtIndex:indexPath.row] valueForKey:@"details"] valueForKey:@"name"];
    
    CGFloat height = [msg sizeWithFont:[UIFont boldSystemFontOfSize:20] constrainedToSize:CGSizeMake(144, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;

    if(height>45)
    {
        cell.barCodeTitleLabel.frame=CGRectMake(10, 0, cell.barCodeTitleLabel.frame.size.width,height);
    }
    else
    {
        cell.barCodeTitleLabel.frame=CGRectMake(10, 2, 144,21);
    }
    
    cell.barCodeTitleLabel.text=[[[mRedeemCouponArray objectAtIndex:indexPath.row] valueForKey:@"details"] valueForKey:@"name"];
    cell.tncButton.tag=indexPath.row;
    [cell.tncButton addTarget:self action:@selector(tncButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}


- (void) iconDownloadManager:(IconDownloadManager *)pIconDownloadManager indexPath:(NSIndexPath *)pIndexPath
{
    [self.mTableView beginUpdates];
    
    if ([mRedeemCouponArray count] > pIndexPath.row)
    {
        [self.mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:pIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
	[self.mTableView endUpdates];
}


- (void) requestHandler:(RequestHandler *)pRequestHandler withRequestType:(RequestType)pRequestType error:(APIError *)pError
{
    
    // run on main thread only
    if (![NSThread isMainThread])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self requestHandler:pRequestHandler withRequestType:pRequestType error:pError];
        });
        return;
    }
    
    [mHudPresenter hideHud];
    if (!pError)
    {
        if (pRequestType == kRedeemAllCouponRequest)
        {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate makeSubscriberGetRequestByName];
            
            [mDelegate redeemListViewController:self isBack:YES];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}

#pragma mark - TNC ButtonClicked

-(void)tncButtonClicked:(UIButton *)sender
{
    
    [PXAlertView showAlertWithTitle:@"Terms & Conditions:"
                            message:[[[mRedeemCouponArray objectAtIndex:sender.tag] valueForKey:@"details"] valueForKey:@"terms_conditions"]
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

#pragma mark - call Webservice

-(void)getCouponsData
{
    [HUDManager showHUDWithText:kHudMassage];
    
    api = [[GREST alloc] init];
    [api setDelegate:self];
    
    NSDictionary *paramsDictionary=[NSDictionary dictionaryWithObjectsAndKeys:mRedeemCouponID,@"coupon_id", nil];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:paramsDictionary options:0 error:Nil];
    NSString *paramString=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    paramString=[paramString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSLog(@"%@",[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kGetMulipleCouponsDetail, paramString]]);
    
    [api get:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kGetMulipleCouponsDetail, paramString]] with_params:nil contentType:nil with_key:@"getMulipleCouponsDetail"];
    [api start];
}

#pragma mark - GREST Methods

- (void)request_finished:(NSString *)response for_key:(NSString *)request_key
{
    NSMutableDictionary *couponDetails = [[response JSONValue] mutableCopy];
    mRedeemCouponArray =[couponDetails valueForKey:@"data"];
    [self setupView];
    
   
}

- (void)request_failed:(NSError *)error for_key:(NSString *)request_key
{
    [HUDManager hideHUD];
}

-(void)setupView
{
    

    for (int i=0; i<[mRedeemCouponArray count]; i++)
    {
        
        if([[[[mRedeemCouponArray objectAtIndex:i] valueForKey:@"details"] objectForKey:@"code_type"] isEqualToString:@"couponcode"])
         {
             [[[mRedeemCouponArray objectAtIndex:i] valueForKey:@"details"] setObject:@"NO" forKey:@"BarcodeImageAvailable"];
             [[[mRedeemCouponArray objectAtIndex:i] valueForKey:@"details"] setObject:@"" forKey:@"BarcodeImage"];
         }
        else
        {
        NSString *barcodeType = [[[mRedeemCouponArray objectAtIndex:i] valueForKey:@"details"] valueForKey:@"bar_type"];
        NSString *originalBar = [[[mRedeemCouponArray objectAtIndex:i] valueForKey:@"details"] valueForKey:@"barcodedata"];
        
        if(![barcodeType isEqualToString:@""] && [originalBar isEqualToString:@""])
        {
            [[[mRedeemCouponArray objectAtIndex:i] valueForKey:@"details"] setObject:@"NO" forKey:@"BarcodeImageAvailable"];
            [[[mRedeemCouponArray objectAtIndex:i] valueForKey:@"details"] setObject:@"" forKey:@"BarcodeImage"];
        }
        else
        {
            originalBar = [originalBar stringByReplacingOccurrencesOfString:@"%" withString:@""];
            NSString *barcode = [[[mRedeemCouponArray objectAtIndex:i] valueForKey:@"details"] valueForKey:@"barcodedata"];
            
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
                } else if([barcodeType isEqualToString:@"upca_upce"]) {
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
                    
                    [[[mRedeemCouponArray objectAtIndex:i] valueForKey:@"details"] setObject:@"YES" forKey:@"BarcodeImageAvailable"];
                    
                    CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
                    [[[mRedeemCouponArray objectAtIndex:i] valueForKey:@"details"] setObject:[UIImage imageWithCGImage:image] forKey:@"BarcodeImage"];
                }
                else
                {
                    [[[mRedeemCouponArray objectAtIndex:i] valueForKey:@"details"] setObject:@"NO" forKey:@"BarcodeImageAvailable"];
                    [[[mRedeemCouponArray objectAtIndex:i] valueForKey:@"details"] setObject:@"" forKey:@"BarcodeImage"];
                }
                
                
            }
            @catch (NSException *exception)
            {
                
                [[[mRedeemCouponArray objectAtIndex:i] valueForKey:@"details"] setObject:@"NO" forKey:@"BarcodeImageAvailable"];
                [[[mRedeemCouponArray objectAtIndex:i] valueForKey:@"details"] setObject:@"" forKey:@"BarcodeImage"];

                
//                [actualCodeView setHidden:NO];
//                [actualCodeView setText:[NSString stringWithFormat:@"Bar Code:%@",detailDictionary[@"barcodedata"]]];
//                [actualCodeView setTextAlignment:NSTextAlignmentCenter];
            }
            
        }
        }
        
    }
    
    NSLog(@"%@",mRedeemCouponArray);
    
    [mTableView reloadData];
    [HUDManager hideHUD];

    
}




#pragma mark - timer
-(void)onTick:(NSTimer*)time
{
    NSDate *date = [NSDate date];
    NSDate * date1 = [[timerDic valueForKey:[mRedeemCouponID firstObject]] objectAtIndex:0];
    
    NSTimeInterval currentSec= [date timeIntervalSince1970];
    NSTimeInterval diffSec= [date1 timeIntervalSince1970];
    
    NSTimeInterval duration=(diffSec-currentSec);
    
    NSInteger minutes = floor(duration/60);
    NSInteger seconds = round(duration - minutes * 60);
    
    
    
    if([timerDic valueForKey:[mRedeemCouponID firstObject]] && seconds>0)
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
    
//    if([timerDic valueForKey:[mRedeemCouponID firstObject]] && seconds>0)
//        self.timeLeftLabel.text=[NSString stringWithFormat:@"%d:%02d min left", minutes, seconds];
//    else
//        self.timeLeftLabel.text=@"00:00 min left";
}

#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}





@end

