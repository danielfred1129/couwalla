//
//  CouponDetailViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestHandler.h"
#import "IconDownloadManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "LocalyticsSession.h"
#import "Coupon.h"
#import "LoyalCardListViewController.h"
#import "WalletViewController.h"
#import <CoreLocation/CoreLocation.h>

#import "GREST.h"

// Coupon Download Types
typedef enum {
    kNormalDownload = 0,
    kAddToTagDownload
}CouponDownloadType;

@interface CouponDetailViewController : BaseViewController<UIActionSheetDelegate, IconDownloadManagerDelegate, RequestHandlerDelegate, MFMailComposeViewControllerDelegate, LoyalCardListViewControllerDelegate,CLLocationManagerDelegate, GRESTDelegate> {
    
    GREST *termsAPI;
    UIScrollView *mainView;
    
    NSString *gripdLat, *gripdLng, *gripdStoreName, *gripdStoreAddress;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollView;

@property (weak, nonatomic) IBOutlet UILabel *mCouponNameLabel;

@property (nonatomic, retain) IBOutlet UILabel *mCouponCodeLabel;
@property (nonatomic, retain) IBOutlet UILabel *mShortPromoLabel;
@property (nonatomic, retain) IBOutlet UILabel *mLongPromoLabel;
@property (nonatomic, retain) IBOutlet UILabel *mValidTillLabel;
@property (nonatomic, retain) IBOutlet UIImageView *mCouponImageView;
@property (nonatomic, retain) IBOutlet UIButton *mDownloadButton;
@property (nonatomic, retain) IBOutlet UIButton *mDownloadAndShareButton;
@property (weak, nonatomic) IBOutlet UILabel *termsNConditionsLabel;


@property (nonatomic, retain) Coupon *mCoupon;
@property (nonatomic, retain) NSString *mCouponID;
@property (nonatomic, retain) NSString *mCouponPromoTextShort;
@property (nonatomic, retain) NSString *mCouponPromoTextLong;
@property (nonatomic, retain) NSString *mCouponName,*userlat,*userlong;
@property (nonatomic, retain) NSString *mCouponExpireDate,*latstr,*longstr,*titlestr,*adrstr,*link;
@property(nonatomic,retain)NSMutableArray *locatarray;
@property (nonatomic, retain) NSString *mCodeType;
@property (nonatomic, retain) NSString *mBarcodeImage;
@property (nonatomic, retain) NSString *mCouponImage;
@property (nonatomic, retain) NSString *mCouponDescription;

@property (nonatomic, strong) NSString *comingFromScreen; //Property to identify from which screen user is coming to this screen...



@property BOOL *downloadAndShareStatus;
@property BOOL mIsNotification;
- (void)shareCoupon;

- (IBAction) downloadCoupon:(id)sender;
- (IBAction) downloadAndShare;
- (void) loadCouponDetails;
- (void) fbPostMessage;
- (void) shareCouponURLWithID:(NSString *)pID;
- (void) downloadCouponByID:(NSInteger)pID;

@end
