//
//  StoresViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "StoresViewController.h"
#import "StoreListCell.h"
#import "StoreMapViewController.h"
#import "Stores.h"
#import "Brands.h"
#import "FileUtils.h"
#import "StoreGoogleMapViewController.h"
#import "CameraViewController.h"
#import "LocationDocs.h"
#import "Request.h"
#import "RightMenuViewController.h"
#import "PKRevealController.h"
//#import "Store.h"
#import "StoreListViewController.h"
#import "KxMenu.h"
#import "CouponPreferencesViewController.h"
#import "MyCoupons.h"
#import "FavouriteViewController.h"
#import "MyCouponViewController.h"
#import "FavouriteCouponsViewController.h"
#import "jsonparse.h"
#import "appcommon.h"
#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "StoreFavoritesViewController.h"
#import "countdownManager.h"


@implementation StoresViewController
{
    UIView *mGestureView;BOOL mIsFavorite;
    UIButton *mMenuButton;
    ProgressHudPresenter *mHudPresenter;
    UIButton *mMapViewButton;NSMutableArray *mDownloadedCouponList;
//    NSMutableArray *storeNameArray;
    NSMutableArray *mBrandsArray;
    NSMutableArray *mManufacturerArray;
    NSMutableArray *mQRCheckInArray;
    NSMutableArray *mStoreLocationArray;
    NSMutableArray *mRequestsArray,*mCouponListArray;;
    NSArray *mStoreIDArray;
    NSInteger mStoreStartIndex, mBrandStartIndex;
    NSString *mCategoryString;
    NSInteger mCategoryID;
    BOOL mStoreLoadMore, mBrandLoadMore;
    BOOL mIsDataLoading;
    NSArray *storeitemsArray;
    NSMutableDictionary *nearmereponseData;
    NSString *userkey,*userlat,*userlong;
    NSMutableArray *nearmestoreThumbnail,*nearmestoreNameArray,*nearmepointsarray,*nearmestorenumber,*storenumber,*storeaddress,*nearmestoreaddress,*brandstorenumber,*brandstoreaddress,*nearmestorelatarray,*nearmestorelongarray,*brandstorelatarray,*brandstorelongarray,*storelatary,*storelongary;
    CLLocationManager *locationManager;
    int result;
    CLLocation *locA;

}
@synthesize mtableView, mSeletedTab, mLocationPreference;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Retailers & Manufacturers";
    [self initButtons];
    locationManager = [[CLLocationManager alloc] init];

    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];

//    storeNameArray = [NSMutableArray new];
    mBrandsArray = [NSMutableArray new];
    mManufacturerArray = [NSMutableArray new];
    mStoreLocationArray = [NSMutableArray new];
    mStoreIDArray = [NSArray new];
    
    mStoreStartIndex = 0;
    mBrandStartIndex = 0;
     mDownloadedCouponList = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchFavoriteMyCouponsByCategory:mCategoryID error:nil]];
    
    mStoreLoadMore = mBrandLoadMore = YES;
    mIsDataLoading = NO;[self.revealController setMinimumWidth:210.0f maximumWidth:244.0f forViewController:self];
    [self.revealController setMinimumWidth:220.0f maximumWidth:234.0f forViewController:self];
    mHudPresenter = [[ProgressHudPresenter alloc] init];
    

    mSeletedTab = kNearmMeTab;

    _collation=[UILocalizedIndexedCollation currentCollation];
    digitsArray=[[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"`",@"~",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"-",@"_",@"=",@"+",@"{",@"}",@"[",@"]",@"|",@":",@";",@"'",@"",@"?",@"/",@">",@"<",@".",@",",@" ",@"end",nil ];
    
    
    NSMutableDictionary *myDic = [NSMutableDictionary dictionaryWithCapacity:7];
    
    [myDic setValue:@"456001"       forKey:@"zip"];
    
    

    NSString *urlString = [NSString stringWithFormat:@"%@/get_manufactures.php?",BASE_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:100.0];
    NSError *error;
    [request setTimeoutInterval:100.0];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    //NSLog(@"request  %@", request);
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"data\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *paramsJSONDictionaryData = [NSJSONSerialization dataWithJSONObject:myDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonParamsString = [[NSString alloc] initWithData:paramsJSONDictionaryData encoding:NSUTF8StringEncoding];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",jsonParamsString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    //NSLog(@"body  %@", body);
    //NSLog(@"request  %@", request);
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *jsonResponseDictionary = [NSJSONSerialization JSONObjectWithData:responseData
                                                                           options:kNilOptions
                                                                             error:&error];
    
    NSString *serJSON = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"responseData  %@", serJSON);
    
    //NSLog(@"jsonResponseDictionary=%@",jsonResponseDictionary);
    
    storeThumbnail = [[NSMutableArray alloc]init];
    storeNameArray = [[NSMutableArray alloc]init];
    pointsarray = [[NSMutableArray alloc]init];
    storenumber = [[NSMutableArray alloc]init];
    storeaddress = [[NSMutableArray alloc]init];
    NSArray *itemsArray = [[NSArray alloc]init];
   
    
    itemsArray=[jsonResponseDictionary valueForKey:@"data"];
    NSLog(@"%@", [jsonResponseDictionary valueForKey:@"data"]);
    
    storeNameArray=[itemsArray valueForKey:@"storename"];
    storeThumbnail=[itemsArray valueForKey:@"storeimage"];
    pointsarray = [itemsArray valueForKey:@"checkinpoints"];
    storenumber = [itemsArray valueForKey:@"storeid"];
    storeaddress = [itemsArray valueForKey:@"address"];
    storelatary = [itemsArray valueForKey:@"latitude"];
    storelongary = [itemsArray valueForKey:@"longitude"];
        ////NSLog(@"coupon_image  %@", storeNameArray);
       // //NSLog(@"storeThumbnail  %@", storeThumbnail);
  
   [self nearmedata];
   // [self getCurrentLocation];
    
    
    
    

}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[LocalyticsSession shared] tagScreen:kBrandsStoresScreen];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
//    //NSLog(@"didFailWithError: %@", error);
//    UIAlertView *errorAlert = [[UIAlertView alloc]
//                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
   // //NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
       userlat = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
       userlong = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    
    
    locA = [[CLLocation alloc] initWithLatitude:currentLocation.coordinate.longitude longitude:currentLocation.coordinate.latitude];
    
   
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:[[NSDecimalNumber decimalNumberWithString:[storelatary objectAtIndex:0]] doubleValue] longitude:[[NSDecimalNumber decimalNumberWithString:[storelongary objectAtIndex:0]] doubleValue]];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    
    NSLog(@"%f",distance/1000);
    result = (int)roundf(distance/1000);
    NSLog(@" = %d", result);
}



-(void)getstoresData
{
    
    
    NSString *str=[NSString stringWithFormat:@"%@/get_stores.php",BASE_URL];
    NSString *urlString = [NSString stringWithFormat:@"%@", str];
    NSURL *URL = [[NSURL alloc]initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    // we'll receive raw data so we'll create an NSData Object with it
    NSData *myData = [[NSData alloc]initWithContentsOfURL:URL];
    
    // now we'll parse our data using NSJSONSerialization
    id myJSON = [NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingMutableContainers error:nil];
    
    // typecast an array and list its contents
    NSDictionary *jsondic = (NSDictionary *)myJSON;
    ////NSLog(@"stores data is:%@",jsondic);
    storeitemsArray = [[NSArray alloc]init];

    storeitemsArray = [jsondic valueForKey:@"data"];
    
    NSLog(@"%@", storeitemsArray);
    
    brandstoreNameArray = [storeitemsArray valueForKey:@"storename"];
    brandstoreThumbnail=[storeitemsArray valueForKey:@"storethumbnail"];
    brandpointsarray = [storeitemsArray valueForKey:@"checkinpoints"];
    brandstorenumber = [storeitemsArray valueForKey:@"storeid"];
    brandstoreaddress = [storeitemsArray valueForKey:@"address"];
    brandstorelatarray = [storeitemsArray valueForKey:@"latitude"];
    brandstorelongarray = [storeitemsArray valueForKey:@"longitude"];
    ////NSLog(@"%@", brandstoreNameArray);
   // //NSLog(@"%i",storeitemsArray.count);
    
}
-(void)nearmedata
{
    // check for location
    int mSeletedValue = [[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreference];
    if(mSeletedValue==0 || [countdownManager shareManeger].userLocationDidUpdate)
    {
        [countdownManager shareManeger].userLocationDidUpdate = NO;
        [countdownManager callWebServiceForLocationUpdate];
    }
    userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
    NSMutableDictionary *nearmeDic = [NSMutableDictionary dictionary];
    [nearmeDic setObject:userkey forKey:@"userid"];
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/get_nearby_retailer_manufacturer.php?",BASE_URL];
    
    jsonparse *objJsonparse =[[jsonparse alloc]init];
    
    nearmereponseData = [[NSMutableDictionary alloc]init];
    
    nearmereponseData = [objJsonparse customejsonParsing:urlString bodydata:nearmeDic];
    
    mDownloadedCouponList = [nearmereponseData valueForKey:@"data"];
    
    nearmestoreThumbnail = [[NSMutableArray alloc]init];
    nearmestoreNameArray = [[NSMutableArray alloc]init];
    nearmepointsarray = [[NSMutableArray alloc]init];
    nearmestorenumber = [[NSMutableArray alloc]init];
    nearmestoreaddress = [[NSMutableArray alloc]init];
    nearmestorelatarray = [[NSMutableArray alloc]init];
    nearmestorelongarray = [[NSMutableArray alloc]init];
    nearmestoreNameArray=[mDownloadedCouponList valueForKey:@"storename"];
    nearmestoreThumbnail=[mDownloadedCouponList valueForKey:@"storeimage"];
    nearmepointsarray = [mDownloadedCouponList valueForKey:@"checkinpoints"];
    nearmestorenumber = [mDownloadedCouponList valueForKey:@"storeid"];
    nearmestoreaddress = [mDownloadedCouponList valueForKey:@"address"];
    nearmestorelatarray = [mDownloadedCouponList valueForKey:@"latitude"];
    nearmestorelongarray = [mDownloadedCouponList valueForKey:@"longitude"];
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
    mMapViewButton.selected=YES;
}

-(void)menuButtonUnselected {
	mMenuButton.selected = NO;
    mMapViewButton.selected = NO;

}


#pragma mark -
#pragma mark Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    // Return the number of sections.
//    return 1;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

    switch (mSeletedTab) {
        case kNearmMeTab:
            return [mDownloadedCouponList count];
            break;
            
        case kBrandsTab:
//            [self flexibleRows:section];
            return [storeitemsArray count];
            break;
        case kQRCheckInTab:
            return [mQRCheckInArray count];
            break;
        case kStoreWithNotification:
            return [storeNameArray count];
            break;
        case kManufacturersTab:
            NSLog(@"%@", storeNameArray);
            return [storeNameArray count];
            break;
        default:
            break;
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    switch (mSeletedTab) {
        case kNearmMeTab:
//            if(sectionwithindex.count>0)
//              return [sectionwithindex objectAtIndex:section];
//            else
                return nil;
            break;
        case kBrandsTab:
            return Nil;
            break;
        case kManufacturersTab:
            return nil;
            break;
        default:
            break;
    }
    return 0;
    
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(290, 0, 20, 20)];
    labelSection = [[UILabel alloc]initWithFrame:headerView.frame];
    //labelSection.backgroundColor = [UIColor redColor];
    //labelSection.text =
    [headerView addSubview:labelSection];
    return headerView;
    
}*/
-(NSInteger )tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
//    labelSection.text = [_collation sectionForSectionIndexTitleAtIndex:index];
    //NSLog(@"StoresViewController-sectionForSectionIndexTitle=%d",[_collation sectionForSectionIndexTitleAtIndex:index]);
    return [_collation sectionForSectionIndexTitleAtIndex:index];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    switch (mSeletedTab) {
        case kNearmMeTab:
//            [self sectionCount:storeNameArray];
            return 1;

            break;
        case kBrandsTab:
//            [self sectionCount1:mBrandsArray];
            return 1;
            break;
        case kManufacturersTab:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"StoreListCelll";
    
    StoreListCell *cell = (StoreListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"StoreListCell" owner:self options:nil];
        cell = (StoreListCell *)[topLevelObjects objectAtIndex:0];
    }
    [cell.mSeperatorImageView setHidden:YES];
    // Configure the cell...
    switch (mSeletedTab) {
        case kNearmMeTab:
        {
//            [storeNameArray removeObjectAtIndex:0];
            if (indexPath.row < [mDownloadedCouponList count]) {
                
                
                //Stores *tStores = [storeNameArray objectAtIndex:indexPath.row];
               // Stores *tStores = [nearmestoreNameArray objectAtIndex:indexPath.row];
               // StoreLocations *tStoreLocations = [storeNameArray objectAtIndex:indexPath.row];

                cell.mStoreTitleLabel.text = [nearmestoreNameArray objectAtIndex:indexPath.row];
                cell.mActiveCouponsLabel.text =[NSString stringWithFormat:@"%d Active Points",[[nearmepointsarray objectAtIndex:indexPath.row] intValue]];
                //[storeNameArray objectAtIndex:indexPath.row];
                
                //CheckIn button in the cell.
                cell.mCheckInButton.tag = indexPath.row;
                [cell.mCheckInButton addTarget:self action:@selector(checkInbuttontapped:) forControlEvents:UIControlEventTouchUpInside];
                
//                cell.mCheckInButton.imageView.image=[storeThumbnail objectAtIndex:indexPath.row];
                
               // NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[nearmestoreThumbnail objectAtIndex:indexPath.row]]];
                //cell.mImageView.image = [UIImage imageWithData:imageData];
                [cell.mImageView setImageWithURL:[NSURL URLWithString:[nearmestoreThumbnail objectAtIndex:indexPath.row]]];
                
                cell.mDistanceLabel.text = [NSString stringWithFormat:@"%d", result];
                
                
//                cell.mStoreTitleLabel.text = [nearmestoreNameArray objectAtIndex:indexPath.row];
//                cell.mActiveCouponsLabel.text = [NSString stringWithFormat:@"%d Active Points",[[nearmepointsarray objectAtIndex:indexPath.row] intValue]];
//                NSData *nearimageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[nearmestoreThumbnail objectAtIndex:indexPath.row]]];
//                
//                cell.mImageView.image = [UIImage imageWithData:nearimageData];
                
                
              //  NSString *tFileName = [tStores.mThumbnailImage lastPathComponent];
//                NSString *tFileName = [tStores.mThumbnailImage lastPathComponent];
//                NSString *fmtFileName = makeFileName([tStores.mID stringValue], tFileName);
                
//                if (isFileExists(fmtFileName)) {
//                    cell.mImageView.image =  [UIImage imageWithContentsOfFile:imageFilePath(fmtFileName)];
//                }
//                else{
//                    cell.mImageView.image = [UIImage imageNamed:@"StoresHomeDefaultImage"];
//                    [[IconDownloadManager getInstance] setScreen:kNearMeScreen delegate:self filePath:tStores.mThumbnailImage iconID:[tStores.mID stringValue] indexPath:indexPath];
//                    
//                }
                
//                cell.mDistanceLabel.text = [[Location getInstance] getDistanceFromCurrentLocationInMiles:tStoreLocations.mISO6709GeoCoordinate];
//                [cell.mDiscountLabel setHidden:YES];
                
//                if (indexPath.row == [storeNameArray count]  && !mStoreLoadMore) {
//                    [cell.mSeperatorImageView setHidden:NO];
//                }
                
//                if (indexPath.row  == [storeNameArray count]) {
//                    if (mStoreLoadMore && !mIsDataLoading) {
//                        mStoreStartIndex += kItemsPerPage;
////                        [self fetchStoreListAtIndex:mStoreStartIndex];
//                    }
//                 }
              }
            [mMapViewButton setHidden:NO];
        }
            break;
            
            
        case kManufacturersTab:
        {
            if (indexPath.row < [storeNameArray count]) {
                
                if([storelongary objectAtIndex:indexPath.row] != (id)[NSNull null] || [storelatary objectAtIndex:indexPath.row] != (id)[NSNull null]) {
                    //Stores *tStores = [storeNameArray objectAtIndex:indexPath.row];
                    Stores *tStores = [storeNameArray objectAtIndex:indexPath.row];
                    StoreLocations *tStoreLocations = [storeNameArray objectAtIndex:indexPath.row];
                    
                    cell.mStoreTitleLabel.text = [storeNameArray objectAtIndex:indexPath.row];
                    cell.mActiveCouponsLabel.text = [NSString stringWithFormat:@"%d Active Points",[[pointsarray objectAtIndex:indexPath.row] intValue]];//[NSString stringWithFormat:@"%d Active Coupons",[tStores.mActiveCouponCount intValue]];
                    
                    //CheckIn button in the cell.
                    cell.mCheckInButton.tag = indexPath.row;
                    [cell.mCheckInButton addTarget:self action:@selector(checkInStore:) forControlEvents:UIControlEventTouchUpInside];
                    
                    //CLLocation *locA = [[CLLocation alloc] initWithLatitude:currentLocation.coordinate.longitude longitude:currentLocation.coordinate.latitude];
                    
                    CLLocation *locB = [[CLLocation alloc] initWithLatitude:[[NSDecimalNumber decimalNumberWithString:[storelatary objectAtIndex:indexPath.row]] doubleValue] longitude:[[NSDecimalNumber decimalNumberWithString:[storelongary objectAtIndex:indexPath.row]] doubleValue]];
                    
                    CLLocationDistance distance = [locA distanceFromLocation:locB];
                    result = (int)roundf(distance/1000);
                    cell.mDistanceLabel.text = [NSString stringWithFormat:@"%d", result];
                    [cell.mImageView setImageWithURL:[NSURL URLWithString:[storeThumbnail objectAtIndex:indexPath.row]]];
                    [cell.mDiscountLabel setHidden:YES];
                }
            }
            [mMapViewButton setHidden:NO];
            
        }

        
            break;
            
          //*********Retaileres
        case kBrandsTab:
        {
           // [self sortingNames];
//            if([storeitemsArray count] )
//            {
//                brandDynamicCount =0;
//            }
            if (indexPath.row < [storeitemsArray count]) {
                //[mMapViewButton setHidden:NO];
                //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                Brands *tBrand =[[filteringBrands valueForKey:[NSString stringWithFormat:@"%d",indexPath.section] ] objectAtIndex:indexPath.row];
                //[mBrandsArray objectAtIndex:brandDynamicCount];http://install.diawi.com/SyC3us
//                //NSLog(@"section is %d %@",indexPath.section,[filteringBrands allKeys]);
//                //NSLog(@"mBrandsArray data %@",[filteringBrands valueForKey:[NSString stringWithFormat:@"%d",indexPath.section]]);
//                brandDynamicCount++;
                cell.mStoreTitleLabel.text = [brandstoreNameArray objectAtIndex:indexPath.row];
                //cell.mActiveCouponsLabel.text = [NSString stringWithFormat:@"%d Active Points",[[brandpointsarray objectAtIndex:indexPath.row] intValue]];
               // NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[brandstoreThumbnail objectAtIndex:indexPath.row]]];
               
                    //cell.mImageView.image = [UIImage imageWithData:imageData];
                [cell.mImageView setImageWithURL:[NSURL URLWithString:[brandstoreThumbnail objectAtIndex:indexPath.row]]];

                cell.mCheckInButton.tag = indexPath.row;
                [cell.mCheckInButton addTarget:self action:@selector(retailercheckin:) forControlEvents:UIControlEventTouchUpInside];
//                NSString *tFileName = [tBrand.mThumbnailImage lastPathComponent];
//                NSString *fmtFileName = makeFileName([tBrand.mID stringValue], tFileName);
//                if (isFileExists(fmtFileName)) {
//                    cell.mImageView.image =  [UIImage imageWithContentsOfFile:imageFilePath(fmtFileName)];
//                }
//                else{
//                    cell.mImageView.image = [UIImage imageNamed:@"BrandsHomeDefaultImage"];
//                    [[IconDownloadManager getInstance] setScreen:kBrandSceen delegate:self filePath:tBrand.mThumbnailImage iconID:[tBrand.mID stringValue] indexPath:indexPath];
//                }
                
                //CheckIn button in the cell.
               // [cell.mCheckInButton setHidden:YES];
                [cell.mActiveCouponsLabel setHidden:YES];
                [cell.mDistanceLabel setHidden:YES];
               // [cell.mDiscountLabel setHidden:YES];
               // [cell.mDistanceLabel setHidden:YES];
                
//                if (indexPath.row == [storeNameArray count] - 1 && !mBrandLoadMore) {
//                    [cell.mSeperatorImageView setHidden:NO];
//                }
//                
//                if (indexPath.row  == [storeNameArray count] - 1) {
//                    if (mBrandLoadMore && !mIsDataLoading) {
//                        mBrandStartIndex += kItemsPerPage;
////                        [self fetchBrandListAtIndex:mBrandStartIndex];
//                    }
//                }
            }
        }
            break;
            
        case kQRCheckInTab:
        {
            [mMapViewButton setHidden:NO];

        
        }
            break;
        case kStoreWithNotification:
        {
            if (indexPath.row < [storeNameArray count]) {
                [mMapViewButton setHidden:NO];
                
                //Stores *tStores = [storeNameArray objectAtIndex:indexPath.row];
                Stores *tStores = [storeNameArray objectAtIndex:indexPath.row];
                StoreLocations *tStoreLocations = [mStoreLocationArray objectAtIndex:indexPath.row];
                
                cell.mStoreTitleLabel.text = tStores.mFullName;
                cell.mActiveCouponsLabel.text = [NSString stringWithFormat:@"%d Active Coupons",[tStores.mActiveCouponCount intValue]];
                
                //CheckIn button in the cell.
                cell.mCheckInButton.tag = indexPath.row;
                [cell.mCheckInButton addTarget:self action:@selector(checkInStore:) forControlEvents:UIControlEventTouchUpInside];
                
                
                //  NSString *tFileName = [tStores.mThumbnailImage lastPathComponent];
                NSString *tFileName = [tStores.mThumbnailImage lastPathComponent];
                NSString *fmtFileName = makeFileName([tStores.mID stringValue], tFileName);
                
                if (isFileExists(fmtFileName)) {
                    cell.mImageView.image =  [UIImage imageWithContentsOfFile:imageFilePath(fmtFileName)];
                }
                else{
                    cell.mImageView.image = [UIImage imageNamed:@"StoresHomeDefaultImage"];
                    [[IconDownloadManager getInstance] setScreen:kNearMeScreen delegate:self filePath:tStores.mThumbnailImage iconID:[tStores.mID stringValue] indexPath:indexPath];
                    
                }
                
                cell.mDistanceLabel.text = [[Location getInstance] getDistanceFromCurrentLocationInMiles:tStoreLocations.mISO6709GeoCoordinate];
                [cell.mDiscountLabel setHidden:YES];
                
                if (indexPath.row == [storeNameArray count] + 1 && !mStoreLoadMore) {
                    [cell.mSeperatorImageView setHidden:NO];
                }
                
                if (indexPath.row  == [storeNameArray count] + 1) {
                    if (mStoreLoadMore && !mIsDataLoading) {
                        mStoreStartIndex += kItemsPerPage;
                        [self fetchStoreListAtIndex:mStoreStartIndex];
                    }
                }
            }
        }
            break;

        default:
            break;
    }
    
    return cell;
}


-(void) checkInStore:(UIButton *)sender {
    
    
    
    StoreListViewController *tStoreListViewController = [[StoreListViewController alloc] initWithNibName:@"StoreListViewController" bundle:nil];
    tStoreListViewController.mStoreLocator = kstoreSelected;
    tStoreListViewController.titlestring = [storeNameArray objectAtIndex:sender.tag];
    tStoreListViewController.addressstring = [storeaddress objectAtIndex:sender.tag];
    tStoreListViewController.tempstring = [storeThumbnail objectAtIndex:sender.tag];
    tStoreListViewController.storeID = [storenumber objectAtIndex:sender.tag];
    tStoreListViewController.latstring = [storelatary objectAtIndex:sender.tag];
    tStoreListViewController.longstring = [storelongary objectAtIndex:sender.tag];
    [self.navigationController pushViewController:tStoreListViewController animated:YES];
//    tStoreListViewController.mStoreID = tStores.mID;
//    [tStoreListViewController showCouponsForStore:tStores];
//    [tStoreListViewController showLocationForStore:tStoreLocations];
    
}

-(void) checkInbuttontapped:(UIButton *)sender {
    
    //NSLog(@"Button tapped");

    StoreListViewController *tStoreListViewController = [[StoreListViewController alloc] initWithNibName:@"StoreListViewController" bundle:nil];
    tStoreListViewController.titlestring = [nearmestoreNameArray objectAtIndex:sender.tag];
    tStoreListViewController.addressstring = [nearmestoreaddress objectAtIndex:sender.tag];
     tStoreListViewController.tempstring = [nearmestoreThumbnail objectAtIndex:sender.tag];
     tStoreListViewController.storeID = [nearmestorenumber objectAtIndex:sender.tag];
    tStoreListViewController.latstring = [nearmestorelatarray objectAtIndex:sender.tag];
    tStoreListViewController.longstring = [nearmestorelongarray objectAtIndex:sender.tag];
    [self.navigationController pushViewController:tStoreListViewController animated:YES];



}
-(void) retailercheckin:(UIButton *)sender {

    StoreListViewController *tStoreListViewController = [[StoreListViewController alloc] initWithNibName:@"StoreListViewController" bundle:nil];
    tStoreListViewController.titlestring = [brandstoreNameArray objectAtIndex:sender.tag];
    tStoreListViewController.addressstring = [brandstoreaddress objectAtIndex:sender.tag];
    tStoreListViewController.tempstring = [brandstoreThumbnail objectAtIndex:sender.tag];
    tStoreListViewController.storeID = [brandstorenumber objectAtIndex:sender.tag];
    tStoreListViewController.latstring = [brandstorelatarray objectAtIndex:sender.tag];
    tStoreListViewController.longstring = [brandstorelongarray objectAtIndex:sender.tag];
    [self.navigationController pushViewController:tStoreListViewController animated:YES];
}

- (void) iconDownloadManager:(IconDownloadManager *)pIconDownloadManager indexPath:(NSIndexPath *)pIndexPath
{
    [self.mtableView beginUpdates];

    switch (mSeletedTab) {
        case kNearmMeTab:
        {
            if ([storeNameArray count] > pIndexPath.row) {
                [self.mtableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:pIndexPath] withRowAnimation:UITableViewRowAnimationNone];

            }
        }
            break;
        case kBrandsTab:
        {
            if ([storeNameArray count] > pIndexPath.row) {
                [self.mtableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:pIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                
            }
        }
            break;
        case kStoreWithNotification:
        {
            if ([storeNameArray count] > pIndexPath.row) {
                [self.mtableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:pIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                
            }
        }
            break;
        case kManufacturersTab:
        {
            if ([storeNameArray count] > pIndexPath.row) {
                [self.mtableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:pIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                
            }

        }
            break;

        default:
            break;
    }
	[self.mtableView endUpdates];
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
/*
    StoreListViewController *tStoreListViewController = [[StoreListViewController alloc] initWithNibName:@"StoreListViewController" bundle:nil];
    tStoreListViewController.titlestring = [brandstoreNameArray objectAtIndex:indexPath.row];
    tStoreListViewController.addressstring = [brandstoreaddress objectAtIndex:indexPath.row];
    tStoreListViewController.tempstring = [brandstoreThumbnail objectAtIndex:indexPath.row];
    tStoreListViewController.storeID = [brandstorenumber objectAtIndex:indexPath.row];
    tStoreListViewController.latstring = [brandstorelatarray objectAtIndex:indexPath.row];
    tStoreListViewController.longstring = [brandstorelongarray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:tStoreListViewController animated:YES];*/
}

- (void)showMenu:(UIButton *)sender
{

        // Assing the arrya to Multiple buttons nn
       
    
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"Near Me"
                     image:[UIImage imageNamed:@"sm_nearby.png"]
                    target:self
                    action:@selector(pushMenuItem1:)],
      
      [KxMenuItem menuItem:@"Retailers"
                     image:[UIImage imageNamed:@"sm_store.png"]
                    target:self
                    action:@selector(pushMenuItem2:)],
      
      [KxMenuItem menuItem:@"Manufactures"
                     image:[UIImage imageNamed:@"sm_coupon3.png"]
                    target:self
                    action:@selector(pushMenuItem3:)],
      
      [KxMenuItem menuItem:@"Store Favorites"
                     image:[UIImage imageNamed:@"favorites"]
                    target:self
                    action:@selector(pushMenuItem4:)],
      
      [KxMenuItem menuItem:@"Store Map"
                     image:[UIImage imageNamed:@"btn_map_02.png"]
                    target:self
                    action:@selector(pushMenuItem5:)],
      
            ];
    
    KxMenuItem *first = menuItems[0];
    //  first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    //first.alignment = NSTextAlignmentCenter;
    
    
    CGRect rect = CGRectMake(200, -100, 100, 100);
    [KxMenu showMenuInView:self.view
                  fromRect:rect
                 menuItems:menuItems];

    
    

}


- (void) pushMenuItem1:(id)sender
{
    
    //[self NearMeSelected:sender];
    mSeletedTab = kNearmMeTab;
    [mMapViewButton setHidden:NO];
    
//    [self fetchStoreListAtIndex:mStoreStartIndex];
    [self nearmedata];
    [self.mtableView reloadData];
    

    
}

- (void) pushMenuItem2:(id)sender
{
    
    //[self BrandSelected:sender];
    mSeletedTab = kBrandsTab;
//    sectionwithindex=[NSMutableArray array];
//    [self fetchBrandListAtIndex:mBrandStartIndex];
//    filteringBrands=[NSMutableDictionary new];
//    brandDynamicCount=0;
    [self getstoresData];
    [self.mtableView reloadData];
}

- (void) pushMenuItem3:(id)sender
{
    mSeletedTab = kManufacturersTab;
    [mMapViewButton setHidden:NO];
    
//    [self fetchStoreListAtIndex:mStoreStartIndex];
   [self.mtableView reloadData];
}




- (void) pushMenuItem4:(id)sender
{
    
//    CouponPreferencesViewController *storefav = [[CouponPreferencesViewController alloc]initWithNibName:@"CouponPreferencesViewController" bundle:nil];
//    
//        [self.navigationController pushViewController:storefav animated:YES];
    StoreFavoritesViewController *storeFavoritesViewController = [[StoreFavoritesViewController alloc]initWithNibName:@"StoreFavoritesViewController" bundle:Nil];
    [self.navigationController pushViewController:storeFavoritesViewController animated:YES];
    
}



- (void) pushMenuItem5:(id)sender
{
//    [self StoresMapView:sender];
    StoreMapViewController *storefav = [[StoreMapViewController alloc]initWithNibName:@"StoreMapViewController" bundle:nil];
    
    [self.navigationController pushViewController:storefav animated:YES];
}

- (void) initButtons{
    //Map View Button.
    
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn1.frame = CGRectMake(260, 0, 40, 30);
//    [btn1 setImage:[UIImage imageNamed:@"btn_more.png"] forState:UIControlStateNormal];
//    [btn1 addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn1];
    
    
    mMapViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [mMapViewButton setImage:[UIImage imageNamed:@"btn_more"] forState:UIControlStateNormal];
    [mMapViewButton sizeToFit];
    [mMapViewButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
//    [mMapViewButton addTarget:self action:@selector(revealToggle11:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tMapBarButton = [[UIBarButtonItem alloc]initWithCustomView:mMapViewButton];
    self.navigationItem.rightBarButtonItem = tMapBarButton;
    
    //Near me Store Button on Store View.
    //[mNearmeStoreButton setImage:[UIImage imageNamed:@"nearmen"] forState:UIControlStateNormal];
    //[mNearmeStoreButton setImage:[UIImage imageNamed:@"nearmeh"] forState:UIControlStateSelected];
    //[mNearmeStoreButton addTarget:self action:@selector(NearMeSelected:) forControlEvents:UIControlEventTouchUpInside];
    //[mNearmeStoreButton setSelected:YES];
    
    //Brand Store Button.
    //[mBrandStoreButton setImage:[UIImage imageNamed:@"retailer_n"] forState:UIControlStateNormal];
   // [mBrandStoreButton setImage:[UIImage imageNamed:@"retailer_h"] forState:UIControlStateSelected];
    //[mBrandStoreButton addTarget:self action:@selector(BrandSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    //Favourite Button.
   // [mFavouritesButton setImage:[UIImage imageNamed:@"favorites_nor"] forState:UIControlStateNormal];
   // [mFavouritesButton setImage:[UIImage imageNamed:@"favorites_hil"] forState:UIControlStateSelected];
    //[mFavouritesButton addTarget:self action:@selector(favouriteSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    //Menu Button.
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


#pragma mark -tableview index sectionCount
//-(void)sectionCount:(NSMutableArray *)_BrandsArray
//{
//    //NSLog(@"sortedArray is ******%d==%d",sortedArray.count,_BrandsArray.count);
//    //[self sortingNames];
//    sectionwithindex=[[NSMutableArray alloc]init];
//    temp1234=0;
//
//    if (_BrandsArray.count !=0 )
//    {
//        int j=0,k,l,m,n;
//        
//        sectionwithindex=[[NSMutableArray alloc]init];
//        for (; j<27; j++) {
//            
//            k=0,l=0,m=0,n=0;
//            
//            NSString *tempstr4=[[_collation sectionTitles]objectAtIndex:j];
//            for (Stores *stores in _BrandsArray) {
//                
//                NSString *tempstr3;
//                NSString *tempstr1;
//            
//                if (stores.mFullName)
//                {
//                    tempstr1=stores.mFullName;
//                }
//                else
//                {return;}
//               
//                if (tempstr1!=nil) {
//                    tempstr3=[tempstr1 substringToIndex:1];
//                }
//                
//                BOOL result=([tempstr3 caseInsensitiveCompare:tempstr4]==NSOrderedSame);
//                
//                if ([tempstr4 isEqualToString:@"#"]) {
//                    for (NSString *tstring in digitsArray) {
//                        if ([tempstr3 isEqualToString:tstring]) {
//                            if (m==0) {
//                                [sectionwithindex addObject:tempstr4];
//                                m++;
//                                l++;
//                                break;
//                            }
//                        }
//                        else{
//                            if ([tstring isEqualToString:@"end"] && m==0) {
//                                m++;
//                                [sectionwithindex addObject:@""];
//                                break;
//                            }
//                        }
//                    }
//                }
//                else{
//                    
//                    if (result)
//                    {
//                        
//                        if (k==0) {
//                            temp1234=27;
//                            l++;
//                            [sectionwithindex addObject:tempstr4];
//                            break;
//                        }
//                        k++;
//                    }
//                }
//            }
//            if (l==0) {
//                if ([tempstr4 isEqualToString:@"#"])
//                {
//                    temp1234=sectionwithindex.count;
//                }
//                else
//                {
//                    //temp1234=sectionwithindex.count;
//
//                }
//            }
//            
//        }
//    }
//}
//-(void)sectionCount1:(NSMutableArray *)_BrandsArray
//{
//    //NSLog(@"sortedArray is ******%d==%d",sortedArray.count,_BrandsArray.count);
//    //[self sortingNames];
//    sectionwithindex=[[NSMutableArray alloc]init];
//    temp1234=0;
//    
//    if (_BrandsArray.count !=0 )
//    {
//        int j=0,k,l,m,n;
//        
//        sectionwithindex=[[NSMutableArray alloc]init];
//        for (; j<27; j++) {
//            
//            k=0,l=0,m=0,n=0;
//            
//            NSString *tempstr4=[[_collation sectionTitles]objectAtIndex:j];
//            for (Brands *tbrand in _BrandsArray) {
//                
//                NSString *tempstr3;
//                NSString *tempstr1;
//                
//                if (tbrand.mName)
//                {
//                    tempstr1=tbrand.mName;
//                }
//                else
//                {return;}
//                
//                if (tempstr1!=nil) {
//                    tempstr3=[tempstr1 substringToIndex:1];
//                }
//                
//                BOOL result=([tempstr3 caseInsensitiveCompare:tempstr4]==NSOrderedSame);
//                
//                if ([tempstr4 isEqualToString:@"#"]) {
//                    for (NSString *tstring in digitsArray) {
//                        if ([tempstr3 isEqualToString:tstring]) {
//                            if (m==0) {
//                                [sectionwithindex addObject:tempstr4];
//                                m++;
//                                l++;
//                                break;
//                            }
//                        }
//                        else{
//                            if ([tstring isEqualToString:@"end"] && m==0) {
//                                m++;
//                                [sectionwithindex addObject:@""];
//                                break;
//                            }
//                        }
//                    }
//                }
//                else{
//                    
//                    if (result)
//                    {
//                        
//                        if (k==0) {
//                            temp1234=27;
//                            l++;
//                            [sectionwithindex addObject:tempstr4];
//                            break;
//                        }
//                        k++;
//                    }
//                }
//            }
//            if (l==0) {
//                if ([tempstr4 isEqualToString:@"#"])
//                {
//                    temp1234=sectionwithindex.count;
//                }
//                else
//                {
//                    //temp1234=sectionwithindex.count;
//                    
//                }
//            }
//            
//        }
//    }
//}
//
//
//
//#pragma mark -Tableview flexibleRows in section
//-(void)flexibleRows:(NSInteger)section
//{
//
//    if (mBrandsArray.count !=0)
//    {
//        int i=0;
//        
////        NSString *str=[sectionwithindex objectAtIndex:section];
//        displayArray=[[NSMutableArray alloc]init];
//        
//        NSString *brandNameSection=[sectionwithindex objectAtIndex:section];
//        for (NSDictionary *brandObject in mBrandsArray)
//        {
//            NSString *brandTitle=[brandObject valueForKey:@"mName"];
//            NSString *sectionTitle=[brandTitle substringToIndex:1];
//            BOOL result=([sectionTitle caseInsensitiveCompare:brandNameSection]==NSOrderedSame);
//
//                if (result)
//                {
//                   // NSMutableDictionary *displaydictionary=[[NSMutableDictionary alloc]init];
//                    //[displaydictionary setObject:brandTitle forKey:@"mName"];
//                    
//                    [displayArray addObject:brandObject];
//                    
//                    
//                    i++;
//                }
//                else
//                {
//                
//                    //            if ([brandNameSection isEqualToString:@"#"])
//                    //            {
//                    //                for (NSString *tstring in digitsArray)
//                    //                {
//                    //                    if ([brandTitle isEqualToString:tstring])
//                    //                    {
//                    //                        NSMutableDictionary *displaydictionary=[[NSMutableDictionary alloc]init];
//                    //
//                    //                        [displayArray addObject:brandObject];
//                    //                        
//                    //                        i++;
//                    //                        
//                    //                    }
//                    //                }
//                    //            }
//                    //else{
//                
//                }
//           
//        }
//        if(displayArray.count>0)
//           [filteringBrands setObject:displayArray forKey:[NSString stringWithFormat:@"%d",section]];
//        //NSLog(@"%@ filtering brands dictionary ",[filteringBrands valueForKey:[NSString stringWithFormat:@"%d",section]]);
//    }
//    
//}
//
//-(void)sortingNames
//{
//    sortedArray=[[NSMutableArray alloc] init];
//    NSSortDescriptor *BrandNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"mName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] ;
//    
//    NSArray *descriptors = [NSArray arrayWithObjects:BrandNameDescriptor, nil];
//    sortedArray=[mBrandsArray copy];
//    sortedArray=[sortedArray sortedArrayUsingDescriptors:descriptors];
//    mBrandsArray=[sortedArray mutableCopy];
//    //NSLog(@"sortedArray********** %d",sortedArray.count);
//    
//}



@end

