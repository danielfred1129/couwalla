//
//  Repository.h
//  Coupit
//
//  Created by Deepak Kumar on 3/4/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Coupon.h"
#import "GiftCards.h"

@interface Repository : NSObject

@property(nonatomic, readonly) NSManagedObjectContext* context;
@property(nonatomic) NSUInteger mTotalArraycount;

+ (Repository *) sharedRepository;
// Fetch All Group
- (NSArray *) fetchAllGroups:(NSError **)error;
- (BOOL) isAllGroupsLoaded;
- (NSArray *) fetchAllCouponGroups:(NSError **)error;

// Fetch All Coupons
- (NSArray *) fetchAllCoupons:(NSError **)error;
- (NSArray *) fetchAllUnMarkedCoupons:(NSError **)error;
- (BOOL) isAllCouponsLoaded;
- (BOOL) deleteCoupons:(Coupon *)pCoupon error:(NSError**)error;
- (BOOL) deleteAllUnMarkedCoupons;
- (void) deleteCouponsByID:(NSString *)pCouponID;

- (NSMutableArray *) fetchDownloadedCouponsByCategory:(NSInteger)pCategoryID error:(NSError **)error;

- (NSArray *) fetchPlannedCoupons:(NSError **)error;
- (NSArray *) fetchFavoriteCoupons:(NSError **)error;

// Fetch All Brands
- (NSArray *) fetchAllBrands:(NSError **)error;
- (BOOL) isAllBrandsLoaded;
- (NSArray *) fetchBrands:(NSError **)error limit:(NSInteger)pLimitIndex;

// Fetch All Category
- (NSArray *) fetchAllCategory:(NSError **)error;
- (BOOL) isAllCategoriesLoaded;

// Fetch All Stores
- (NSArray *) fetchAllStores:(NSError **)error;
- (BOOL) isAllStoresLoaded;
- (NSArray *) fetchStores:(NSError **)error limit:(NSInteger)pLimitIndex;


//Fetch All Stores Locations //vikas
- (NSArray *) fetchAllStoresLocations:(NSError **)error;
-( BOOL) isAllStoresLocationsLoaded;
- (NSArray *) fetchStoreLocationsWithStoreID:(NSInteger)pStoreID error:(NSError **)error;


// Conditional
- (NSArray *) fetchBrandIDWithCategoryID:(NSInteger)pCategoryID  error:(NSError **)error;

//- (NSMutableArray *) fetchCouponWithsIDs:(NSMutableArray *)pCouponIDs  error:(NSError **)error;
//- (NSMutableArray *) fetchCouponIDsWithGroupID:(NSInteger)pGroupID  error:(NSError **)error;
- (NSMutableArray *) fetchCouponIDsWithGroupID:(NSInteger)pGroupID categoryID:(NSInteger)pCategoryID error:(NSError **)error;

- (NSArray *) fetchStoreIDWithCategoryID:(NSInteger)pCategoryID  error:(NSError **)error;
- (NSArray *) fetchCouponsIDWithStoreID:(NSInteger)pStoreID error:(NSError **)error;

- (NSArray *) fetchStoreWithsIDs:(NSString* )pStoreIDs  error:(NSError **)error;
- (NSMutableArray *) fetchCouponIDsWithGroupID:(NSInteger)pGroupID categoryID:(NSInteger)pCategoryID limit:(NSInteger)pLimitIndex error:(NSError **)error ;

- (NSArray *) fetchAllGiftCards:(NSError **)error;
- (BOOL) deleteGiftCards:(GiftCards *)pGiftCards error:(NSError**)error;

- (NSArray *) fetchAllWalletGiftCards;
- (NSArray *) fetchAllWalletLoyaltyCards;

- (NSArray *) fetchAllStoresPreference:(NSError **)error;
- (NSArray *) fetchStorePreferencesWithStoreID:(NSInteger)pStoreID error:(NSError **)error;
- (NSArray *) fetchStorePreferencesWithBrandID:(NSInteger)pBrandID error:(NSError **)error;

- (NSArray *) fetchRedeemCoupons:(NSError **)error;
- (NSMutableArray *) fetchRedeemCouponsByCategory:(NSInteger)pCategoryID error:(NSError **)error;

//DeleteCoupon From  Mycoupon
- (void) deleteMyCouponsByID:(NSString *)pCouponID;
//Delete Gift Card
- (void) deleteGiftCardbyID:(NSString *)pGiftCardID;


//Fetch All MyCoupon
- (NSArray *) fetchAllMyCoupons:(NSError **)error;
//Fetch FavoruteMyCoupon
- (NSArray *) fetchFavoriteMyCouponsByCategory:(NSInteger)pCategoryID error:(NSError **)error;


@end
