//
//  CouponCategoriesViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponSubCategoryViewController.h" 
#import "RequestHandler.h"

@class CouponCategoriesViewController;

@protocol CouponCategoriesViewControllerDelegate
- (void) couponViewController:(CouponCategoriesViewController *)pCouponPreferences isBack:(BOOL)pValue;

@end


@interface CouponCategoriesViewController : BaseViewController <CouponSubCategoryViewControllerDelegate>{

}
@property(nonatomic, retain) IBOutlet UITableView *mTableView;
@property CouponPrefrencesSelected mCouponPrefrencesSelected;
@property (nonatomic, retain) id <CouponCategoriesViewControllerDelegate> mDelegate;



@end
