//
//  CouponListViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoriesViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "RNFullScreenScroll.h"

typedef enum
{
    kMenuSearchViewSelection = 0,
    kSearchListViewSelection,
    kCategorySelection
}SearchViewSelectionType;

@class CouponListViewController;

@protocol CouponListViewControllerDelegate
- (void) couponListViewController:(CouponListViewController *)pCategories isBack:(BOOL)pValue;

@end

@interface CouponListViewController : UITableViewController<CategoriesViewControllerDelegate, EGORefreshTableHeaderDelegate,UIScrollViewDelegate,RNTableViewDelegate,UISearchBarDelegate> {
@private
    NSUInteger numberOfItemsToDisplay;
    UIRefreshControl *refreshControl;
    
}
@property GroupType mGroupType;
@property NSInteger mCategoryID;
@property SearchViewSelectionType mSelectionType;

@property (nonatomic, retain) NSMutableArray *mCouponListArray;
@property (nonatomic, retain) NSDictionary *mDataDictionary;
@property (nonatomic, assign) int buttonTag;

@property (nonatomic, retain) id <CouponListViewControllerDelegate> mDelegate;
@property (nonatomic,strong)  UILabel* buttomLabel;

- (void) loadCouponsForGroupID:(NSInteger)pGroupID category:(NSInteger)pCategoryID;
- (void)pulledToRefresh;

-(void)showGestureView;
-(void)hideGestureView;
-(void)menuButtonSelected;
-(void)menuButtonUnselected;
-(void)backButton:(id)sender;

@end
