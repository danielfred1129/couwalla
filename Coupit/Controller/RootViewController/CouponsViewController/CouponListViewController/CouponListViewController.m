//
//  CouponListViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CouponListViewController.h"
#import "CouponTableCell.h"
#import "Coupon.h"
#import "FileUtils.h"
#import "CouponDetailViewController.h"
#import "DPKMakeURL.h"
#import "Request.h"
#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "CouponView.h"
#import "IQKeyboardManager.h"
#import "UIColor+AppTheme.h"
#import "GTScrollNavigationBar.h"
#import "CoupitService.h"

#import "RNFullScreenScroll.h"
#import "UIViewController+RNFullScreenScroll.h"
#import "UITabBarController+hidable.h"
#import "SearchViewController.h"
#import "countdownManager.h"



#define kNumberOfItemsToDisplay 10

#define kItemWidth 103
#define kItemHeight 35
#define kItemMargin 10
static int hide;

@interface CouponListViewController ()

@property (assign, nonatomic) CGFloat lastContentOffsetY;

@end

@implementation CouponListViewController
{
    //NSMutableArray *mCouponListArray;
    UIView *mGestureView;
    UIButton *mMenuButton;
    NSMutableArray *mKeyWordCouponArray;
    NSMutableArray *mDBCouponArray;
    NSUInteger mLimits;
    NSUInteger mCount;
    NSMutableArray *listcoupon_actualimage, *listcoupon_image,*listCouponName,*listcouponShortText,*listcouponLongtext,*listcouponExpireDate,*listcouponID,*listlocationarray,*listCodeType,*listBarcodeImage,*listDescription;
    
    
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    NSMutableArray *mRequestsArray;
    ProgressHudPresenter *mHudPresenter;
    BOOL showHeaderfooter;
    
    UISearchBar *searchBar;
    UIView *hideView;
    UISegmentedControl *segmentedControl;
    
    SearchType msearchType;
    UIWindow  *currentWindow;
}

@synthesize mGroupType, mCategoryID;
@synthesize mSelectionType;
@synthesize mCouponListArray;
@synthesize mDelegate;
@synthesize buttomLabel;

#pragma mark -
#pragma mark View lifecycle
- (void)viewDidLoad
{
    
    [self.navigationController.navigationBar setTranslucent:NO];

    [super viewDidLoad];
    buttomLabel=[[UILabel alloc]init];
    currentWindow = [UIApplication sharedApplication].keyWindow;

    self.navigationItem.titleView =[self getNevigationBarView:@"Category"];
//    self.fullScreenScroll = [[RNFullScreenScroll alloc] initWithViewController:self scrollView:self.tableView];
//    [self.fullScreenScroll setDelegateRNTableView:self];
    
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"What's Hot", @"Popular",@"Near Me",nil];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame=CGRectMake(5, 5, 310, 30);
    [segmentedControl setTintColor:[UIColor appGreenColor]];
    segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    [segmentedControl addTarget:self action:@selector(MySegmentControlAction:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = self.buttonTag;
  
    
    numberOfItemsToDisplay = kNumberOfItemsToDisplay;
    mLimits = 0;
    mCount = 0;
    
    
    //self.navigationItem.title = @"Coupon List";
    self.navigationItem.hidesBackButton = YES;
    mHudPresenter = [ProgressHudPresenter new];
    mDBCouponArray = [NSMutableArray new];
    mRequestsArray = [NSMutableArray new];
    
    [self loadCouponsForGroupID:mGroupType category:mCategoryID];
    
    //Back Button.
    UIButton *tbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tbackButton.frame = CGRectMake(0, 0, 38, 30);
    [tbackButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
   // [tbackButton sizeToFit];
    [tbackButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
   
    UIBarButtonItem *tBackBar = [[UIBarButtonItem alloc]initWithCustomView:tbackButton];
    self.navigationItem.leftBarButtonItem = tBackBar;
    
    UIButton *tSearchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tSearchButton.frame = CGRectMake(0, 0, 38, 30);
    
    [tSearchButton setImage:[UIImage imageNamed:@"button_search.png"] forState:UIControlStateNormal];
    [tSearchButton addTarget:self action:@selector(searchView:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *menuBarCategory = [[UIBarButtonItem alloc]initWithCustomView:tSearchButton];
    self.navigationItem.rightBarButtonItem = menuBarCategory;
    
    
    // Refresh Headerå View

    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor appGreenColor];
    [refreshControl addTarget:self action:@selector(pulledToRefresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self.tableView addSubview:refreshControl];
	
    hide=0;
    [self addSearching];

}

-(void)viewWillAppear:(BOOL)animated
{
    
    [countdownManager shareManeger].opensidemenu=NO;
    [super viewWillAppear:animated];
    showHeaderfooter=YES;
    //for hide nevigati
    [segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [self showViewForFooterOfTableView];
    
    self.navigationController.scrollNavigationBar.scrollView = self.tableView;

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [self hideViewForFooterOfTableView];
    [buttomLabel removeFromSuperview];
    self.navigationController.scrollNavigationBar.scrollView = nil;

}
-(void)addSearching
{
    
    hideView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 600)];
    [hideView setBackgroundColor:[UIColor blackColor]];
    [hideView setAlpha:0.5];
    // hideView.hidden=YES;
    
    UITapGestureRecognizer *tapRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchView:)];
    [tapRecognizer1 setNumberOfTapsRequired:1];
    hideView.userInteractionEnabled = YES;
    [hideView addGestureRecognizer:tapRecognizer1];
    
    searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0,0,320,40)];
    [searchBar setBackgroundColor:[UIColor whiteColor]];
    [searchBar setPlaceholder:@"Search"];
    //searchBar.hidden=YES;
    [searchBar setDelegate:self];
}

- (void)reloadTableView
{
    //NSLog(@"array is %@",mCouponListArray);
    listcoupon_image        = [mCouponListArray valueForKey:@"coupon_thumbnail"];
    listcoupon_actualimage  = [mCouponListArray valueForKey:@"coupon_image"];
    listCouponName          = [mCouponListArray valueForKey:@"name"];
    listcouponShortText     = [mCouponListArray valueForKey:@"promo_text_short"];
    listcouponLongtext      = [mCouponListArray valueForKey:@"promo_text_long"];
    listcouponExpireDate    = [mCouponListArray valueForKey:@"expiry_date"];
    listcouponID            = [mCouponListArray valueForKey:@"id"];
    listlocationarray       = [mCouponListArray valueForKey:@"store_name"];
    listCodeType            = [mCouponListArray valueForKey:@"code_type"];
    listBarcodeImage        = [mCouponListArray valueForKey:@"barcode_image"];
    listcoupon_actualimage  = [mCouponListArray valueForKey:@"coupon_image"];
    listDescription         = [mCouponListArray valueForKey:@"coupon_description"];

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

//    [self.tableView reloadData];
    
    // 1. content height is long enough
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        self.fullScreenScroll.shouldHideNavigationBarOnScroll=YES;
    }
    // 2. content height is too short
    else
    {
        self.fullScreenScroll.shouldHideNavigationBarOnScroll=NO;
    }
    
    
}
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
- (void)pulledToRefresh
{
    //[self callHomeService:@""];
}

//-(void)showGestureView
//{
//	if (![self.view.subviews containsObject:mGestureView]) {
//		[self.view addSubview:mGestureView];
//	}
//}
//
//-(void)hideGestureView {
//	if ([self.view.subviews containsObject:mGestureView]) {
//		[mGestureView removeFromSuperview];
//	}
//}

-(void)menuButtonSelected
{
	mMenuButton.selected = YES;
}

-(void)menuButtonUnselected
{
	mMenuButton.selected = NO;
}

- (void) solrCouponRequest
{
    [mHudPresenter presentHud];
    [mRequestsArray removeAllObjects];
    
    NSString *locKey = [[Location getInstance] userLocation];
    NSArray *listItems = [locKey componentsSeparatedByString:@";"];
    NSString *tStringLat = [listItems objectAtIndex:0];
    NSString *tLatitude = [tStringLat substringWithRange:NSMakeRange(4, [tStringLat length]-4)];
    NSString *tStringLong = [listItems objectAtIndex:1];
    NSString *tLongitude = [tStringLong substringWithRange:NSMakeRange(4, [tStringLong length]-4)];
    
    CLLocation *tCurrentLocation = [[Location getInstance] getCurrentLocation];
    
    DPKMakeURL *tNearMeURL = [[DPKMakeURL alloc] initWithMainURL:KURL_SolrCouponRequest];
    [tNearMeURL setParamValue:@"*:*" forKey:@"q"];
    [tNearMeURL setParamValue:@"json" forKey:@"wt"];
    [tNearMeURL setParamValue:@"0" forKey:@"start"];
    [tNearMeURL setParamValue:@"20" forKey:@"rows"];
    
    [tNearMeURL setParamValue:@"{!bbox}" forKey:@"fq"];
    
    [tNearMeURL setParamValue:@"geo_coordinate" forKey:@"sfield"];
    [tNearMeURL setParamValue:[NSString stringWithFormat:@"%f,%f&d=50", tCurrentLocation.coordinate.latitude,tCurrentLocation.coordinate.longitude] forKey:@"pt"];
    [tNearMeURL setParamValue:@"geodist() asc" forKey:@"sort"];
    
    //NSLog(@"shiufiewhnfierwfj %@",tNearMeURL);
    
    DPKMakeURL *tWhatsHotURL = [[DPKMakeURL alloc] initWithMainURL:KURL_SolrCouponRequest];
    [tWhatsHotURL setParamValue:@"*:*" forKey:@"q"];
    [tWhatsHotURL setParamValue:@"json" forKey:@"wt"];
    [tWhatsHotURL setParamValue:@"0" forKey:@"start"];
    [tWhatsHotURL setParamValue:@"20" forKey:@"rows"];
    
    [tWhatsHotURL setParamValue:@"(hot_deal:true)AND{!bbox}" forKey:@"fq"];
    
    [tWhatsHotURL setParamValue:@"geo_coordinate" forKey:@"sfield"];
    [tWhatsHotURL setParamValue:[NSString stringWithFormat:@"%@,%@&d=50", tLatitude,tLongitude] forKey:@"pt"];
    [tWhatsHotURL setParamValue:@"geodist() asc" forKey:@"sort"];
    
    DPKMakeURL *tMostPopularURL = [[DPKMakeURL alloc] initWithMainURL:KURL_SolrCouponRequest];
    [tMostPopularURL setParamValue:@"*:*" forKey:@"q"];
    [tMostPopularURL setParamValue:@"json" forKey:@"wt"];
    [tMostPopularURL setParamValue:@"0" forKey:@"start"];
    [tMostPopularURL setParamValue:@"20" forKey:@"rows"];
    
    [tMostPopularURL setParamValue:@"{!bbox}" forKey:@"fq"];
    
    
    [tMostPopularURL setParamValue:@"geo_coordinate" forKey:@"sfield"];
    [tMostPopularURL setParamValue:[NSString stringWithFormat:@"%@,%@&d=50", tLatitude,tLongitude] forKey:@"pt"];
    [tMostPopularURL setParamValue:@"downloads desc,geodist() asc" forKey:@"sort"];
    
    NSMutableArray *mCouponPrefencesArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"CouponPrefences"]];
    
    //NSLog(@"....%@",mCouponPrefencesArray);
    NSString *tCategoryString = [NSString new];
    NSString *tCategoryID = [NSString new];
    for (int i = 0; i < [mCouponPrefencesArray count]; i++) {
        tCategoryID = [mCouponPrefencesArray objectAtIndex:i];
        if ([tCategoryID doubleValue] != 0) {
            if (i == [mCouponPrefencesArray count] -1) {
                tCategoryString = [tCategoryString stringByAppendingFormat:@"category_ids:%@", tCategoryID];
            }
            else{
                tCategoryString = [tCategoryString stringByAppendingFormat:@"category_ids:%@  OR ", tCategoryID];
            }
            
        }
    }
    //NSLog(@"Category Id :%@",tCategoryString);
    
    DPKMakeURL *tRecommendedURL = [[DPKMakeURL alloc] initWithMainURL:KURL_SolrCouponRequest];
    [tRecommendedURL setParamValue:@"*:*" forKey:@"q"];
    [tRecommendedURL setParamValue:@"json" forKey:@"wt"];
    [tRecommendedURL setParamValue:@"0" forKey:@"start"];
    [tRecommendedURL setParamValue:@"20" forKey:@"rows"];
    if ([tCategoryID doubleValue] == 0) {
        [tRecommendedURL setParamValue:@"{!bbox}" forKey:@"fq"];
    } else {
        [tRecommendedURL setParamValue:[NSString stringWithFormat:@"(%@)AND{!bbox}", tCategoryString] forKey:@"fq"];
    }
    [tRecommendedURL setParamValue:@"geo_coordinate" forKey:@"sfield"];
    [tRecommendedURL setParamValue:[NSString stringWithFormat:@"%@,%@&d=50", tLatitude,tLongitude] forKey:@"pt"];
    [tRecommendedURL setParamValue:@"geodist() asc" forKey:@"sort"];
    
    
    [mRequestsArray addObject:[[Request alloc] initWithRequestURL:[tWhatsHotURL getPreparedURL] type:kWhatsHotCouponRequest]];
    
    [mRequestsArray addObject:[[Request alloc] initWithRequestURL:[tNearMeURL getPreparedURL] type:kNearMeCouponRequest]];
    
    [mRequestsArray addObject:[[Request alloc] initWithRequestURL:[tMostPopularURL getPreparedURL] type:kMostPopularCouponRequest]];
    if ([mCouponPrefencesArray count]) {
        [mRequestsArray addObject:[[Request alloc] initWithRequestURL:[tRecommendedURL getPreparedURL] type:kRecommendeCouponRequest]];
    }
    
    [self fetchRequestURLs];
}

- (void) fetchRequestURLs
{
    //NSLog(@"------fetchRequestURLs:%d", [mRequestsArray count]);
    
    if ([mRequestsArray count]) {
        Request *tRequest = [mRequestsArray objectAtIndex:0];
        [[RequestHandler getInstance] getRequestURL:tRequest.mRequestURL delegate:self requestType:tRequest.mRequestType];
        [mRequestsArray removeObjectAtIndex:0];
    }
    else{
        //[self doneLoadingTableViewData];
        [mHudPresenter hideHud];
        [self loadCouponsForGroupID:mGroupType category:mCategoryID];
        
    }
}


-(void)backButton:(id)sender
{
    
    if (mDelegate)
    {
        [mDelegate couponListViewController:self isBack:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) loadCouponsForGroupID:(NSInteger)pGroupID category:(NSInteger)pCategoryID
{
    /*
     if (mCouponListArray) {
     [mCouponListArray removeAllObjects];
     mCouponListArray = nil;
     mLimits = 0;
     }
     
     mDBCouponArray = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchCouponIDsWithGroupID:pGroupID categoryID:pCategoryID limit:mLimits error:nil]];
     mCouponListArray = [[NSMutableArray alloc] initWithArray:mDBCouponArray];
     mCount = [[Repository sharedRepository]mTotalArraycount];*/
  //  [self reloadTableView];
    
}

-(void)loadData:(NSInteger)pGroupID category:(NSInteger)pCategoryID {
    
    
    if (mDBCouponArray) {
        [mDBCouponArray removeAllObjects];
        mDBCouponArray = nil;
    }
    
    mLimits = mLimits + kNumberOfItemsToDisplay;
    mDBCouponArray = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchCouponIDsWithGroupID:pGroupID categoryID:pCategoryID limit:mLimits error:nil]];
    
    NSMutableArray *tNewItemArray = [[NSMutableArray alloc] init];
    for (int i = 0; i< [mDBCouponArray count] ; i++)
    {
        [tNewItemArray addObject:[mDBCouponArray objectAtIndex:i]];
    }
    
    [mCouponListArray addObjectsFromArray:tNewItemArray];
    [mHudPresenter hideHud];
    
    [self reloadTableView];
}




// Categories List
-(void)categoryView:(id)sender
{
    if(hide)
    {
        [self searchView:nil];
    }
    
    CategoriesViewController *tCategoriesViewController = [CategoriesViewController new];
    
    tCategoriesViewController.mDelegate = self;
    tCategoriesViewController.mSelectedCategoryID = mCategoryID;
    
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:tCategoriesViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

- (void) categoriesViewController:(CategoriesViewController *)pCategoriesViewController selectedCategoryID:(NSNumber *)pID
{
    //NSLog(@"selectedCategoryID:%d", [pID integerValue]);
    mSelectionType = kCategorySelection;
    mCategoryID = pID;
    [self loadCouponsForGroupID:mGroupType category:[pID integerValue]];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(showHeaderfooter)
    {
        return 40.0;
    }
    return 0.0;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if(showHeaderfooter)
//    {
//        return 30.0;
//    }
//    return 0.0;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  
    UIView *v=[[UIView alloc]initWithFrame:CGRectZero];
    v.backgroundColor=[UIColor whiteColor];
    [v addSubview:segmentedControl];
    if(showHeaderfooter)
        return v;
    return nil;
}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//
//UILabel* buttomLabel=[[UILabel alloc]initWithFrame:CGRectZero];
//[buttomLabel setBackgroundColor:[UIColor appGreenColor]];
//buttomLabel.text=@"© 2014 Couwalla. All rights reserved";
//buttomLabel.font=[UIFont boldSystemFontOfSize:12.0];
//buttomLabel.textColor=[UIColor whiteColor];
//buttomLabel.textAlignment=NSTextAlignmentCenter;
//    return buttomLabel;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int coutForArray=[mCouponListArray count];
    if(coutForArray==0)
    {
        return 0;
    }else
        if (coutForArray<=3)
        {
            return 1;
        }else {
            int countForRow=coutForArray/3;
            if (coutForArray%3 !=0) {
                return countForRow+1;
            }else{
                return countForRow;
            }
        }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
 	static NSString *CellIdentifier1 = @"CellTest";
    
    
    CouponTableCell *cell= (CouponTableCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil) {
        cell = [[CouponTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    int margin=3;
    
    int countForRow=[mCouponListArray count]/3;
    if ([mCouponListArray count]%3 !=0)
    {
        countForRow= countForRow+1;
    }
    int count=3;
    if (indexPath.row==countForRow-1 && [mCouponListArray count]>3 && [mCouponListArray count]%3 !=0)
    {
        count=[mCouponListArray count]%3;
    }
    else if ([mCouponListArray count]<=3)
    {
        count=[mCouponListArray count];
    }
    int i;
    for ( i = 0; i < count; i++)
    {
        CGRect frame=CGRectMake(kItemWidth * i+margin, 0, kItemWidth, kItemHeight);
        margin=margin+3;
        
        CouponView *tCouponView = [[CouponView alloc] init];
        [tCouponView.view removeFromSuperview];
        tCouponView.mTopRightView.hidden=YES;
        tCouponView.view.frame = frame;
        
        NSURL *image=[NSURL URLWithString:[listcoupon_image objectAtIndex:(indexPath.row *3)+i]];
        [tCouponView.mItemButton setBackgroundImageWithURL:image placeholderImage:nil];
        [tCouponView.mItemButton setContentMode:UIViewContentModeScaleAspectFit];
        tCouponView.mItemButton.tag=(indexPath.row *3)+i;
        [tCouponView.mItemButton addTarget:self action:@selector(actionOnImage:) forControlEvents:UIControlEventTouchUpInside];
        
        if([[[mCouponListArray objectAtIndex:(indexPath.row *3)+i] valueForKey:@"promo_text_short"] length])
            tCouponView.mTopRightView.hidden=NO;
        
        tCouponView.mTopRightLabel.text = [[mCouponListArray objectAtIndex:(indexPath.row *3)+i] valueForKey:@"promo_text_short"];
        tCouponView.mButtomLable.text = [[mCouponListArray objectAtIndex:(indexPath.row *3)+i] valueForKey:@"name"];
        
        [tCouponView.mItemButton addSubview:tCouponView.mTopRightView];
        
        [cell.contentView addSubview:tCouponView.view];
    }
    
    
    
    return cell;
}


- (void)loadCouponListData {
    [self loadData:mGroupType category:mCategoryID];
    
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    //    Coupon *tCoupon = [listcoupon_actualimage objectAtIndex:indexPath.row];
    //
    //    CouponDetailViewController *tController = [CouponDetailViewController new];
    //    tController.mCoupon = tCoupon;
    //    tController.mCouponName           = [listCouponName objectAtIndex:indexPath.row];
    //    tController.mCouponPromoTextShort = [listcouponShortText  objectAtIndex:indexPath.row];
    //    tController.mCouponPromoTextLong  = [listcouponShortText   objectAtIndex:indexPath.row];
    //    tController.mCouponExpireDate     = [listcouponExpireDate objectAtIndex:indexPath.row];
    //    tController.mCouponID = [listcouponID objectAtIndex:indexPath.row];
    //    tController.locatarray = [listlocationarray objectAtIndex:indexPath.row];
    //    [self.navigationController pushViewController:tController animated:YES];
    
}

-(void)actionOnImage:(UIButton *)bt
{
    Coupon *tCoupon = [listcoupon_actualimage objectAtIndex:bt.tag];
    
    CouponDetailViewController *tController = [CouponDetailViewController new];
    tController.mCoupon                     = tCoupon;
    tController.mCouponName                 = [listCouponName objectAtIndex:bt.tag];
    tController.mCouponPromoTextShort       = [listcouponShortText  objectAtIndex:bt.tag];
    tController.mCouponPromoTextLong        = [listcouponLongtext   objectAtIndex:bt.tag];
    tController.mCouponExpireDate           = [listcouponExpireDate objectAtIndex:bt.tag];
    tController.mCouponID                   = [listcouponID objectAtIndex:bt.tag];
    tController.locatarray                  = [listlocationarray objectAtIndex:bt.tag];
    tController.mCodeType                   = [listCodeType objectAtIndex:bt.tag];
    tController.mCouponImage                = [listcoupon_image objectAtIndex:bt.tag];
    tController.mBarcodeImage               = [listBarcodeImage objectAtIndex:bt.tag];
    tController.mCouponDescription          = [listDescription objectAtIndex:bt.tag];
        
    [self.navigationController pushViewController:tController animated:YES];
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
    
    if (pRequestType == kCouponQueryRequest) {
        if (!pError) {
            [self loadCouponsForGroupID:mGroupType category:mCategoryID];
            //[self doneLoadingTableViewData];
            //            [self refreshTableView];
        } else {
            //NSLog(@"Request Failed:%d | Code:%d | Message:%@",pRequestType, pError.mErrorCode.intValue, pError.mMessage);
            
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Unable to fetch coupons" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        }
    }
    else if (pRequestType == kNearMeCouponRequest) {
        if (!pError) {
            [self performSelector:@selector(fetchRequestURLs) withObject:nil afterDelay:0.1];
            
        } else {
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Unable to fetch coupons" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
            
        }
    }
    else if (pRequestType == kWhatsHotCouponRequest) {
        if (!pError) {
            [self performSelector:@selector(fetchRequestURLs) withObject:nil afterDelay:0.1];
            
        } else {
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Unable to fetch coupons" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
            
        }
    }
    else if (pRequestType == kTodaysDealCouponRequest) {
        if (!pError) {
            [self performSelector:@selector(fetchRequestURLs) withObject:nil afterDelay:0.1];
        } else {
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Unable to fetch coupons" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
        }
    }
    else if (pRequestType == kMostPopularCouponRequest) {
        if (!pError) {
            [self performSelector:@selector(fetchRequestURLs) withObject:nil afterDelay:0.1];
            
        } else {
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Unable to fetch coupons" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
            
        }
    }
    else if (pRequestType == kRecommendeCouponRequest) {
        if (!pError) {
            [self performSelector:@selector(fetchRequestURLs) withObject:nil afterDelay:0.1];
        } else {
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Unable to fetch coupons" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
            
        }
    }
    
    
}


- (void) removeAllUnMarkedCoupons{
    if ([[Repository sharedRepository] deleteAllUnMarkedCoupons]) {
        //NSLog(@" deleteAllUnMarkedCoupons ");
        [mHudPresenter presentHud];
        [self solrCouponRequest];
        
    }
    else{
        //NSLog(@"fail - deleteAllUnMarkedCoupons ");
    }
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    if ([[RequestHandler getInstance] checkInternet]) {
        
        [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(removeAllUnMarkedCoupons) userInfo:nil repeats:NO];
    }
    _reloading = YES;
    
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

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
	// This enables the user to scroll down the navbar by tapping the status bar.
	[self performSelector:@selector(showNavbar) withObject:nil afterDelay:0.1];
	
	return YES;
}

-(void)showHeaderFooter
{
    showHeaderfooter=YES;
    [self showViewForFooterOfTableView];

    self.tableView.tableFooterView.hidden=NO;
    //    buttomLabel.transform = CGAffineTransformMakeTranslation(0, +40);
//    [UIView animateWithDuration:0.3 animations:^{
//        buttomLabel.transform = CGAffineTransformIdentity;
//        
//    }];
    self.tableView.tableHeaderView.hidden =NO;
    [self reloadTableView];
}

-(void)hiddenHeaderFooter
{
    showHeaderfooter=NO;
    [self hideViewForFooterOfTableView];

    self.tableView.tableFooterView.hidden=YES;
    self.tableView.tableHeaderView.hidden=YES;
    [self reloadTableView];
}
- (void)MySegmentControlAction:(UISegmentedControl *)segment
{
   // [self.tableView setContentOffset:CGPointZero animated:NO];
    
    if(segment.selectedSegmentIndex == 0)
    {
        mCouponListArray=[self.mDataDictionary valueForKey:@"whatshot"];
    }
    if(segment.selectedSegmentIndex == 1)
    {
        mCouponListArray=[self.mDataDictionary valueForKey:@"popular_data"];
    }
    if(segment.selectedSegmentIndex == 2)
    {
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        {
            if([[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreference])
            {
                mCouponListArray =[self.mDataDictionary valueForKey:@"nearme_data"];
            }
            else
            {
                mCouponListArray=[[NSMutableArray alloc]init];
            }
        }
        else
        {
            mCouponListArray =[self.mDataDictionary valueForKey:@"nearme_data"];
        }

    }
    [self reloadTableView];
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

#pragma mark-search

-(void)searchView:(id)sender
{
    if(!hide)
    {
        [self.view addSubview:hideView];
        [self.view addSubview:searchBar];
        [self.tableView setContentOffset:CGPointZero animated:NO];
        
        self.tableView.scrollEnabled=NO;
        searchBar.transform = CGAffineTransformMakeTranslation(0, -44);
        [UIView animateWithDuration:0.3 animations:^{
            searchBar.transform = CGAffineTransformIdentity;
        }];
        [searchBar becomeFirstResponder];
        hide=!hide;
    }
    else
    {
        
        //        hideView.hidden=YES;
        //        searchBar.hidden=YES;
        self.tableView.scrollEnabled=YES;
        
        searchBar.transform = CGAffineTransformMakeTranslation(0, 0);
        [UIView animateWithDuration:0.3 animations:^{
            searchBar.alpha = 0.0;
        }];
        [hideView removeFromSuperview];
        [searchBar removeFromSuperview];
        searchBar.alpha = 1.0;
        [searchBar resignFirstResponder];
        hide=!hide;
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    [HUDManager showHUDWithText:@"Please Wait..."];
    [searchBar1 resignFirstResponder];
    
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        msearchType =kCouponSearch;
        if ([searchBar1.text length] == 0)
        {
            return;
        }
        else
        {
            
            SearchViewController *tSearchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
            tSearchViewController.mSearchText = searchBar1.text;
            
            [self.navigationController pushViewController:tSearchViewController animated:YES];
            
        }
    });
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar1 {
    [self handleSearch:searchBar1];
}

- (void)handleSearch:(UISearchBar *)searchBar1
{
    NSLog(@"User searched for %@", searchBar1.text);
    [searchBar1 resignFirstResponder]; // if you want the keyboard to go away
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar1 {
    NSLog(@"User canceled search");
    [searchBar1 resignFirstResponder];// if you want the keyboard to go away
}

#pragma -mark UIScrollViewDelegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat deltaY = contentOffsetY - self.lastContentOffsetY;
    if (deltaY < 0.0f) {
        [UIView animateWithDuration:0.1 animations:^{
            
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            [self showViewForFooterOfTableView];
        }];
    } else if (deltaY > 0.0f) {
        [UIView animateWithDuration:0.1 animations:^{
        
            scrollView.contentInset = UIEdgeInsetsMake(-40, 0, 0, 0);
            [self hideViewForFooterOfTableView];
        }];

    }
    
//    CGFloat sectionHeaderHeight = 40;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    self.lastContentOffsetY=scrollView.contentOffset.y;
}

#pragma -mark Show Hide Footer View Methods

-(void)showViewForFooterOfTableView
{
    [self.navigationController.scrollNavigationBar resetToDefaultPosition:YES];
    [buttomLabel setFrame:CGRectMake(0, CGRectGetMaxY([currentWindow frame])-30, 320, 30)];
    [buttomLabel setBackgroundColor:[UIColor appGreenColor]];
    buttomLabel.text=@"© 2014 Couwalla. All rights reserved";
    buttomLabel.font=[UIFont boldSystemFontOfSize:12.0];
    buttomLabel.textColor=[UIColor whiteColor];
    buttomLabel.textAlignment=NSTextAlignmentCenter;
    
    //    [self.view addSubview:buttomLabel];
    
    [currentWindow addSubview:buttomLabel];
}
-(void)hideViewForFooterOfTableView
{
    
    [buttomLabel setFrame:CGRectMake(0, 538, 320, 0)];
}

//-(void)callHomeService:(NSString *)str
//{
//    //[HUDManager showHUDWithText:kHudMassage];
//    
//   NSString* userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
//   NSString* latstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"latvalue"];
//   NSString* longstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"longvalue"];
//    NSMutableDictionary *myDic = [NSMutableDictionary dictionaryWithCapacity:7];
//    [myDic setValue:str forKey:@"categoryid"];
//    [myDic setValue:userkey forKey:@"userid"];
//    [myDic setValue:latstr forKey:@"latitude"];
//    [myDic setValue:longstr forKey:@"longitude"];
//    [[CoupitService service] homepageCoupons:myDic completionHandler:^(NSDictionary *result, NSError *error)
//     {
//         
//         if (error)
//         {
//             [[[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//             [[LocalyticsSession shared] tagEvent:kErrorSummary attributes:@{kError:[error localizedDescription]}];
//             // [HUDManager hideHUD];
//             [self.refreshControl endRefreshing];
//             
//         }
//         else
//         {
//             
//             self.mDataDictionary =[result copy];
//            
//             switch (self.buttonTag)
//             {
//                 case 0:
//                     mCouponListArray=[self.mDataDictionary valueForKey:@"whatshot"];
//
//                     break;
//                 case 1:
//                     mCouponListArray=[self.mDataDictionary valueForKey:@"popular_data"];
//
//                     break;
//                 case 2:
//                     mCouponListArray =[self.mDataDictionary valueForKey:@"nearme_data"];
//
//                     break;
//                     
//                 default:
//                     break;
//             }
//             
////             itemsArray = [[NSMutableArray alloc]init];
////             hotarray=[result valueForKey:@"whatshot"];
////             nearmearray =[result valueForKey:@"nearme_data"];
////             itemsArray=[result valueForKey:@"popular_data"];
////             
////             coupon_image            = [itemsArray valueForKey:@"coupon_thumbnail"];
////             CouponName              = [itemsArray valueForKey:@"name"];
////             couponShortText         = [itemsArray valueForKey:@"promo_text_short"];
////             couponLongtext          = [itemsArray valueForKey:@"promo_text_long"];
////             couponExpireDate        = [itemsArray valueForKey:@"expiry_date"];
////             couponID                = [itemsArray valueForKey:@"id"];
////             locationarray           = [itemsArray valueForKey:@"store_name"];
////             BarcodeImage            = [itemsArray valueForKey:@"barcode_image"];
////             CodeType                = [itemsArray valueForKey:@"code_type"];
////             couponDescription       = [itemsArray valueForKey:@"coupon_description"];
////             
////             hotcoupon_image         = [hotarray valueForKey:@"coupon_thumbnail"];
////             hotCouponName           = [hotarray valueForKey:@"name"];
////             hotcouponShortText      = [hotarray valueForKey:@"promo_text_short"];
////             hotcouponLongtext       = [hotarray valueForKey:@"promo_text_long"];
////             hotcouponExpireDate     = [hotarray valueForKey:@"expiry_date"];
////             hotcouponID             = [hotarray valueForKey:@"id"];
////             hotlocationarray        = [hotarray valueForKey:@"store_name"];
////             hotBarcodeImage         = [hotarray valueForKey:@"barcode_image"];
////             hotCodeType             = [hotarray valueForKey:@"code_type"];
////             hotcouponDescription    = [hotarray valueForKey:@"coupon_description"];
////             
////             nearcoupon_image        = [nearmearray valueForKey:@"coupon_thumbnail"];
////             nearCouponName          = [nearmearray valueForKey:@"name"];
////             nearcouponShortText     = [nearmearray valueForKey:@"promo_text_short"];
////             nearcouponLongtext      = [nearmearray valueForKey:@"promo_text_long"];
////             nearcouponExpireDate    = [nearmearray valueForKey:@"expiry_date"];
////             nearcouponID            = [nearmearray valueForKey:@"id"];
////             nearlocationarray       = [nearmearray valueForKey:@"store_name"];
////             nearBarcodeImage        = [nearmearray valueForKey:@"barcode_image"];
////             nearCodeType            = [nearmearray valueForKey:@"code_type"];
////             nearcouponDescription   = [nearmearray valueForKey:@"coupon_description"];
////             
////             mCountryNameArray       = [NSMutableArray new];
////             mCountryCodeArray       = [NSMutableArray new];
////             mRequestsArray          = [NSMutableArray new];
////             
////             //[HUDManager hideHUD];
////             [mTableView reloadData];
//             [self reloadTableView];
//             [self.refreshControl endRefreshing];
//         }
//         
//     }];
//}

@end

