//
//  CouponsViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CouponsViewController.h"
#import "CouponDetailViewController.h"
#import "Coupon.h"
#import "Groups.h"
#import "Advertisement.h"
#import "FileUtils.h"
#import "WebViewController.h"
#import "AppDelegate.h"
#import "ProgressHudPresenter.h"
#import "Advertisment.h"
#import "Subscriber.h"
#import "Request.h"
#import "DPKMakeURL.h"
#import "CouponView.h"
#import "jsonparse.h"
#import "appcommon.h"
#import "SeeallViewController.h"
#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "InfiniteScrollview.h"
#import "SearchViewController.h"
#import "CoupitService.h"
#import "UIColor+AppTheme.h"
#import "CouponsListCell.h"
#import <AppiaSDK/AIAdParameters.h>
#import <AppiaSDK/AIAppWall.h>
#import <AppiaSDK/AIAppia.h>
#import <AppiaSDK/AIBannerAd.h>
#import "countdownManager.h"

//#import "GTScrollNavigationBar.h"


#define kItemWidth 320
#define kItemHeight 100
#define kItemMargin 0

static int hide;

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


#define kLatestKivaLoansURL [NSURL URLWithString:[NSString stringWithFormat@"%@/get_20coupons.php?data={zip:33433}",BASE_URL]]


@implementation CouponsViewController
{
    UIView *mGestureView;
	UIButton *mMenuButton;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    BOOL mCouponExpireNotification;
    
    ProgressHudPresenter *mHudPresenter;
    NSNumber *mCategoryID;
    NSInteger mCouponStartIndex;
    NSInteger mAdIndex;
    NSInteger mExpireCouponCount;
    
    NSMutableArray *mCouponGroupArray;
    NSMutableArray *mAdArray;
    NSMutableArray *mDBStorePreferencesArray;
    NSMutableArray *mCategoryCouponArray;
    NSMutableArray *mCountryNameArray;
    NSMutableArray *mCountryCodeArray;
    NSMutableArray *mRequestsArray;
    NSMutableArray *mMyCouponArray,*couponlatary,*couponlongary,*locationarray,*nearlocationarray,*hotlocationarray;
    UILabel  *mDisplayMessage;
    NSMutableDictionary *responseData;
    MyCoupons *mMyCoupons;
    NSMutableArray *itemsArray,*catarray,*hotarray,*nearmearray;
    NSMutableArray *tCategoryCouponArray;
    NSString *userkey,*catid;
    CLLocationManager *locationManager;
    NSMutableString *latstr,*longstr;
    
    NSDictionary* addvDic ;

    NSArray *addvArray;
    
    NSDictionary *jsonResponseDictionary;
    
    SearchType msearchType;
    
    UILabel *lbl1;
    UILabel *lbl2;
    UILabel *lbl3;
    
    UIView *hideView;
    UISearchBar *searchBar;
    NSMutableArray *searchDummyArray;
    UITableView *searchDummyTable;
    UILabel *noResult;
    
    LocationPreference tLocationPreference;

    long checkFlagForNullArrays;
}

@synthesize mTableView, mADImageView,mResetCouponCategory,viewForScroll;

- (void)fetchedData:(NSData *)responseData
{
    
}
- (BOOL)shouldAutorotate
{
    //returns true if want to allow orientation change
    return YES;
}


- (void)viewDidLoad
{
    checkFlagForNullArrays=0;
    [super viewDidLoad];
    mTableView.tableHeaderView = viewForScroll;
    
    [countdownManager shareManeger].opensidemenu=NO;
    
    //self.navigationController.scrollNavigationBar.scrollView=self.mTableView;
    api = [[GREST alloc] init];
    [api setDelegate:self];
    
    
    [[Location getInstance] userLocation];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    // calling home web service;
    {
       // [self callAdvertisementService];
        [self callHomeService:catid];
    }
    
    
    NSUserDefaults *defaultsKey = [NSUserDefaults standardUserDefaults];
    // saving a string
    [defaultsKey setObject:@"Yes" forKey:@"rigisterdUserKey"];
    [defaultsKey synchronize];
       
    mAdIndex = 0;
    mCouponStartIndex = 0;
    mExpireCouponCount = 0;
    mCategoryID = [NSNumber numberWithInt:0];
    mCategoryCouponArray = [NSMutableArray new];
    mCouponGroupArray = [NSMutableArray new];
    
    
    // side Menu Activate
    {
        mMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [mMenuButton setImage:[UIImage imageNamed:@"button_menu"] forState:UIControlStateNormal];
        [mMenuButton sizeToFit];
        
        [mMenuButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
        [self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
        
        UIBarButtonItem* menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:mMenuButton];
        self.navigationItem.leftBarButtonItem = menuBarButton;
        
        mGestureView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealToggle:)];
        [mGestureView addGestureRecognizer:recognizer];
        
        UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
        [mGestureView addGestureRecognizer:panRecognizer];
        
    }
    // Refresh View
    {
        refreshControl = [[UIRefreshControl alloc] init];
        refreshControl.tintColor = [UIColor appGreenColor];
        [refreshControl addTarget:self action:@selector(pulledToRefresh) forControlEvents:UIControlEventValueChanged];
        self.refreshControl = refreshControl;
        [self.mTableView addSubview:refreshControl];
        // [self.mTableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_reward"]]];
    }
    
    
    BOOL tCouponRequestOnDay = [[DataManager getInstance] couponRequest];
    
    if (!tCouponRequestOnDay)
    {
        [self removeAllUnMarkedCoupons];
        mCouponExpireNotification = NO;
    } else
    {
        if (![[Repository sharedRepository] isAllCouponsLoaded])
        {
            
        }
        else
        {
            [self refreshTableView];
        }
    }
    
    mDBStorePreferencesArray = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchAllStoresPreference:nil]];
    if (![mDBStorePreferencesArray count]) {
        [[RequestHandler getInstance] getRequestURL:KURL_GetAllStorePreferences delegate:self requestType:kGetAllStorePreferenceRequest];
    }
    
    if (mAdArray == nil)
    {
        mAdArray = [[NSMutableArray alloc] initWithArray:[[DataManager getInstance] mAdvertsArray]];
    }
    
    
    // add searching
    hide=0;
    [self addSearching];
    
    banerimgarray=[NSMutableArray new];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[LocalyticsSession shared] tagScreen:kCouponsScreen];
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // This line makes the spinner start spinning
    [self.refreshControl beginRefreshing];
    // This line makes the spinner visible by pushing the table view/collection view down
    [self.mTableView setContentOffset:CGPointMake(0, -1.0f * self.refreshControl.frame.size.height) animated:YES];
    // This line is what actually triggers the refresh action/selector
    [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
    
    if([countdownManager shareManeger].opensidemenu)
    {
        [mMenuButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
    self.navigationItem.titleView = [self getNevigationBarView:@"Category"];
    
    if (mResetCouponCategory == kFromMenuScreen)
    {
        mCategoryID = [NSNumber numberWithInt:0];
        [self refreshTableView];
        mResetCouponCategory = kFromAllScreen;
        
        //Calculate No of Expire Coupon
        mMyCouponArray = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchAllMyCoupons:nil]];
        
        for (int i = 0; i < [mMyCouponArray count]; i++)
        {
            mMyCoupons = [mMyCouponArray objectAtIndex:i];
            NSDate *tStartDate = [NSDate date];
            unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *tComponents = [gregorian components:flags fromDate:tStartDate toDate:mMyCoupons.mCouponExpireDate options:0];
            NSInteger tDays = [tComponents day];
            
            if (tDays == 0)
            {
                mExpireCouponCount = ++ mExpireCouponCount;
            }
        }
        if (!mCouponExpireNotification)
        {
            if (mExpireCouponCount > 0)
            {
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"dd MMM yyyy"];
                NSString *tCouponExpireDate = [dateFormat stringFromDate:[[DataManager getInstance] couponExpireDate:mMyCoupons.mCouponExpireDate]];
                UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%d coupons will expire by %@",mExpireCouponCount,tCouponExpireDate] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [tAlertView show];
                mCouponExpireNotification = YES;
                
            }
        }
    }
    mExpireCouponCount = 0;
    [mHudPresenter hideHud];
  }

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    hide=YES;
    [self searchView:nil];
    [self.refreshControl endRefreshing];
    
}

- (void)pulledToRefresh
{
    // NSDictionary * dictionaryForAppiaValue = @{@"placement id":[NSString stringWithFormat:@"%d",2]};
    
    //AIAdParameters *adParameters = [[AIAdParameters alloc] init];
    //[adParameters setUserParameters:dictionaryForAppiaValue];
    
    
     [self callHomeService:catid];
}

- (void)reloadForCategory
{
    [self callHomeService:catid];
}

- (void) solrCouponRequest
{
    
}

- (void) fetchRequestURLs
{
    if ([mRequestsArray count])
    {
    }
}


#pragma mark - GREST Methods

- (void)request_finished:(NSString *)response for_key:(NSString *)request_key with_details:(ASIHTTPRequest *)request {
    
    if([request_key isEqualToString:@"adsDetail"]) {
        
        NSDictionary *responseDetails = [response JSONValue];
        if (![responseDetails[@"data"][0][@"adv_type"] isEqualToString:@"coupon"]) {
            
            WebViewController *tWebViewController = [WebViewController new];
            NSString *urlToLoad = responseDetails[@"data"][0][@"hyperlink"];
            urlToLoad = [urlToLoad stringByReplacingOccurrencesOfString:@" " withString:@""];
            urlToLoad = [urlToLoad stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [tWebViewController setUrlToLoad:[NSURL URLWithString:urlToLoad]];
            [self presentViewController:tWebViewController animated:YES completion:^{
            }];
            
            CouponDetailViewController *tController = [CouponDetailViewController new];
            tController.mCouponID = [responseDetails[@"data"][0][@"hyperlink"] stringValue];
            [self.navigationController pushViewController:tController animated:YES];
            
        } else {
            
            /*
             
             CouponDetailViewController *tController = [CouponDetailViewController new];
             tController.mCouponID = [responseDetails[@"data"][0][@"hyperlink"] stringValue];
             [self.navigationController pushViewController:tController animated:YES];
             
             */
            
        }
        
    }
    
}

- (void)queue_completed:(BOOL)status failed_request_key:(NSString *)request_key {
    
    if(!status) {
        if([request_key isEqualToString:@"adsDetail"]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Couwalla"
                                  message:@"No advertisement available."
                                  delegate:self cancelButtonTitle:@"Close"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    
}

#pragma mark - Other Methods

- (void) iconDownloadManager:(IconDownloadManager *)pIconDownloadManager indexPath:(NSIndexPath *)pIndexPath
{
    Advertisement *tAdvertisement = [coupon_image objectAtIndex:pIndexPath.row];
    Advertisment *tAdvertismentView = [coupon_image objectAtIndex:pIndexPath.row];
    NSString *tFileName = [tAdvertisement.mBannerImage lastPathComponent];
    NSString *fmtFileName = makeFileName([tAdvertisement.mID stringValue], tFileName);
    
    if (isFileExists(fmtFileName)) {
        [UIView beginAnimations:nil context:NULL];
        
        [tAdvertismentView.mImageView setImage:[UIImage imageWithContentsOfFile:imageFilePath(fmtFileName)]];
        [UIView commitAnimations];
    }
    else {
        [tAdvertismentView.mImageView setImage:[UIImage imageNamed:@"t_Add"]];
    }
    
}

- (void) requestHandler:(RequestHandler *)pRequestHandler withRequestType:(RequestType)pRequestType error:(APIError *)pError
{
}
- (void) refreshTableView {
    
    [self.mTableView reloadData];
}

- (void)categoryView:(id)sender
{
    CategoriesViewController *tCategoriesViewController = [CategoriesViewController new];
    tCategoriesViewController.mDelegate = self;
    tCategoriesViewController.mSelectedCategoryID = [mCategoryID intValue];
    
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:tCategoriesViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

- (void) categoriesViewController:(CategoriesViewController *)pCategoriesViewController selectedCategoryID:(NSNumber *)pID
{
    mCategoryID = pID;
    catid = [NSString stringWithFormat:@"%@",pID];
    [self reloadForCategory];
}

-(void)listallcoupons
{
    CouponDetailViewController *tController = [CouponDetailViewController new];
    [self.navigationController pushViewController:tController animated:YES];
}

-(void)showGestureView
{
    if (![self.view.subviews containsObject:mGestureView])
    {
        [self.view addSubview:mGestureView];
    }
}

-(void)hideGestureView
{
    if ([self.view.subviews containsObject:mGestureView])
    {
        [mGestureView removeFromSuperview];
    }
}
- (void) notificationDictionary:(NSDictionary *)pDict{}


-(void)menuButtonUnselected
{
    
    mMenuButton.selected = NO;
}

-(void)menuButtonSelected
{
    
    mMenuButton.selected = YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView==searchDummyTable)
        return 1;
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==searchDummyTable)
        return 102;
    return 135.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(tableView==searchDummyTable)
        return [searchDummyArray count];
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView != searchDummyTable)
    {
        static NSString *CellIdentifier = @"CouponTableCell";
        
        CouponTableCell *cell = (CouponTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell=nil;
        
        if (cell == nil)
        {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CouponTableCell" owner:self options:nil];
            cell =  (CouponTableCell *)[topLevelObjects objectAtIndex:0];
            
            
        }
        
        NSArray* grp=[[NSArray alloc]initWithObjects:@"What's Hot",@"Most Popular",@"Near Me", nil];
        
        
            if ((hotarray.count !=0) || (itemsArray.count != 0)|| (nearmearray.count !=0) || checkFlagForNullArrays==1)
            {
                if (indexPath.section==0)
                {
                    if (hotarray.count>0)
                    {
                        [cell categoryTitle:[hotCouponName objectAtIndex:indexPath.row] items:hotarray indexPath:indexPath];
                        cell.mDelegate = self;
                        cell.detailTextLabel.text=[hotcoupon_image objectAtIndex:indexPath.row];
                        cell.seeallbut.hidden=NO;
                        cell.seeallimg.hidden=NO;
                        cell.mCategoryTitleLabel.hidden=NO;
                    }
                    else
                    {
                        UILabel * lbl=[[UILabel alloc]initWithFrame:cell.contentView.frame];
                        lbl.text=@"No Coupons found please try later.";
                        lbl.textAlignment=NSTextAlignmentCenter;
                        [lbl setBackgroundColor:[UIColor clearColor]];
                        lbl.textColor=[UIColor blackColor];
                        [lbl setFont:[UIFont fontWithName:nil size:15.0]];
                        [cell.contentView addSubview:lbl];
                        cell.seeallbut.hidden=YES;
                        cell.seeallimg.hidden=YES;
                        //cell.mCategoryTitleLabel.hidden=YES;
                    }
                }
                
                if (indexPath.section==1)
                {
                    if (itemsArray.count>0)
                    {
                        [cell categoryTitle:[CouponName objectAtIndex:indexPath.row] items:itemsArray indexPath:indexPath];
                        cell.mDelegate = self;
                        cell.detailTextLabel.text=[coupon_image objectAtIndex:indexPath.row];
                        cell.seeallbut.hidden=NO;
                        cell.seeallimg.hidden=NO;
                        cell.mCategoryTitleLabel.hidden=NO;
                        
                    }
                    else
                    {
                        UILabel * lbl=[[UILabel alloc]initWithFrame:cell.contentView.frame];
                        //lbl.text=@"There are no available offers near you. Please check back soon.";
                        lbl.text=@"No Coupons found please try later.";
                        lbl.numberOfLines=2;
                        lbl.textAlignment=NSTextAlignmentCenter;
                        [lbl setBackgroundColor:[UIColor clearColor]];
                        lbl.textColor=[UIColor blackColor];
                        [lbl setFont:[UIFont fontWithName:nil size:15.0]];
                        [cell.contentView addSubview:lbl];
                        cell.seeallbut.hidden=YES;
                        cell.seeallimg.hidden=YES;
                        //cell.mCategoryTitleLabel.hidden=YES;
                    }
                }
                if (indexPath.section==2)
                {
                    if (nearmearray.count>0)
                    {
                        [cell categoryTitle:[nearCouponName objectAtIndex:indexPath.row] items:nearmearray indexPath:indexPath];
                        cell.mDelegate = self;
                        cell.detailTextLabel.text=[nearcoupon_image objectAtIndex:indexPath.row];
                        cell.seeallbut.hidden=NO;
                        cell.seeallimg.hidden=NO;
                        cell.mCategoryTitleLabel.hidden=NO;
                        
                    }
                    else
                    {
//                        Please turn on your location settings on your device
                        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
                        {
                            UILabel * lbl=[[UILabel alloc]initWithFrame:cell.contentView.frame];
                            lbl.text=@"Please turn on your location settings on your device.";
                            lbl.textAlignment=NSTextAlignmentCenter;
                            [lbl setBackgroundColor:[UIColor clearColor]];
                            lbl.textColor=[UIColor blackColor];
                            [lbl setFont:[UIFont fontWithName:nil size:13.0]];
                            [cell.contentView addSubview:lbl];
                            cell.seeallbut.hidden=YES;
                            cell.seeallimg.hidden=YES;
                            //cell.mCategoryTitleLabel.hidden=YES;
                        }
                        else
                        {
                            UILabel * lbl=[[UILabel alloc]initWithFrame:cell.contentView.frame];
                            lbl.text=@"No coupons currently found near you.";
                            lbl.textAlignment=NSTextAlignmentCenter;
                            [lbl setBackgroundColor:[UIColor clearColor]];
                            lbl.textColor=[UIColor blackColor];
                            [lbl setFont:[UIFont fontWithName:nil size:15.0]];
                            [cell.contentView addSubview:lbl];
                            cell.seeallbut.hidden=YES;
                            cell.seeallimg.hidden=YES;
                            //cell.mCategoryTitleLabel.hidden=YES;
                        }
                        
                    }
                }
                
                //NSLog(@"%@", nearmearray);
                
                cell.mCategoryTitleLabel.text=[grp objectAtIndex:indexPath.section];
                //cell.detailTextLabel.text=[coupon_image objectAtIndex:indexPath.row];
            }
            else
            {
                UILabel * lbl=[[UILabel alloc]initWithFrame:cell.contentView.frame];
                lbl.text=@"Coupons Loading...";
                lbl.textAlignment=NSTextAlignmentCenter;
                [lbl setBackgroundColor:[UIColor clearColor]];
                lbl.textColor=[UIColor lightGrayColor];
                [lbl setFont:[UIFont fontWithName:nil size:15.0]];
                [cell.contentView addSubview:lbl];
                cell.seeallbut.hidden=YES;
                cell.seeallimg.hidden=YES;
            }
        
        
        cell.selectionStyle=UITableViewCellAccessoryNone;
        return cell;
    }
    else
    {
        static NSString *CellIdentifier1 = @"CouponsListCell";
        
        
        CouponsListCell* cell1 = (CouponsListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell1 == nil)
        {
            NSArray *topLevelObjects1 = [[NSBundle mainBundle] loadNibNamed:@"CouponsListCell" owner:self options:nil];
            cell1 = (CouponsListCell *)[topLevelObjects1 objectAtIndex:0];
        }
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        //  cell1.mCouponDiscountLabel.textColor  = kproductSubTitleColor;
        cell1.mTitleLabel.textColor        = [UIColor appGreenColor];
        
        
        MyCoupons *tCoupon = [searchDummyArray objectAtIndex:indexPath.row];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *startDate = [dateFormatter dateFromString:[tCoupon valueForKey:@"expiry_date"]];
        NSDate *endDate = [NSDate date];
        
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
        
        
        
        cell1.mTitleLabel.text          =  [tCoupon valueForKey:@"name"];
        cell1.mCouponDiscountLabel.text =  [tCoupon valueForKey:@"promo_text_short"];
        cell1.mCouponDetailLabel.text   =  [tCoupon valueForKey:@"promo_text_long"] ;
        cell1.mValidDateLabel .text     =  str;
        
        // for image
        [cell1.mImageView setImageWithURL:[NSURL URLWithString:[tCoupon valueForKey:@"coupon_thumbnail"]]];
        
        
        return cell1;
    }
}

- (void) couponTableCell:(CouponTableCell *)pTableCell selectedItemIndex:(NSIndexPath *)pIndexPath
{
    if (pIndexPath.row == -1)
    {
        // SeeAll Items- nn
        
        CouponListViewController *tController = [CouponListViewController new];
        tController.mDataDictionary=[jsonResponseDictionary copy];
        
        if (pIndexPath.section==0)
        {
            tController.buttonTag = 0;
        }
        if (pIndexPath.section==1)
        {
            tController.buttonTag = 1;
        }
        if (pIndexPath.section==2)
        {
            tController.buttonTag = 2;
        }
        tController.mDelegate = self;
        
        [self.navigationController pushViewController:tController animated:YES];
        //tController.navigationItem.title = tCouponGroup.mName;
        
        return;
    }
    
    Coupon *tCoupon = [pTableCell getCouponAtIndex:pIndexPath.row];
    CouponDetailViewController *tController = [CouponDetailViewController new];
    
    if (pIndexPath.section==0)
    {
        
        tController.mCoupon                 = tCoupon;
        tController.mCouponName             = [hotCouponName objectAtIndex:pIndexPath.row];
        tController.mCouponPromoTextShort   = [hotcouponShortText  objectAtIndex:pIndexPath.row];
        tController.mCouponPromoTextLong    = [hotcouponLongtext   objectAtIndex:pIndexPath.row];
        tController.mCouponExpireDate       = [hotcouponExpireDate objectAtIndex:pIndexPath.row];
        tController.mCouponID               = [hotcouponID objectAtIndex:pIndexPath.row];
        tController.locatarray              = [hotlocationarray objectAtIndex:pIndexPath.row];
        tController.mCodeType               = [hotCodeType objectAtIndex:pIndexPath.row];
        tController.mCouponImage            = [hotcoupon_image objectAtIndex:pIndexPath.row];
        tController.mBarcodeImage           = [hotBarcodeImage objectAtIndex:pIndexPath.row];
        tController.mCouponDescription      = [hotcouponDescription objectAtIndex:pIndexPath.row];
        
        [self.navigationController pushViewController:tController animated:YES];
    }
    if (pIndexPath.section==1)
    {
        
        tController.mCoupon                 = tCoupon;
        tController.mCouponName             = [CouponName objectAtIndex:pIndexPath.row];
        tController.mCouponPromoTextShort   = [couponShortText  objectAtIndex:pIndexPath.row];
        tController.mCouponPromoTextLong    = [couponLongtext   objectAtIndex:pIndexPath.row];
        tController.mCouponExpireDate       = [couponExpireDate objectAtIndex:pIndexPath.row];
        tController.mCouponID               = [couponID objectAtIndex:pIndexPath.row];
        tController.locatarray              = [locationarray objectAtIndex:pIndexPath.row];
        
        tController.mCodeType               = [CodeType objectAtIndex:pIndexPath.row];
        tController.mCouponImage            = [coupon_image objectAtIndex:pIndexPath.row];
        tController.mBarcodeImage           = [BarcodeImage objectAtIndex:pIndexPath.row];
        tController.mCouponDescription      = [couponDescription objectAtIndex:pIndexPath.row];
        
        
        [self.navigationController pushViewController:tController animated:YES];
    }
    if (pIndexPath.section==2)
    {
        
        tController.mCoupon                 = tCoupon;
        tController.mCouponName             = [nearCouponName objectAtIndex:pIndexPath.row];
        tController.mCouponPromoTextShort   = [nearcouponShortText  objectAtIndex:pIndexPath.row];
        tController.mCouponPromoTextLong    = [nearcouponLongtext   objectAtIndex:pIndexPath.row];
        tController.mCouponExpireDate       = [nearcouponExpireDate objectAtIndex:pIndexPath.row];
        tController.mCouponID               = [nearcouponID objectAtIndex:pIndexPath.row];
        tController.locatarray              = [nearlocationarray objectAtIndex:pIndexPath.row];
        
        tController.mCodeType               = [nearCodeType objectAtIndex:pIndexPath.row];
        tController.mCouponImage            = [nearcoupon_image objectAtIndex:pIndexPath.row];
        tController.mBarcodeImage           = [nearBarcodeImage objectAtIndex:pIndexPath.row];
        tController.mCouponDescription      = [nearcouponDescription objectAtIndex:pIndexPath.row];
        
        
        [self.navigationController pushViewController:tController animated:YES];
    }
}

- (void) couponListViewController:(CouponListViewController *)pCategories isBack:(BOOL)pValue
{
    if (pValue) {
        [self refreshTableView];
    }
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == searchDummyTable)
    {
        Coupon *tCoupon = [searchDummyArray objectAtIndex:indexPath.row];
        
        CouponDetailViewController *tController = [CouponDetailViewController new];
        tController.mCoupon = tCoupon;
        
        tController.mCouponName                 = [[searchDummyArray objectAtIndex:indexPath.row] valueForKey:@"name"];
        tController.mCouponPromoTextShort       = [[searchDummyArray objectAtIndex:indexPath.row] valueForKey:@"promo_text_short"];
        tController.mCouponPromoTextLong        = [[searchDummyArray objectAtIndex:indexPath.row] valueForKey:@"promo_text_long"];
        tController.mCouponExpireDate           = [[searchDummyArray objectAtIndex:indexPath.row] valueForKey:@"expiry_date"];
        tController.mCouponID                   = [[searchDummyArray objectAtIndex:indexPath.row] valueForKey:@"id"];
        tController.mCodeType                   = [[searchDummyArray objectAtIndex:indexPath.row] valueForKey:@"code_type"];
        tController.mCouponImage                = [[searchDummyArray objectAtIndex:indexPath.row] valueForKey:@"coupon_thumbnail"];
        tController.mBarcodeImage               = [[searchDummyArray objectAtIndex:indexPath.row] valueForKey:@"barcode_image"];
        tController.locatarray              = [[searchDummyArray objectAtIndex:indexPath.row] valueForKey:@"store_name"];
        tController.mCouponDescription          = [[searchDummyArray objectAtIndex:indexPath.row] valueForKey:@"coupon_description"];
        
        
        [self.navigationController pushViewController:tController animated:YES];
    }
}


- (void) removeAllUnMarkedCoupons{
    if ([[Repository sharedRepository] deleteAllUnMarkedCoupons]) {
        //NSLog(@" deleteAllUnMarkedCoupons ");
        [mHudPresenter presentHud];
        //        [self solrCouponRequest];
    }
    else{
        //NSLog(@"fail - deleteAllUnMarkedCoupons ");
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
    [self doneLoadingTableViewData];
    _reloading = YES;
    
}


- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mTableView];
    
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    //[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(UIView *)getNevigationBarView:(NSString *)title
{
    
    UIButton *tcategoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tcategoryButton.frame = CGRectMake(0, 0,250,45 );
    [tcategoryButton setBackgroundColor:[UIColor clearColor]];
    
    tcategoryButton.titleLabel.font=[UIFont boldSystemFontOfSize:20.0];
    [tcategoryButton setTitle:title forState:UIControlStateNormal];
    [tcategoryButton addTarget:self action:@selector(categoryView:) forControlEvents:UIControlEventTouchUpInside];
    tcategoryButton.titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [tcategoryButton setImage:[UIImage imageNamed:@"downarrow_icon.png"] forState:UIControlStateNormal];
    tcategoryButton.imageEdgeInsets=UIEdgeInsetsMake(0, 170, 0, 0);
    tcategoryButton.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0,30);
    
    return tcategoryButton;
}

#pragma mark - Search

-(void)addSearching
{
    UIButton *tSearchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tSearchButton.frame = CGRectMake(0, 0, 38, 30);
    [tSearchButton setImage:[UIImage imageNamed:@"button_search.png"] forState:UIControlStateNormal];
    [tSearchButton addTarget:self action:@selector(searchView:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *menuBarCategory = [[UIBarButtonItem alloc]initWithCustomView:tSearchButton];
    self.navigationItem.rightBarButtonItem = menuBarCategory;
    
    searchDummyArray=[[NSMutableArray alloc]init];
    
    searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0,20,320,40)];
    [searchBar setTintColor:[UIColor appGreenColor]];
    searchBar.barTintColor=[UIColor whiteColor];
    [searchBar setPlaceholder:@"Search"];
    searchBar.hidden=YES;
    searchBar.showsCancelButton=YES;
    [searchBar setDelegate:self];
    
    //    NSLog(@"%f",self.view.frame.size.height);
    //    NSLog(@"%f",[UIScreen mainScreen].bounds.size.height);
    
    searchDummyTable=[[UITableView alloc]initWithFrame:CGRectMake(0,60,320,[UIScreen mainScreen].bounds.size.height-60)];
    [searchDummyTable setDataSource:self];
    [searchDummyTable setDelegate:self];
    searchDummyTable.hidden=YES;
    searchDummyTable.separatorColor = [UIColor clearColor];
    
    noResult=[[UILabel alloc]initWithFrame:CGRectMake(120, 100,320,100)];
    
    hideView =[[UIView alloc]initWithFrame:CGRectMake(0,0,320,self.view.frame.size.height)];
    [hideView setBackgroundColor:[UIColor darkGrayColor]];
    [hideView setAlpha:1.0];
    hideView.hidden=YES;
    
    UITapGestureRecognizer *tapRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchView:)];
    [tapRecognizer1 setNumberOfTapsRequired:2];
    hideView.userInteractionEnabled = YES;
    [hideView addGestureRecognizer:tapRecognizer1];
    
    [hideView addSubview:searchDummyTable];
    [hideView addSubview:searchBar];
    [self.view addSubview:hideView];
}

-(void) searchView:(id)sender
{
    if(!hide)
    {
        hideView.hidden=NO;
        searchBar.hidden=NO;
        searchBar.text=@"";
        [self.view bringSubviewToFront:hideView];
        [self.mTableView setScrollEnabled:NO];
        //[mTableView setContentOffset:CGPointZero];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        
        searchBar.transform = CGAffineTransformMakeTranslation(0, -44);
        [UIView animateWithDuration:0.3 animations:^{
            searchBar.transform = CGAffineTransformIdentity;
        }];
        [searchBar becomeFirstResponder];
        hide=!hide;
    }
    else
    {
        hideView.hidden=YES;
        searchBar.hidden=YES;
        [self.mTableView setScrollEnabled:YES];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        searchDummyTable.hidden=YES;
        [self.mTableView reloadData];
        searchBar.transform = CGAffineTransformMakeTranslation(0, 0);
        [UIView animateWithDuration:0.3 animations:^{
            searchBar.alpha = 0.0;
        }];
        searchBar.alpha = 1.0;
        [searchBar resignFirstResponder];
        hide=!hide;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    [searchBar1 resignFirstResponder];
    noResult.hidden=YES;
    [searchDummyTable setScrollEnabled:YES];
    
    [HUDManager showHUDWithText:kHudMassage];
    [searchBar1 resignFirstResponder];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        msearchType =kCouponSearch;
        if ([searchBar1.text length] == 0)
        {
            [HUDManager hideHUD];
            
            return;
        }
        else
        {
            
            NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
            [parameterDic setObject:searchBar1.text forKey:@"search_text"];
            [parameterDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"] forKey:@"userid"];

            NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/search_manufacturer_coupons.php?",BASE_URL];
            jsonparse *objJsonparse =[[jsonparse alloc]init];
            NSMutableDictionary *reponseData = [[NSMutableDictionary alloc]init];
            reponseData = [objJsonparse customejsonParsing:urlString bodydata:parameterDic];
            searchDummyArray = [reponseData valueForKey:@"data"];
            [searchDummyTable reloadData];
            if(!searchDummyArray.count)
            {
                noResult.hidden=NO;
                noResult.text=@"No Result";
                noResult.textColor=[UIColor grayColor];
                noResult.font=[UIFont boldSystemFontOfSize:20.0];
                [searchDummyTable addSubview:noResult];
                [searchDummyTable setScrollEnabled:NO];
            }
            searchDummyTable.hidden=NO;
            [HUDManager hideHUD];
        }
    });
    
    
    
}

- (void)handleSearch:(UISearchBar *)searchBar1
{
    [searchBar1 resignFirstResponder]; // if you want the keyboard to go away
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar1
{
    
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar1
{
    [self searchView:nil];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
    
}

#pragma mark - Advertise

- (IBAction)buyNowAction:(id)sender {
}
-(void)advertiseClicked:(UIButton*)bt;
{
    
    NSLog(@"%@",[addvArray objectAtIndex:bt.tag]);
    
    NSString *str=[addvArray objectAtIndex:bt.tag];
    NSArray *a =[[addvArray objectAtIndex:bt.tag] componentsSeparatedByString:@"http:"];
    if(a.count)
    {
        str=[str stringByReplacingOccurrencesOfString:@" " withString:@""];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark - call service

-(void)callHomeService:(NSString *)str
{
    if(![[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreference])
    {
        latstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"latvalue"];
        longstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"longvalue"];
        
        NSLog(@"%@",latstr);
        NSLog(@"%@",longstr);
    }
    else
    {
        latstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"keylat"];
        longstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"keylon"];
        
        NSLog(@"%@",latstr);
        NSLog(@"%@",longstr);

    }
    
    if(latstr== nil || longstr==nil)
    {
        latstr=[NSMutableString stringWithFormat:@""];
        longstr=[NSMutableString stringWithFormat:@""];
    }
    
        userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
       
        NSMutableDictionary *myDic = [NSMutableDictionary dictionaryWithCapacity:7];
        [myDic setValue:str forKey:@"categoryid"];
        [myDic setValue:userkey forKey:@"userid"];
        [myDic setValue:latstr forKey:@"latitude"];
        [myDic setValue:longstr forKey:@"longitude"];
        [[CoupitService service] homepageCoupons:myDic completionHandler:^(NSDictionary *result, NSError *error)
         {
             
             if (error)
             {
                 [[[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                 [[LocalyticsSession shared] tagEvent:kErrorSummary attributes:@{kError:[error localizedDescription]}];
                 // [HUDManager hideHUD];
                 [self callAdvertisementService];
                 
                 
             }
             else
             {
                 jsonResponseDictionary =[result copy];
                 itemsArray = [[NSMutableArray alloc]init];
                 hotarray=[result valueForKey:@"whatshot"];
                 if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
                 {
                     if([[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreference])
                     {
                         nearmearray =[result valueForKey:@"nearme_data"];
                     }
                     else
                     {
                         nearmearray = [[NSMutableArray alloc]init];
                     }
                 }
                 else
                 {
                     nearmearray =[result valueForKey:@"nearme_data"];
                 }
                  itemsArray=[result valueForKey:@"popular_data"];
                 
                 //             coupon_image            = [[NSMutableArray alloc]init];
                 //             CouponName              = [[NSMutableArray alloc]init];
                 //             couponShortText         = [[NSMutableArray alloc]init];
                 //             couponLongtext          = [[NSMutableArray alloc]init];
                 //             couponExpireDate        = [[NSMutableArray alloc]init];
                 //             couponID                = [[NSMutableArray alloc]init];
                 //             couponlatary            = [[NSMutableArray alloc]init];
                 //             couponlongary           = [[NSMutableArray alloc]init];
                 //             BarcodeImage            = [[NSMutableArray alloc]init];
                 //             CodeType                = [[NSMutableArray alloc]init];
                 
                 coupon_image            = [itemsArray valueForKey:@"coupon_thumbnail"];
                 CouponName              = [itemsArray valueForKey:@"name"];
                 couponShortText         = [itemsArray valueForKey:@"promo_text_short"];
                 couponLongtext          = [itemsArray valueForKey:@"promo_text_long"];
                 couponExpireDate        = [itemsArray valueForKey:@"expiry_date"];
                 couponID                = [itemsArray valueForKey:@"id"];
                 locationarray           = [itemsArray valueForKey:@"store_name"];
                 BarcodeImage            = [itemsArray valueForKey:@"barcode_image"];
                 CodeType                = [itemsArray valueForKey:@"code_type"];
                 couponDescription       = [itemsArray valueForKey:@"coupon_description"];
                 
                 hotcoupon_image         = [hotarray valueForKey:@"coupon_thumbnail"];
                 hotCouponName           = [hotarray valueForKey:@"name"];
                 hotcouponShortText      = [hotarray valueForKey:@"promo_text_short"];
                 hotcouponLongtext       = [hotarray valueForKey:@"promo_text_long"];
                 hotcouponExpireDate     = [hotarray valueForKey:@"expiry_date"];
                 hotcouponID             = [hotarray valueForKey:@"id"];
                 hotlocationarray        = [hotarray valueForKey:@"store_name"];
                 hotBarcodeImage         = [hotarray valueForKey:@"barcode_image"];
                 hotCodeType             = [hotarray valueForKey:@"code_type"];
                 hotcouponDescription    = [hotarray valueForKey:@"coupon_description"];
                 
                 nearcoupon_image        = [nearmearray valueForKey:@"coupon_thumbnail"];
                 nearCouponName          = [nearmearray valueForKey:@"name"];
                 nearcouponShortText     = [nearmearray valueForKey:@"promo_text_short"];
                 nearcouponLongtext      = [nearmearray valueForKey:@"promo_text_long"];
                 nearcouponExpireDate    = [nearmearray valueForKey:@"expiry_date"];
                 nearcouponID            = [nearmearray valueForKey:@"id"];
                 nearlocationarray       = [nearmearray valueForKey:@"store_name"];
                 nearBarcodeImage        = [nearmearray valueForKey:@"barcode_image"];
                 nearCodeType            = [nearmearray valueForKey:@"code_type"];
                 nearcouponDescription   = [nearmearray valueForKey:@"coupon_description"];
                 
                 mCountryNameArray       = [NSMutableArray new];
                 mCountryCodeArray       = [NSMutableArray new];
                 mRequestsArray          = [NSMutableArray new];
                 
                 //[HUDManager hideHUD];
                 if ([itemsArray count]==0 && [hotarray count]==0 && [nearmearray count]==0)
                 {
                     checkFlagForNullArrays=1;
                 }
                 [mTableView reloadData];
                 [self callAdvertisementService];
             }
             
         }];
    
   // NSLog(@"%d",[[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreference]);
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
    {
        if(![[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreference])
        {
            UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:kLocationMassage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [servicesDisabledAlert show];
        }
    }
    
  
}

-(void)callAdvertisementService
{
//    UIImageView * cv=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BG_CouponCell.png"]];
//    cv.frame=viewForScroll.frame;
//    [viewForScroll addSubview:cv];
//    
//    UIView *appiaView=[[UIView alloc]initWithFrame:CGRectMake(0, 24, 320, 50)];
//    [viewForScroll addSubview:appiaView];
//    AIBannerAd *ad = [[AIAppia sharedInstance] createBannerAdWithSize:AIBannerAd320x50];
//    viewForScroll.frame=CGRectMake(0, 0, 320, 50);
//    [ad presentInView:appiaView];
//    [mTableView reloadData];
//    //mTableView.tableHeaderView = appiaView;
//    [self.refreshControl endRefreshing];
    
    [[CoupitService service]advertisementsWithCompletionHandler:^(NSDictionary *result, NSError *error) {
        if (error)
        {
            [[[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            [[LocalyticsSession shared] tagEvent:kErrorSummary attributes:@{kError:[error localizedDescription]}];
            //[HUDManager hideHUD];
            [self.refreshControl endRefreshing];

        }
        else
        {
            addvDic = [result copy];

            banerimgarray = [[addvDic valueForKey:@"data"] valueForKey:@"banner_image"];
            addvArray=[[addvDic valueForKey:@"data"] valueForKey:@"hyperlink"];
          
        }
        
//        AIBannerAd *ad = [[AIAppia sharedInstance] createBannerAdWithSize:AIBannerAd320x50];
//        
//        if([banerimgarray count]<= 0)
//        {
//            viewForScroll.frame=CGRectMake(0, 0, 320, 50);
//            [ad presentInView:viewForScroll];
//        }
//        else
//        {
            viewForScroll.frame=CGRectMake(0, 0, 320, 100);
            //[ad dismiss];
            
            NSArray *advertiseName=[[NSArray alloc]init];
            advertiseName=[[addvDic valueForKey:@"data"] valueForKey:@"advert_name"];
            
            NSArray *advertiseDiscount=[[NSArray alloc]init];
            advertiseDiscount=[[addvDic valueForKey:@"data"] valueForKey:@"description"];
            
            infiScroll = [[InfiniteScrollview alloc] initWithFrame:viewForScroll.frame withArray:banerimgarray];
            [infiScroll setDelegateCheckbox:self];
            [viewForScroll addSubview:infiScroll];
            [infiScroll startScrolling];
            [infiScroll advertiseNameOnLabels:advertiseName arrayDiscount:advertiseDiscount];
            //[HUDManager hideHUD];
            
//        }
        [mTableView reloadData];
        mTableView.tableHeaderView = viewForScroll;
        [self.refreshControl endRefreshing];
    }];
}

@end

