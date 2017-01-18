//
//  StoreListViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "StoreListViewController.h"
#import "CouponsListCell.h"
#import "Coupon.h"
#import "FileUtils.h"
#import "CouponDetailViewController.h"
#import "tJSON.h"
#import "StoreLocatorMap.h"
#import "StoreSettingViewController.h"
#import "AppDelegate.h"
#import "jsonparse.h"
#import "appcommon.h"
#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "ProgressHudPresenter.h"

@implementation StoreListViewController
{
    NSMutableArray *mCouponListArray;
    ProgressHudPresenter *mHudPresenter;
    NSString *mBannerImageURL;
    NSString *mBannerID;
    NSString *mBannerName;
    NSString *mBrandName;
    NSString *mBrandID;
    NSMutableArray *mStoreArray;
    NSInteger mStartIndex;
    BOOL mIsLoadMore, mIsStoreCoupons;
    NSMutableArray *mStoreLocationArray;
    NSMutableArray *mDBStorePreferencesArray;
    NSInteger mEntityType;
    
    NSMutableDictionary *nearmereponseData;
    NSMutableArray *sCouponList,*couponNameArray,*couponThumbnail,*coupondesc;


}

@synthesize mBannerImageView, mTableView, mStoreID, mStoreLocator, mActivityIndicator, mAddressLabel, mAddStorePreferencesButton;
@synthesize mDelegate, mEditStorePreferencesButton,titlestring,tempstring,storeID,addressstring,latstring,longstring;

- (void)viewDidLoad {
    //self.navigationItem.title = @"Coupon List";
    
    self.title = titlestring;
    
    //NSLog(@"Hello!");

    [super viewDidLoad];
    mStartIndex = 0;
    mIsLoadMore = NO;
    mIsStoreCoupons = YES;
    [mActivityIndicator startAnimating];
    
    mStoreArray = [NSMutableArray new];
    mStoreLocationArray = [[NSMutableArray alloc] initWithArray:[[DataManager getInstance] mStoresLocationArray]];
    
    //NSLog(@"mStoreLocationArray %d",[mStoreLocationArray count]);
    mHudPresenter = [[ProgressHudPresenter alloc] init];

    self.navigationItem.hidesBackButton = YES;
    mCouponListArray = [NSMutableArray new];
    
    //Back Button.
    UIButton *tbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tbackButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tbackButton sizeToFit];
    [tbackButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tBackBar = [[UIBarButtonItem alloc]initWithCustomView:tbackButton];
    self.navigationItem.leftBarButtonItem = tBackBar;
    
    if (mStoreLocator != kBrandSelected) {
    //Map View Button.
    UIButton *tMapViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tMapViewButton setImage:[UIImage imageNamed:@"btn_locate"] forState:UIControlStateNormal];
    [tMapViewButton sizeToFit];
    [tMapViewButton addTarget:self action:@selector(StoresMapView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tMapBarButton = [[UIBarButtonItem alloc]initWithCustomView:tMapViewButton];
    self.navigationItem.rightBarButtonItem = tMapBarButton;
    }
    
    
   // NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempstring]];
   // mBannerImageView.image = [UIImage imageWithData:imageData];
    [mBannerImageView setImageWithURL:[NSURL URLWithString:tempstring]];
    //NSLog(@"Storeis is%@",storeID);
    //NSLog(@"Storeis address%@",addressstring);
    //NSLog(@"lat is%@",latstring);
    //NSLog(@"long is%@",longstring);
    mAddressLabel.text=addressstring;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:latstring forKey:@"lat"];
    [defaults setObject:longstring forKey:@"long"];
    [defaults setObject:titlestring forKey:@"title"];
    [defaults setObject:addressstring forKey:@"addr"];
    [defaults setObject:tempstring forKey:@"url"];
    [defaults synchronize];
    
    
    NSMutableDictionary *coupndic = [NSMutableDictionary dictionary];
    [coupndic setObject:storeID forKey:@"retailer_id"];
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/get_retailer_coupons.php?",BASE_URL];
    
    jsonparse *objJsonparse =[[jsonparse alloc]init];
    
    nearmereponseData = [[NSMutableDictionary alloc]init];
    
    nearmereponseData = [objJsonparse customejsonParsing:urlString bodydata:coupndic];
    
    sCouponList = [nearmereponseData valueForKey:@"data"];
    
    mCouponListArray = sCouponList;
    
    couponNameArray = [mCouponListArray valueForKey:@"name"];
    couponThumbnail=[mCouponListArray valueForKey:@"coupon_thumbnail"];
    coupondesc = [mCouponListArray valueForKey:@"promo_text_short"];
    
}

- (void) viewDidAppear:(BOOL)animated {
    mDBStorePreferencesArray = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchAllStoresPreference:nil]];
    
}

- (void)backButton:(id)sender {
    if (mDelegate) {
        [self.navigationController popViewControllerAnimated:YES ];
        [mDelegate storeListViewController:nil isBack:YES];
        
    } else {
        [self.navigationController popViewControllerAnimated:YES ];

    }
}


- (void) showCouponsForStore:(Stores *)pStore
{
    //NSLog(@".........:%@",pStore.mBrandId);
    [mEditStorePreferencesButton setHidden:YES];

    mDBStorePreferencesArray = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchAllStoresPreference:nil]];
    for (StorePreferences *tStorePreferences in mDBStorePreferencesArray) {
        if (([pStore.mBrandId isEqualToNumber:tStorePreferences.mBrandID]) && ([tStorePreferences.mEntityType isEqualToNumber:[NSNumber numberWithInt:1]]))
        {
            [mAddStorePreferencesButton setHidden:YES];
            [mEditStorePreferencesButton setHidden:YES];
            
        } else {
            if (([pStore.mID isEqualToNumber:tStorePreferences.mStoreID]) && ([tStorePreferences.mEntityType isEqualToNumber:[NSNumber numberWithInt:2]])) {
                [mEditStorePreferencesButton setHidden:NO];
                [mAddStorePreferencesButton setHidden:YES];
            }
        }
    }
    mStoreLocator = kstoreSelected;
    self.navigationItem.title = pStore.mFullName;
    mIsStoreCoupons = YES;
    mEntityType = kStoreEntityType;
    
    [mHudPresenter presentHud];
    mBannerImageURL = pStore.mFullImage;
    mBannerID = [pStore.mID stringValue];
    mBrandID = [pStore.mBrandId stringValue];
    mBannerName = pStore.mFullName;
    NSString *tFileName = [mBannerImageURL lastPathComponent];
    NSString *fmtFileName = makeFileName(mBannerID, tFileName);
    //NSLog(@"image's url  %@ showCouponsForStore ------- fmtFileName:%@",mBannerImageURL ,fmtFileName);
    if (isFileExists(fmtFileName)) {
        [mActivityIndicator stopAnimating];
        [self.mBannerImageView setImage:[UIImage imageWithContentsOfFile:imageFilePath(fmtFileName)]];

    }
    else{
        [self.mBannerImageView setImage:[UIImage imageNamed:@"StoreBannerDefaultImage"]];
        [[IconDownloadManager getInstance] setScreen:kStoreListScreen delegate:self filePath:mBannerImageURL iconID:mBannerID indexPath:[NSIndexPath indexPathForRow:-1 inSection:0]];
    }
    
    [self fetchCouponsForStoreAtIndex:mStartIndex];
}

- (void) showLocationForStore:(StoreLocations *)pStoreLocation {
    //
    mAddressLabel.text = pStoreLocation.mAddressLine;

}

- (void) fetchCouponsForStoreAtIndex:(NSInteger)pStartIndex
{
    NSDictionary *idDict = [NSDictionary dictionaryWithObject:mBannerID forKey:@"id"];
    
    NSArray *tIDs = [NSArray arrayWithObjects:idDict, nil];
    NSMutableDictionary *tRequestDict = [NSMutableDictionary new];
    [tRequestDict setObject:[NSNumber numberWithInt:pStartIndex] forKey:@"startIndex"];
    [tRequestDict setObject:[NSNumber numberWithInt:kItemsPerPage] forKey:@"itemsPerPage"];
    [tRequestDict setObject:tIDs forKey:@"stores"];
    
    NSString *jsonRequest = [tRequestDict JSONRepresentation];
    //NSLog(@"jsonRequest is %@", jsonRequest);
    
    BOOL *tIsCheckedIn = [[DataManager getInstance] storeCheckIn:mBannerID];
    if (!tIsCheckedIn) {
        CLLocation *tCurrentLocation = [[Location getInstance] getCurrentLocation];
        NSString *tPostCouponQuery = [kURL_PostCouponQuery stringByAppendingFormat:@"?lat=%f&lng=%f",tCurrentLocation.coordinate.latitude,tCurrentLocation.coordinate.longitude];
        //NSLog(@"tSolrStoresRequestURL--------:%@",tPostCouponQuery);
        
        [[RequestHandler getInstance] postRequestwithHostURL:tPostCouponQuery bodyPost:jsonRequest delegate:self requestType:kCouponQueryStorePostRequest];

    } else {
        [[RequestHandler getInstance] postRequestwithHostURL:kURL_PostCouponQuery bodyPost:jsonRequest delegate:self requestType:kCouponQueryStorePostRequest];

    }
    
    
}

- (void) showCouponsForBrand:(Brands *)pBrand
{
    [mEditStorePreferencesButton setHidden:YES];
    mDBStorePreferencesArray = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchAllStoresPreference:nil]];
    for (StorePreferences *tStorePreferences in mDBStorePreferencesArray) {
        if (([pBrand.mID isEqualToNumber:tStorePreferences.mBrandID]) && ([tStorePreferences.mEntityType isEqualToNumber:[NSNumber numberWithInt:1]]))
        {
            [mAddStorePreferencesButton setHidden:YES];
            [mEditStorePreferencesButton setHidden:NO];
            
        }
    }

    mStoreLocator = kBrandSelected;
    self.navigationItem.title = pBrand.mName;
    mBrandName = pBrand.mName;
    mIsStoreCoupons = NO;
    mEntityType = kBrandEntityType;

    [mHudPresenter presentHud];
    mBannerImageURL = pBrand.mFullImage;
    mBrandID = [pBrand.mID stringValue];
    [mAddressLabel setHidden:YES];
    NSString *tFileName = [mBannerImageURL lastPathComponent];
    NSString *fmtFileName = makeFileName(mBrandID, tFileName);
    //NSLog(@"showCouponsForBrand ------- fmtFileName:%@", fmtFileName);
    if (isFileExists(fmtFileName)) {
        [mActivityIndicator stopAnimating];
        [self.mBannerImageView setImage:[UIImage imageWithContentsOfFile:imageFilePath(fmtFileName)]];
    }
    else{
        [self.mBannerImageView setImage:[UIImage imageNamed:@"BrandBannerDefaultImage"]];
        [[IconDownloadManager getInstance] setScreen:kStoreListScreen delegate:self filePath:mBannerImageURL iconID:[pBrand.mID stringValue] indexPath:[NSIndexPath indexPathForRow:-1 inSection:0]];
    }
    
    [self fetchCouponsForBrandAtIndex:mStartIndex];

}

- (void) fetchCouponsForBrandAtIndex:(NSInteger)pStartIndex
{    
    NSDictionary *idDict = [NSDictionary dictionaryWithObject:mBrandID forKey:@"id"];
    
    NSArray *tIDs = [NSArray arrayWithObjects:idDict, nil];
    //NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    NSMutableDictionary *tRequestDict = [NSMutableDictionary new];
    [tRequestDict setObject:[NSNumber numberWithInt:pStartIndex] forKey:@"startIndex"];
    [tRequestDict setObject:[NSNumber numberWithInt:kItemsPerPage] forKey:@"itemsPerPage"];
    [tRequestDict setObject:tIDs forKey:@"brands"];

    
    NSString *jsonRequest = [tRequestDict JSONRepresentation];
    //NSLog(@"jsonRequest is %@", jsonRequest);
    
    //  NSString *tPostBody = [NSString stringWithFormat:@"[\"%d\"]", [mCoupon.mID integerValue]];
    [[RequestHandler getInstance] postRequestwithHostURL:kURL_PostCouponQuery bodyPost:jsonRequest delegate:self requestType:kCouponQueryBrandPostRequest];

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
    
        if (pRequestType == kCouponQueryStorePostRequest) {

            if (!pError) {
                if (mCouponListArray) {
                    [mCouponListArray removeAllObjects];
                }
                mCouponListArray = [[DataManager getInstance] mStoreCheckInCouponArray];
            } else {
                //NSLog(@"Request Failed:%d | Code:%d | Message:%@",pRequestType, pError.mErrorCode.intValue, pError.mMessage);
                
                UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Unable to fetch Coupons" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [tAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
            }

        }else if (pRequestType == kCouponQueryBrandPostRequest) {
            if (!pError) {
                if (mCouponListArray) {
                    [mCouponListArray removeAllObjects];
                }
                mCouponListArray = [[DataManager getInstance] mBrandCheckInCouponArray];
            } else {
                //NSLog(@"Request Failed:%d | Code:%d | Message:%@",pRequestType, pError.mErrorCode.intValue, pError.mMessage);
                
                UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Unable to fetch Coupons" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [tAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
            }
        }
    if (!pError) {
        //NSLog(@"--------------mCouponListArray:%d", [mCouponListArray count]);
        mIsLoadMore = [mCouponListArray count] % kItemsPerPage == 0 ? YES : NO;
        
        [self refreshData];
    }
    
        //[self performSelectorOnMainThread:@selector(refreshData) withObject:nil waitUntilDone:NO];
}

- (void) refreshData {
    [mHudPresenter hideHud];
    [self.mTableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [mCouponListArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CouponsListCell";
    
    CouponsListCell *cell = (CouponsListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CouponsListCell" owner:self options:nil];
        cell = (CouponsListCell *)[topLevelObjects objectAtIndex:0];
        
    }

    [cell.mImageView setImageWithURL:[NSURL URLWithString:[couponThumbnail objectAtIndex:indexPath.row]]];
 
    MyCoupons *tCoupon = [mCouponListArray objectAtIndex:indexPath.row];
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
    
    
    cell.mTitleLabel.text          =  [tCoupon valueForKey:@"name"];
    cell.mCouponDiscountLabel.text =  [tCoupon valueForKey:@"promo_text_short"];
    cell.mCouponDetailLabel.text   =  [tCoupon valueForKey:@"promo_text_long"] ;
    cell.mValidDateLabel .text     =  str;

    
    if (indexPath.row  == [mCouponListArray count] - 1)
    {
        if (mIsLoadMore)
        {
            mStartIndex += kItemsPerPage;
            if (mIsStoreCoupons)
            {
                [self fetchCouponsForStoreAtIndex:mStartIndex];
            }
            else
            {
                [self fetchCouponsForBrandAtIndex:mStartIndex];
            }
            
        }
    }
    
  
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    
    NSDictionary *couponDetails = [mCouponListArray objectAtIndex:indexPath.row];
    //NSLog(@"%@\n\n", couponDetails);
    
    CouponDetailViewController *tController = [CouponDetailViewController new];
    tController.mCouponName             = couponDetails[@"name"];
    tController.mCouponPromoTextShort   = couponDetails[@"promo_text_short"];
    tController.mCouponPromoTextLong    = couponDetails[@"promo_text_long"];
    tController.mCouponExpireDate       = couponDetails[@"expiry_date"];
    tController.mCouponID               = couponDetails[@"id"];
    tController.locatarray              = couponDetails[@"store_name"];
    tController.mCodeType               = couponDetails[@"code_type"];
    tController.mBarcodeImage           = couponDetails[@"barcode_image"];
    tController.mCouponImage            = couponDetails[@"coupon_image"];
    tController.mCouponDescription      = couponDetails[@"coupon_description"];

    [self.navigationController pushViewController:tController animated:YES];
    
}


- (void) iconDownloadManager:(IconDownloadManager *)pIconDownloadManager indexPath:(NSIndexPath *)pIndexPath
{
    if (pIndexPath.row < 0) {
        if (mEntityType == kBrandEntityType) {
            NSString *tFileName = [mBannerImageURL lastPathComponent];
            NSString *fmtFileName = makeFileName(mBrandID, tFileName);
            //NSLog(@"Banner ----- fmtFileName:%@", mBrandID);
            //NSLog(@"Banner path=== : %@", fmtFileName);
            [self performSelectorOnMainThread:@selector(displayBanner:) withObject:imageFilePath(fmtFileName) waitUntilDone:NO];
            
        } else if (mEntityType == kStoreEntityType) {
            NSString *tFileName = [mBannerImageURL lastPathComponent];
            NSString *fmtFileName = makeFileName(mBannerID, tFileName);
            //NSLog(@"Banner ----- fmtFileName:%@", mBannerID);
            //NSLog(@"Banner path=== : %@", fmtFileName);
            [self performSelectorOnMainThread:@selector(displayBanner:) withObject:imageFilePath(fmtFileName) waitUntilDone:NO];

        }
        [self.mTableView beginUpdates];
        
    } else if ([mCouponListArray count] > pIndexPath.row) {
        [self.mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:pIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
	[self.mTableView endUpdates];
}

- (void) displayBanner:(NSString *)pFilePath{
    [self.mBannerImageView setImage:[UIImage imageWithContentsOfFile:pFilePath]];
}



- (void)StoresMapView:(id)sender
{
    //NSLog(@"--------------------:%@",mBannerID);
    StoreLocatorMap *tStoreLocator = [StoreLocatorMap new];
    UINavigationController *tNavigationController= [[UINavigationController alloc] initWithRootViewController:tStoreLocator];
    [self presentViewController:tNavigationController animated:YES completion:^{

    }];
    //[tStoreLocator setStoreLocationWithStoreID:mBannerID];

}

- (StorePreferences *) getBrandById:(NSInteger)pID {
    if (mDBStorePreferencesArray) {
        [mDBStorePreferencesArray removeAllObjects];
    }
    mDBStorePreferencesArray = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchAllStoresPreference:nil]];

    for (StorePreferences *tStorePreferences in mDBStorePreferencesArray) {
        if (mEntityType == kStoreEntityType) {
            if (pID == [tStorePreferences.mStoreID integerValue]) {
                return tStorePreferences;
            }
            
        } else if (mEntityType == kBrandEntityType) {
            if (pID == [tStorePreferences.mBrandID integerValue]  )
            {
                return tStorePreferences;
            }

        }
    }
    return nil;
}


- (IBAction)addStorePreferences:(UIButton *)pButton {
    
  /*  StoreSettingViewController *tStoreSettingViewController = [[StoreSettingViewController alloc] initWithNibName:@"StoreSettingViewController" bundle:nil];
    tStoreSettingViewController.mStoreName = mBannerName;
    tStoreSettingViewController.mBrandName = mBrandName;
    if (pButton.tag == 1) {
        tStoreSettingViewController.mStorePreferencesType = kAddStorePreferenes;
    } else {
        tStoreSettingViewController.mStorePreferencesType = kEditStorePreferences;
        if (mEntityType == kStoreEntityType) {
            tStoreSettingViewController.mStorePreferencesSetting = [self getBrandById:[mBannerID integerValue]];
            
        } else {
            tStoreSettingViewController.mStorePreferencesSetting = [self getBrandById:[mBrandID integerValue]];
        }
    }
    [self.navigationController pushViewController:tStoreSettingViewController animated:YES];
    [tStoreSettingViewController getStoreWithStoreID:mBannerID withBrandID:mBrandID withEntityType:mEntityType];
    */
    
    NSString *userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
    NSMutableDictionary *nearmeDic = [NSMutableDictionary dictionary];
    [nearmeDic setObject:userkey forKey:@"userid"];
    [nearmeDic setObject:storeID forKey:@"storeid"];
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/add_to_my_stores.php?",BASE_URL];
    
    jsonparse *objJsonparse =[[jsonparse alloc]init];
    
    NSMutableDictionary *responcedic = [[NSMutableDictionary alloc]init];
    
    responcedic = [objJsonparse customejsonParsing:urlString bodydata:nearmeDic];
    
    //NSMutableArray *mDownloadedCouponList = [responcedic valueForKey:@"data"];
    
    NSMutableArray *mDownloadedCouponList =[responcedic valueForKey:@"response"];
    if ([mDownloadedCouponList  isEqual:@"Success"]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Nil message:@"Store Added to Favorites" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
        
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}





@end
