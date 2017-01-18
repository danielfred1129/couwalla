//
//  MyCouponViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MyCouponViewController.h"

#import "NewMyCouponsCell.h"
#import "Coupon.h"
#import "FileUtils.h"
#import "WebViewController.h"
#import "AppDelegate.h"
#import "Card.h"
#import "MyCoupons.h"
//#import "KxMenu.h"
#import "PlannerListViewController.h"
#import "FavouriteViewController.h"
#import "jsonparse.h"
#import "appcommon.h"
#import "MyCoupons.h"
#import "CouponRedeemViewerViewController.h"
#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "UIColor+AppTheme.h"
#import "IQKeyboardManager.h"
#import "GTScrollNavigationBar.h"
#import "CoupitService.h"
#import "CouponDetailViewController.h"
#import "CouponsListCell.h"



#define kAlertViewOne 1
#define kAlertViewTwo 2
#define kAlertViewThree 3
#define kAlertViewFour 4

#define kproductTitleColor [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1.0]
#define kproductSubTitleColor [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]

static int hide;

@interface MyCouponViewController ()

@property (assign, nonatomic) CGFloat lastContentOffsetY;

@end

@implementation MyCouponViewController
{
    UIView *mGestureView;
    UIButton *mMenuButton;
    UIButton *mFavriteButton;
    
    NSMutableArray *mDownloadedCouponList;
    NSInteger mCategoryID;
    NSInteger mDeleteButtonIndex;
    NSInteger mSelectedRedeemIndex,mFavoriteCouponIndex;
    NSInteger mCouponIndex;
    NSMutableArray* mCardArray;
    
    NSArray* mIndexArray;
    NSMutableArray *mRedeemCouponArray;
    NSDate *mTodaysDate;
    UILabel *mDisplayMessage;
    BOOL mIsFavorite;
    NSMutableDictionary *reponseData;
    NSString *userkey,*catid;
    NewMyCouponsCell *cell;
    CouponsListCell *cell1;
    
    UIView *hideView;
    UISearchBar *searchBar;
    NSMutableArray *searchDummyArray;
    UITableView *searchDummyTable;
    UILabel *noResult;
    
    int shortingTag;
    UIButton *btnForFooter;
}

@synthesize mSelectionType, mTableView,mBadgeValue,switchControl;
@synthesize mCategories,mExpCoupons,mPlanner,moreView,cancellall;

#pragma mark- View lifecycle
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleBlackOpaque;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationController.scrollNavigationBar.scrollView = self.mTableView;
    
    [self.navigationController.navigationBar setTranslucent:NO];

    
    hide=0;
    shortingTag=0;
    [self addSearching];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"###" forKey:@"CatValue"];
    self.navigationItem.title = @"My Coupons";
    
    [self.mCategories setHidden:YES];
    [self.mPlanner setHidden:YES];
    [self.mExpCoupons setHidden:YES];
    
    
    moreView.hidden=YES;
    [[LocalyticsSession shared] tagEvent:@"xyz"];
    
    ////
    menuarray=[[NSArray alloc]initWithObjects:@"noerg",@"wefewf",@"juytjy", nil];
    TableView.hidden=YES;
    TableView.delegate=self;
    TableView.dataSource=self;
    TableView.tag=1;
    self.switchControl.hidden=NO;
    
    mIsFavorite = NO;
    mTodaysDate = [NSDate date];
    
    mCardArray = [NSMutableArray new];
    mRedeemCouponArray = [NSMutableArray new];
    
    if (mCardArray)
    {
        [mCardArray removeAllObjects];
        [mCardArray addObjectsFromArray:[[Repository sharedRepository] fetchAllWalletLoyaltyCards]];
        
    }
    
    mCategoryID = 0;
   // mHudPresenter = [[ProgressHudPresenter alloc] init];
    
    //Favrite Button.
    mFavriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mFavriteButton setImage:[UIImage imageNamed:@"sm_planner"] forState:UIControlStateNormal];
    [mFavriteButton setImage:[UIImage imageNamed:@"icon_planner_selected"] forState:UIControlStateSelected];
    
    [mFavriteButton sizeToFit];
    [mFavriteButton addTarget:self action:@selector(favorite:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
    
    mGestureView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealToggle:)];
	[mGestureView addGestureRecognizer:recognizer];
	UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
	[mGestureView addGestureRecognizer:panRecognizer];
    
    
    if (mSelectionType == kSeeListViewSelection)
    {
        //Back Button.
        UIButton *tbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tbackButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
        [tbackButton sizeToFit];
        [tbackButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *tBackBar = [[UIBarButtonItem alloc]initWithCustomView:tbackButton];
        self.navigationItem.leftBarButtonItem = tBackBar;
        
    }
    else
    {
        
        
        mMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [mMenuButton setImage:[UIImage imageNamed:@"button_menu"] forState:UIControlStateNormal];
        [mMenuButton sizeToFit];
        [mMenuButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:mMenuButton];
        self.navigationItem.leftBarButtonItem = menuBarButton;
        
    }
    
    //RightItem
    
//    _btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
//    _btn4.frame = CGRectMake(0, 0, 38, 30);
//    [_btn4 setBackgroundImage:[UIImage imageNamed:@"btn_more"] forState:UIControlStateNormal];
//    [_btn4 addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* menuBarButton2 = [[UIBarButtonItem alloc] initWithCustomView:_btn4];
//    
//    UIButton *tSearchButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    tSearchButton.frame = CGRectMake(0, 0, 38, 30);
//    [tSearchButton setImage:[UIImage imageNamed:@"button_search.png"] forState:UIControlStateNormal];
//    [tSearchButton addTarget:self action:@selector(searchView:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    UIBarButtonItem *menuBarCategory = [[UIBarButtonItem alloc]initWithCustomView:tSearchButton];
//    self.navigationItem.rightBarButtonItem = menuBarCategory;
    
    
    [self.navigationController.navigationBar addSubview:_btn4];
    cancellall.hidden=YES;
    
    //Footer button
    
    btnForFooter=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, 310,30)];
    [btnForFooter addTarget:self action:@selector(redeemAll:) forControlEvents:UIControlEventTouchUpInside];
    [btnForFooter setBackgroundImage:[UIImage imageNamed:@"big_redeemUnselected@2x"] forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[LocalyticsSession shared] tagScreen:kMyCouponsScreen];
}
- (void) couponsWithDict:(NSDictionary *)pDict
{
    pDict = [[reponseData objectForKey:@"data"] objectAtIndex:0];
    
}

- (void)favorite {
    
    FavouriteViewController *favouriteViewController = [[FavouriteViewController alloc]initWithNibName:@"FavouriteViewController" bundle:[NSBundle mainBundle]];
    
    [self.navigationController pushViewController:favouriteViewController animated:YES];
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
   
    [_btn4 setHidden:NO];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar=NO;
    [IQKeyboardManager sharedManager].enable=NO;
    
    [self refreshList];
    
    if (self.interfaceOrientation != UIInterfaceOrientationPortrait)
    {
        // http://stackoverflow.com/questions/181780/is-there-a-documented-way-to-set-the-iphone-orientation
        // http://openradar.appspot.com/radar?id=697
        // [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait]; // Using the following code to get around apple's static analysis...
        [[UIDevice currentDevice] performSelector:NSSelectorFromString(@"setOrientation:") withObject:(__bridge id)((void*)UIInterfaceOrientationPortrait)];
    }
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar=YES;
    [IQKeyboardManager sharedManager].enable=YES;
    hide=YES;
    [self searchView:nil];
}
-(void)addSearching
{
//    searchDummyArray=[[NSMutableArray alloc]init];
//    
//    searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0,0,320,40)];
//    [searchBar setTintColor:[UIColor appGreenColor]];
//    searchBar.barTintColor=[UIColor whiteColor];
//    [searchBar setPlaceholder:@"Search"];
//    searchBar.hidden=YES;
//    searchBar.showsCancelButton=YES;
//    [searchBar setDelegate:self];
//    
//   // NSLog(@"%f",self.view.frame.size.height);
//    
//    searchDummyTable=[[UITableView alloc]initWithFrame:CGRectMake(0,40,320,CGRectGetMaxY(self.view.frame))];
//    [searchDummyTable setDataSource:self];
//    [searchDummyTable setDelegate:self];
//    searchDummyTable.hidden=YES;
//    searchDummyTable.separatorColor = [UIColor clearColor];
//    
//    noResult=[[UILabel alloc]initWithFrame:CGRectMake(120, 100,320,100)];
//    
//    hideView =[[UIView alloc]initWithFrame:CGRectMake(0,0,320,[UIScreen mainScreen].bounds.size.height-60)];
//    [hideView setBackgroundColor:[UIColor darkGrayColor]];
//    [hideView setAlpha:1.0];
//    hideView.hidden=YES;
//    
//    UITapGestureRecognizer *tapRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchView:)];
//    [tapRecognizer1 setNumberOfTapsRequired:2];
//    hideView.userInteractionEnabled = YES;
//    [hideView addGestureRecognizer:tapRecognizer1];
//   
//    [hideView addSubview:searchDummyTable];
//    [hideView addSubview:searchBar];
//    [self.view addSubview:hideView];
    
    
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
    
    hideView =[[UIView alloc]initWithFrame:CGRectMake(0,-20,320,[UIScreen mainScreen].bounds.size.height+20)];
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


- (void) refreshList
{
    [self getMyCoupon];

}

- (void) redeemListViewController:(RedeemAllViewController *)pRedeem isBack:(BOOL)pValue
{
    if (pValue)
    {
        [self refreshList];
    }
}
- (void) redeemViewController:(RedeemCouponViewController *)pRedeem isBack:(BOOL)pValue
{
    if (pValue)
    {
        [self refreshList];
    }
}

- (IBAction)mDeleteAll:(id)sender
{
    
    [mDownloadedCouponList removeAllObjects];
    [self.mTableView reloadData];
    
}


- (IBAction)switchTapped:(id)sender {
    //NSLog(@"switche value changed");
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

- (void) backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES ];
}


// Categories
- (void) filterAction:(UIButton* )sender
{
    [[LocalyticsSession shared] tagEvent:@"mycoupon"];
    moreView.hidden=NO;
    [self.mCategories setHidden:NO];
    [self.mPlanner setHidden:NO];
    [self.mExpCoupons setHidden:NO];
    
    //NSLog(@"inside filterAction");
    
    if ([_btn4 isTouchInside])
    {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"More"
                              message:@""
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Planner", @"Categories", nil];
        alert.tag=1;
        [alert show];
        
    }
    
    [self.view addSubview:TableView];
    
    
    
}

- (void) categoriesViewController:(MyCouponViewController *)pCategoriesViewController selectedCategoryID:(NSNumber *)pID
{
    mCategoryID = [pID intValue];
    //NSLog(@"selectedCategoryID:%d", [pID integerValue]);
    
    catid = pID;
    
    //NSLog(@"categoriesViewController >> %@",catid);
    
    [self viewWillAppear:YES];
    
    
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == searchDummyTable)
        return 102.0;
    return 146.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView==searchDummyTable)
        return 1.0;
    return 40.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    mDisplayMessage.text=@"";
    
    if([mDownloadedCouponList count]==0)
    {
		mDisplayMessage = [[UILabel alloc]initWithFrame:CGRectMake(45, 200, 320, 35)];
        mDisplayMessage.font = [UIFont systemFontOfSize:14.0f];
        mDisplayMessage.textColor = [UIColor colorWithRed:(102/255.0) green:(102/255.0) blue:(102/255.0) alpha:1.0];
        mDisplayMessage.backgroundColor = [UIColor clearColor];
        if (mIsFavorite)
        {
            mDisplayMessage.text = @"No Coupons marked favorite";
        } else {
            mDisplayMessage.text = @"No Coupons have been downloaded";
            //mRedeemAllButton.hidden =YES
            
        }
		[tableView addSubview:mDisplayMessage];
    }
    else
    {
        [mDisplayMessage removeFromSuperview];
    }
    
    if(tableView==searchDummyTable)
        return [searchDummyArray count];
    return [mDownloadedCouponList count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(tableView!=searchDummyTable)
    return 40;
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v=[[UIView alloc]initWithFrame:CGRectZero];
    [v setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BG_CouponCell@2x"]]];
    [v addSubview:btnForFooter];

    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v=[[UIView alloc]initWithFrame:CGRectZero];
    v.backgroundColor=[UIColor whiteColor];
    NSArray *itemArray = [NSArray arrayWithObjects: @"A-Z", @"%OFF", @"Company",@"Expiring",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame=CGRectMake(5, 5, 310, 30);
    [segmentedControl setTintColor:[UIColor appGreenColor]];
    segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    [segmentedControl addTarget:self action:@selector(MySegmentControlAction:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = shortingTag;
    if(tableView!=searchDummyTable)
    [v addSubview:segmentedControl];
    return v;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView!=searchDummyTable)
    {
        static NSString *CellIdentifier = @"NewMyCouponsCell";
        
        
        cell = (NewMyCouponsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NewMyCouponsCell" owner:self options:nil];
            cell = (NewMyCouponsCell *)[topLevelObjects objectAtIndex:0];
        }
        if(shortingTag==1)
        {
            cell.titleLabel.textColor        = kproductSubTitleColor;
            cell.discriptionLabel.textColor  = kproductSubTitleColor;
            cell.offerLabel.textColor        = [UIColor appGreenColor];
            cell.validLabel.textColor        = kproductSubTitleColor;
        }
        else if(shortingTag==2)
        {
            cell.titleLabel.textColor        =kproductSubTitleColor;
            cell.discriptionLabel.textColor  =kproductSubTitleColor;
            cell.offerLabel.textColor        =kproductSubTitleColor;
            cell.validLabel.textColor        =kproductSubTitleColor;
        }
        else if(shortingTag==3)
        {
            cell.titleLabel.textColor        =kproductSubTitleColor;
            cell.discriptionLabel.textColor  =kproductSubTitleColor;
            cell.offerLabel.textColor        =kproductSubTitleColor;
            cell.validLabel.textColor        =[UIColor appGreenColor];
            
        }
        else
        {
            cell.titleLabel.textColor        = [UIColor appGreenColor];
            cell.discriptionLabel.textColor  = kproductSubTitleColor;
            cell.offerLabel.textColor        = kproductSubTitleColor;
            cell.validLabel.textColor        = kproductSubTitleColor;
        }
        
        
        
        
        MyCoupons *tCoupon = [mDownloadedCouponList objectAtIndex:indexPath.row];
        
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
        
        
        
        
        cell.titleLabel.text        =   [tCoupon valueForKey:@"name"];
        cell.discriptionLabel.text  =   [tCoupon valueForKey:@"promo_text_long"];
        cell.offerLabel.text        =   [tCoupon valueForKey:@"promo_text_short"];
        cell.validLabel.text        =   str;
        
        // for image
        [cell.couponImage setImageWithURL:[NSURL URLWithString:[tCoupon valueForKey:@"coupon_thumbnail"]]];
        
        // CHECK MARK
        
        NSString *value = [[mDownloadedCouponList objectAtIndex:indexPath.row] valueForKey:@"CheckMark"];
   
        if([value isEqualToString:@"NO"])
        {
            [cell.checkMarkButton setImage:[UIImage imageNamed:@"icon_redeemUnselect"] forState:UIControlStateNormal];
            [cell.redeemButton setBackgroundImage:[UIImage imageNamed:@"small_redeemSelected"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.checkMarkButton setImage:[UIImage imageNamed:@"icon_redeemSelect"] forState:UIControlStateNormal];
            [cell.redeemButton setBackgroundImage:[UIImage imageNamed:@"small_redeemUnselected"] forState:UIControlStateNormal];
        }
        
        cell.checkMarkButton.tag=indexPath.row;
        [cell.checkMarkButton addTarget:self action:@selector(checkMarkAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.redeemButton.tag = indexPath.row;
        [cell.redeemButton addTarget:self action:@selector(redeemButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        
         cell.checkMarkButton.imageEdgeInsets=UIEdgeInsetsMake(0, cell.checkMarkButton.frame.size.height-30,0, 0);
        
        
        
        return cell;
        
    }
    else
    {
        static NSString *CellIdentifier1 = @"CouponsListCell";
        
        
        cell1 = (CouponsListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell1 == nil)
        {
            NSArray *topLevelObjects1 = [[NSBundle mainBundle] loadNibNamed:@"CouponsListCell" owner:self options:nil];
            cell1 = (CouponsListCell *)[topLevelObjects1 objectAtIndex:0];
        }
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
 
        
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
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    int i= (int) indexPath.row;
    [self deleteButtonSelected:i];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==mTableView)
        return UITableViewCellEditingStyleDelete;
    return UITableViewCellEditingStyleNone;
}

- (void)couponTapped:(id)sender
{
    MyCoupons *tCoupon = [mDownloadedCouponList objectAtIndex:mCouponIndex];
    UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Want to redirect at %@",tCoupon.mOnlineRedemptionUrl] delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Cancel", nil];
    tAlertView.tag = kAlertViewOne;
    [tAlertView show];
    
}

- (void)openWebView
{
    
    WebViewController *tWebViewController = [WebViewController new];
    
    [self presentViewController:tWebViewController animated:YES completion:^{
        [tWebViewController openURLString:@"https://policy-portal.truste.com/core/privacy-policy/Q2-Intel/6b45b037-c5b6-472b-b6c2-29a44b9dd9f1#landingPage"];
    }];
}

- (void) iconDownloadManager:(IconDownloadManager *)pIconDownloadManager indexPath:(NSIndexPath *)pIndexPath
{
    [self.mTableView beginUpdates];
    
    if ([mDownloadedCouponList count] > pIndexPath.row)
    {
        [self.mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:pIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
	[self.mTableView endUpdates];
}


-(void)favouriteButtonSelected:(UIButton *)sender
{
//    //NSLog(@"%d",sender.tag);
//    if (sender.tag==0)
//    {
//        if (sender.selected)
//        {
//            cell.mFavouriteButton.selected=NO;
//            [cell.mFavouriteButton setImage:[UIImage imageNamed:@"icon_favorites_normal"] forState:UIControlStateSelected];
//            cell.mFavouriteButton.highlighted =NO;
//        }
//        else
//        {
//            cell.mFavouriteButton.selected=YES;
//            [cell.mFavouriteButton setImage:[UIImage imageNamed:@"icon_favorites_selected"] forState:UIControlStateSelected];
//            cell.mFavouriteButton.highlighted =YES;
//        }
//    }
//    if (sender.tag==1)
//    {
//        if (sender.selected)
//        {
//            cell.mFavouriteButton.selected=NO;
//            [cell.mFavouriteButton setImage:[UIImage imageNamed:@"icon_favorites_normal"] forState:UIControlStateSelected];
//            //cell.mFavouriteButton.highlighted =NO;
//        }
//        else
//        {
//            cell.mFavouriteButton.selected=YES;
//            [cell.mFavouriteButton setImage:[UIImage imageNamed:@"icon_favorites_selected"] forState:UIControlStateSelected];
//            // cell.mFavouriteButton.highlighted =YES;
//        }
//    }

}


-(void)plannerButtonSelected:(UIButton *)sender
{
    //NSLog(@"%d",sender.tag);
    NSString *plannerid =[[mDownloadedCouponList objectAtIndex:sender.tag] valueForKey:@"id"];
    ////NSLog(@"%@",plannerid);
    NSMutableDictionary *planerDic = [NSMutableDictionary dictionary];
    [planerDic setObject:userkey forKey:@"userid"];
    [planerDic setObject:plannerid forKey:@"couponid"];
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/add_to_planner.php?",BASE_URL];
    
    jsonparse *objJsonparse =[[jsonparse alloc]init];
    
    reponseData = [[NSMutableDictionary alloc]init];
    
//    reponseData = [objJsonparse customejsonParsing:urlString bodydata:planerDic];
//    MyCouponsCell *plancoupon =[[MyCouponsCell alloc]init];
//    if (sender.tag==0) {
//        
//        if (sender.selected) {
//            cell.mPlannerButton.selected=NO;
//            [cell.mPlannerButton setImage:[UIImage imageNamed:@"icon_planner_normal"] forState:UIControlStateSelected];
//            cell.mPlannerButton.highlighted =NO;
//        }
//        else
//        {
//            cell.mPlannerButton.selected=YES;
//            [cell.mPlannerButton setImage:[UIImage imageNamed:@"icon_planner_selected"] forState:UIControlStateSelected];
//            cell.mPlannerButton.highlighted =YES;
//        }
//    }
}

-(void)redeemSelectButton:(UIButton *)sender
{
    MyCoupons *tCoupon = [mDownloadedCouponList objectAtIndex:sender.tag];
    tCoupon.mRedeeemSelected = [NSNumber numberWithBool:![tCoupon.mRedeeemSelected boolValue]];
    sender.highlighted = [tCoupon.mRedeeemSelected boolValue] ? YES : NO;
    NSError *error;
    [[Repository sharedRepository].context save:&error];
    [self.mTableView reloadData];
    [self refreshList];
    
}


- (void) deleteButtonSelected:(int )sender
{
    mDeleteButtonIndex = sender;
    UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:@"Delete coupon" message:kDeleteCouponMessage delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    tAlertView.tag = kAlertViewTwo;
    [tAlertView show];
}

- (void)redeemButtonSelected:(UIButton *)sender
{
    if(sender.currentBackgroundImage==[UIImage imageNamed:@"small_redeemSelected"])
    {
    CouponRedeemViewerViewController *redeem = [[CouponRedeemViewerViewController alloc] initWithNibName:@"CouponRedeemViewerViewController" bundle:[NSBundle mainBundle]];
    NSString *removeid =[[mDownloadedCouponList objectAtIndex:sender.tag] valueForKey:@"id"];
    [redeem setCouponid:removeid];
    [self.navigationController pushViewController:redeem animated:YES];
    [[mDownloadedCouponList objectAtIndex:sender.tag] setObject:@"NO" forKey:@"CheckMark"];
    [self reloadTable];
    }
}

-(void)redeemAll:(UIButton *)sender
{
    for(int i=0;i<[mDownloadedCouponList count];i++)
    {
        NSString *value = [[mDownloadedCouponList objectAtIndex:i] valueForKey:@"CheckMark"];
        if([value isEqualToString:@"YES"])
        {
                RedeemAllViewController *tRedeemAllViewController = [RedeemAllViewController new];
                tRedeemAllViewController.mDelegate = self;
                tRedeemAllViewController.mRedeemAllSelection = kRedeemAllFromMyCoupon;
                
                [mRedeemCouponArray removeAllObjects];
                for ( int i=0; i<[mDownloadedCouponList count]; i++)
                {
                    NSString *value = [[mDownloadedCouponList objectAtIndex:i] valueForKey:@"CheckMark"];
                    if(![value isEqualToString:@"NO"])
                    {
                        [mRedeemCouponArray addObject:[mDownloadedCouponList objectAtIndex:i]];
                    }
                }
                
                [tRedeemAllViewController redeemAllCoupons:mRedeemCouponArray];
                [self.navigationController pushViewController:tRedeemAllViewController animated:YES];
            
            break;
        }
    }

}

-(void) checkMarkAction:(UIButton *)sender
{
    NSString *value = [[mDownloadedCouponList objectAtIndex:sender.tag] valueForKey:@"CheckMark"];
    
    if([value isEqualToString:@"NO"])
    {
        [[mDownloadedCouponList objectAtIndex:sender.tag] setObject:@"YES" forKey:@"CheckMark"];
    }
    else
    {
        [[mDownloadedCouponList objectAtIndex:sender.tag] setObject:@"NO" forKey:@"CheckMark"];
    }
    
    [self reloadTable];
    
    for(int i=0;i<[mDownloadedCouponList count];i++)
    {
        NSString *value = [[mDownloadedCouponList objectAtIndex:i] valueForKey:@"CheckMark"];
        if([value isEqualToString:@"YES"])
        {
            [ btnForFooter setBackgroundImage:[UIImage imageNamed:@"big_redeemSelected@2x"] forState:UIControlStateNormal];
            break;
        }
        else
        {
            [ btnForFooter setBackgroundImage:[UIImage imageNamed:@"big_redeemUnselected@2x"] forState:UIControlStateNormal];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (alertView.tag==1)
    {
        if(buttonIndex == 1)
        {
            FavouriteViewController *fav = [[FavouriteViewController alloc]initWithNibName:@"FavouriteViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:fav animated:YES];
            [_btn4 setHidden:YES];
            
        }
        else if(buttonIndex == 2)
        {
            CategoriesViewController *tWebViewController = [CategoriesViewController new];
            UINavigationController *tNavigationController= [[UINavigationController alloc] initWithRootViewController:tWebViewController];
            [self presentViewController:tNavigationController animated:YES completion:^{
                
            }];
            
            
        }
        else if(buttonIndex == 3)
        {
            WebViewController *tWebViewController = [WebViewController new];
            UINavigationController *tNavigationController= [[UINavigationController alloc] initWithRootViewController:tWebViewController];
            [self presentViewController:tNavigationController animated:YES completion:^{
                
            }];
        }
    }
    else if (alertView.tag == kAlertViewOne)
    {
        if (buttonIndex == 0)
        {
            WebViewController *tWebViewController = [WebViewController new];
            UINavigationController *tNavigationController= [[UINavigationController alloc] initWithRootViewController:tWebViewController];
            [self presentViewController:tNavigationController animated:YES completion:^{
                [tWebViewController openURLString:@"http://www.couwalla.com"];
            }];
        }
        else
        {
            
        }
    }
    else if (alertView.tag == kAlertViewTwo)
    {
        if ([alertView cancelButtonIndex] == buttonIndex)
        {
            NSString *removeid =[[mDownloadedCouponList objectAtIndex:mDeleteButtonIndex] valueForKey:@"id"];
            //NSLog(@"Remove Id %@",removeid);
            
            NSMutableDictionary *removeDic = [NSMutableDictionary dictionary];
            [removeDic setObject:userkey forKey:@"userid"];
            [removeDic setObject:removeid forKey:@"couponid"];
            NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/remove_from_mycoupon.php?",BASE_URL];
            
            jsonparse *objJsonparse =[[jsonparse alloc]init];
            
            reponseData = [[NSMutableDictionary alloc]init];
            
            reponseData = [objJsonparse customejsonParsing:urlString bodydata:removeDic];
            [self refreshList];
        }
    }
    
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
    
    //[mHudPresenter hideHud];
    if (!pError) {
        if (pRequestType == kRedeemCouponRequest) {
            
        }
        else if (pRequestType == kRedeemAllCouponRequest) {
            
        }
        
        else if (pRequestType == kCouponPlanRequest) {
            [[Repository sharedRepository].context save:nil];
            [self.mTableView reloadData];
        }
        else if (pRequestType == kCouponUnPlanRequest) {
            [[Repository sharedRepository].context save:nil];
            [self.mTableView reloadData];
        }
        else if (pRequestType == kCouponFavRequest) {
            [[Repository sharedRepository].context save:nil];
            [self.mTableView reloadData];
        }
        else if (pRequestType == kCouponUnFavRequest) {
            [[Repository sharedRepository].context save:nil];
            if (mIsFavorite) {
                [mDownloadedCouponList removeObjectAtIndex:mFavoriteCouponIndex];
            }
            [self.mTableView reloadData];
            
        }
        
    }
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==searchDummyTable)
    {
        Coupon *tCoupon = [searchDummyArray objectAtIndex:indexPath.row];
        
        CouponDetailViewController *tController = [CouponDetailViewController new];
        tController.mCoupon                     = tCoupon;
        tController.mCouponName                 = [[searchDummyArray objectAtIndex:indexPath.row] valueForKey:@"name"];
        tController.mCouponPromoTextShort       = [[searchDummyArray objectAtIndex:indexPath.row] valueForKey:@"promo_text_short"];
        tController.mCouponPromoTextLong        = [[searchDummyArray objectAtIndex:indexPath.row] valueForKey:@"promo_text_long"];
        tController.mCouponExpireDate           = [[searchDummyArray objectAtIndex:indexPath.row] valueForKey:@"expiry_date"];
        tController.mCouponID                   = [[searchDummyArray objectAtIndex:indexPath.row] valueForKey:@"id"];
        tController.mCodeType                   = [[searchDummyArray objectAtIndex:indexPath.row] valueForKey:@"code_type"];
        tController.mCouponImage                = [[searchDummyArray objectAtIndex:indexPath.row] valueForKey:@"coupon_thumbnail"];
        tController.mBarcodeImage               = [[searchDummyArray objectAtIndex:indexPath.row] valueForKey:@"barcode_image"];
        tController.locatarray                  = [[searchDummyArray objectAtIndex:indexPath.row] valueForKey:@"store_name"];
        tController.mCouponDescription          = [[searchDummyArray objectAtIndex:indexPath.row] valueForKey:@"coupon_description"];

        tController.comingFromScreen=@"MyCouponsScreen";

        [self.navigationController pushViewController:tController animated:YES];
    }
    else
    {
        Coupon *tCoupon = [mDownloadedCouponList objectAtIndex:indexPath.row];

        CouponDetailViewController *tController = [CouponDetailViewController new];
        
        tController.mCoupon                     = tCoupon;
        tController.mCouponName                 = [[mDownloadedCouponList objectAtIndex:indexPath.row] valueForKey:@"name"];
        tController.mCouponPromoTextShort       = [[mDownloadedCouponList objectAtIndex:indexPath.row] valueForKey:@"promo_text_short"];
        tController.mCouponPromoTextLong        = [[mDownloadedCouponList objectAtIndex:indexPath.row] valueForKey:@"promo_text_long"];
        tController.mCouponExpireDate           = [[mDownloadedCouponList objectAtIndex:indexPath.row] valueForKey:@"expiry_date"];
        tController.mCouponID                   = [[mDownloadedCouponList objectAtIndex:indexPath.row] valueForKey:@"id"];
        tController.mCodeType                   = [[mDownloadedCouponList objectAtIndex:indexPath.row] valueForKey:@"code_type"];
        tController.mCouponImage                = [[mDownloadedCouponList objectAtIndex:indexPath.row] valueForKey:@"coupon_thumbnail"];
        tController.mBarcodeImage               = [[mDownloadedCouponList objectAtIndex:indexPath.row] valueForKey:@"barcode_image"];
        tController.locatarray                  = [[mDownloadedCouponList objectAtIndex:indexPath.row] valueForKey:@"store_name"];
        tController.mCouponDescription          = [[mDownloadedCouponList objectAtIndex:indexPath.row] valueForKey:@"coupon_description"];
        
        tController.comingFromScreen=@"MyCouponsScreen";
        
        [self.navigationController pushViewController:tController animated:YES];
    }
}
#pragma mark-search

-(void) searchView:(id)sender
{
    if([mDownloadedCouponList count]>0)
    {
    
    if(!hide)
    {
        hideView.hidden=NO;
        searchBar.hidden=NO;
        searchBar.text=@"";
        [self.view bringSubviewToFront:hideView];
        [self.mTableView setScrollEnabled:NO];
        [mTableView setContentOffset:CGPointZero];
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
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    [searchBar1 resignFirstResponder];
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
- (BOOL)searchBar:(UISearchBar *)searchBar1 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    searchDummyTable.hidden=NO;
    NSString *finalString;
    if([text isEqualToString:@"\n"])
        finalString=searchBar1.text;
    else
        finalString = [searchBar1.text stringByReplacingCharactersInRange:range withString:text];
    
    if(finalString.length)
    {
        [self updateTableAfterSearch:finalString];
    }
    else
    {
        searchDummyTable.hidden=YES;
    }
    
    return YES;
}

-(void)updateTableAfterSearch:(NSString *)productName
{
    //                if([searchDummyArray count]>0)
    //                {
    //                    NSMutableArray *productAry=[NSMutableArray arrayWithArray:searchDummyArray];
    //                    for (MyCoupons *idCheck in productAry)
    //                    {
    //                        NSString *idL = [idCheck valueForKey:@"id"];
    //                        NSLog(@"%@----%@",idL,idG);
    //
    //                        if([idL isEqualToString:idG])
    //                            [searchDummyArray removeObject:idCheck];
    //                        else
    //                            [searchDummyArray addObject:product];
    //                    }
    //                }
    //                else
    //                {
    //                    [searchDummyArray addObject:product];
    //                }
    

    [searchDummyArray removeAllObjects];
    [searchDummyTable setScrollEnabled:YES];
    noResult.hidden=YES;
    
    
   for (MyCoupons *product in mDownloadedCouponList)
    {
        
        NSMutableArray * localAry=[[NSMutableArray alloc]init];
        
        //ByName
        {
            NSString *str=[product valueForKey:@"name"];
            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
            NSRange productNameRange = NSMakeRange(0, str.length);
            NSRange foundRange = [str rangeOfString:productName options:searchOptions range:productNameRange];
            if (foundRange.length > 0)
            {
                [localAry addObject:product];
            }
        }
        
        //ByDescription
        {
            NSString *str=[product valueForKey:@"coupon_description"];
            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
            NSRange productNameRange = NSMakeRange(0, str.length);
            NSRange foundRange = [str rangeOfString:productName options:searchOptions range:productNameRange];
            
            if (foundRange.length > 0)
            {
                [localAry addObject:product];
            }
        }
        
        //ByPromo_text_short
        {
            NSString *str=[product valueForKey:@"promo_text_short"];
            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
            NSRange productNameRange = NSMakeRange(0, str.length);
            NSRange foundRange = [str rangeOfString:productName options:searchOptions range:productNameRange];
            if (foundRange.length > 0)
            {
                [localAry addObject:product];

            }
        }
        
        //ByStore_name
        {
            NSString *str=[[NSString alloc] init];
            if ([[product valueForKey:@"store_name"] count] == @0)
            {
                str=[[[product valueForKey:@"store_name"] objectAtIndex:0]valueForKey:@"storename"];
            }
            else
                str=@"-";
            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
            NSRange productNameRange = NSMakeRange(0, str.length);
            NSRange foundRange = [str rangeOfString:productName options:searchOptions range:productNameRange];
            
            if (foundRange.length > 0)
            {
                [localAry addObject:product];
            }
        }
        
        for (MyCoupons *idCheck in localAry)
        {
            
            if([searchDummyArray count]>0)
            {
                NSString *idG=[idCheck valueForKey:@"id"];
                int flag=0;
                for (int i=0; i<[searchDummyArray count]; i++)
                {
                    NSString *idL = [[searchDummyArray objectAtIndex:i] valueForKey:@"id"];
                    if([idL isEqualToString:idG])
                    {
                        flag=1;
                    }
                }
                if(!flag)
                {
                    [searchDummyArray addObject:idCheck];
                }
            }
            else
            {
                [searchDummyArray addObject:idCheck];
            }
        }
    }
    if(!searchDummyArray.count)
    {
        noResult.hidden=NO;
        noResult.text=@"No Result";
        noResult.textColor=[UIColor grayColor];
        noResult.font=[UIFont boldSystemFontOfSize:20.0];
        [searchDummyTable addSubview:noResult];
        [searchDummyTable setScrollEnabled:NO];
    }
    for (int i=0; i<[searchDummyArray count];i++)
    {
        NSLog(@"%@",[[searchDummyArray objectAtIndex:i] valueForKey:@"id"]);
    }
    
    [searchDummyTable reloadData];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];

}
- (void)MySegmentControlAction:(UISegmentedControl *)segment
{
    [mTableView setContentOffset:CGPointZero];
    if(segment.selectedSegmentIndex == 0)
    {
        shortingTag=0;
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        [mDownloadedCouponList sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    }
    if(segment.selectedSegmentIndex == 1)
    {
        shortingTag=1;
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"promo_text_short" ascending:YES];
        [mDownloadedCouponList sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    }
    if(segment.selectedSegmentIndex == 2)
    {
        shortingTag=2;
//        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"store_name" ascending:YES];
//        [mDownloadedCouponList sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        
        
        [mDownloadedCouponList sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2)
        {
            NSString *store1=[[NSString alloc] init];
            NSString *store2=[[NSString alloc] init];
            if ([[obj1 objectForKey:@"store_name"] count] == @0 )
            {
                store1 = [[[obj1 objectForKey:@"store_name"] objectAtIndex:0]valueForKey:@"storename"];
            }
            else
            {
                store1 = @"-";
            }
            if ([[obj2 objectForKey:@"store_name"] count] == @0)
            {
                store2 = [[[obj2 objectForKey:@"store_name"] objectAtIndex:0]valueForKey:@"storename"];
            }
            else
            {
                store2 = @"-";
            }
            
            return [store1 compare:store2];
        }];
        
    }
    if(segment.selectedSegmentIndex == 3)
    {
        shortingTag=3;
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"expiry_date" ascending:YES];
        [mDownloadedCouponList sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    }
    [self reloadTable];
}
#pragma mark - call service

-(void)getMyCoupon
{
    [HUDManager showHUDWithText:kHudMassage];
   // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //self.navigationItem.title = [defaults valueForKey:@"Rowvalue"];
    
    NSMutableDictionary *couponDic = [NSMutableDictionary dictionary];
    
    catid = [[NSUserDefaults standardUserDefaults] stringForKey:@"CatValue"];
    userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
    [couponDic setObject:userkey forKey:@"userid"];
    
    if (![catid isEqualToString:@"###"])
    {
        [couponDic setObject:catid forKey:@"category_id"];
    }
    else
    {
        [couponDic setObject:@"" forKey:@"category_id"];
    }
    
    [[CoupitService service]myCoupons:couponDic completionHandler:
     
     ^(NSDictionary *result, NSError *error)
     {
         if (error)
         {
             [[[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
             [[LocalyticsSession shared] tagEvent:kErrorSummary attributes:@{kError:[error localizedDescription]}];
             [HUDManager hideHUD];
         }
         else
         {
             mDownloadedCouponList =[result valueForKey:@"data"];
             NSLog(@"List=%@",mDownloadedCouponList);
             NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
             [mDownloadedCouponList sortUsingDescriptors:[NSArray arrayWithObject:sort]];
             
             [self.mTableView reloadData];
             
             for (int i=0; i<[mDownloadedCouponList count]; i++)
             {
                 [[mDownloadedCouponList objectAtIndex:i] setObject:@"NO" forKey:@"CheckMark"];
             }
             
             [btnForFooter setBackgroundImage:[UIImage imageNamed:@"big_redeemUnselected@2x"] forState:UIControlStateNormal];
             
             [self reloadTable];
         }
         [HUDManager hideHUD];
         
     }];
    
}

-(void)reloadTable
{
    [self.mTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

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

