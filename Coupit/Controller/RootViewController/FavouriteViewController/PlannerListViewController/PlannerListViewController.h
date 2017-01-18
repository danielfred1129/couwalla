//
//  MyCouponViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloadManager.h"
#import "CategoriesViewController.h"
#import "RequestHandler.h"
#import "RedeemAllViewController.h"
#import "RedeemCouponViewController.h"

typedef enum {
    kMenuViewSelectionn = 0,
    kSeeListViewSelectionn
}ViewSelectionTypee;


@interface PlannerListViewController : UITableViewController<IconDownloadManagerDelegate, CategoriesViewControllerDelegate, RequestHandlerDelegate,RedeemAllViewControllerDelegate,RedeemCouponViewControllerDelegate>

@property ViewSelectionTypee mSelectionType;
@property (nonatomic, retain) IBOutlet UIView *mBottomBarUIView;
@property (nonatomic, retain) IBOutlet UIButton *mRedeemAllButton;
@property (nonatomic, retain) IBOutlet UILabel *mBadgeValue;
@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic,retain) NSString *name,*descrp,*tumbimg;
@property (nonatomic, retain) NSMutableArray *mDownloadedCouponList;
- (IBAction)redeemAllButton:(id)sender;
- (IBAction)deleteAllButton:(id)sender;

-(void)backButton:(id)sender;
- (void) setPlannerCoupons:(NSArray *)pCoupons forGroup:(NSString *)pGroupName;


@end
