//
//  NewStoresViewController.m
//  Coupit
//
//  Created by Canopus5 on 6/13/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "NewStoresViewController.h"
#import "CouponTableCell.h"
#import "CouponView.h"
#import "UIButton+WebCache.h"
#import "UIColor+AppTheme.h"
#import "LocalyticsSession.h"
#import "Location.h"
#import "SearchViewController.h"
#import "GTScrollNavigationBar.h"
#import "GetCoupons.h"
#import "jsonparse.h"
#import "CouponsListCell.h"
#import "countdownManager.h"



#define kItemWidth 103
#define kItemHeight 35

static int hide;

@interface NewStoresViewController () <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray      * tableStoreArray;
    NSMutableArray      * tableBrandArray;
    NSMutableArray      * tableDataArray;
    UISegmentedControl  *segmentedControl;
    
    UIView              *mGestureView;
    UIButton            *mMenuButton;
    
    CLLocation          *locA;
    NSString            *userlat;
    NSString            *userlong;
    
    UILabel *lblForEmptyData;
    
    int    shortingTag;
    
    UIView *hideView;
    UISearchBar *searchBar;
    NSMutableArray *searchDummyArray;
    UITableView *searchDummyTable;
    UILabel *noResult;
    
}

@property (assign, nonatomic) CGFloat lastContentOffsetY;

@end

@implementation NewStoresViewController

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
    
    self.navigationItem.title=@"Stores & Brands";
    [self.navigationController.navigationBar setTranslucent:NO];
    
    
    // Shorting function
    {
        shortingTag=0;
        NSArray *itemArray = [NSArray arrayWithObjects: @"Stores", @"Brands",nil];
        segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
        segmentedControl.frame=CGRectMake(5, 5, 310, 30);
        [segmentedControl setTintColor:[UIColor appGreenColor]];
        segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
        [segmentedControl addTarget:self action:@selector(MySegmentControlAction:) forControlEvents: UIControlEventValueChanged];
        segmentedControl.selectedSegmentIndex = shortingTag;
    }
    
    //call Web Service
    {
        tableStoreArray = [[NSMutableArray alloc]init];
        tableBrandArray = [[NSMutableArray alloc]init];
        tableDataArray  = [[NSMutableArray alloc]init];
        
        // check for location
        int mSeletedValue = [[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreference];
//        if(mSeletedValue==0 || [countdownManager shareManeger].userLocationDidUpdate)
//        {
//            [countdownManager shareManeger].userLocationDidUpdate = NO;
//            [countdownManager callWebServiceForLocationUpdate];
//        }
        [countdownManager shareManeger].userLocationDidUpdate=NO;
        [countdownManager callWebServiceForLocationUpdate];

        [self getStore];
        
    }
    
    //For side menu activate
    {
        mMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [mMenuButton setImage:[UIImage imageNamed:@"button_menu"] forState:UIControlStateNormal];
        
        [mMenuButton sizeToFit];
        [mMenuButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
        [self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
        
        UIBarButtonItem* menuBarButton = [[UIBarButtonItem alloc]initWithCustomView:mMenuButton];
        self.navigationItem.leftBarButtonItem = menuBarButton;
        
        mGestureView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self.navigationController.parentViewController action:@selector(revealToggle:)];
        [mGestureView addGestureRecognizer:recognizer];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
        [mGestureView addGestureRecognizer:panRecognizer];
    }
    
    //Empty data
    {
        
        lblForEmptyData=[[UILabel alloc]initWithFrame:CGRectMake(10, 100, 300, 50)];
        lblForEmptyData.textAlignment=NSTextAlignmentCenter;
        [lblForEmptyData setBackgroundColor:[UIColor clearColor]];
        lblForEmptyData.textColor=[UIColor blackColor];
        lblForEmptyData.numberOfLines=2;
        [lblForEmptyData setFont:[UIFont fontWithName:nil size:15.0]];
    }
    
    // add searching
    {
        hide=0;
        [self addSearching];
    }
    self.mTableView.scrollsToTop=YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.scrollNavigationBar.scrollView=self.mTableView;
    // [self.mTableView setContentOffset:CGPointZero];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.scrollNavigationBar.scrollView = nil;
    hide=YES;
    [self searchView:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)MySegmentControlAction:(UISegmentedControl *)segment
{
    //  [self.mTableView setContentOffset:CGPointZero animated:NO];
    [tableDataArray removeAllObjects];
    if(segment.selectedSegmentIndex == 0)
    {
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        {
            if([[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreference])
            {
                tableDataArray=[tableStoreArray mutableCopy];
            }
            else
            {
                if([tableDataArray count])
                {
                    [tableDataArray removeAllObjects];
                }
            }
        }
        else
        {
            tableDataArray=[tableStoreArray mutableCopy];
        }
        
        
        
        shortingTag=0;
    }
    if(segment.selectedSegmentIndex == 1)
    {
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        {
            if([[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreference])
            {
                tableDataArray=[tableBrandArray mutableCopy];
            }
            else
            {
                if([tableBrandArray count])
                {
                    [tableBrandArray removeAllObjects];
                }
            }
        }
        else
        {
            tableDataArray=[tableBrandArray mutableCopy];
        }
        
        shortingTag=1;
    }
    [lblForEmptyData removeFromSuperview];
    
 
    if([tableStoreArray count]==0)
    {
        [self.mTableView setScrollEnabled:NO];
        if([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusDenied)
        {
            lblForEmptyData.text=@"There are no coupons available, please check back later.";
        }
        else
        {
            if(!shortingTag)
            lblForEmptyData.text=@"To view stores please turn on your location settings on your device.";
            else
            lblForEmptyData.text=@"To view brands please turn on your location settings on your device.";
        }
        [self.mTableView addSubview:lblForEmptyData];
    }
    else
    {
        [self.mTableView setScrollEnabled:YES];
        
        [lblForEmptyData removeFromSuperview];
    }
    [self.mTableView reloadData];
}


#pragma mark -
#pragma mark Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == searchDummyTable)
        return [searchDummyArray count];
    
    int coutForArray=[tableDataArray count];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==searchDummyTable)
        return 102;
   if(!shortingTag && [CLLocationManager authorizationStatus]!=kCLAuthorizationStatusDenied )
        return 120.0;
    return 101.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == searchDummyTable)
        return 0;
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 50, 50, 50)];
    v.backgroundColor=[UIColor whiteColor];
    [v addSubview:segmentedControl];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView!=searchDummyTable)
    {
        static NSString *CellIdentifier1 = @"CellTest";
        
        CouponTableCell *cell= (CouponTableCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        
        if (cell == nil)
        {
            cell = [[CouponTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        int margin=3;
        
        int countForRow=[tableDataArray count]/3;
        if ([tableDataArray count]%3 !=0)
        {
            countForRow= countForRow+1;
        }
        int count=3;
        if (indexPath.row==countForRow-1 && [tableDataArray count]>3 && [tableDataArray count]%3 !=0)
        {
            count=[tableDataArray count]%3;
        }
        else if ([tableDataArray count]<=3)
        {
            count=[tableDataArray count];
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
            
            NSURL *image=[NSURL URLWithString:[[tableDataArray  objectAtIndex:(indexPath.row *3)+i]valueForKey:@"storethumbnail"]];
            [tCouponView.mItemButton setBackgroundImageWithURL:image placeholderImage:nil];
            [tCouponView.mItemButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
            tCouponView.mItemButton.tag=(indexPath.row *3)+i;
            [tCouponView.mItemButton addTarget:self action:@selector(actionOnImage:) forControlEvents:UIControlEventTouchUpInside];
            
            [tCouponView.mItemButton addSubview:tCouponView.mTopRightView];

            if([[[tableDataArray objectAtIndex:(indexPath.row *3)+i] valueForKey:@"storename"] length]>0)
                tCouponView.mTopRightView.hidden=YES;
            
            tCouponView.mTopRightLabel.text = [[tableDataArray objectAtIndex:(indexPath.row *3)+i] valueForKey:@"storename"];
            
            
           // CGRect frame1 = tCouponView.mItemButton.frame;
            
            if(shortingTag==0 )
            {
                NSLog(@"%f",tCouponView.view.frame.size.height);
                tCouponView.mButtomLable.text = [[tableDataArray objectAtIndex:(indexPath.row *3)+i] valueForKey:@"Distance"];
            }
            else
            {
                NSLog(@"%f",tCouponView.view.frame.size.height);

                [tCouponView.mButtomLable setBackgroundColor:[UIColor whiteColor]];
            }
            
            [cell.contentView addSubview:tCouponView.view];
        }
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
        
        NSLog(@"Index path %ld", (long)indexPath.row);
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

#pragma mark - Image Click action

-(void)actionOnImage:(UIButton *)sender
{
    GetCoupons * gc = [[GetCoupons alloc]init];
    
    gc.mID=[[tableDataArray  objectAtIndex:sender.tag] valueForKey:@"storeid"];
    if(!shortingTag)
    {
        gc.msgtitle=@"store";
        gc.title=@"Stores";
    }
    else
    {
        gc.msgtitle=@"brand";
        gc.title=@"Brands";
    }
    [self.navigationController pushViewController:gc animated:YES];
    
}



#pragma mark call Webservice

-(void)getStore
{
    [HUDManager showHUDWithText:kHudMassage];
    
    api = [[GREST alloc] init];
    [api setDelegate:self];
    
    NSString* userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
    //userkey= @"214";
    
    NSDictionary *paramsDictionary=[NSDictionary dictionaryWithObjectsAndKeys:userkey,@"userid", nil];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:paramsDictionary options:0 error:Nil];
    NSString *paramString=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    paramString=[paramString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    [api get:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNearStores, paramString]] with_params:nil contentType:nil with_key:@"getStores"];
    [api start];
}

-(void)getBrand
{
    [HUDManager showHUDWithText:kHudMassage];
    api = [[GREST alloc] init];
    [api setDelegate:self];
    
    NSString* userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
    //userkey= @"214";
    
    NSDictionary *paramsDictionary=[NSDictionary dictionaryWithObjectsAndKeys:userkey,@"userid", nil];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:paramsDictionary options:0 error:Nil];
    NSString *paramString=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    paramString=[paramString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    [api get:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNearBrands, paramString]] with_params:nil contentType:nil with_key:@"getBrands"];
    [api start];
}

#pragma mark - GREST Methods

- (void)request_finished:(NSString *)response for_key:(NSString *)request_key
{
    NSMutableDictionary *couponDetails = [[response JSONValue] mutableCopy];
    
    if([request_key isEqualToString:@"getStores"])
    {
        id responseObject=[couponDetails valueForKey:@"data"];
        
        if([responseObject isKindOfClass:[NSArray class]])
        {
        tableStoreArray =[couponDetails valueForKey:@"data"];
        [self compareLocationByLatitudeAndLongitude];
        }
        else if([responseObject isKindOfClass:[NSDictionary class]])
        {
            
        }
        [self getBrand];
        
    }
    else if([request_key isEqualToString:@"getBrands"])
    {
        id responseObject=[couponDetails valueForKey:@"data"];
        
        if([responseObject isKindOfClass:[NSArray class]])
        {
        tableBrandArray = [couponDetails valueForKey:@"data"];
        }
        else if([responseObject isKindOfClass:[NSDictionary class]])
        {
            
        }
        [HUDManager hideHUD];
    }
    else if([request_key isEqualToString:@"storeSearch"])
    {
        id responseObject=[couponDetails valueForKey:@"data"];
        
        if([responseObject isKindOfClass:[NSArray class]])
        {
            searchDummyArray=responseObject;
            if([searchDummyArray count]>0)
                [searchDummyTable reloadData];
        }
        else if([responseObject isKindOfClass:[NSDictionary class]])
        {
            
        }
        
        if(!searchDummyArray.count)
        {
            noResult.hidden=NO;
            noResult.text=@"No coupons found in near by stores.";
            noResult.textColor=[UIColor grayColor];
            noResult.font=[UIFont boldSystemFontOfSize:20.0];
            [searchDummyTable addSubview:noResult];
            [searchDummyTable setScrollEnabled:NO];
        }
        searchDummyTable.hidden=NO;
        [HUDManager hideHUD];
    }
    else if([request_key isEqualToString:@"brandsSearch"])
    {
        id responseObject = [couponDetails valueForKey:@"data"];
        
        if([responseObject isKindOfClass:[NSArray class]])
        {
            searchDummyArray=responseObject;
            if([searchDummyArray count]>0)
                [searchDummyTable reloadData];
        }
        else if([responseObject isKindOfClass:[NSDictionary class]])
        {
            
        }
        
        //[searchDummyTable reloadData];
        if(!searchDummyArray.count)
        {
            noResult.hidden=NO;
            noResult.text=@"No coupons found in near by brands.";
            noResult.textColor=[UIColor grayColor];
            noResult.font=[UIFont boldSystemFontOfSize:20.0];
            [searchDummyTable addSubview:noResult];
            [searchDummyTable setScrollEnabled:NO];
        }
        searchDummyTable.hidden=NO;
        [HUDManager hideHUD];
    }
    
}

- (void)request_failed:(NSError *)error for_key:(NSString *)request_key
{
    [HUDManager hideHUD];
}


#pragma mark sideMenu

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

-(void)menuButtonSelected
{
	mMenuButton.selected = YES;
}

-(void)menuButtonUnselected
{
	mMenuButton.selected = NO;
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

    
    for (int i =0;i<[tableStoreArray count];i++)
    {
        CLLocation *updatedLocation = [[CLLocation alloc] initWithLatitude:[[[tableStoreArray objectAtIndex:i]valueForKey:@"latitude"] doubleValue] longitude:[[[tableStoreArray objectAtIndex:i]valueForKey:@"longitude"] doubleValue]];
        
        CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:userLatitude longitude:userLongitude];
        
        CLLocationDistance distance = [updatedLocation distanceFromLocation:userLocation];
        
     
        [[tableStoreArray objectAtIndex:i] setObject:[NSString stringWithFormat:@"%1.2f miles away", 0.621371*(distance/1000)] forKey:@"Distance"];
    }
    
//    NSSortDescriptor *sort =[NSSortDescriptor sortDescriptorWithKey:@"Distance" ascending:YES];
//    [tableStoreArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    NSArray *sortedArray = [tableStoreArray sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* obj1, NSDictionary* obj2)
                            {
        return [(NSString *)[obj1 valueForKey:@"Distance"] compare:(NSString *)[obj2 valueForKey:@"Distance"] options:NSNumericSearch];
                            }];
    [tableStoreArray removeAllObjects];
    [tableStoreArray addObjectsFromArray:sortedArray];
    [segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - Searching

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
    
    noResult=[[UILabel alloc]initWithFrame:CGRectMake(0, 100,320,80)];
    [noResult setNumberOfLines:2];
    noResult.textAlignment=NSTextAlignmentCenter;
    
    hideView =[[UIView alloc]initWithFrame:CGRectMake(0,0,320,[UIScreen mainScreen].bounds.size.height)];
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
        if ([searchBar1.text length] == 0)
        {
            [HUDManager hideHUD];
            
            return;
        }
        else
        {
            // check for location
            int mSeletedValue = [[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreference];
//            if(mSeletedValue==0 || [countdownManager shareManeger].userLocationDidUpdate)
//            {
//                [countdownManager shareManeger].userLocationDidUpdate=NO;
//                [countdownManager callWebServiceForLocationUpdate];
//            }
            [countdownManager shareManeger].userLocationDidUpdate=NO;
            [countdownManager callWebServiceForLocationUpdate];

            api = [[GREST alloc] init];
            [api setDelegate:self];
            
            NSString* userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
            // userkey= @"214";
            NSDictionary *paramsDictionary=[NSDictionary dictionaryWithObjectsAndKeys:userkey,@"userid",searchBar1.text,@"search_text", nil];
            
            if(!shortingTag)
            {
                NSData *jsonData=[NSJSONSerialization dataWithJSONObject:paramsDictionary options:0 error:Nil];
                NSString *paramString=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                paramString=[paramString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
                [api get:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kSearchForStore, paramString]] with_params:nil contentType:nil with_key:@"storeSearch"];
            }
            else
            {
                NSData *jsonData=[NSJSONSerialization dataWithJSONObject:paramsDictionary options:0 error:Nil];
                NSString *paramString=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                paramString=[paramString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
                [api get:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kSearchForBrand, paramString]] with_params:nil contentType:nil with_key:@"brandsSearch"];
            }
            [api start];
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
    //[self.mTableView setContentOffset:CGPointZero];
    [self searchView:nil];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
    
}

#pragma -mark UIScrollViewDelegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat deltaY = contentOffsetY - self.lastContentOffsetY;
    if (deltaY < 0.0f) {
        [UIView animateWithDuration:0.1 animations:^{
            
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            [self.navigationController.scrollNavigationBar resetToDefaultPosition:YES];

        }];
    } else if (deltaY > 0.0f) {
        [UIView animateWithDuration:0.1 animations:^{
            
            scrollView.contentInset = UIEdgeInsetsMake(-40, 0, 0, 0);
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



@end
