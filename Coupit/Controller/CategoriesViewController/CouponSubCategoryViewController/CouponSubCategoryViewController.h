//
//  CategoriesViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CouponSubCategoryViewController;

@protocol CouponSubCategoryViewControllerDelegate
- (void) subCategoryViewController:(CouponSubCategoryViewController *)pSubCategoryViewController selectedCategoryID:(NSNumber *)pID;

@end


@interface CouponSubCategoryViewController : UIViewController {

}

@property(nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) id <CouponSubCategoryViewControllerDelegate> mDelegate;

- (void) setTitle:(NSString *)pTitle ID:(NSNumber *)pID subCategories:(NSArray *)pArray;

@end
