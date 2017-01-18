//
//  CategoriesViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubCategoryViewController.h"
#import "GREST.h"
#import "tNSString+SBJSON.h"
#import "RequestHandler.h"

@class CategoriesViewController;

@protocol CategoriesViewControllerDelegate
- (void) categoriesViewController:(CategoriesViewController *)pCategoriesViewController selectedCategoryID:(NSNumber *)pID;
 
@end

@interface CategoriesViewController : BaseViewController<SubCategoryViewControllerDelegate,UISearchBarDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,GRESTDelegate>
{
     GREST *api;
        UIRefreshControl *refreshControl;

}

@property (nonatomic, retain) UIRefreshControl *refreshControl;
@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) id <CategoriesViewControllerDelegate> mDelegate;
@property NSInteger mSelectedCategoryID;

- (void) dismissViewControlerForCategoryID:(NSNumber *)pID;

- (void)showGestureView;
- (void)hideGestureView;
- (void)menuButtonSelected;
- (void)menuButtonUnselected;
- (void) notificationDictionary:(NSDictionary *)pDict;

@end
