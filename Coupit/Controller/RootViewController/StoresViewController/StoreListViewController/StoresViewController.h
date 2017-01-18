//
//  StoresViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestHandler.h"
#import "IconDownloadManager.h"
#import <CoreLocation/CoreLocation.h>
#import "StoreLocations.h"
#import "StoreGoogleMapViewController.h"
#import "ZUUIRevealController.h"
#import "AppDelegate.h"
#define kStoresPerPage 20    //page size



typedef enum {
    kNearmMeTab,
    kBrandsTab,
    kManufacturersTab,
    kQRCheckInTab,
    kMapViewSelected,
    kStoreWithNotification
}SeletedTab;
typedef enum {
    kFromMenuScreenn,
    kFromAllScreenn
}ResetCouponCategoryy;

@class StoresViewController;


@interface StoresViewController : BaseViewController<RequestHandlerDelegate, IconDownloadManagerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZBarReaderDelegate,StoreGoogleMapViewControllerDelegate,CLLocationManagerDelegate>
{
    NSArray *sortedArray;
    NSMutableArray *sectionwithindex,*storeNameArray,*storeThumbnail,*pointsarray,*brandstoreNameArray,*brandstoreThumbnail,*brandpointsarray;
    NSArray *digitsArray;
    int temp1234;
    NSMutableArray *displayArray;
    int brandDynamicCount;
    NSMutableDictionary *filteringBrands;
    UILabel *labelSection;
}

@property SeletedTab mSeletedTab;
@property LocationPreference mLocationPreference;
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, retain) IBOutlet UITableView *mtableView;
//@property(nonatomic, retain) IBOutlet UIButton *mNearmeStoreButton;
//@property(nonatomic, retain) IBOutlet UIButton *mBrandStoreButton;
//@property (nonatomic, retain) IBOutlet UIButton *mFavouritesButton;
@property (nonatomic,retain) UILocalizedIndexedCollation *collation;

-(void) initButtons;
-(void) revealToggle11;
-(void)showGestureView;
-(void)hideGestureView;
-(void)menuButtonSelected;
-(void)menuButtonUnselected;

- (void) fetchStoreListAtIndex:(NSInteger)pIndex;
- (void) fetchBrandListAtIndex:(NSInteger)pIndex;
- (void) notificationDictionary:(NSDictionary *)pDict;
-(void)flexibleRows:(NSInteger)section;


//- (StoreLocations *) getStoreLocationByID:(NSInteger)pID;

@end

