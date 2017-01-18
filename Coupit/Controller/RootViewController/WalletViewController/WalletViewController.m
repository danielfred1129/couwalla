//
//  WalletViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//


#import "WalletViewController.h"
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


@implementation WalletViewController
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

@synthesize mLoyalityCardButton, mImagePickerController, mGiftCardButton,mShowBarCodeButton, mDeletCardButton;
@synthesize mCarousel, mObjCameraController, mCardNameLabel, mTableView, mEditCardButton, mScrollView, mBarCodeView;
@synthesize mCardNumberLabel, mSavingsLabel, mFlipCardButton, mSearchText, mIsSearched;
@synthesize mNextImageView, mPreviousImageView;
@synthesize repositaryObject;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSArray *arrayRepositary = [repositaryObject fetchAllWalletGiftCards];
    //NSLog(@"pradeep =%@",arrayRepositary);
    self.navigationItem.title = @"Wallet";
    
    mMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mMenuButton setImage:[UIImage imageNamed:@"button_menu"] forState:UIControlStateNormal];
    [mMenuButton sizeToFit];
	[mMenuButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    mLoyalityCardButton.selected = YES;
    mCardType = kLoyaltyCard;
    mScrollIndex = 0;
    mShowBarCode = NO;
    
    self.mCarousel.type = iCarouselTypeLinear;
    mHudPresenter = [[ProgressHudPresenter alloc] init];
    mDownloadedCouponList = [NSMutableArray new];
    if ([mDownloadedCouponList count]== 0) {
        [mTableView setHidden:NO];
    }
    else{
        [mTableView setHidden:NO];
    }

    mIsFliped = NO;
    
    //Add button on navigation Bar.
    UIButton *tAddMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tAddMoreButton setImage:[UIImage imageNamed:@"btn_add_new"] forState:UIControlStateNormal];
    [tAddMoreButton sizeToFit];
    [tAddMoreButton addTarget:self action:@selector(addMore:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tAddBarButton = [[UIBarButtonItem alloc]initWithCustomView:tAddMoreButton];
    self.navigationItem.rightBarButtonItem = tAddBarButton;
    
    UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
    
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc]initWithCustomView:mMenuButton];
    self.navigationItem.leftBarButtonItem = menuBarButton;
    
    
    
    mGestureView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealToggle:)];
	[mGestureView addGestureRecognizer:recognizer];
    
	UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
	[mGestureView addGestureRecognizer:panRecognizer];
    
    mCardArray = [NSMutableArray new];
    Card *c=[[Card alloc]init];
    [mCardArray addObjectsFromArray:[[Repository sharedRepository] fetchAllWalletLoyaltyCards]];
    //NSLog(@"mcardArray:-- %@ and mID IS %@", mCardArray,c.mID);
    

    CGRect f = CGRectMake(10, 240, 320, 20);
    mPageControl = [[PageControl alloc] initWithFrame:f];
    mPageControl.delegate = self;
    [self.view addSubview:mPageControl];
    [mCardNumberLabel setHidden:YES];
    [mSavingsLabel setHidden:YES];
    [mBarCodeView setHidden:YES];
    
    mAddViewArray = [NSMutableArray new];
    mBarCodeImagePath = [NSMutableArray new];
    mRedeemStatusArray = [NSMutableArray new];
    mCounterValueArray = [NSMutableArray new];

    
}

- (void) viewDidAppear:(BOOL)animated {
    [self refreshCarousel];
}

- (void)displayLeftMenu {
    
    [self revealController];
    
}

//Push Notification 
- (void) notificationDictionary:(NSDictionary *)pDict {
    
    NSString *tId = [pDict objectForKey:@"cardId"];
    //NSLog(@"tId:%@", tId);
    
    NSString *tGetGiftCard = [kURL_GiftCardNotification stringByAppendingFormat:@"/%@", tId];
    [[RequestHandler getInstance] getRequestURL:tGetGiftCard delegate:self requestType:kAPNSRedeemGiftCardRequest];
    
}

- (void) refreshCarousel
{
//    mCardNameLabel.text = nil;
//    if (mCardArray) {
//        [mCardArray removeAllObjects];
//    }
//    
//    if (self.mLoyalityCardButton.selected) {
//        [mCardArray addObjectsFromArray:[[Repository sharedRepository] fetchAllWalletLoyaltyCards]];
//        if (![mCardArray count]) {
//            [mPageControl setHidden:YES];
//            [mShowBarCodeButton setHidden:YES];
//            [mDeletCardButton setHidden:YES];
//        } else {
//            [mDeletCardButton setHidden:NO];
//            mPageControl.numberOfPages = [mCardArray count];
//            mPageControl.currentPage = 0;
//            [mPageControl setHidden:NO];
//        }
//    }
//    else{
//        [mCardArray addObjectsFromArray:[[Repository sharedRepository] fetchAllWalletGiftCards]];
//        if (![mCardArray count]) {
//            [mPageControl setHidden:YES];
//            [mShowBarCodeButton setHidden:YES];
//            [mDeletCardButton setHidden:YES];
//        } else {
//            [mDeletCardButton setHidden:NO];
//            mPageControl.numberOfPages = [mCardArray count];
//            mPageControl.currentPage = 0;
//            [mPageControl setHidden:NO];
//        }
//    }
//
//
//    [self.mCarousel reloadData];
}

- (IBAction)segementController:(UIButton *)pButton {
    switch (pButton.tag) {
        case 0:
        {
            [mCardNumberLabel setHidden:YES];
            [mSavingsLabel setHidden:YES];
            [mFlipCardButton setHidden:NO];
            mLoyalityCardButton.selected = YES;
            mGiftCardButton.selected = NO;
            mCardType = kLoyaltyCard;
            [self.mTableView setHidden:NO];
            [mCardNameLabel setHidden:NO];
            if ([mDownloadedCouponList count]== 0) {
                [mTableView setHidden:YES];
            }
            [self refreshCarousel];
        }
            break;
        case 1:
        {
            mLoyalityCardButton.selected = NO;
            mGiftCardButton.selected = YES;
            mCardType = kGiftCard;
            [mTableView setHidden:YES];
            [mCardNameLabel setHidden:YES];
            [self refreshCarousel];
        }
            break;
            
        default:
            break;
    }
    
    [self refreshCarousel];
}

- (IBAction)flipCard:(id)sender {
    
    if ([mCardArray count]) {
        Card *tCard = [mCardArray objectAtIndex:self.mCarousel.currentItemIndex];
        if ([tCard.mIsFliped boolValue]) {
            tCard.mIsFliped = [NSNumber numberWithBool:NO];
        }
        else{
            tCard.mIsFliped = [NSNumber numberWithBool:YES];
        }
        UIView *cardView = [self.mCarousel itemViewAtIndex:self.mCarousel.currentItemIndex];
        
        NSInteger option = [tCard.mIsFliped boolValue] ?UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight;
        
        [UIView transitionWithView:cardView duration:1 options:option animations:^{
            UIImageView *tFrontImage = (UIImageView *)[cardView viewWithTag:980];
            tFrontImage.hidden = [tCard.mIsFliped boolValue] ? YES : NO;
            
            UIImageView *tBackImage = (UIImageView *)[cardView viewWithTag:981];
            tBackImage.hidden = NO;
            tBackImage.hidden = [tCard.mIsFliped boolValue] ? NO : YES;
            
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (IBAction)editCard:(id)sender
{
    if ([mCardArray count]) {
        Card *tCard = [mCardArray objectAtIndex:self.mCarousel.currentItemIndex];
        //NSLog(@"tcardFrontImage :%@",tCard.mFrontImage);

        if ([tCard.mIsCameraImage boolValue]) {
            if (self.mObjCameraController == nil) {
                self.mObjCameraController = [[CameraViewController alloc] initWithNibName:@"CameraViewController" bundle:nil];
            }
            
            if (mLoyalityCardButton.selected) {
                self.mObjCameraController.mCardType = kLoyaltyCard;
            }
            else{
                self.mObjCameraController.mCardType = kGiftCard;
            }
            self.mObjCameraController.mObjCard = tCard;
            self.mObjCameraController.mAddCameraButton = NO;
            self.mObjCameraController.mEditButtonClicked = YES;
            
            [self.mObjCameraController setupImagePicker:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:self.mObjCameraController.mImagePickerReference animated:NO completion:^{
                //NSLog(@"----------presentViewController");
            }];
        }
        else{
            UIAlertView *iAlertView = [[UIAlertView alloc] initWithTitle:@"Can't edit this GiftCard" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [iAlertView show];
        }
        
    }
    
}

- (IBAction)barCodeView:(id)sender {
    
    [mScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [mBarCodeView setHidden:NO];
    [mPageControl setHidden:YES];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    mShowBarCode = YES;

    //Scroll View For Advertisment.
    if (mCardArray) {
        [mCardArray removeAllObjects];
        if (mCardType == kLoyaltyCard) {
            [mCardArray addObjectsFromArray:[[Repository sharedRepository] fetchAllWalletLoyaltyCards]];
        } else {
            [mCardArray addObjectsFromArray:[[Repository sharedRepository] fetchAllWalletGiftCards]];
        }
    }
    
    NSInteger count1 = [mCardArray count];
    if ([mBarCodeImagePath count]) {
        [mBarCodeImagePath removeAllObjects];
    }
    for (int i = 0; i < count1; i++) {
        Card *tCard = [mCardArray objectAtIndex:i];
        if ([tCard.mHaveBarcodeImage boolValue] == YES) {
            [mBarCodeImagePath addObject:tCard];
        }
    }
    CGRect f = CGRectMake(-140, 250, 320, 20);
    mPageControlBarCode = [[PageControl alloc] initWithFrame:f];
    mPageControlBarCode.numberOfPages = [mBarCodeImagePath count];
    mPageControlBarCode.currentPage = 0;
    mPageControlBarCode.delegate = self;
    mPageControlBarCode.transform = CGAffineTransformMakeRotation(M_PI / 2);
    
    [self.mBarCodeView addSubview:mPageControlBarCode];

    NSInteger count = [mBarCodeImagePath count];
    for (int i = 0; i< count; i++) {
        
        Card *tCard = [mBarCodeImagePath objectAtIndex:i];
        
        CGRect frame;
        frame.origin.x = 0;
        frame.origin.y = kItemHeightBarCode * i;
        frame.size = CGSizeMake(kItemWidthBarCode, kItemHeightBarCode);
        
        mBarCodeImageView = [[BarCodeImageView alloc] initWithNibName:@"BarCodeImageView" bundle:nil];
        mBarCodeImageView.view.frame = frame;
        
        [self.mScrollView addSubview:mBarCodeImageView.view];
        [mBarCodeImageView.mCardTitleLabel setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
        if (mCardType == kLoyaltyCard) {
            mBarCodeImageView.mCardTitleLabel.text = @"LOYALTY CARD";
        } else {
            mBarCodeImageView.mCardTitleLabel.text = @"GIFT CARD";
        }
        [mBarCodeImageView.mCardNumberLabel setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
        mBarCodeImageView.mCardNumberLabel.text = tCard.mCardNumber;
        [mBarCodeImageView.mCardDescriptionLabel setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
        mBarCodeImageView.mCardDescriptionLabel.text = tCard.mCardName;

        [mBarCodeImageView.mImageView setImage:[UIImage imageNamed:@"BarCodeLoyalty"]];
        [mBarCodeImageView.mBarCodeImageView setImage:[UIImage imageWithContentsOfFile:tCard.mBarCodeImage]];
        [mAddViewArray addObject:mBarCodeImageView];
    }
    self.mScrollView.contentSize = CGSizeMake(kItemWidthBarCode  , self.mScrollView.frame.size.height * count);
    
    //Navigate to the required view
    if (mShowBarCode) {
        CGRect frame = mScrollView.frame;
        frame.origin.x = 0;
        frame.origin.y = kItemHeightBarCode * mScrollIndex;
        [mScrollView scrollRectToVisible:frame animated:NO];
        mPageControlBarCode.currentPage = mScrollIndex;
        mShowBarCode = NO;
    }

}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat pageWidth = self.mScrollView.frame.size.height;
    int page = floor((self.mScrollView.contentOffset.y - pageWidth / 2) / pageWidth) + 1;
    mPageControlBarCode.currentPage = page;

}

- (IBAction)deleteCard:(id)sender {
    
    UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:@"Delete Card" message:@"Card will no longer be available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    tAlertView.tag = kAlertViewThree;
    [tAlertView show];

}

- (IBAction)dismissBarcodeView:(id)sender {
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [mBarCodeView setHidden:YES];
    [mPageControlBarCode setHidden:YES];
    [mPageControl setHidden:NO];
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

-(void)addMore:(id)sender {

    if (self.mObjCameraController == nil) {
        self.mObjCameraController = [[CameraViewController alloc] initWithNibName:@"CameraViewController" bundle:nil];
    }
    
    if (mLoyalityCardButton.selected) {
        self.mObjCameraController.mCardType = kLoyaltyCard;
    }
    else{
        self.mObjCameraController.mCardType = kGiftCard;
    }
    
    self.mObjCameraController.mDelegate = self;
    self.mObjCameraController.mAddCameraButton = YES;
    self.mObjCameraController.mEditButtonClicked = NO;
    
    [self.mObjCameraController setupImagePicker:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:self.mObjCameraController.mImagePickerReference animated:NO completion:^{
        //NSLog(@"----------presentViewController");
    }];

}

- (void) cameraViewController:(CameraViewController *)pController captureImage:(BOOL)pBool
{
    if (pBool) {
        [self refreshCarousel];
    }
}


#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    if (mIsSearched) {
        mSearchIndex = 50000;
        for (Card *tCard in mCardArray) {
            if ([tCard.mCardName isEqualToString:mSearchText]) {
                NSUInteger index = [mCardArray indexOfObject:tCard];
                //NSLog(@"Index :%d",index);
                mSearchIndex = index;
            }
        }
    }
    //NSLog(@"---------Cards count]:%d", [mCardArray count] );
    return [mCardArray count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{

    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kItemWidth, kItemHeight)];
    [view setBackgroundColor:[UIColor clearColor]];
    
    Card *tCard = [mCardArray objectAtIndex:index];
    UIImageView *tFrontImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kItemWidth, kItemHeight)];
    
    tFrontImageView.tag = 980;
    [tFrontImageView setImage:[tCard.mIsFliped boolValue]? [UIImage imageWithContentsOfFile:tCard.mBackImage] : [UIImage imageWithContentsOfFile:tCard.mFrontImage]];


    [view addSubview:tFrontImageView];

    
    UIImageView *tBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kItemWidth, kItemHeight)];
    
    tBackImageView.tag = 981;
    [tBackImageView setImage:[tCard.mIsFliped boolValue]? [UIImage imageWithContentsOfFile:tCard.mFrontImage] : [UIImage imageWithContentsOfFile:tCard.mBackImage]];
    
    [view addSubview:tBackImageView];
    tBackImageView.hidden = YES;
    
    view.layer.doubleSided = NO; //prevent back side of view from showing

    //NSLog(@"---------mSelectedIndex:%d", index);

    return view;

}


- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //usually this should be slightly wider than the item views
    return ITEM_SPACING;
}

- (CGFloat)carousel:(iCarousel *)carousel itemAlphaForOffset:(CGFloat)offset
{
    //set opacity based on distance from camera
    return 1.0f - fminf(fmaxf(offset, 0.0f), 1.0f);
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 1.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * mCarousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return NO;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    if (mIsSearched) {
        if (mSearchIndex == 50000) {
            UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"No Card Found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [tAlertView show];
        } else {
            carousel.currentItemIndex = mSearchIndex;
        }
    }
    mScrollIndex = carousel.currentItemIndex;
    mPageControl.currentPage = mScrollIndex;
    if (![mCardArray count]){
        [mPreviousImageView setHidden:YES];
        [mNextImageView setHidden:YES];
    }
    else if ((mScrollIndex == 0) && (mScrollIndex == [mCardArray count]-1)) {
        [mPreviousImageView setHidden:YES];
        [mNextImageView setHidden:YES];

    }
    else if ((mScrollIndex == 0) && ([mCardArray count])){
        [mPreviousImageView setHidden:YES];
        [mNextImageView setHidden:NO];
    }
    else if (mScrollIndex < [mCardArray count]-1) {
        [mPreviousImageView setHidden:NO];
        [mNextImageView setHidden:NO];

    }
    else if (mScrollIndex == [mCardArray count]-1) {
        [mPreviousImageView setHidden:NO];
        [mNextImageView setHidden:YES];

    }
    
    if ([mCardArray count] > carousel.currentItemIndex) {
        Card *tCard = [mCardArray objectAtIndex:carousel.currentItemIndex];
        if ([tCard.mIsCameraImage isEqualToNumber:[NSNumber numberWithBool:NO]]) {
            
            if ([tCard.mHaveBarcodeImage boolValue] == NO) {
                [mShowBarCodeButton setHidden:YES];
            } else {
                [mShowBarCodeButton setHidden:NO];
            }
            [mFlipCardButton setHidden:YES];
            [mCardNumberLabel setHidden:NO];
            [mSavingsLabel setHidden:NO];
            mCardNumberLabel.text = tCard.mCardNumber;
            mSavingsLabel.text = [NSString stringWithFormat:@"%@",tCard.mCardSavings];
            mSavingsLabel.tag = [tCard.mCardSavings stringValue];
        } else {
            [mFlipCardButton setHidden:NO];
            [mCardNumberLabel setHidden:YES];
            [mSavingsLabel setHidden:YES];
        }
        
        self.mCardNameLabel.text = tCard.mCardName;
        if ([tCard.mHaveBarcodeImage boolValue] == NO) {
            [mShowBarCodeButton setHidden:YES];
        } else {
            [mShowBarCodeButton setHidden:NO];

        }
        [mDownloadedCouponList setArray:[tCard.coupons allObjects]];
        
        for (int i = 0; i < [mDownloadedCouponList count]; i++) {
            MyCoupons *tMyCoupons = [mDownloadedCouponList objectAtIndex:i];
            
            NSDate *tNowDate = [NSDate date];
            if ([tNowDate compare:tMyCoupons.mCouponExpireDate] == NSOrderedDescending) {
                //NSLog(@"date1 is later than date2");
                MyCoupons *tCoupon = [mDownloadedCouponList objectAtIndex:mDeleteButtonIndex];
                [[Repository sharedRepository] deleteMyCouponsByID:[tCoupon.mID stringValue]];
                
                NSError *error = nil;
                Card *tCard = [mCardArray objectAtIndex:i];
                [tCard removeCouponsObject:tCoupon];
                [[Repository sharedRepository].context save:&error];
                [mDownloadedCouponList removeObjectAtIndex:i];
                
                [self.mTableView reloadData];
                [self refreshCarousel];
                
            } else if ([tNowDate compare:tMyCoupons.mCouponExpireDate] == NSOrderedAscending) {
                //NSLog(@"date1 is earlier than date2");
                
            } else {
                //NSLog(@"dates are the same");
            }
        }
        [self.mTableView reloadData];
        
    } else{
        mSavingsLabel.text = nil;
        mCardNumberLabel.text = nil;
    }
    
    if (mLoyalityCardButton.selected == YES) {
        if ([mDownloadedCouponList count]== 0) {
            [mTableView setHidden:YES];
        }
        else{
            [mTableView setHidden:NO];
        }

    }
    
    if (mRedeemStatusArray) {
        [mRedeemStatusArray removeAllObjects];
    }
    for (int i = 0; i < [mDownloadedCouponList count]; i++) {
        [mRedeemStatusArray addObject:@"False"];
    }
    
    if (mCounterValueArray) {
        [mCounterValueArray removeAllObjects];
    }
    for (int i = 0; i < [mDownloadedCouponList count]; i++) {
        [mCounterValueArray addObject:[NSNumber numberWithInt:10]];
    }
    mIsSearched = NO;

    
}


- (void)carouselCurrentItemIndexUpdated:(iCarousel *)carousel
{
    //NSLog(@"---------carouselCurrentItemIndexUpdated:%d", carousel.currentItemIndex );
}


- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    //NSLog(@"didSelectItemAtIndex:%d", index);
}




#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [mDownloadedCouponList count];
    return mDownloadedCouponList.count;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"MyCouponsCell";
    MyCouponsCell *cell = (MyCouponsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MyCouponsCell" owner:self options:nil];
        cell = (MyCouponsCell *)[topLevelObjects objectAtIndex:0];
    }
    [cell.mSeperatorImageView setHidden:YES];
    
    MyCoupons *tCoupon = [mDownloadedCouponList objectAtIndex:indexPath.row];
    // Configure the cell...
    NSString *tFileName = [tCoupon.mThumbnailImage lastPathComponent];
    NSString *fmtFileName = makeFileName([tCoupon.mID stringValue], tFileName);
    
    if (isFileExists(fmtFileName)) {
        cell.mCouponImageView.image =  [UIImage imageWithContentsOfFile:imageFilePath(fmtFileName)];
    }
    else {
        [[IconDownloadManager getInstance] setScreen:kMyCouponScreen delegate:self filePath:tCoupon.mThumbnailImage iconID:[tCoupon.mID stringValue] indexPath:indexPath];
        cell.mCouponImageView.image = [UIImage imageNamed:@"CouponsHomeDefaultImage"];
    }
    //. BarCode image
    NSString *tBarcodeFileName = [tCoupon.mBarcodeImage lastPathComponent];
    if (isFileExists(tBarcodeFileName)) {
        
        cell.mBarCodeImageView.image =  [UIImage imageWithContentsOfFile:imageFilePath(tBarcodeFileName)];
    }
    else {
        [[IconDownloadManager getInstance] setScreen:kMyCouponScreen delegate:self
                                            filePath:tCoupon.mBarcodeImage iconID:[tCoupon.mID stringValue]
                                           indexPath:indexPath];
        
        cell.mBarCodeImageView.image = [UIImage imageNamed:@"t_NewBarCode"];
    }
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
    
    cell.mTitleLabel.text = [mCardArray objectAtIndex:indexPath.row];
    cell.mCouponDetailLabel.text = tCoupon.mLongPromoText;
    [cell.mTermsAndConditionButton addTarget:self action:@selector(openWebView) forControlEvents:UIControlEventTouchUpInside];

    
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
    [cell.mRedeemSelectButton setHidden:YES];
    [cell.mBarCodeImageView setHidden:YES];

    
    
    mCouponIndex = indexPath.row;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(couponTapped:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    cell.mCouponImageView.userInteractionEnabled = YES;
    [cell.mCouponImageView addGestureRecognizer:tapRecognizer];
    
    return cell;
    
}
/*/
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    }
    Card *cardObject = [mCardArray objectAtIndex:indexPath.row];
    cell.textLabel.text = cardObject.mID;
    return cell;
}*/

- (void)couponTapped:(id)sender {
    
    MyCoupons *tCoupon = [mDownloadedCouponList objectAtIndex:mCouponIndex];
    UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Want to redirect at %@",tCoupon.mOnlineRedemptionUrl] delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Cancel", nil];
    tAlertView.tag = kAlertViewOne;
    [tAlertView show];

}


-(void)openWebView {
    
    WebViewController *tWebViewController = [WebViewController new];
    
    [tWebViewController openURLString:[[DataManager getInstance] getLegalURL]];
    [self presentViewController:tWebViewController animated:YES completion:^{
        
    }];
}

- (void) iconDownloadManager:(IconDownloadManager *)pIconDownloadManager indexPath:(NSIndexPath *)pIndexPath {
    [self.mTableView beginUpdates];
    
    if ([mDownloadedCouponList count] > pIndexPath.row) {
        [self.mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:pIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
	[self.mTableView endUpdates];
}


-(void)favouriteButtonSelected:(UIButton *)sender
{
    //NSLog(@"Favourite button pressed");
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
    mDeleteButtonIndex = sender.tag;
    UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:@"Delete coupon" message:kDeleteCouponMessage delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    tAlertView.tag = kAlertViewTwo;
    [tAlertView show];
    //NSLog(@"Delete button selected");
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
            MyCoupons *tCoupon = [mDownloadedCouponList objectAtIndex:mDeleteButtonIndex];
            [[Repository sharedRepository] deleteMyCouponsByID:[tCoupon.mID stringValue]];
            
            NSError *error = nil;
            Card *tCard = [mCardArray objectAtIndex:mScrollIndex];
            [tCard removeCouponsObject:tCoupon];
            [[Repository sharedRepository].context save:&error];
            [mDownloadedCouponList removeObjectAtIndex:mDeleteButtonIndex];
            [self.mTableView reloadData];
            [self refreshCarousel];

            //NSLog(@"Delete button selected");
        }
    }
    else if (alertView.tag == kAlertViewThree) {
        if ([alertView cancelButtonIndex] == buttonIndex) {
            NSError *error;
            if ([mCardArray count]) {
                [mCardArray removeAllObjects];
                if (mCardType == kLoyaltyCard) {
                    [mCardArray addObjectsFromArray:[[Repository sharedRepository] fetchAllWalletLoyaltyCards]];
                } else {
                    [mCardArray addObjectsFromArray:[[Repository sharedRepository] fetchAllWalletGiftCards]];
                }
            }
            
            Card *tCard = [mCardArray objectAtIndex:self.mCarousel.currentItemIndex];
            [[Repository sharedRepository] deleteGiftCardbyID:tCard.mID];

            //NSLog(@"tcardFrontImage :%@",tCard.mFrontImage);
            
            NSFileManager *fileMgr = [[NSFileManager alloc] init];
            [fileMgr removeItemAtPath:tCard.mFrontImage error:&error];
            [fileMgr removeItemAtPath:tCard.mBackImage error:&error];
            [fileMgr removeItemAtPath:tCard.mBarCodeImage error:&error];
            [[Repository sharedRepository].context deleteObject:tCard];
            [[Repository sharedRepository].context save:&error];
            [self refreshCarousel];
        }
    }
    else if (alertView.tag == kAlertViewFour) {
        if ([alertView cancelButtonIndex] == buttonIndex) {
            MyCoupons *tCoupons = [mDownloadedCouponList objectAtIndex:mSelectedRedeemIndex];
            RedeemCouponViewController *tRedeemCouponViewController = [RedeemCouponViewController new];
            tRedeemCouponViewController.mMyCoupon = tCoupons;
            
            UINavigationController *tNavigationController= [[UINavigationController alloc] initWithRootViewController:tRedeemCouponViewController];
            [self presentViewController:tNavigationController animated:YES completion:^{
                
            }];

        }
    }
}

- (void) redeemButtonSelected:(UIButton *)sender
{
    mSelectedRedeemIndex = sender.tag;
    UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:kRedeemCouponMessage delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    tAlertView.tag = kAlertViewFour;
    [tAlertView show];
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
            [self.mTableView reloadData];
            
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
