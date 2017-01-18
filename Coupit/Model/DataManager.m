//
//  DataManager.m
//  VisitReporting
//
//  Created by AtreeTech on 06/01/13.
//  Copyright (c) 2013 Deepak Kumar. All rights reserved.
//

#import "DataManager.h"
#import "tJSON.h"

static DataManager *sharedInstance = nil;

@implementation DataManager
@synthesize mCouponGroupArray, mCategoriesArray, mCouponBrandArray ,mNearMeStoreArray, mCouponQueryArray;
@synthesize mStoreCheckInCouponArray, mBrandCheckInCouponArray;
@synthesize mKeywordCouponArray, mGiftCardsArray, mBrandsArray, mAdvertsArray, mStoresArray, mMapStoreLocationArray,mCouponPreferences,mStoresLocationArray;

@synthesize mObjCouponDetail, mDeviceToken, mCouponShareURL, mObjCouponAddToTagDetail, mObjStorePreferences, mDownloadCoupon,mSolrCouponsArray,mRedeemCouponResponseArray;

#pragma mark singleton class method
+ (DataManager *) getInstance
{
	@synchronized(self)
	{
		if(sharedInstance == nil)
		{
			sharedInstance = [[self alloc] init];
		}
	}
	
	return sharedInstance;
}

+ (id) allocWithZone:(NSZone*)zone
{
	@synchronized(self)
	{
		if(sharedInstance == nil)
		{
			sharedInstance = [super allocWithZone:zone];
			return sharedInstance;
		}
	}
	return nil;
}

- (id) init
{
	self = [super init];
	
	if (self != nil) {
    
        self.mCategoriesArray = [NSMutableArray new];
        self.mNearMeStoreArray = [NSMutableArray new];
	}
	return self;
}

- (id)copyWithZone:(NSZone*)zone
{
	return self;
}

- (NSString *) getContentURL
{
    NSString *rContentURL = [[NSUserDefaults standardUserDefaults] objectForKey:kContentUrl];
    return rContentURL;
}


- (NSString *) getSupportURL
{
    NSString *rSupportURL = [[NSUserDefaults standardUserDefaults] objectForKey:kSupportUrl];
    return rSupportURL;
}


- (NSString *) getLogoURL
{
    NSString *rLogoURL = [[NSUserDefaults standardUserDefaults] objectForKey:kLogoUrl];
    return rLogoURL;
}


- (NSString *) getLegalURL
{
    NSString *rLegalURL = [[NSUserDefaults standardUserDefaults] objectForKey:kLegalUrl];
    return rLegalURL;
}

- (NSString *) getAdTimer
{
    NSString *rAdTimer = [[NSUserDefaults standardUserDefaults] objectForKey:kAdTimer];
    return rAdTimer;
}

- (RewardCard *) getRewardCardObject
{
    tSBJSON *tJsonParser = [[tSBJSON alloc] init];
    RewardCard *rRewardCard = [RewardCard new];
    
    NSString *tRewardCardJSON = [[NSUserDefaults standardUserDefaults] objectForKey:kRewardCardKey];
    NSMutableDictionary* tRewardCardDictionary = (NSMutableDictionary*)[tJsonParser objectWithString:tRewardCardJSON error:nil];
    
    [rRewardCard rewardCardWithDict:tRewardCardDictionary];
    return rRewardCard;
}

- (NSDate *)couponExpireDate:(NSDate *)pCouponValidity {
    
    int daysToAdd = -1;
    NSDateComponents *tComponents = [[NSDateComponents alloc] init];
    [tComponents setDay:daysToAdd];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *rExpireDate = [gregorian dateByAddingComponents:tComponents toDate:pCouponValidity options:0];
    
    return rExpireDate;
}

- (NSDate *)myCouponExpireDate:(NSInteger)pDaysToAdd {
    
    NSDate *tStartDate = [NSDate date];
    int daysToAdd = pDaysToAdd;
    NSDateComponents *tComponents = [[NSDateComponents alloc] init];
    [tComponents setDay:daysToAdd];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *rExpireDate = [gregorian dateByAddingComponents:tComponents toDate:tStartDate options:0];
    return rExpireDate;

}

- (BOOL)couponRequest {
    
    BOOL rIsCouponRequest;
    
    NSCalendar* tCalender = [NSCalendar currentCalendar];
    NSDateComponents* tComponents = [tCalender components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSInteger tTodaysDay = [[[NSUserDefaults standardUserDefaults] objectForKey:kCouponRequestDay] intValue];
    
    if (tTodaysDay == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[tComponents weekday]] forKey:kCouponRequestDay];
    }
    
    tTodaysDay = [[[NSUserDefaults standardUserDefaults] objectForKey:kCouponRequestDay] intValue];
    if (tTodaysDay == [tComponents weekday]) {
        rIsCouponRequest = true;
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCouponRequestDay];
        [[NSUserDefaults standardUserDefaults]synchronize ];
                
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[tComponents weekday]] forKey:kCouponRequestDay];
        rIsCouponRequest = false;

    }
    return rIsCouponRequest;
}


- (BOOL)storeCheckIn:(NSString *)pStoreID {

    BOOL rIsCheckedIn = '\0';
    NSMutableArray *tStoreId = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kCheckInStore]];

    NSCalendar* tCalender = [NSCalendar currentCalendar];
    NSDateComponents* tComponents = [tCalender components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSInteger tTodaysDay = [[[NSUserDefaults standardUserDefaults] objectForKey:kDayofWeek] intValue];

    if (tTodaysDay == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[tComponents weekday]] forKey:kDayofWeek];
    }
    
    tTodaysDay = [[[NSUserDefaults standardUserDefaults] objectForKey:kDayofWeek] intValue];
    if (tTodaysDay == [tComponents weekday]) {
        if ([tStoreId containsObject:pStoreID]) {
            rIsCheckedIn = true;
        } else {
            [tStoreId addObject:pStoreID];
            [[NSUserDefaults standardUserDefaults] setObject:tStoreId forKey:kCheckInStore];
            rIsCheckedIn = false;
        }
    } else {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDayofWeek];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCheckInStore];
        [[NSUserDefaults standardUserDefaults]synchronize ];
        [tStoreId removeAllObjects];
        
        tTodaysDay = [[[NSUserDefaults standardUserDefaults] objectForKey:kDayofWeek] intValue];
        
        if (tTodaysDay == 0) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[tComponents weekday]] forKey:kDayofWeek];
        }
        tTodaysDay = [[[NSUserDefaults standardUserDefaults] objectForKey:kDayofWeek] intValue];
        if (tTodaysDay == [tComponents weekday]) {
            if ([tStoreId containsObject:pStoreID]) {
                rIsCheckedIn = true;
            } else {
                [tStoreId addObject:pStoreID];
                [[NSUserDefaults standardUserDefaults] setObject:tStoreId forKey:kCheckInStore];
                rIsCheckedIn = false;
            }
        }
    }
    return rIsCheckedIn;

    
}


@end
