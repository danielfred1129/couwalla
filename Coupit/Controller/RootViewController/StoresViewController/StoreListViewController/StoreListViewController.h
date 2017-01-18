//
//  StoreListViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RequestHandler.h"
#import "IconDownloadManager.h"

#import "Brands.h"
#import "Stores.h"
#import "StoreLocations.h"
#import "LocationDocs.h"
#import <MapKit/MapKit.h>
#import "DataManager.h"
#import "Location.h"

@class StoreListViewController;

@protocol StoreListViewControllerDelegate
- (void) storeListViewController:(StoreListViewController *)pStoreList isBack:(BOOL)pValue;

@end

@interface StoreListViewController : BaseViewController<IconDownloadManagerDelegate, RequestHandlerDelegate> {

}
@property (nonatomic, retain) id <StoreListViewControllerDelegate> mDelegate;
@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) IBOutlet UIImageView *mBannerImageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *mActivityIndicator;
@property (nonatomic, retain) IBOutlet UILabel *mAddressLabel;
@property (nonatomic, retain) IBOutlet UIButton *mAddStorePreferencesButton;
@property (nonatomic, retain) IBOutlet UIButton *mEditStorePreferencesButton;
@property (nonatomic) NSInteger mStoreID;

@property StoreLocatorType mStoreLocator;
@property(nonatomic, retain)NSString *titlestring,*tempstring,*storeID,*addressstring,*latstring,*longstring;

//- (void) showCouponsForStore:(Stores *)pStore;
- (void) showCouponsForStore:(Stores *)pStore;
- (void) showCouponsForBrand:(Brands *)pBrand;
- (void) showLocationForStore:(StoreLocations *)pStoreLocation;
- (void) refreshData;

- (void) fetchCouponsForStoreAtIndex:(NSInteger)pStartIndex;
- (void) fetchCouponsForBrandAtIndex:(NSInteger)pStartIndex;

- (IBAction)addStorePreferences:(id)sender;



@end
