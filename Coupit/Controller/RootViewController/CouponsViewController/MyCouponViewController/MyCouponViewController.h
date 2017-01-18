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
#import "FavouriteViewController.h"
#import "LocalyticsSession.h"

typedef enum
{
    kMenuViewSelection = 0,
    kSeeListViewSelection
}ViewSelectionType;


@interface MyCouponViewController : BaseViewController<IconDownloadManagerDelegate, CategoriesViewControllerDelegate, RequestHandlerDelegate,RedeemAllViewControllerDelegate,RedeemCouponViewControllerDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UITableView *TableView;
    NSArray *menuarray;
    UIButton *_btn4;
    

}

@property ViewSelectionType mSelectionType;
@property (nonatomic, retain) IBOutlet UITableView *mTableView;

@property (nonatomic, retain) IBOutlet UILabel *mBadgeValue;
@property (strong, nonatomic) IBOutlet UISwitch *switchControl;
@property (strong, nonatomic) IBOutlet UIView *moreView;

- (IBAction)switchTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *mPlanner;
@property (strong, nonatomic) IBOutlet UIButton *mCategories;
@property (strong, nonatomic) IBOutlet UIButton *mExpCoupons;

@property (strong, nonatomic) IBOutlet UIButton *cancellall;
@property (nonatomic)CGFloat previousScrollViewYOffset;

-(void)showGestureView;
-(void)hideGestureView;
-(void)menuButtonSelected;
-(void)menuButtonUnselected;
-(void)backButton:(id)sender;

- (void) refreshList;
- (IBAction)redeemAllButton:(id)sender;
- (IBAction)mDeleteAll:(id)sender;


@end
