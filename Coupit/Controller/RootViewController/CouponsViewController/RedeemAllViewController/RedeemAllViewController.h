//
//  RedeemAllViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloadManager.h"
#import "RequestHandler.h"
#import "GREST.h"
#import "tNSString+SBJSON.h"
#import "RequestHandler.h"
#import "jsonparse.h"


typedef enum
{
    kRedeemAllFromMyCoupon,
    KRedeemAllFromPlanner
}RedeemSelection;

@class RedeemAllViewController;

@protocol RedeemAllViewControllerDelegate
- (void) redeemListViewController:(RedeemAllViewController *)pRedeem isBack:(BOOL)pValue;

@end

@interface RedeemAllViewController : BaseViewController<IconDownloadManagerDelegate, RequestHandlerDelegate,GRESTDelegate>
{
    GREST *api;

}
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;

@property RedeemSelection mRedeemAllSelection;
@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) IBOutlet UIView *mTimerUIView;
@property (nonatomic, retain) IBOutlet UILabel *mTinerValue;
@property (nonatomic, retain) id <RedeemAllViewControllerDelegate> mDelegate;




-(void)showGestureView;
-(void)hideGestureView;
- (IBAction)couponRedeem:(id)sender;

//- (void) refreshList;
- (void) redeemAllCoupons:(NSMutableArray *)pCoupons;



@end
