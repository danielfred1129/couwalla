//
//  CouponsViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODRefreshControl.h"
#import "CategoriesViewController.h"
#import "CouponTableCell.h"
#import "RequestHandler.h"
#import "IconDownloadManager.h"
#import "CouponListViewController.h"
#import "GREST.h"
#import <CoreLocation/CoreLocation.h>
#import "InfiniteScrollview.h"

typedef enum {
    kFromMenuScreen,
    kFromAllScreen
}ResetCouponCategory;



@interface CouponsViewController : BaseViewController<EGORefreshTableHeaderDelegate, CouponTableCellDelegate, RequestHandlerDelegate, CategoriesViewControllerDelegate, IconDownloadManagerDelegate, CouponListViewControllerDelegate,CLLocationManagerDelegate, GRESTDelegate,UISearchBarDelegate,InfiniteCheckboxDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *coupon_image,*CouponName,*couponShortText,*couponLongtext,*couponExpireDate,*couponID,*banerimgarray,*couponDescription,*nearcoupon_image,*nearCouponName,*nearcouponShortText,*nearcouponLongtext,*nearcouponExpireDate,*nearcouponID,*nearcouponDescription,*hotcoupon_image,*hotCouponName,*hotcouponShortText,*hotcouponLongtext,*hotcouponExpireDate,*hotcouponID,*CodeType,*BarcodeImage,*hotCodeType,*hotBarcodeImage,*hotcouponDescription,*nearCodeType,*nearBarcodeImage;
    
    
    
//    ODRefreshControl *syncRefresh;
    UIRefreshControl *refreshControl;
    GREST *api;
    InfiniteScrollview * infiScroll;

}

@property (nonatomic, retain) UIRefreshControl *refreshControl;
@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) IBOutlet UIImageView *mADImageView;
@property (weak, nonatomic)     IBOutlet UIView *viewForScroll;
@property ResetCouponCategory mResetCouponCategory;
@property BOOL opensidemenu;





//@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *mActivityIndicator;
- (void)showGestureView;
- (void)hideGestureView;
- (void)menuButtonSelected;
- (void)menuButtonUnselected;
- (void)pulledToRefresh;

- (void) reloadTableViewDataSource;
- (void) doneLoadingTableViewData;
- (void) refreshTableView;
//- (void) showAdAtIndex:(NSInteger)pIndex;
- (void) notificationDictionary:(NSDictionary *)pDict;
- (void) fetchRequestURLs;
-(void)listallcoupons;
- (IBAction)buyNowAction:(id)sender;
@end
