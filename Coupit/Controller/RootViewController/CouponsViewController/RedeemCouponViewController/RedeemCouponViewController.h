//
//  RedeemCouponViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloadManager.h"
#import "RequestHandler.h"
#import "MyCoupons.h"

@class RedeemCouponViewController;

@protocol RedeemCouponViewControllerDelegate
- (void) redeemViewController:(RedeemCouponViewController *)pRedeem isBack:(BOOL)pValue;

@end

@interface RedeemCouponViewController : BaseViewController<IconDownloadManagerDelegate, RequestHandlerDelegate>

@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property MyCoupons *mMyCoupon;
@property (nonatomic, retain) id <RedeemCouponViewControllerDelegate> mDelegate;


-(void)showGestureView;
-(void)hideGestureView;

- (IBAction)couponRedeemed:(id)sender;



@end
