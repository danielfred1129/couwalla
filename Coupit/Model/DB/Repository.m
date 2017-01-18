//
//  Repository.m
//  Coupit
//
//  Created by Deepak Kumar on 3/4/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "Repository.h"
#import "FileUtils.h"
#import "Repository_ContextAccess.h"
#import "NSManagedObjectContext+SafeInsert.h"
#import "Groups.h"
#import "CouponCategories.h"
#import "CouponGroups.h"

@implementation Repository
{
    //NSManagedObjectContext* context;
    NSManagedObjectModel *model;
    NSPersistentStoreCoordinator *coordinator;
}

@synthesize context;
@synthesize mTotalArraycount;

+(Repository*)sharedRepository {
    static Repository* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Repository alloc] init];
    });
    return instance;
}

-(id)init
{
    if (self = [super init])
    {
        model = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:[NSBundle mainBundle]]];
        coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSURL* storeUrl = [NSURL fileURLWithPath:documentsFilePath(kDBName)];
        NSError *error = nil;
        if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error])
        {
            NSAssert(false, @"Failed to add persistent store to coordinator");
            return nil;
        }
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:coordinator];
    }
    return self;
}

- (NSArray *) fetchAllGroups:(NSError **)error {
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Groups"];
    return [context executeFetchRequest:fetchRequest error:error];
}

- (BOOL) isAllGroupsLoaded
{
    return [[self fetchAllGroups:nil] count] ? YES : NO;
}

- (NSArray *) fetchAllCouponGroups:(NSError **)error
{
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CouponGroups"];
    return [context executeFetchRequest:fetchRequest error:error];
}

- (NSArray *) fetchAllCouponCategories:(NSError **)error
{
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CouponCategories"];
    return [context executeFetchRequest:fetchRequest error:error];
}


- (NSArray *) fetchAllCoupons:(NSError **)error {
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Coupon"];
    return [context executeFetchRequest:fetchRequest error:error];
}

- (BOOL) isAllCouponsLoaded
{
    return [[self fetchAllCoupons:nil] count] ? YES : NO;
}

- (NSArray *) fetchAllUnMarkedCoupons:(NSError **)error {
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Coupon"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mDownloaded == NO"]];
    return [context executeFetchRequest:fetchRequest error:error];
}

- (BOOL) deleteAllUnMarkedCoupons
{
    for (Coupon *tCoupon in [self fetchAllUnMarkedCoupons:nil]) {
        [self deleteObject:tCoupon error:nil];
    }
    for (CouponGroups *tCouponGroups in [self fetchAllCouponGroups:nil]) {
        [self deleteObject:tCouponGroups error:nil];
    }
    for (CouponCategories *tCouponCategories in [self fetchAllCouponCategories:nil]) {
        [self deleteObject:tCouponCategories error:nil];
    }
    
    return YES;
}

// CouponGroups

- (BOOL)deleteCoupons:(Coupon *)pCoupon error:(NSError**)error
{
    return [self deleteObject:pCoupon error:error];
}

- (void) deleteCouponsByID:(NSString *)pCouponID
{
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Coupon"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mID == %@", pCouponID]];
    
    for (Coupon *tCoupon in [context executeFetchRequest:fetchRequest error:nil]) {
        [self deleteObject:tCoupon error:nil];
    }
}

- (void) deleteGiftCardbyID:(NSString *)pGiftCardID {
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"GiftCards"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mID == %@", pGiftCardID]];
    
    for (GiftCards *tGiftCards in [context executeFetchRequest:fetchRequest error:nil]) {
        [self deleteObject:tGiftCards error:nil];
    }
}


- (void) deleteMyCouponsByID:(NSString *)pCouponID
{
    NSManagedObjectContext *tContext = [Repository sharedRepository].context;
    NSFetchRequest *tRequest = [[NSFetchRequest alloc] init];
    [tRequest setEntity:[NSEntityDescription entityForName:@"MyCoupons" inManagedObjectContext:tContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mID == %@", pCouponID];
    [tRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *tRowDataArray = [tContext executeFetchRequest:tRequest error:&error];
    NSManagedObject *tDeleteTheRow = [tRowDataArray objectAtIndex:0];
    [tContext deleteObject:tDeleteTheRow];
    
    /*
     NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MyCoupons"];
     [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mID == %@", pCouponID]];
     
     for (MyCoupons *tCoupon in [context executeFetchRequest:fetchRequest error:nil]) {
     [self deleteObject:tCoupon error:nil];
     }
     */
}


- (NSMutableArray *) fetchDownloadedCouponsByCategory:(NSInteger)pCategoryID error:(NSError **)error {
    
    if (pCategoryID) {
        
        NSMutableArray *rCouponCategoryArray = [NSMutableArray new];
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MyCouponCategories"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mCategoryID == %d", pCategoryID]];
        
        NSMutableArray *tCouponIDs = [NSMutableArray new];
        for (NSManagedObject *tCouponCategory in [context executeFetchRequest:fetchRequest error:error])
        {
            NSNumber *tCouponID = [tCouponCategory valueForKey:@"mCouponID"];
            [tCouponIDs addObject:[tCouponID stringValue]];
        }
        
        NSFetchRequest* fetchRequest1 = [NSFetchRequest fetchRequestWithEntityName:@"MyCoupons"];
        [fetchRequest1 setPredicate:[NSPredicate predicateWithFormat:@"mDownloaded == YES AND mID IN %@", tCouponIDs]];
        [rCouponCategoryArray addObjectsFromArray:[context executeFetchRequest:fetchRequest1 error:error]];
        
        return rCouponCategoryArray;
        
        
        /*
         NSMutableArray *rCouponCategoryArray = [NSMutableArray new];
         NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CouponCategories"];
         [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mCategoryID == %d", pCategoryID]];
         
         for (NSManagedObject *tCouponCategory in [context executeFetchRequest:fetchRequest error:error])
         {
         NSNumber *tCouponID = [tCouponCategory valueForKey:@"mCouponID"];
         
         NSFetchRequest* fetchRequest1 = [NSFetchRequest fetchRequestWithEntityName:@"Coupon"];
         [fetchRequest1 setPredicate:[NSPredicate predicateWithFormat:@"mDownloaded == YES AND mID == %@", tCouponID]];
         [rCouponCategoryArray addObjectsFromArray:[context executeFetchRequest:fetchRequest1 error:error]];
         }
         
         
         return rCouponCategoryArray;
         */
    }
    else{
        NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MyCoupons"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mDownloaded == YES"]];
        return [NSMutableArray arrayWithArray:[context executeFetchRequest:fetchRequest error:error]];
    }
}

- (NSArray *) fetchPlannedCoupons:(NSError **)error{
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MyCoupons"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mPlanned == YES"]];
    
    return [context executeFetchRequest:fetchRequest error:error];
}

- (NSArray *) fetchFavoriteCoupons:(NSError **)error{
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MyCoupons"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mFavorited == YES AND mPlanned == YES"]];
    
    return [context executeFetchRequest:fetchRequest error:error];
}

- (NSArray *) fetchFavoriteMyCouponsByCategory:(NSInteger)pCategoryID error:(NSError **)error
{
    
    if (pCategoryID)
    {
        
        NSMutableArray *rCouponCategoryArray = [NSMutableArray new];
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MyCouponCategories"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mCategoryID == %d", pCategoryID]];
        
        NSMutableArray *tCouponIDs = [NSMutableArray new];
        for (NSManagedObject *tCouponCategory in [context executeFetchRequest:fetchRequest error:error])
        {
            NSNumber *tCouponID = [tCouponCategory valueForKey:@"mCouponID"];
            [tCouponIDs addObject:[tCouponID stringValue]];
        }
        
        NSFetchRequest* fetchRequest1 = [NSFetchRequest fetchRequestWithEntityName:@"MyCoupons"];
        [fetchRequest1 setPredicate:[NSPredicate predicateWithFormat:@"mFavorited == YES AND mID IN %@", tCouponIDs]];
        [rCouponCategoryArray addObjectsFromArray:[context executeFetchRequest:fetchRequest1 error:error]];
        
        return rCouponCategoryArray;
        
    }
    else {
        NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MyCoupons"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mFavorited == YES"]];
        
        return [context executeFetchRequest:fetchRequest error:error];
    }
    
    
    
    
    
}



- (NSMutableArray *) fetchCouponIDsWithGroupID:(NSInteger)pGroupID categoryID:(NSInteger)pCategoryID error:(NSError **)error {
    
    NSMutableArray *mCouponGroupArray = [NSMutableArray new];
    NSMutableArray *mCouponCategoryArray = [NSMutableArray new];
    
    if(pCategoryID){
        NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CouponCategories"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mCategoryID == %d", pCategoryID]];
        
        NSMutableArray *tCouponIDArray = [NSMutableArray new];
        for (NSManagedObject *tCouponCategory in [context executeFetchRequest:fetchRequest error:error])
        {
            NSNumber *tCategoryID = [tCouponCategory valueForKey:@"mCouponID"];
            [tCouponIDArray addObject:[tCategoryID stringValue]];
            
        }
        
        NSFetchRequest* fetchRequest1 = [NSFetchRequest fetchRequestWithEntityName:@"Coupon"];
        [fetchRequest1 setPredicate:[NSPredicate predicateWithFormat:@"mID IN %@", tCouponIDArray]];
        [mCouponCategoryArray addObjectsFromArray:[context executeFetchRequest:fetchRequest1 error:error]];
        // return mCouponCategoryArray;
    }
    
    if (pGroupID){
        NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CouponGroups"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mGroupID == %d", pGroupID]];
        
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:error];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"mIndex" ascending:YES];
        fetchedObjects = [fetchedObjects sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        
        NSMutableArray *tCouponIDArray = [NSMutableArray new];
        for (NSManagedObject *tCouponGroup in fetchedObjects)
        {
            NSNumber *tCouponID = [tCouponGroup valueForKey:@"mCouponID"];
            [tCouponIDArray addObject:[tCouponID stringValue]];
        }
        
        //NSLog(@"tcouponID Array :%d",[tCouponIDArray count]);
        
        NSFetchRequest* fetchRequest1 = [NSFetchRequest fetchRequestWithEntityName:@"Coupon"];
        [fetchRequest1 setPredicate:[NSPredicate predicateWithFormat:@"mID IN %@", tCouponIDArray]];
        [mCouponGroupArray addObjectsFromArray:[context executeFetchRequest:fetchRequest1 error:error]];
        
    }
    
    if (pGroupID && pCategoryID) {
        NSMutableSet *set1 = [NSMutableSet setWithArray: mCouponCategoryArray];
        NSSet *set2 = [NSSet setWithArray: mCouponGroupArray];
        [set1 intersectSet: set2];
        return [NSMutableArray arrayWithArray:[set1 allObjects]];
    }
    else if (pCategoryID)
    {
        return mCouponCategoryArray;
    }
    else{ // Group
        return mCouponGroupArray;
    }
    
    
    return 0;
}


/*
 - (NSMutableArray *) fetchCouponWithsIDs:(NSMutableArray *)pCouponIDs  error:(NSError **)error {
 
 NSMutableArray *mCouponArray = [NSMutableArray new];
 
 for (NSString *tCouponID in pCouponIDs) {
 NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Coupon"];
 [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mID == %@", tCouponID]];
 [mCouponArray addObjectsFromArray:[context executeFetchRequest:fetchRequest error:error]];
 
 }
 
 return mCouponArray;
 }
 */

- (NSArray *) fetchStoreWithsIDs:(NSString *)pStoreIDs  error:(NSError **)error
{
    NSMutableArray *mStoreArray = [NSMutableArray new];
    
    
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Stores"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mID == %@", pStoreIDs]];
    [mStoreArray addObjectsFromArray:[context executeFetchRequest:fetchRequest error:error]];
    
    
    return mStoreArray;
}

//-----------------------------------------------//
// Brand Pagination.
//-----------------------------------------------//

- (NSArray *) fetchBrands:(NSError **)error limit:(NSInteger)pLimitIndex
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Brands"];
    [fetchRequest setFetchOffset:pLimitIndex];
    [fetchRequest setFetchLimit:kItemsPerPage];
    //NSLog(@"---------------fetchBrand_Limit:%d", pLimitIndex);
    
    return [context executeFetchRequest:fetchRequest error:error];
}

- (NSArray *) fetchAllBrands:(NSError **)error
{
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Brands"];
    return [context executeFetchRequest:fetchRequest error:error];
    
}

- (BOOL)isAllBrandsLoaded
{
    return [[self fetchAllBrands:nil] count] ? YES : NO;
}

- (NSArray *)fetchBrandIDWithCategoryID:(NSInteger)pCategoryID  error:(NSError **)error
{
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"BrandCategories"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mCategoryID == %d", pCategoryID]];
    return [context executeFetchRequest:fetchRequest error:error];
}


- (NSArray *) fetchAllCategory:(NSError **)error
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Categories"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mChild == NO"]];
    return [context executeFetchRequest:fetchRequest error:error];
}

- (BOOL) isAllCategoriesLoaded
{
    return [[self fetchAllCategory:nil] count] ? YES : NO;
}

//-----------------------------------------------//
// Store Pagination.
//-----------------------------------------------//

- (NSArray *) fetchStores:(NSError **)error limit:(NSInteger)pLimitIndex
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Stores"];
    [fetchRequest setFetchOffset:pLimitIndex];
    [fetchRequest setFetchLimit:kItemsPerPage];
    //NSLog(@"---------------fetchStores_Limit:%d", pLimitIndex);
    
    return [context executeFetchRequest:fetchRequest error:error];
}


- (NSArray *) fetchAllStores:(NSError **)error
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Stores"];
    return [context executeFetchRequest:fetchRequest error:error];
}

- (BOOL) isAllStoresLoaded {
    return [[self fetchAllStores:nil] count] ? YES : NO;
}

- (NSArray *) fetchAllStoresLocations:(NSError **)error
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"StoreLocations"];
    return [context executeFetchRequest:fetchRequest error:error];
}

-( BOOL) isAllStoresLocationsLoaded
{
    return [[self fetchAllStoresLocations:nil] count] ? YES : NO;
}

- (NSArray *) fetchStoreLocationsWithStoreID:(NSInteger)pStoreID error:(NSError **)error
{
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"StoreLocations"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mStoreID == %d", pStoreID]];
    return [context executeFetchRequest:fetchRequest error:error];
    
}


- (NSArray *) fetchStoreIDWithCategoryID:(NSInteger)pCategoryID  error:(NSError **)error
{
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"StoreCategories"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mCategoryID == %d", pCategoryID]];
    
    NSMutableArray *tCouponIDArray = [NSMutableArray new];
    for (NSManagedObject *tCouponGroup in [context executeFetchRequest:fetchRequest error:error]) {
        
        NSNumber *tStoreID = [tCouponGroup valueForKey:@"mStoreID"];
        ////NSLog(@"--------------tStoreID:%d", tStoreID.intValue);
        [tCouponIDArray addObject:[tStoreID stringValue]];
        
    }
    
    NSMutableArray *mStoreArray = [NSMutableArray new];
    
    NSFetchRequest* fetchRequest1 = [NSFetchRequest fetchRequestWithEntityName:@"Stores"];
    [fetchRequest1 setPredicate:[NSPredicate predicateWithFormat:@"mID IN %@", tCouponIDArray]];
    [mStoreArray addObjectsFromArray:[context executeFetchRequest:fetchRequest1 error:error]];
    
    return mStoreArray;
    
}
/*
 - (NSArray *) fetchStoreWithsIDs:(NSArray *)pStoreIDs  error:(NSError **)error {
 NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Stores"];
 [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(SUBQUERY(mID IN %@).@count > %d)", pStoreIDs, [pStoreIDs count]-1]];
 //NSLog(@"STOREID  %@",pStoreIDs);
 
 return [context executeFetchRequest:fetchRequest error:error];
 }
 */

- (NSArray *) fetchCouponsIDWithStoreID:(NSInteger)pStoreID error:(NSError **)error
{
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"StoreCoupons"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mStoreID == %d", pStoreID]];
    return [context executeFetchRequest:fetchRequest error:error];
}

//-----------------------------------------------//
//Method for Pagination.
//-----------------------------------------------//

- (NSMutableArray *) fetchCouponIDsWithGroupID:(NSInteger)pGroupID categoryID:(NSInteger)pCategoryID limit:(NSInteger)pLimitIndex error:(NSError **)error {
    
    NSMutableArray *mCouponGroupArray = [NSMutableArray new];
    NSMutableArray *mCouponCategoryArray = [NSMutableArray new];
    
    if(pCategoryID){
        NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CouponCategories"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mCategoryID == %d", pCategoryID]];
        
        NSMutableArray *tCouponIDArray = [NSMutableArray new];
        for (NSManagedObject *tCouponCategory in [context executeFetchRequest:fetchRequest error:error])
        {
            NSNumber *tCategoryID = [tCouponCategory valueForKey:@"mCouponID"];
            [tCouponIDArray addObject:[tCategoryID stringValue]];
            
        }
        
        NSFetchRequest* fetchRequest1 = [NSFetchRequest fetchRequestWithEntityName:@"Coupon"];
        [fetchRequest1 setPredicate:[NSPredicate predicateWithFormat:@"mID IN %@", tCouponIDArray]];
        [mCouponCategoryArray addObjectsFromArray:[context executeFetchRequest:fetchRequest1 error:error]];
        // return mCouponCategoryArray;
    }
    
    if (pGroupID){
        NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CouponGroups"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mGroupID == %d", pGroupID]];
        
        
        NSMutableArray *tCouponIDArray = [NSMutableArray new];
        for (NSManagedObject *tCouponGroup in [context executeFetchRequest:fetchRequest error:error])
        {
            NSNumber *tCouponID = [tCouponGroup valueForKey:@"mCouponID"];
            [tCouponIDArray addObject:[tCouponID stringValue]];
        }
        
        NSFetchRequest* fetchRequest1 = [NSFetchRequest fetchRequestWithEntityName:@"Coupon"];
        [fetchRequest1 setPredicate:[NSPredicate predicateWithFormat:@"mID IN %@", tCouponIDArray]];
        
        
        mTotalArraycount = [context countForFetchRequest:fetchRequest1 error:error];
        //NSLog(@"Total count: %u", mTotalArraycount);
        
        [fetchRequest1 setFetchOffset:pLimitIndex];
        [fetchRequest1 setFetchLimit:10];
        
        [mCouponGroupArray addObjectsFromArray:[context executeFetchRequest:fetchRequest1 error:error]];
        
    }
    
    if (pGroupID && pCategoryID) {
        NSMutableSet *set1 = [NSMutableSet setWithArray: mCouponCategoryArray];
        NSSet *set2 = [NSSet setWithArray: mCouponGroupArray];
        [set1 intersectSet: set2];
        return [NSMutableArray arrayWithArray:[set1 allObjects]];
    }
    else if (pCategoryID)
    {
        return mCouponCategoryArray;
    }
    else{ // Group
        return mCouponGroupArray;
    }
    
    return 0;
}

- (NSArray *) fetchAllGiftCards:(NSError **)error
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"GiftCards"];
    return [context executeFetchRequest:fetchRequest error:error];
}

- (BOOL) deleteGiftCards:(GiftCards *)pGiftCards error:(NSError**)error
{
    return [self deleteObject:pGiftCards error:error];
}

// Private Method
-(BOOL)deleteObject:(NSManagedObject*)object error:(NSError**)error
{
    [context deleteObject:object];
    return [context save:error];
}

// Card
-(NSArray*) fetchAllWalletGiftCards {
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Card"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mCardType == 1"]];
    
    return [context executeFetchRequest:fetchRequest error:nil];
}

-(NSArray*) fetchAllWalletLoyaltyCards
{
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Card"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mCardType == 0"]];
    return [context executeFetchRequest:fetchRequest error:nil];
}

//Store Preferences
- (NSArray *) fetchAllStoresPreference:(NSError **)error
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"StorePreferences"];
    return [context executeFetchRequest:fetchRequest error:error];
}

- (NSArray *) fetchStorePreferencesWithStoreID:(NSInteger)pStoreID error:(NSError **)error {
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"StorePreferences"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mStoreID == %@",pStoreID]];
    return [context executeFetchRequest:fetchRequest error:nil];
    
}
- (NSArray *) fetchStorePreferencesWithBrandID:(NSInteger)pBrandID error:(NSError **)error {
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"StorePreferences"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mBrandID == %@",pBrandID]];
    return [context executeFetchRequest:fetchRequest error:nil];
    
}

- (NSArray *) fetchRedeemCoupons:(NSError **)error{
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MyCoupons"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mRedeeemSelected == YES"]];
    
    return [context executeFetchRequest:fetchRequest error:error];
}


- (NSMutableArray *) fetchRedeemCouponsByCategory:(NSInteger)pCategoryID error:(NSError **)error {
    
    if (pCategoryID) {
        
        NSMutableArray *rCouponCategoryArray = [NSMutableArray new];
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MyCouponCategories"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mCategoryID == %d", pCategoryID]];
        
        NSMutableArray *tCouponIDs = [NSMutableArray new];
        for (NSManagedObject *tCouponCategory in [context executeFetchRequest:fetchRequest error:error])
        {
            NSNumber *tCouponID = [tCouponCategory valueForKey:@"mCouponID"];
            [tCouponIDs addObject:[tCouponID stringValue]];
        }
        
        NSFetchRequest* fetchRequest1 = [NSFetchRequest fetchRequestWithEntityName:@"MyCoupons"];
        [fetchRequest1 setPredicate:[NSPredicate predicateWithFormat:@"mRedeeemSelected == YES AND mID IN %@", tCouponIDs]];
        [rCouponCategoryArray addObjectsFromArray:[context executeFetchRequest:fetchRequest1 error:error]];
        
        return rCouponCategoryArray;
        
    }else {
        NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MyCoupons"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mRedeeemSelected == YES"]];
        return [NSMutableArray arrayWithArray:[context executeFetchRequest:fetchRequest error:error]];
    }
}


- (NSArray *) fetchAllMyCoupons:(NSError **)error {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MyCoupons"];
    return [context executeFetchRequest:fetchRequest error:error];
}



@end
