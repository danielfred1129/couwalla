//
//  MyCouponViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "PlannerListViewController.h"
#import "MyCouponsCell.h"
#import "Coupon.h"
#import "FileUtils.h"
#import "AppDelegate.h"
#import "WebViewController.h"
#import "MyCoupons.h"
#import "RedeemAllViewController.h"
#import "CouponGrouper.h"
#import "Card.h"
#import "RedeemCouponViewController.h"
#import "CouponRedeemViewerViewController.h"
#import "LocalyticsSession.h"

#define kAlertViewOne 1
#define kAlertViewTwo 2
#define kAlertViewThree 3
#define kAlertViewFour 4
#define deletetag 5
@class MyCouponViewController;
@implementation PlannerListViewController
{
    
    NSInteger mCategoryID;
    NSInteger mSelectedRedeemIndex;
    ProgressHudPresenter *mHudPresenter;
    NSInteger mCouponIndex, mPlannedCouponIndex, mFavoriteCouponIndex;
    NSInteger mDeleteButtonIndex;
    CouponGrouper *mCouponGrouper;
    NSString *mGroupName,*userkey;
    NSInteger mRedeemCouponCount;
    
    NSMutableArray *mCardArray;
    NSMutableArray *mRedeemCouponArray;
    NSMutableDictionary *plannerdic;
}

@synthesize mSelectionType ,mBottomBarUIView, mBadgeValue, mRedeemAllButton, mTableView;
@synthesize name,descrp,tumbimg,mDownloadedCouponList;
#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Planner Details";

    mCategoryID = 0;
    mRedeemCouponCount = 0;
    mHudPresenter = [[ProgressHudPresenter alloc] init];
    userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];

    UIButton *tbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tbackButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tbackButton sizeToFit];
    [tbackButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tBackBar = [[UIBarButtonItem alloc]initWithCustomView:tbackButton];
    self.navigationItem.leftBarButtonItem = tBackBar;
    mCardArray = [NSMutableArray new];
    
    if (mCardArray) {
        [mCardArray removeAllObjects];
        [mCardArray addObjectsFromArray:[[Repository sharedRepository] fetchAllWalletLoyaltyCards]];
        
    }
    mRedeemCouponArray = [NSMutableArray new];

    [self refreshList];
    //NSLog(@"%@",mDownloadedCouponList);
    plannerdic = mDownloadedCouponList;
 }
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[LocalyticsSession shared] tagScreen:kPlannerScreen];
}
-(void)backButtonn {
//    [self dismissViewControllerAnimated:YES completion:^{
//       
//    }];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setPlannerCoupons:(NSArray *)pCoupons forGroup:(NSString *)pGroupName
{
    self.navigationItem.title = pGroupName;
    mGroupName = pGroupName;
    mDownloadedCouponList = [[NSMutableArray alloc] initWithArray:pCoupons];
    
    for (int i = 0; i < [mDownloadedCouponList count]; i++) {
        MyCoupons *tMyCoupons = [mDownloadedCouponList objectAtIndex:i];
        
        NSDate *tNowDate = [NSDate date];
        if ([tNowDate compare:tMyCoupons.mCouponExpireDate] == NSOrderedDescending) {
            [[Repository sharedRepository] deleteMyCouponsByID:[tMyCoupons.mID stringValue]];
            for (Card *tCard in mCardArray) {
                if ([tCard.coupons containsObject:tMyCoupons]) {
                    [tCard removeCouponsObject:tMyCoupons];
                }
            }
            NSError *error = nil;
            [[Repository sharedRepository].context save:&error];
            [mDownloadedCouponList removeObjectAtIndex:i];
            [self.mTableView reloadData];
            
        } else if ([tNowDate compare:tMyCoupons.mCouponExpireDate] == NSOrderedAscending) {
            //NSLog(@"date1 is earlier than date2");
            
        } else {
            //NSLog(@"dates are the same");
        }
    }

}


- (void) backButton:(id)sender
{
//    MyCouponViewController *mc=[MyCouponViewController new];
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


// Categories 
- (void) filterAction:(id)sender
{
    CategoriesViewController *tCategoriesViewController = [CategoriesViewController new];
    
    UINavigationController *tNavigationController= [[UINavigationController alloc] initWithRootViewController:tCategoriesViewController];
    
    tCategoriesViewController.mDelegate = self;
    
    [self presentViewController:tNavigationController animated:YES completion:^{
        
    }];
}

- (void) categoriesViewController:(CategoriesViewController *)pCategoriesViewController selectedCategoryID:(NSNumber *)pID
{
    mCategoryID = [pID integerValue];
    //NSLog(@"mCategoryID:%d", mCategoryID);
}

- (void) refreshList {
    /*
    for (int i = 0; i < [mDownloadedCouponList count]; i++) {
        MyCoupons *tCoupons = [mDownloadedCouponList objectAtIndex:i];
        if ([tCoupons.mRedeeemSelected isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            mRedeemCouponCount = ++ mRedeemCouponCount;
        } 
    }
    mBadgeValue.text = [NSString stringWithFormat:@"%d",mRedeemCouponCount];
    
    [self.mTableView reloadData];*/
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if([mDownloadedCouponList count]==0)
        
	{
        //tableView.hidden = YES;
		UILabel *message=[[UILabel alloc]initWithFrame:CGRectMake(45, 200, 320, 35)];
        
		//message.text=@"No Coupons have been planned";
        message.font = [UIFont systemFontOfSize:14.0f];
        message.textColor = [UIColor colorWithRed:(102/255.0) green:(102/255.0) blue:(102/255.0) alpha:1.0];
        message.backgroundColor = [UIColor clearColor];
		[tableView addSubview:message];
	}
    
   // return [mDownloadedCouponList count];
    return 1;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([mBadgeValue.text isEqualToString:@"0"]) {
        [mBottomBarUIView setHidden:YES];
    } else {
        [mBottomBarUIView setHidden:NO];
        
    }
    return mBottomBarUIView;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MyCouponsCell";
    
    MyCouponsCell *cell = (MyCouponsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MyCouponsCell" owner:self options:nil];
        cell = (MyCouponsCell *)[topLevelObjects objectAtIndex:0];
        
    }
    cell.mTitleLabel.text = name;
    cell.mCouponDetailLabel.text=descrp;
    NSData *imageData= [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:tumbimg]];
     cell.mCouponImageView.image= [[UIImage alloc]initWithData:imageData];
    cell.mCouponCodeLabel.hidden=YES;
    
    
    cell.mDeleteButton.tag = indexPath.row;
    [cell.mDeleteButton addTarget:self action:@selector(deleteButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
   [cell.mRedeemSelectButton setHidden:YES];
    cell.mRedeemButton.tag = indexPath.row;
    [cell.mRedeemButton addTarget:self action:@selector(redeemButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
   // [cell.mBarCodeImageView setHidden:YES];

   // MyCoupons *tCoupon = [mDownloadedCouponList objectAtIndex:indexPath.row];
    // Configure the cell...
   /*
    NSString *tFileName = [tCoupon.mThumbnailImage lastPathComponent];
    NSString *fmtFileName = makeFileName([tCoupon.mID stringValue], tFileName);
    
    if (isFileExists(fmtFileName)) {
        cell.mCouponImageView.image =  [UIImage imageWithContentsOfFile:imageFilePath(fmtFileName)];
    }
    else{
        cell.mCouponImageView.image = [UIImage imageNamed:@"t_MyCoupons"];
    }
    
    //. BarCode image
    NSString *tBarcodeFileName = [tCoupon.mBarcodeImage lastPathComponent];
    if (isFileExists(tBarcodeFileName)) {
        cell.mBarCodeImageView.image =  [UIImage imageWithContentsOfFile:imageFilePath(tBarcodeFileName)];
    }
    else{
        [[IconDownloadManager getInstance] setScreen:kMyCouponScreen delegate:self
                                            filePath:tCoupon.mBarcodeImage iconID:[tCoupon.mID stringValue]
                                           indexPath:indexPath];
        
        cell.mBarCodeImageView.image = [UIImage imageNamed:@"t_NewBarCode"];
    }
    
    cell.mTitleLabel.text = tCoupon.mBrandName;
    cell.mCodeLabel.text = [NSString stringWithFormat:@"Code: %@",tCoupon.mCouponCode];
    cell.mCouponDetailLabel.text = tCoupon.mLongPromoText;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    cell.mValidDateLabel.text = [NSString stringWithFormat:@"Valid till: %@", [dateFormat stringFromDate:[[DataManager getInstance] couponExpireDate:tCoupon.mCouponExpireDate]]];
    [cell.mTermsAndConditionButton addTarget:self action:@selector(openWebView) forControlEvents:UIControlEventTouchUpInside];

    mCouponIndex = indexPath.row;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(couponTapped:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    cell.mCouponImageView.userInteractionEnabled = YES;
    [cell.mCouponImageView addGestureRecognizer:tapRecognizer];


    cell.mFavouriteButton.highlighted = [tCoupon.mFavorited boolValue] ? YES : NO;
    cell.mFavouriteButton.tag = indexPath.row;
    [cell.mFavouriteButton addTarget:self action:@selector(favouriteButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    //Planner Button in the cell.
    cell.mPlannerButton.highlighted = [tCoupon.mPlanned boolValue] ? YES : NO;    
    cell.mPlannerButton.tag = indexPath.row;
    [cell.mPlannerButton addTarget:self action:@selector(plannerButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //Delete button in the cell.
    cell.mDeleteButton.tag = indexPath.row;
    [cell.mDeleteButton addTarget:self action:@selector(deleteButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    //Delete button in the cell.
    cell.mRedeemButton.tag = indexPath.row;
    [cell.mRedeemButton addTarget:self action:@selector(redeemButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [cell.mBarCodeImageView setHidden:YES];
    
    cell.mRedeemSelectButton.highlighted = [tCoupon.mRedeeemSelected boolValue] ? YES : NO;
    cell.mRedeemSelectButton.tag = indexPath.row;
    [cell.mRedeemSelectButton addTarget:self action:@selector(redeemSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    */
    
    return cell;
    
}
- (void)couponTapped:(id)sender {
//    MyCoupons *tCoupon = [mDownloadedCouponList objectAtIndex:mCouponIndex];
//    UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Want to redirect at %@",tCoupon.mOnlineRedemptionUrl] delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Cancel", nil];
//    tAlertView.tag = kAlertViewOne;
//    [tAlertView show];

}
-(void)openWebView {
    
    WebViewController *tWebViewController = [WebViewController new];
    [tWebViewController openURLString:[[DataManager getInstance] getLegalURL]];
    [self presentViewController:tWebViewController animated:YES completion:^{
        
    }];
}


- (void) iconDownloadManager:(IconDownloadManager *)pIconDownloadManager indexPath:(NSIndexPath *)pIndexPath
{
    [self.tableView beginUpdates];

    if ([mDownloadedCouponList count] > pIndexPath.row) {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:pIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }

	[self.tableView endUpdates];
}


-(void)favouriteButtonSelected:(UIButton *)sender
{
    //NSLog(@"Favourite button pressed");
    MyCoupons *tCoupon = [mDownloadedCouponList objectAtIndex:sender.tag];
    tCoupon.mFavorited = [NSNumber numberWithBool:![tCoupon.mFavorited boolValue]];
    sender.highlighted = [tCoupon.mFavorited boolValue] ? YES : NO;
    mFavoriteCouponIndex = sender.tag;
    if ([tCoupon.mFavorited boolValue]) {
        NSMutableString *tFavouriteCouponURl = [NSMutableString new];
        tFavouriteCouponURl = [NSMutableString stringWithString:kFavouriteCouponRequestURL];
        [tFavouriteCouponURl appendString:[NSString stringWithFormat:@"%@", tCoupon.mID]];
        
        [mHudPresenter presentHud];
        [[RequestHandler getInstance] getRequestURL:tFavouriteCouponURl delegate:self requestType:kCouponFavRequest];
        
    } else {
        NSMutableString *tUnFavouriteCouponURl = [NSMutableString new];
        tUnFavouriteCouponURl = [NSMutableString stringWithString:kUnFavouriteCouponRequestURL];
        [tUnFavouriteCouponURl appendString:[NSString stringWithFormat:@"%@", tCoupon.mID]];
        
        [mHudPresenter presentHud];
        [[RequestHandler getInstance] getRequestURL:tUnFavouriteCouponURl delegate:self requestType:kCouponUnFavRequest];
    }


}


-(void)plannerButtonSelected:(UIButton *)sender
{
    MyCoupons *tCoupon = [mDownloadedCouponList objectAtIndex:sender.tag];
    tCoupon.mPlanned = [NSNumber numberWithBool:NO];
    mPlannedCouponIndex = sender.tag;
    if (![tCoupon.mPlanned boolValue]) {
        NSMutableString *tUnPlanCouponURl = [NSMutableString new];
        tUnPlanCouponURl = [NSMutableString stringWithString:kUnPlanCouponRequestURL];
        [tUnPlanCouponURl appendString:[NSString stringWithFormat:@"%@", tCoupon.mID]];
        
        [mHudPresenter presentHud];
        [[RequestHandler getInstance] getRequestURL:tUnPlanCouponURl delegate:self requestType:kCouponUnPlanRequest];
    } 

    //NSLog(@"Planner button pressed");

}

-(void)deleteButtonSelected:(UIButton *)sender {
    mDeleteButtonIndex = sender.tag;
    UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:@"Delete coupon" message:@"you want to delete?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    tAlertView.tag = kAlertViewTwo;
    [tAlertView show];

}

- (void) redeemButtonSelected:(UIButton *)sender {
    mSelectedRedeemIndex = sender.tag;
    UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you wish to reedem now?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    tAlertView.tag = kAlertViewFour;
    [tAlertView show];
    
}
- (IBAction)redeemAllButton:(id)sender {
    UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:kRedeemCouponMessage delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    tAlertView.tag = kAlertViewThree;
    [tAlertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAlertViewOne) {
        if ([alertView cancelButtonIndex] == buttonIndex) {
            MyCoupons *tCoupon = [mDownloadedCouponList objectAtIndex:mCouponIndex];
            NSMutableString *tRedemptionUrl = [NSMutableString stringWithString:tCoupon.mOnlineRedemptionUrl];
            if (![tRedemptionUrl hasPrefix:@"http"]) {
                [tRedemptionUrl insertString:@"http://" atIndex:0];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tRedemptionUrl]];
                
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tRedemptionUrl]];
            }
        }
    }
    else if (alertView.tag == kAlertViewTwo) {
        if ([alertView cancelButtonIndex] == buttonIndex) {
            /*
            MyCoupons *tCoupon = [mDownloadedCouponList objectAtIndex:mDeleteButtonIndex];
            [[Repository sharedRepository] deleteMyCouponsByID:[tCoupon.mID stringValue]];
            
            NSError *error = nil;
            for (Card *tCard in mCardArray) {
                if ([tCard.coupons containsObject:tCoupon]) {
                    [tCard removeCouponsObject:tCoupon];
                }
            }
            [[Repository sharedRepository].context save:&error];
            [mDownloadedCouponList removeObjectAtIndex:mDeleteButtonIndex];
            [self.mTableView reloadData];
            [self redeemViewController:nil isBack:YES];*/
            
            NSMutableDictionary *removeDic = [NSMutableDictionary dictionary];
            [removeDic setObject:userkey forKey:@"userid"];
            [removeDic setObject:[plannerdic valueForKey:@"id"] forKey:@"couponid"];
            NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/remove_from_planner.php?",BASE_URL];
            
            jsonparse *objJsonparse =[[jsonparse alloc]init];
            
            NSMutableDictionary *reponseData = [[NSMutableDictionary alloc]init];
            
            reponseData = [objJsonparse customejsonParsing:urlString bodydata:removeDic];
            //NSLog(@"%@",reponseData);
            NSString *response = [reponseData valueForKey:@"response"];
            
            
            if ([response isEqual:@"Success"])
            {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Coupon deleted successlly" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.tag = deletetag;
                [alert show];
                
                
            }

            
        }
    }
    else if (alertView.tag == deletetag)
    {
        if ([alertView cancelButtonIndex] == buttonIndex) {
           
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
    }
    
    
    
    else if (alertView.tag == kAlertViewThree) {
        if ([alertView cancelButtonIndex] == buttonIndex) {
            RedeemAllViewController *tRedeemAllViewController = [RedeemAllViewController new];
            tRedeemAllViewController.mRedeemAllSelection = KRedeemAllFromPlanner;
            tRedeemAllViewController.mDelegate = self;
            [tRedeemAllViewController redeemAllCoupons:mRedeemCouponArray];
            UINavigationController *tNavigationController= [[UINavigationController alloc] initWithRootViewController:tRedeemAllViewController];
            [self presentViewController:tNavigationController animated:YES completion:^{
                
            }];
        }
    }
    else if (alertView.tag == kAlertViewFour) {
        if ([alertView cancelButtonIndex] == buttonIndex) {
            /*
            MyCoupons *tCoupons = [mDownloadedCouponList objectAtIndex:mSelectedRedeemIndex];
            
            RedeemCouponViewController *tRedeemCouponViewController = [RedeemCouponViewController new];
            tRedeemCouponViewController.mMyCoupon = tCoupons;
            tRedeemCouponViewController.mDelegate = self;
            
            UINavigationController *tNavigationController= [[UINavigationController alloc] initWithRootViewController:tRedeemCouponViewController];
            [self presentViewController:tNavigationController animated:YES completion:^{
                
            }];*/
            
            NSMutableDictionary *couponDetails=plannerdic;
            if([couponDetails[@"code_type"] isEqualToString:@"couponcode"]) {
                NSError* error = nil;
                ZXMultiFormatWriter* writer = [ZXMultiFormatWriter writer];
                ZXBitMatrix* result = [writer encode:couponDetails[@"name"]
                                              format:kBarcodeFormatCode128
                                               width:500
                                              height:500
                                               error:&error];
                CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
                
                CouponRedeemViewerViewController *redeemer = [[CouponRedeemViewerViewController alloc] initWithNibName:@"CouponRedeemViewerViewController" bundle:[NSBundle mainBundle]];
                [redeemer setCouponImage:[UIImage imageWithCGImage:image]];
                [redeemer setCouponid:[plannerdic valueForKey:@"id"]];
                [self.navigationController pushViewController:redeemer animated:YES];
                
                ////NSLog(@"%@", image);
            }
            else
            {
                //UIAlertView *rAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"No Bar Code is available?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
                
                //[rAlertView show];
                NSError* error = nil;
                ZXMultiFormatWriter* writer = [ZXMultiFormatWriter writer];
                ZXBitMatrix* result = [writer encode:couponDetails[@"name"]
                                              format:kBarcodeFormatCode128
                                               width:500
                                              height:500
                                               error:&error];
                CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
                
                CouponRedeemViewerViewController *redeemer = [[CouponRedeemViewerViewController alloc] initWithNibName:@"CouponRedeemViewerViewController" bundle:[NSBundle mainBundle]];
                [redeemer setCouponImage:[UIImage imageWithCGImage:image]];
                [redeemer setCouponid:[plannerdic valueForKey:@"id"]];
                [self.navigationController pushViewController:redeemer animated:YES];
            }

        }
    }

}


- (void) redeemListViewController:(RedeemAllViewController *)pRedeem isBack:(BOOL)pValue {
    if (pValue) {
        mRedeemCouponCount = 0;
        mCouponGrouper = [CouponGrouper new];
        [mCouponGrouper setCoupons:[[Repository sharedRepository] fetchPlannedCoupons:nil]];
        
        mDownloadedCouponList = [[NSMutableArray alloc] initWithArray:[mCouponGrouper getCouponListForGroupID:mGroupName]];
        [self refreshList];
        [self.mTableView reloadData];
    }
}

- (void) redeemViewController:(RedeemCouponViewController *)pRedeem isBack:(BOOL)pValue {
    if (pValue) {
        mRedeemCouponCount = 0;
        mCouponGrouper = [CouponGrouper new];
        [mCouponGrouper setCoupons:[[Repository sharedRepository] fetchPlannedCoupons:nil]];
        
        mDownloadedCouponList = [[NSMutableArray alloc] initWithArray:[mCouponGrouper getCouponListForGroupID:mGroupName]];
        [self refreshList];
        [self.mTableView reloadData];
    }
}

-(void)redeemSelectButton:(UIButton *)sender {
    MyCoupons *tCoupon = [mDownloadedCouponList objectAtIndex:sender.tag];
    tCoupon.mRedeeemSelected = [NSNumber numberWithBool:![tCoupon.mRedeeemSelected boolValue]];
    sender.highlighted = [tCoupon.mRedeeemSelected boolValue] ? YES : NO;
    if ([tCoupon.mRedeeemSelected isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        mRedeemCouponCount = ++ mRedeemCouponCount;
    } else {
        mRedeemCouponCount = -- mRedeemCouponCount;

    }

    mBadgeValue.text = [NSString stringWithFormat:@"%d",mRedeemCouponCount];

    NSError *error;
    [[Repository sharedRepository].context save:&error];
    
    if (mRedeemCouponArray) {
        [mRedeemCouponArray removeAllObjects];
        [mRedeemCouponArray addObjectsFromArray:[[Repository sharedRepository] fetchRedeemCoupons:nil]];
    }

    [self.mTableView reloadData];
    
}


- (IBAction)deleteAllButton:(id)sender {
    for (int i = 0; i < [mDownloadedCouponList count]; i++) {
        MyCoupons *tCoupon = [mDownloadedCouponList objectAtIndex:i];
        tCoupon.mRedeeemSelected = [NSNumber numberWithBool:NO];
        NSError *error;
        [[Repository sharedRepository].context save:&error];
    }
    mRedeemCouponCount = 0;
    
    [self refreshList];

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
    if (!pError) {
        if (pRequestType == kRedeemCouponRequest) {
        }
        else if (pRequestType == kCouponUnPlanRequest) {
            [[Repository sharedRepository].context save:nil];
            [mDownloadedCouponList removeObjectAtIndex:mPlannedCouponIndex];
            [self.tableView reloadData];
        }
        else if (pRequestType == kCouponFavRequest) {
            [[Repository sharedRepository].context save:nil];
            [self.tableView reloadData];
        }
        else if (pRequestType == kCouponUnFavRequest) {
            [[Repository sharedRepository].context save:nil];
            [self.tableView reloadData];
            
        }

    }
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
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

