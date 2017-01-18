//
//  WWalletViewController.m
//  Coupit
//
//  Created by geniemac4 on 06/11/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "WWalletViewController.h"
#import "WalletCardView.h"
#import "CardManager.h"
#import "Card.h"
#import "FileUtils.h"
#import "AppDelegate.h"
#import "MyCouponsCell.h"
#import "Coupon.h"
#import "FileUtils.h"
#import "WebViewController.h"
#import "AppDelegate.h"
#import "BarCodeImageView.h"
#import "RedeemCouponViewController.h"
#import "RedeemAllViewController.h"

#define kItemWidth 265
#define kItemHeight 153
#define kItemMargin 0

#define kItemWidthBarCode 240
#define kItemHeightBarCode 375
#define kItemMarginBarCode 0


#define ITEM_SPACING 300.0f
#define INCLUDE_PLACEHOLDERS YES

#define kAlertViewOne 1
#define kAlertViewTwo 2
#define kAlertViewThree 3
#define kAlertViewFour 4

@interface WWalletViewController ()


@end

@implementation WWalletViewController
{
    UIView *mGestureView;
    UIButton *mMenuButton;
    NSInteger mScrollIndex;
    
    BOOL mIsFliped;
    NSMutableArray *mDownloadedCouponList;
    NSInteger mCategoryID;
    NSInteger mSelectedRedeemIndex;
    NSInteger mCouponIndex;
    NSInteger mDeleteButtonIndex;
    UIPageControl *mPageControll;
    NSMutableArray* tempArr;
    CardType  mCardType;
    ProgressHudPresenter *mHudPresenter;
    PageControl *mPageControl;
    PageControl *mPageControlBarCode;
    BarCodeImageView *mBarCodeImageView;
    
    NSMutableArray *mAddViewArray;
    NSMutableArray *mBarCodeImagePath;
    NSMutableArray *mRedeemStatusArray;
    NSMutableArray *mCounterValueArray;
    NSMutableArray *mCouponViewArray;
    NSMutableArray *mCardArray;
    NSInteger       mSearchIndex;
    BOOL  mShowBarCode;
    
}

@synthesize table,title,mObjCameraController,mIsSearched,mSearchText;

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
    self.navigationItem.title = @"Wallet";
    
    UIButton *tAddMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tAddMoreButton setImage:[UIImage imageNamed:@"btn_add_new"] forState:UIControlStateNormal];
    [tAddMoreButton sizeToFit];
    [tAddMoreButton addTarget:self action:@selector(addMore:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tAddBarButton = [[UIBarButtonItem alloc]initWithCustomView:tAddMoreButton];
    self.navigationItem.rightBarButtonItem = tAddBarButton;
    
    mMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mMenuButton setImage:[UIImage imageNamed:@"button_menu"] forState:UIControlStateNormal];
    [mMenuButton sizeToFit];
    [mMenuButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc]initWithCustomView:mMenuButton];
    self.navigationItem.leftBarButtonItem = menuBarButton;
    
    tempArr=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4", nil];
    mGestureView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealToggle:)];
	[mGestureView addGestureRecognizer:recognizer];
    
	UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
	[mGestureView addGestureRecognizer:panRecognizer];
    // Do any additional setup after loading the view from its nib.
    
    mCardArray = [NSMutableArray new];
    [mCardArray addObjectsFromArray:[[Repository sharedRepository] fetchAllWalletLoyaltyCards]];
    //NSLog(@"mcardArray:-- %@", mCardArray);
   
//        Card *tCard = [mCardArray objectAtIndex:mSearchIndex];
//        [mDownloadedCouponList setArray:[tCard.coupons allObjects]];
//    
//
//     [self refreshList];
    mDownloadedCouponList = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchDownloadedCouponsByCategory:mCategoryID error:nil]];
    //NSLog(@"mDownloadedCouponList:-- %@", mDownloadedCouponList);
    
}


- (void) notificationDictionary:(NSDictionary *)pDict {
    
    NSString *tId = [pDict objectForKey:@"cardId"];
    //NSLog(@"tId:%@", tId);
    
    NSString *tGetGiftCard = [kURL_GiftCardNotification stringByAppendingFormat:@"/%@", tId];
    [[RequestHandler getInstance] getRequestURL:tGetGiftCard delegate:self requestType:kAPNSRedeemGiftCardRequest];
    
}

- (void) refreshList {
    
    
//    [self.table reloadData];
//        mDownloadedCouponList = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchFavoriteMyCouponsByCategory:mCategoryID error:nil]];
//    
//    
//    if ([mDownloadedCouponList count]) {
//        for (int i = 0; i < [mDownloadedCouponList count]; i++) {
//            MyCoupons *tMyCoupons = [mDownloadedCouponList objectAtIndex:i];
//            
//            NSDate *tNowDate = [NSDate date];
//            if ([tNowDate compare:tMyCoupons.mCouponExpireDate] == NSOrderedDescending) {
//                //NSLog(@"date1 is later than date2");
//                [[Repository sharedRepository] deleteMyCouponsByID:[tMyCoupons.mID stringValue]];
//                for (Card *tCard in mCardArray) {
//                    if ([tCard.coupons containsObject:tMyCoupons]) {
//                        [tCard removeCouponsObject:tMyCoupons];
//                    }
//                }
//                NSError *error = nil;
//                [[Repository sharedRepository].context save:&error];
//                [mDownloadedCouponList removeObjectAtIndex:i];
//                [self.table reloadData];
//                
//            } else if ([tNowDate compare:tMyCoupons.mCouponExpireDate] == NSOrderedAscending) {
//                //NSLog(@"date1 is earlier than date2");
//                
//            } else {
//                //NSLog(@"dates are the same");
//            }
//        }
//        
//    } else {
//        NSInteger tCouponCount = 0;
//       
//        
//    }
//    
//    [self.table reloadData];
}


-(void)addMore:(id)sender {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    
    if (self.mObjCameraController == nil) {
        self.mObjCameraController = [[CameraViewController alloc] initWithNibName:@"CameraViewController" bundle:nil];
    }
    

        self.mObjCameraController.mCardType = kLoyaltyCard;
   
    
    self.mObjCameraController.mDelegate = self;
    self.mObjCameraController.mAddCameraButton = YES;
    self.mObjCameraController.mEditButtonClicked = NO;
    
    [self.mObjCameraController setupImagePicker:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:self.mObjCameraController.mImagePickerReference animated:NO completion:^{
        //NSLog(@"----------presentViewController");
    }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//    if (mIsSearched) {
//        mSearchIndex = 50000;
//        for (Card *tCard in mCardArray) {
//            if ([tCard.mCardName isEqualToString:mSearchText]) {
//                NSUInteger index = [mCardArray indexOfObject:tCard];
//                //NSLog(@"Index :%d",index);
//                mSearchIndex = index;
//            }
//        }
//    }
//    //NSLog(@"---------Cards count]:%d", [mCardArray count] );
    
    return mCardArray.count;
}

- (void) cameraViewController:(CameraViewController *)pController captureImage:(BOOL)pBool
{
    if (pBool) {
        [mCardArray addObjectsFromArray:[[Repository sharedRepository] fetchAllWalletLoyaltyCards]];
        //NSLog(@"---------Cards count]:%d", [mCardArray count] );
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
/*{
    static NSString *celldemodentifier = @"MyCouponsCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:celldemodentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:celldemodentifier];
    }
    cell.textLabel.text=[tempArr objectAtIndex:indexPath.row];
    cell.textLabel.backgroundColor=[UIColor greenColor];
    //cell.namelbl.text = [namearray objectAtIndex:indexPath.row];
    
    return cell;
}*/

{
    
    static NSString *CellIdentifier = @"MyCouponsCell";
    MyCouponsCell *cell = (MyCouponsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MyCouponsCell" owner:self options:nil];
        cell = (MyCouponsCell *)[topLevelObjects objectAtIndex:0];
    }
    [cell.mSeperatorImageView setHidden:YES];
    MyCoupons *tCoupon;
    if (mDownloadedCouponList.count>0) {
        
    
        tCoupon = [mDownloadedCouponList objectAtIndex:indexPath.row];
    }else{
        //NSLog(@"mDownloadedCouponList ");
    }
//    // Configure the cell...
//    NSString *tFileName = [tCoupon.mThumbnailImage lastPathComponent];
//    NSString *fmtFileName = makeFileName([tCoupon.mID stringValue], tFileName);
//
//    if (isFileExists(fmtFileName)) {
//        cell.mCouponImageView.image =  [UIImage imageWithContentsOfFile:imageFilePath(fmtFileName)];
//    }
//    else {
//        [[IconDownloadManager getInstance] setScreen:kMyCouponScreen delegate:self filePath:tCoupon.mThumbnailImage iconID:[tCoupon.mID stringValue] indexPath:indexPath];
        cell.mCouponImageView.image = [UIImage imageNamed:@"CouponsHomeDefaultImage"];
//    }
//    //. BarCode image
//    NSString *tBarcodeFileName = [tCoupon.mBarcodeImage lastPathComponent];
//    if (isFileExists(tBarcodeFileName)) {
////
//        cell.mBarCodeImageView.image =  [UIImage imageWithContentsOfFile:imageFilePath(tBarcodeFileName)];
//    }
//    else {
//        [[IconDownloadManager getInstance] setScreen:kMyCouponScreen delegate:self
//                                            filePath:tCoupon.mBarcodeImage iconID:[tCoupon.mID stringValue]
//                                           indexPath:indexPath];
//
        cell.mBarCodeImageView.image = [UIImage imageNamed:@"t_NewBarCode"];
//    }
    
    Card *cardObject = [mCardArray objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    cell.mValidDateLabel.text = [NSString stringWithFormat:@"Valid till: %@", [dateFormat stringFromDate:[[DataManager getInstance] couponExpireDate:tCoupon.mCouponExpireDate]]];
    
        if (tCoupon.mCouponCode == nil) {
            [cell.mCodeLabel setHidden:YES];
        } else {
            [cell.mCodeLabel setHidden:NO];
            cell.mCodeLabel.text = [NSString stringWithFormat:@"Code: %@",tCoupon.mCouponCode];
        }
        if (indexPath.row  == [mDownloadedCouponList count] - 1) {
            [cell.mSeperatorImageView setHidden:NO];
        }
    
    
    cell.mCouponCodeLabel.text = cardObject.mID;
    
    cell.mCouponDetailLabel.text = cardObject.mCardDescription;
    cell.mTitleLabel.text=cardObject.mCardName;
    [cell.mTermsAndConditionButton addTarget:self action:@selector(openWebView) forControlEvents:UIControlEventTouchUpInside];
    
    
        cell.mFavouriteButton.highlighted = [tCoupon.mFavorited boolValue] ? YES : NO;
        cell.mFavouriteButton.tag = indexPath.row;
    if (mDownloadedCouponList.count>0) {
        
        [cell.mPlannerButton addTarget:self action:@selector(plannerButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell.mDeleteButton addTarget:self action:@selector(deleteButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell.mRedeemSelectButton addTarget:self action:@selector(redeemSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell.mRedeemButton addTarget:self action:@selector(redeemButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell.mFavouriteButton addTarget:self action:@selector(favouriteButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        //NSLog(@"mDownloadedCouponList empty");
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Coupon not found !!!" message:@"No coupons has been added to loyalty card" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlert show];
    }
    
    
        //Planner Button in the cell.       dr_college-http://install.diawi.com/gtZTM8
        cell.mPlannerButton.highlighted = [tCoupon.mPlanned boolValue] ? YES : NO;
        cell.mPlannerButton.tag = indexPath.row;
            //
    //
    //    //Delete button in the cell.
        cell.mDeleteButton.tag = indexPath.row;
    
    
        //Delete button in the cell.
        cell.mRedeemButton.tag = indexPath.row;
    
//        [cell.mRedeemSelectButton setHidden:YES];
//       [cell.mBarCodeImageView setHidden:YES];
    
    
    
    mCouponIndex = indexPath.row;
//        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(couponTapped:)];
//        [tapRecognizer setNumberOfTapsRequired:1];
//        cell.mCouponImageView.userInteractionEnabled = YES;
//        [cell.mCouponImageView addGestureRecognizer:tapRecognizer];
    
    return cell;
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAlertViewOne) {
        if ([alertView cancelButtonIndex] == buttonIndex) {
            MyCoupons *tCoupon = [mCardArray objectAtIndex:mCouponIndex];
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
            MyCoupons *tCoupon = [mDownloadedCouponList objectAtIndex:mDeleteButtonIndex];
            NSError *error = nil;
            [[Repository sharedRepository] deleteMyCouponsByID:[tCoupon.mID stringValue]];
            for (Card *tCard in mCardArray) {
                if ([tCard.coupons containsObject:tCoupon]) {
                    [tCard removeCouponsObject:tCoupon];
                }
            }
            [[Repository sharedRepository].context save:&error];
            [mDownloadedCouponList removeObjectAtIndex:mDeleteButtonIndex];
//            [self refreshList];
            [self.table reloadData];
        }
    }
    else if (alertView.tag == kAlertViewThree) {
//        if ([alertView cancelButtonIndex] == buttonIndex) {
//            NSError *error;
//            if ([mCardArray count]) {
//                [mCardArray removeAllObjects];
//                if (mCardType == kLoyaltyCard) {
//                    [mCardArray addObjectsFromArray:[[Repository sharedRepository] fetchAllWalletLoyaltyCards]];
//                } else {
//                    [mCardArray addObjectsFromArray:[[Repository sharedRepository] fetchAllWalletGiftCards]];
//                }
//            }
//            
//            Card *tCard = [mCardArray objectAtIndex:self.table.indexPathForSelectedRow];
//            [[Repository sharedRepository] deleteGiftCardbyID:tCard.mID];
//            
//            //NSLog(@"tcardFrontImage :%@",tCard.mFrontImage);
//            
//            NSFileManager *fileMgr = [[NSFileManager alloc] init];
//            [fileMgr removeItemAtPath:tCard.mFrontImage error:&error];
//            [fileMgr removeItemAtPath:tCard.mBackImage error:&error];
//            [fileMgr removeItemAtPath:tCard.mBarCodeImage error:&error];
//            [[Repository sharedRepository].context deleteObject:tCard];
//            [[Repository sharedRepository].context save:&error];
//            
//        }
    }
    else if (alertView.tag == kAlertViewFour) {
        if ([alertView cancelButtonIndex] == buttonIndex) {
            
            MyCoupons *tCoupon;
            if (mDownloadedCouponList.count>0)
                tCoupon= [mDownloadedCouponList objectAtIndex:mSelectedRedeemIndex];
            RedeemCouponViewController *tRedeemCouponViewController = [RedeemCouponViewController new];
            tRedeemCouponViewController.mMyCoupon = tCoupon;
            tRedeemCouponViewController.mDelegate = self;
            
            UINavigationController *tNavigationController= [[UINavigationController alloc] initWithRootViewController:tRedeemCouponViewController];
            [self presentViewController:tNavigationController animated:YES completion:^{
            
            }];
//
        }
    }
}


- (void)couponTapped:(id)sender {
    
    MyCoupons *tCoupon = [mCardArray objectAtIndex:mCouponIndex];
    UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Want to redirect at %@",tCoupon.mOnlineRedemptionUrl] delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Cancel", nil];
    tAlertView.tag = kAlertViewOne;
    [tAlertView show];
    
}

-(void)redeemSelected:(UIButton *)sender
{
    //NSLog(@"redeemSelected button pressed");
    MyCoupons *tCoupon = [mDownloadedCouponList objectAtIndex:sender.tag];
    tCoupon.mRedeeemSelected = [NSNumber numberWithBool:![tCoupon.mRedeeemSelected boolValue]];
    sender.highlighted = [tCoupon.mRedeeemSelected boolValue] ? YES : NO;
    NSError *error;
    [[Repository sharedRepository].context save:&error];
    [self.table reloadData];
}

- (void) redeemListViewController:(RedeemAllViewController *)pRedeem isBack:(BOOL)pValue {
    if (pValue) {
        [self.table reloadData];
    }
}
- (void) redeemViewController:(RedeemCouponViewController *)pRedeem isBack:(BOOL)pValue {
    if (pValue) {
        [self.table reloadData];
    }
}


-(void)openWebView {
    
    WebViewController *tWebViewController = [WebViewController new];
    
    [self presentViewController:tWebViewController animated:YES completion:^{
        [tWebViewController openURLString:@"https://policy-portal.truste.com/core/privacy-policy/Q2-Intel/6b45b037-c5b6-472b-b6c2-29a44b9dd9f1#landingPage"];
    }];
    
}

-(void)favouriteButtonSelected:(UIButton *)sender
{
//    //NSLog(@"Favourite button pressed");
    MyCoupons *tCoupon = [mDownloadedCouponList objectAtIndex:sender.tag];
    tCoupon.mFavorited = [NSNumber numberWithBool:![tCoupon.mFavorited boolValue]];
    sender.highlighted = [tCoupon.mFavorited boolValue] ? YES : NO;
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




-(void)viewWillAppear:(BOOL)animated{
    [self.table reloadData];
    [super viewWillAppear:YES];
}


-(void)plannerButtonSelected:(UIButton *)sender {
    
    MyCoupons *tCoupon = [mDownloadedCouponList objectAtIndex:sender.tag];
    tCoupon.mPlanned = [NSNumber numberWithBool:![tCoupon.mPlanned boolValue]];
    sender.highlighted = [tCoupon.mPlanned boolValue] ? YES : NO;
    if ([tCoupon.mPlanned boolValue]) {
        NSMutableString *tPlanCouponURl = [NSMutableString new];
        tPlanCouponURl = [NSMutableString stringWithString:kPlanCouponRequestURL];
        [tPlanCouponURl appendString:[NSString stringWithFormat:@"%@", tCoupon.mID]];
        
        [mHudPresenter presentHud];
        [[RequestHandler getInstance] getRequestURL:tPlanCouponURl delegate:self requestType:kCouponPlanRequest];
        
    } else {
        NSMutableString *tUnPlanCouponURl = [NSMutableString new];
        tUnPlanCouponURl = [NSMutableString stringWithString:kUnPlanCouponRequestURL];
        [tUnPlanCouponURl appendString:[NSString stringWithFormat:@"%@", tCoupon.mID]];
        
        [mHudPresenter presentHud];
        [[RequestHandler getInstance] getRequestURL:tUnPlanCouponURl delegate:self requestType:kCouponUnPlanRequest];
        
    }
}

- (void) deleteButtonSelected:(UIButton *)sender
{
//    mDeleteButtonIndex = sender.tag;
//    UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:@"Delete coupon" message:kDeleteCouponMessage delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
//    tAlertView.tag = kAlertViewTwo;
//    [tAlertView show];
//    //NSLog(@"Delete button selected");
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
        else if (pRequestType == kAPNSRedeemGiftCardRequest) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate makeSubscriberGetRequestByName];
            [appDelegate fetchGiftCardsImages];
            
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Message" message:kGiftCardAddedMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
            
        }
        else if (pRequestType == kCouponPlanRequest) {
            [[Repository sharedRepository].context save:nil];
            [self.table reloadData];
        }
        else if (pRequestType == kCouponUnPlanRequest) {
            [[Repository sharedRepository].context save:nil];
            [self.table reloadData];
        }
        else if (pRequestType == kCouponFavRequest) {
            [[Repository sharedRepository].context save:nil];
            [self.table reloadData];
        }
        else if (pRequestType == kCouponUnFavRequest) {
            [[Repository sharedRepository].context save:nil];
            [self.table reloadData];
            
        }
        
        
    }
}

- (void) redeemButtonSelected:(UIButton *)sender {
    mSelectedRedeemIndex = sender.tag;
    UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:kRedeemCouponMessage delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    tAlertView.tag = kAlertViewFour;
    [tAlertView show];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
