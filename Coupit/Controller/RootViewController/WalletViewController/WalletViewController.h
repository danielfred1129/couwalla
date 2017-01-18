//
//  WalletViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraViewController.h"
#import "iCarousel.h"
#import "RequestHandler.h"
#import "IconDownloadManager.h"
#import "PageControl.h"
#import "Repository.h"

@interface WalletViewController : BaseViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CameraViewControllerDelegate, RequestHandlerDelegate, IconDownloadManagerDelegate ,PageControlDelegate>{
    NSString *s1,*s2,*s3,*s4;
}

- (void) showGestureView;
- (void) hideGestureView;
- (void) menuButtonSelected;
- (void) menuButtonUnselected;
- (void) displayLeftMenu;

@property(nonatomic, retain) IBOutlet UIButton *mLoyalityCardButton;
@property(nonatomic, retain) IBOutlet UIButton *mGiftCardButton;
@property(nonatomic, retain) IBOutlet UIButton *mEditCardButton;
@property(nonatomic, retain) IBOutlet UIButton *mShowBarCodeButton;
@property(nonatomic, retain) IBOutlet UIButton *mFlipCardButton;
@property(nonatomic, retain) IBOutlet UIButton *mDeletCardButton;
@property(nonatomic, retain) IBOutlet UIImageView *mNextImageView;
@property(nonatomic, retain) IBOutlet UIImageView *mPreviousImageView;

@property(nonatomic, retain) UIImagePickerController *mImagePickerController;
@property(nonatomic, retain) CameraViewController *mObjCameraController;
@property(nonatomic, retain) IBOutlet UIScrollView *mScrollView;
@property(nonatomic, retain) IBOutlet UITableView *mTableView;
@property(nonatomic, retain) IBOutlet UIView *mBarCodeView;
@property BOOL mIsSearched;

@property (nonatomic, retain) IBOutlet NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet iCarousel *mCarousel;
@property (nonatomic, retain) IBOutlet UILabel *mCardNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *mCardNumberLabel;
@property (nonatomic, retain) IBOutlet UILabel *mSavingsLabel;
@property (nonatomic, retain) NSString *mSearchText;

@property (nonatomic, strong) Repository *repositaryObject;
- (IBAction) segementController:(UIButton *)pButton;
- (IBAction)flipCard:(id)sender;
- (IBAction)editCard:(id)sender;
- (IBAction)barCodeView:(id)sender;
- (IBAction)deleteCard:(id)sender;
- (IBAction)dismissBarcodeView:(id)sender;

- (void) notificationDictionary:(NSDictionary *)pDict;
- (void) refreshCarousel;

@end
