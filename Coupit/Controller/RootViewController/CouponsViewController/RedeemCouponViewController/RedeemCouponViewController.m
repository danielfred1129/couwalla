//
//  RedeemCouponViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RedeemCouponViewController.h"
#import "MyCouponsCell.h"
#import "Coupon.h"
#import "FileUtils.h"
#import "WebViewController.h"
#import "AppDelegate.h"
#import "Card.h"
#import "MyCoupons.h"

#define kAlertViewOne 1
#define kAlertViewTwo 2

@implementation RedeemCouponViewController
{
    UIView *mGestureView;
    NSInteger mCategoryID;
    ProgressHudPresenter *mHudPresenter;
    NSTimer *timer;
    NSMutableArray* mCardArray;
    NSString *mCouponID;

}

@synthesize  mTableView , mMyCoupon, mDelegate;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    self.navigationItem.title = @"Redeem Coupons";
    [super viewDidLoad];
    mCardArray = [NSMutableArray new];
    mCouponID = [mMyCoupon.mID stringValue];

    mCategoryID = 0;
    mHudPresenter = [[ProgressHudPresenter alloc] init];

    if (mCardArray) {
        [mCardArray removeAllObjects];
        [mCardArray addObjectsFromArray:[[Repository sharedRepository] fetchAllWalletLoyaltyCards]];
        
    }

    UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
    
    mGestureView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealToggle:)];
    [mGestureView addGestureRecognizer:recognizer];
    
    UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [mGestureView addGestureRecognizer:panRecognizer];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasComeInForeground:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    NSDate *tRedeemTime = [NSDate date];
    //NSLog(@"Reddeem Time :%@",tRedeemTime);
    [[NSUserDefaults standardUserDefaults] setObject:tRedeemTime forKey:@"RedeemCouponTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

}
- (void)appHasComeInForeground:(id)sender{
    //NSLog(@"Application is in ForeGround");
    
    NSDate *tRedeemTime = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"RedeemCouponTime"];
    NSDate *tCurrentTime = [NSDate date];
    NSTimeInterval timeDifference = [tCurrentTime timeIntervalSinceDate:tRedeemTime];
    
    NSInteger ti = (NSInteger)timeDifference;
    //NSInteger timeInMinutes = (ti / 60) % 60;
    //NSLog(@"Time in minutes :%d",ti);

    
    if (ti > 3600) {
        UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Your Coupon Redeemption time is finished" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        tAlertView.tag = 2;
        [tAlertView show];
    }
}

- (void)redeemCouponRequest {
    
    [mHudPresenter presentHud];
    NSString *tPostBody = [NSString stringWithFormat:@"[%@]",mCouponID];
    CLLocation *tCurrentLocation = [[Location getInstance] getCurrentLocation];
    NSString *tRedeemAllCouponQuery = [kURL_RedeemAllCoupon stringByAppendingFormat:@"?lat=%f&lng=%f",tCurrentLocation.coordinate.latitude,tCurrentLocation.coordinate.longitude];
    //NSLog(@"Redeem Request :%@",tRedeemAllCouponQuery);

    [[RequestHandler getInstance] postRequestwithHostURL:tRedeemAllCouponQuery bodyPost:tPostBody delegate:self requestType:kRedeemCouponRequest];

}


- (IBAction)redeemAllButton:(id)sender {
    //NSLog(@"redeeem all");
}

- (IBAction)mDeleteAll:(id)sender {
    //NSLog(@"delete all");

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


- (IBAction)couponRedeemed:(id)sender {
    UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please make sure you are done with Coupon. Coupon will be deleted immediately." delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"No", nil];
    tAlertView.tag = 1;
    [tAlertView show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView cancelButtonIndex] == buttonIndex) {
        if (alertView.tag == 1) {
            [[Repository sharedRepository] deleteMyCouponsByID:[mMyCoupon.mID stringValue]];
            for (Card *tCard in mCardArray) {
                if ([tCard.coupons containsObject:mMyCoupon]) {
                    [tCard removeCouponsObject:mMyCoupon];
                }
            }
            NSError *error = nil;
            [[Repository sharedRepository].context save:&error];
            [self redeemCouponRequest];

        }
        else if (alertView.tag ==2) {
            [[Repository sharedRepository] deleteMyCouponsByID:[mMyCoupon.mID stringValue]];
            for (Card *tCard in mCardArray) {
                if ([tCard.coupons containsObject:mMyCoupon]) {
                    [tCard removeCouponsObject:mMyCoupon];
                }
            }
            NSError *error = nil;
            [[Repository sharedRepository].context save:&error];
            [mDelegate redeemViewController:self isBack:YES];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MyCouponsCell";
    MyCouponsCell *cell = (MyCouponsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MyCouponsCell" owner:self options:nil];
        cell = (MyCouponsCell *)[topLevelObjects objectAtIndex:0];
    }
    [cell.mSeperatorImageView setHidden:YES];
    [cell.mTermsAndConditionButton setHidden:YES];

    // Configure the cell...
    NSString *tFileName = [mMyCoupon.mThumbnailImage lastPathComponent];
    NSString *fmtFileName = makeFileName([mMyCoupon.mID stringValue], tFileName);
    
    [cell.mButtonsView setHidden:YES];
    [cell.mFavouriteButton setHidden:YES];
    [cell.mPlannerButton setHidden:YES];
    [cell.mRedeemButton setHidden:YES];
    [cell.mDeleteButton setHidden:YES];
    [cell.mRedeemSelectButton setHidden:YES];

    if (isFileExists(fmtFileName)) {
        cell.mCouponImageView.image =  [UIImage imageWithContentsOfFile:imageFilePath(fmtFileName)];
    }
    else {
        [[IconDownloadManager getInstance] setScreen:kMyCouponScreen delegate:self filePath:mMyCoupon.mThumbnailImage iconID:[mMyCoupon.mID stringValue] indexPath:indexPath];
        cell.mCouponImageView.image = [UIImage imageNamed:@"CouponsHomeDefaultImage"];
    }
    

    if (mMyCoupon.mBarcodeImage.length  == 0) {
        [cell.mBarCodeImageView setHidden:YES];
        [cell.mCouponCodeLabel setHidden:NO];

    } else {
        [cell.mBarCodeImageView setHidden:NO];
        [cell.mCouponCodeLabel setHidden:YES];

    }

    NSString *tBarcodeFileName = [mMyCoupon.mBarcodeImage lastPathComponent];
    NSString *fmtBarCodeFileName = makeFileName([mMyCoupon.mID stringValue], tBarcodeFileName);

    //NSLog(@"......:%@",tBarcodeFileName);
    if (isFileExists(fmtBarCodeFileName)) {
        
        cell.mBarCodeImageView.image =  [UIImage imageWithContentsOfFile:imageFilePath(fmtBarCodeFileName)];
    }
    else {
        [[IconDownloadManager getInstance] setScreen:kMyCouponScreen delegate:self
                                            filePath:mMyCoupon.mBarcodeImage iconID:[mMyCoupon.mID stringValue]
                                           indexPath:indexPath];
        
        //cell.mBarCodeImageView.image = [UIImage imageNamed:@"t_NewBarCode"];
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    cell.mValidDateLabel.text = [NSString stringWithFormat:@"Valid till: %@", [dateFormat stringFromDate:[[DataManager getInstance] couponExpireDate:mMyCoupon.mCouponExpireDate]]];
    
    cell.mTitleLabel.text = mMyCoupon.mBrandName;
    cell.mCouponDetailLabel.text = mMyCoupon.mLongPromoText;
    cell.mCouponCodeLabel.text = [NSString stringWithFormat:@"Coupon Code: %@",mMyCoupon.mCouponCode];
    [cell.mTermsAndConditionButton addTarget:self action:@selector(openWebView) forControlEvents:UIControlEventTouchUpInside];
    if (mMyCoupon.mCouponCode == nil) {
        [cell.mCodeLabel setHidden:YES];
    } else {
        [cell.mCodeLabel setHidden:NO];
        cell.mCodeLabel.text = [NSString stringWithFormat:@"Code: %@",mMyCoupon.mCouponCode];
    }
    [cell.mTimerValue setHidden:YES];

    return cell;
    
}


- (void) iconDownloadManager:(IconDownloadManager *)pIconDownloadManager indexPath:(NSIndexPath *)pIndexPath {
    
    [self.mTableView beginUpdates];
    [self.mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:pIndexPath] withRowAnimation:UITableViewRowAnimationNone];
	[self.mTableView endUpdates];
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
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate makeSubscriberGetRequestByName];
            [mDelegate redeemViewController:self isBack:YES];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
    }
    }
}

- (void)openWebView {
    
    WebViewController *tWebViewController = [WebViewController new];
    
    [self presentViewController:tWebViewController animated:YES completion:^{
        [tWebViewController openURLString:[[DataManager getInstance]getSupportURL]];
    }];
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

