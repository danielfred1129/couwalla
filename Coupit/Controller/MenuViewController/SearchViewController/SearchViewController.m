//
//  SearchViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "CouponsListCell.h"
#import "Coupon.h"
#import "FileUtils.h"
#import "CouponDetailViewController.h"
#import "jsonparse.h"
#import "appcommon.h"
#import "UIImageView+WebCache.h"

#define kNumberOfItemsToDisplay 10

@implementation SearchViewController
{
    ProgressHudPresenter *mHudPresenter;
    
    NSMutableArray *mCouponListArray,*searchstoreNameArray,*searchstoreThumbnail,*searchstoretext;
    UIView *mGestureView;
    UIButton *mMenuButton;
    
    NSInteger mStartIndex;
    BOOL mLoadMore;
    
}

@synthesize mSearchText, mSearchType;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    numberOfItemsToDisplay = kNumberOfItemsToDisplay;
    
    self.navigationItem.title = [NSString stringWithFormat:@"Search '%@'", self.mSearchText];
    self.navigationItem.hidesBackButton = YES;
    
    mLoadMore = YES;
    mStartIndex = 0;
    mHudPresenter = [[ProgressHudPresenter alloc] init];
    mCouponListArray = [NSMutableArray new];
    
    mMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mMenuButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [mMenuButton sizeToFit];
    [mMenuButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
    UIBarButtonItem* menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:mMenuButton];
    self.navigationItem.leftBarButtonItem = menuBarButton;
    
    mGestureView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealToggle:)];
    [mGestureView addGestureRecognizer:recognizer];
    
    UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [mGestureView addGestureRecognizer:panRecognizer];
    
    [self makeSearchRequestWithString:self.mSearchText];
}

- (void) makeSearchRequestWithString:(NSString *)pSearchStr
{
    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
    
    switch (mSearchType)
    {
        case kCouponSearch:
        {
            [parameterDic setObject:mSearchText forKey:@"search_text"];
            [parameterDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"] forKey:@"userid"];
            NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/search_manufacturer_coupons.php?",BASE_URL];
            jsonparse *objJsonparse =[[jsonparse alloc]init];
            NSMutableDictionary *reponseData = [[NSMutableDictionary alloc]init];
            reponseData = [objJsonparse customejsonParsing:urlString bodydata:parameterDic];
            mCouponListArray = [reponseData valueForKey:@"data"];
            
            if (mCouponListArray.count==0)
            {
                UIAlertView *searchalert = [[UIAlertView alloc]initWithTitle:Nil message:@"No Related Data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
                [searchalert show];
                [HUDManager hideHUD];
            }
            
            searchstoreNameArray = [mCouponListArray valueForKey:@"name"];
            searchstoreThumbnail=[mCouponListArray valueForKey:@"coupon_thumbnail"];
            searchstoretext = [mCouponListArray valueForKey:@"promo_text_short"];
            
        }
            break;
        case kStoreSearch:
        {
            [HUDManager showHUDWithText:kHudMassage];
            api = [[GREST alloc] init];
            [api setDelegate:self];
            
            NSString* userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
            // userkey= @"214";
            
            NSDictionary *paramsDictionary=[NSDictionary dictionaryWithObjectsAndKeys:userkey,@"userid",mSearchText,@"search_text", nil];
            NSData *jsonData=[NSJSONSerialization dataWithJSONObject:paramsDictionary options:0 error:Nil];
            NSString *paramString=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            paramString=[paramString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            [api get:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kSearchForStore, paramString]] with_params:nil contentType:nil with_key:@"storeSearch"];
            [api start];
            
        }
            break;
        case kBrandSearch:
        {
            [HUDManager showHUDWithText:kHudMassage];
            api = [[GREST alloc] init];
            [api setDelegate:self];
            
            NSString* userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
            //userkey= @"214";
            
            NSDictionary *paramsDictionary=[NSDictionary dictionaryWithObjectsAndKeys:userkey,@"userid",mSearchText,@"search_text", nil];
            NSData *jsonData=[NSJSONSerialization dataWithJSONObject:paramsDictionary options:0 error:Nil];
            NSString *paramString=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            paramString=[paramString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            [api get:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kSearchForBrand, paramString]] with_params:nil contentType:nil with_key:@"brandsSearch"];
            [api start];
            
        }
            break;
        case kLoyaltyCardSearch:
        {
            
        }
            break;
        default:
        {
            [parameterDic setObject:mSearchText forKey:@"search_text"];
            [parameterDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"] forKey:@"userid"];
            NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/search_manufacturer_coupons.php?",BASE_URL];
            jsonparse *objJsonparse =[[jsonparse alloc]init];
            NSMutableDictionary *reponseData = [[NSMutableDictionary alloc]init];
            reponseData = [objJsonparse customejsonParsing:urlString bodydata:parameterDic];
            mCouponListArray = [reponseData valueForKey:@"data"];
            
            if (mCouponListArray.count==0)
            {
                UIAlertView *searchalert = [[UIAlertView alloc]initWithTitle:Nil message:@"No Related Data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
                [searchalert show];
                [HUDManager hideHUD];
            }
            
            searchstoreNameArray = [mCouponListArray valueForKey:@"name"];
            searchstoreThumbnail=[mCouponListArray valueForKey:@"coupon_thumbnail"];
            searchstoretext = [mCouponListArray valueForKey:@"promo_text_short"];
        }
            break;
    }
}

#pragma mark - GREST Methods

- (void)request_finished:(NSString *)response for_key:(NSString *)request_key
{
    NSMutableDictionary *couponDetails = [[response JSONValue] mutableCopy];
    mCouponListArray =[couponDetails valueForKey:@"data"];
    if([request_key isEqualToString:@"storeSearch"])
    {
        searchstoreNameArray = [mCouponListArray valueForKey:@"storename"];
        searchstoreThumbnail=[mCouponListArray valueForKey:@"storethumbnail"];
        searchstoretext = [mCouponListArray valueForKey:@"storephone"];
    }
    else  if([request_key isEqualToString:@"brandsSearch"])
    {
        searchstoreNameArray = [mCouponListArray valueForKey:@"storename"];
        searchstoreThumbnail=[mCouponListArray valueForKey:@"storethumbnail"];
        searchstoretext = [mCouponListArray valueForKey:@"storephone"];
    }
    if (mCouponListArray.count==0)
    {
        UIAlertView *searchalert = [[UIAlertView alloc]initWithTitle:Nil message:@"No Related Data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [searchalert show];
        [HUDManager hideHUD];
    }
    
    [self.tableView reloadData];
    [HUDManager hideHUD];
}

- (void)request_failed:(NSError *)error for_key:(NSString *)request_key
{
    [HUDManager hideHUD];
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
    
    [mHudPresenter hideHud];
    if (pRequestType == kKeyWordCouponPostRequest) {
        if (!pError) {
            NSMutableArray *tItems = [[DataManager getInstance] mKeywordCouponArray];
            if ([tItems count] >= kItemsPerPage) {
                mLoadMore = YES;
            }
            else{
                mLoadMore = NO;
            }
            
            [mCouponListArray addObjectsFromArray:tItems];
            [self.tableView reloadData];
            if (![mCouponListArray count]) {
                UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"No Coupons found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [tAlertView show];
            }
            
        }
        else {
            //NSLog(@"Request Failed:%d | Code:%d | Message:%@",pRequestType, pError.mErrorCode.intValue, pError.mMessage);
            
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Search Failed" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
            
        }
    }
}

-(void)showGestureView
{
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


-(void)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES ];
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    [HUDManager hideHUD];
    return [mCouponListArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CouponsListCell";
    
    CouponsListCell *cell = (CouponsListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CouponsListCell" owner:self options:nil];
        cell = (CouponsListCell *)[topLevelObjects objectAtIndex:0];
        
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    Coupon *tCoupon = [mCouponListArray objectAtIndex:indexPath.row];
    
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
    
    [cell.mImageView setImageWithURL:[NSURL URLWithString:[searchstoreThumbnail objectAtIndex:indexPath.row]]];
    return cell;
    
    
    
    // Configure the cell...
    
    //cell.textLabel.text = [NSString stringWithFormat:@"cell:%d",indexPath.row];
    /* NSString *tFileName = [tCoupon.mThumbnailImage lastPathComponent];
     NSString *fmtFileName = makeFileName([tCoupon.mID stringValue], tFileName);
     
     
     if (isFileExists(fmtFileName)) {
     [cell.mImageView setImage:[UIImage imageWithContentsOfFile:imageFilePath(fmtFileName)]];
     }
     else{
     cell.mImageView.image = [UIImage imageNamed:@"t_MyCoupons"];
     }
     
     cell.mTitleLabel.text = tCoupon.mBrandName;
     cell.mCouponDetailLabel.text = tCoupon.mLongPromoText;
     if (tCoupon.mCouponCode == nil) {
     [cell.mCodeLabel setHidden:YES];
     } else {
     [cell.mCodeLabel setHidden:NO];
     cell.mCodeLabel.text = [NSString stringWithFormat:@"Code: %@",tCoupon.mCouponCode];
     }
     
     NSDate *tExpiresdate = tCoupon.mValidTill;
     NSDate *tTodaysDate = [NSDate date];
     NSCalendar *tCalendar = [NSCalendar currentCalendar];
     NSInteger tExpiresdateOfYear = [tCalendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:tExpiresdate];
     NSInteger tTodaysDateOfYear = [tCalendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:tTodaysDate];
     NSInteger tNoOfDaysLeft = tExpiresdateOfYear - tTodaysDateOfYear;
     
     if (tNoOfDaysLeft == 0) {
     cell.mValidDateLabel.text = [NSString stringWithFormat:@"Expires Today"];
     }
     else if (tNoOfDaysLeft == 1) {
     cell.mValidDateLabel.text = [NSString stringWithFormat:@"Expires Tommorrow"];
     }
     else if (tNoOfDaysLeft > 1) {
     cell.mValidDateLabel.text = [NSString stringWithFormat:@"Expires in %ld days", (long)tNoOfDaysLeft];
     }
     cell.mCouponDiscountLabel.text = tCoupon.mShortPromoText;
     
     if (indexPath.row == [mCouponListArray count] - 1 && !mLoadMore) {
     [cell.mSeperatorImageView setHidden:NO];
     }
     
     if (indexPath.row  == [mCouponListArray count] - 1) {
     if (mLoadMore) {
     mStartIndex += kItemsPerPage;
     [self makeSearchRequestWithString:self.mSearchText];
     }
     }*/
    /*
     cell.mStoreTitleLabel.text = [nearmestoreNameArray objectAtIndex:indexPath.row];
     cell.mActiveCouponsLabel.text =[NSString stringWithFormat:@"%d Active Points",[[nearmepointsarray objectAtIndex:indexPath.row] intValue]];
     //[storeNameArray objectAtIndex:indexPath.row];
     
     //CheckIn button in the cell.
     cell.mCheckInButton.tag = indexPath.row;
     [cell.mCheckInButton addTarget:self action:@selector(checkInbuttontapped:) forControlEvents:UIControlEventTouchUpInside];
     
     //                cell.mCheckInButton.imageView.image=[storeThumbnail objectAtIndex:indexPath.row];
     */
    
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    Coupon *tCoupon = [mCouponListArray objectAtIndex:indexPath.row];
    
    CouponDetailViewController *tController = [CouponDetailViewController new];
    tController.mCoupon = tCoupon;
    
    tController.mCouponName                 = [[mCouponListArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    tController.mCouponPromoTextShort       = [[mCouponListArray objectAtIndex:indexPath.row] valueForKey:@"promo_text_short"];
    tController.mCouponPromoTextLong        = [[mCouponListArray objectAtIndex:indexPath.row] valueForKey:@"promo_text_long"];
    tController.mCouponExpireDate           = [[mCouponListArray objectAtIndex:indexPath.row] valueForKey:@"expiry_date"];
    tController.mCouponID                   = [[mCouponListArray objectAtIndex:indexPath.row] valueForKey:@"id"];
    tController.mCodeType                   = [[mCouponListArray objectAtIndex:indexPath.row] valueForKey:@"code_type"];
    tController.locatarray                  = [[mCouponListArray objectAtIndex:indexPath.row] valueForKey:@"store_name"];
    tController.mCouponImage                = [[mCouponListArray objectAtIndex:indexPath.row] valueForKey:@"coupon_thumbnail"];
    tController.mBarcodeImage               = [[mCouponListArray objectAtIndex:indexPath.row] valueForKey:@"barcode_image"];
    tController.mCouponDescription          = [[mCouponListArray objectAtIndex:indexPath.row] valueForKey:@"coupon_description"];
    
    [self.navigationController pushViewController:tController animated:YES];
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





@end

