//
//  DPKRequestHandler.m
//  NewtworkProgram
//
//  Created by Deepak Kumar on 16/06/10.
//  Copyright 2010 home. All rights reserved.
//

#import "RequestHandler.h"
#import "Reachability.h"
#import "DataManager.h"

// Parser Class
#import "Groups.h"
#import "Stores.h"
#import "StoreLocations.h"
#import "Category.h"
#import "Coupon.h"
#import "Brands.h"
#import "FileUtils.h"
#import "Subscriber.h"
#import "APIError.h"
#import "GiftCards.h"
#import "Advertisement.h"
#import "LocationDocs.h"
#import "SubscriberCredentials.h"
#import "StorePreferences.h"
#import "MyCoupons.h"
#import "SolrCoupons.h"
#import "LocalyticsSession.h"

@implementation RequestHandler
{
    NSInteger mIndex;
}

@synthesize mDelegateDictionary;
@synthesize mAuthKey;


static RequestHandler *sharedInstance = nil;

#pragma mark DPKRequestHandler singleton class method
+ (RequestHandler *) getInstance
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
		mQueue = [[NSOperationQueue alloc] init];
		AlertVisible = NO;
        mIndex = 0;
        
        //-- Create new SBJSON parser object
		if(!mJsonParser)
			mJsonParser = [[tSBJSON alloc] init];
	}
	return self;
}

- (id)copyWithZone:(NSZone*)zone
{
	return self;
}

#pragma mark RequestMethods
- (NSArray *) requests
{
	return [mQueue operations];
}

- (void) cancellAllRequest
{
	[mQueue cancelAllOperations];
}

#pragma mark -
#pragma mark RequestMethods
- (void) getRequestURL:(NSString *)pURL delegate:(id)pDelegate requestType:(RequestType)pRequestType
{
    mURL = pURL;
    mIsPostRequest = NO;
    mRequestType = pRequestType;
    
	if ([self checkInternet])
    {
        
        if (!mDelegateDictionary)
        {
            mDelegateDictionary = [NSMutableDictionary dictionary];
        }
        
        NSString *tKeyString = [NSString stringWithFormat:@"k_Delegate%d", pRequestType];
        id tDelegate = [mDelegateDictionary objectForKey:tKeyString];

        if (tDelegate == nil)
        {
            [mDelegateDictionary setObject:pDelegate forKey:tKeyString];
        }
        //NSLog(@"Request_url:*************  *%@*", pURL);

		HttpRequest *networkRequest = [[HttpRequest alloc] initGetRequestWithURL:pURL requestType:pRequestType];
        networkRequest.mIsPostRequest = NO;
		networkRequest.mDelegate = self;
		[mQueue addOperation:networkRequest]; // this will start the "Network Operation"
        
        //NSLog(@"---- Get_mQueue:%d",[mQueue operationCount]);
        
	}
	else {
		///////////////////////////////
		
			if (!AlertVisible)
            {
				mAlertView = [[UIAlertView alloc] 
							  initWithTitle:nil
							  message:@"No Internet Connection." delegate:self 
							  cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[mAlertView show];
			}
	}
}

- (void) postRequestwithHostURL:(NSString *)pHostURL bodyPost:(NSString *)pBodyPost delegate:(id)pDelegate requestType:(RequestType)pRequestType
{
    NSLog(@"%@", pBodyPost);
    
    if (pRequestType != kReLoginRequest) {
        mURL = pHostURL;
        mPostBodyString = pBodyPost;
        mIsPostRequest = YES;
        mRequestType = pRequestType;
    }
    
    
    if ([self checkInternet]) {
        
        if (!mDelegateDictionary) {
            mDelegateDictionary = [NSMutableDictionary dictionary];
        }
        
        NSString *tKeyString = [NSString stringWithFormat:@"k_Delegate%d", pRequestType];
        id tDelegate = [mDelegateDictionary objectForKey:tKeyString];
        
        if (tDelegate == nil)
        {
            [mDelegateDictionary setObject:pDelegate forKey:tKeyString];
        }
        //NSLog(@"Request_url:%@", pHostURL);
        
        //pBodyPost = [NSString stringWithFormat:@"%@", @"{\"coupons\":[{\"description\":\"With bold, colorful and energetic design\"}]}"];
        
        
        
		HttpRequest *networkRequest = [[HttpRequest alloc] initPostRequestwithHostURL:pHostURL bodyPost:pBodyPost requestType:pRequestType];
        networkRequest.mIsPostRequest = YES;
		networkRequest.mDelegate = self;
		[mQueue addOperation:networkRequest]; // this will start the "Network Operation"
        //NSLog(@"---- Post_mQueue:%d",[mQueue operationCount]);
	}
	else {
		///////////////////////////////
		
        if (!AlertVisible) {
            mAlertView = [[UIAlertView alloc]
                          initWithTitle:nil
                          message:@"No Internet Connection." delegate:self
                          cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [mAlertView show];
        }
	}
}


#pragma mark -
#pragma mark ResponseMethods
- (void) responseHandler:(HttpRequest *)pController requestType:(RequestType)pRequestType status:(int)pStatusCode
{
    NSString *tKeyString = [NSString stringWithFormat:@"k_Delegate%d", pRequestType];

    id tDelegate = [mDelegateDictionary objectForKey:tKeyString];

    if (tDelegate != nil)
    {        
        NSString* jsonString	= [[NSString alloc] initWithData:[pController mResponseData] encoding:NSUTF8StringEncoding];		

        NSManagedObjectContext *tContext = [Repository sharedRepository].context;
        NSMutableDictionary* responseData;
        
        id jsonObject = [mJsonParser objectWithString:jsonString error:nil];
        
        BOOL tError = NO;
        APIError* tAPIError;
        
        responseData = (NSMutableDictionary *)jsonObject;
        NSLog(@"responseData JSON - %@", responseData);

        if ([jsonObject isKindOfClass:[NSArray class]]) {
            //Is array
        } else if([jsonObject isKindOfClass:[NSDictionary class]]) {
            //is dictionary
            if ([responseData objectForKey:@"errorCode"]) {
                tError = YES;
                tAPIError = [[APIError alloc] initWithDict:responseData];
                
                // Tag Web Service Error On Localytics
                
                [[LocalyticsSession shared] tagEvent:kErrorSummary attributes:@{kError:tAPIError.mMessage}];
                
                //////////////////////////////////////
                
            }
        } else {
            //is something else
        }
        
        if ([tAPIError.mErrorCode integerValue] == 4104) {
            //HttpRequest *tHttpRequest = [mQueue.operations objectAtIndex:0];
            ////NSLog(@"-----RequestType:%d | mIsPost:%d", tHttpRequest.mRequestType, tHttpRequest.mIsPostRequest);
            // Re-loging -----

            [RequestHandler getInstance].mAuthKey = @"";
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            // getting an NSString
            NSString *savedUsername = [prefs stringForKey:kUsernameKey];
            NSString *savedPassword = [prefs stringForKey:kPasswordKey];
            
            //NSLog(@"Re-Login ID:%@ | Password:%@",savedUsername, savedPassword);
            
            SubscriberCredentials *tSubscriberCredentials = [[SubscriberCredentials alloc]init];
            [tSubscriberCredentials setMUserName:savedUsername];
            [tSubscriberCredentials setMPassword:savedPassword];

            [self postRequestwithHostURL:KURL_LoginRequestQuery bodyPost:[tSubscriberCredentials pToJSONString] delegate:self requestType:kReLoginRequest];

            return;
        }
        
        if (pStatusCode == 407) {
            
            [RequestHandler getInstance].mAuthKey = @"";
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            // getting an NSString
            NSString *savedUsername = [prefs stringForKey:kUsernameKey];
            NSString *savedPassword = [prefs stringForKey:kPasswordKey];
            
            //NSLog(@"Re-Login ID:%@ | Password:%@",savedUsername, savedPassword);
            
            SubscriberCredentials *tSubscriberCredentials = [[SubscriberCredentials alloc]init];
            [tSubscriberCredentials setMUserName:savedUsername];
            [tSubscriberCredentials setMPassword:savedPassword];
            
            [self postRequestwithHostURL:KURL_LoginRequestQuery bodyPost:[tSubscriberCredentials pToJSONString] delegate:self requestType:kReLoginRequest];
            return;
            
        }

        
        if (pStatusCode > 399 ) {
            tError = YES;
            if (!tAPIError) {
                tAPIError = [[APIError alloc] init];
                tAPIError.mErrorCode = [[NSNumber alloc] initWithInt: pStatusCode];
                tAPIError.mMessage = [NSHTTPURLResponse localizedStringForStatusCode:(NSInteger)pStatusCode];
            }
        }
        
        if (tError && (tAPIError.mMessage == nil || tAPIError.mMessage.length == 0)) {
            tAPIError.mMessage = @"Internal Error. Please try again later.";
        }

        if (!tError) {
            switch (pRequestType) {
                case kReLoginRequest:
                {
                    if (mIsPostRequest) {
                        HttpRequest *networkRequest = [[HttpRequest alloc] initPostRequestwithHostURL:mURL bodyPost:mPostBodyString requestType:mRequestType];
                        networkRequest.mIsPostRequest = YES;
                        networkRequest.mDelegate = self;
                        [mQueue addOperation:networkRequest];
                    }
                    else{
                        HttpRequest *networkRequest = [[HttpRequest alloc] initGetRequestWithURL:mURL requestType:mRequestType];
                        networkRequest.mIsPostRequest = NO;
                        networkRequest.mDelegate = self;
                        [mQueue addOperation:networkRequest];
                    }
                }
                    break;
                case kCouponGroupsRequest:{
                    NSEnumerator *enumerator = [responseData objectEnumerator];
                    id value;
                    
                    while ((value = [enumerator nextObject]))
                    {
                        
                        //Groups *tGroup = [NSEntityDescription
                        //                                  insertNewObjectForEntityForName:@"Groups"
                          //                                inManagedObjectContext:tContext];
                        //[tGroup groupsWithDict:value];
                        /*
                        tGroup.mID = [NSNumber numberWithInteger:[[value objectForKey:@"id"] intValue]];
                        tGroup.mName = [value objectForKey:@"name"];
                        //
                        //NSLog(@"tGroup.mID:%@ == %@",[value objectForKey:@"name"], tGroup.mName);
                        */
                        //[[Repository sharedRepository].context insertObject:tGroup];
                     
                        //NSError *error;
                        //[[Repository sharedRepository].context save:&error];
                        
                    }
                    
                }
                    break;
                case kCouponBrandRequest:{
                    
                    NSEnumerator *enumerator = [responseData objectEnumerator];
                    id value;
                    NSMutableArray *tBrandArray = [NSMutableArray new];
                    while ((value = [enumerator nextObject]))
                    {
                        Brands *tBrands = [[Brands alloc] initWithEntity:[NSEntityDescription entityForName:@"Brands" inManagedObjectContext:tContext] insertIntoManagedObjectContext:nil];
                        [tBrands brandsWithDict:value];
                        [tBrandArray addObject:tBrands];

                    }
                    
                    if ([tBrandArray count]) {
                        //NSLog(@"tBrandArray  :%d",[tBrandArray count]);
                        [[DataManager getInstance] setMBrandsArray:tBrandArray];
                    }
                    else{
                        [[DataManager getInstance].mBrandsArray removeAllObjects];

                    }
                }
                    
                    break;
                case kRedeemAllCouponRequest:{
                    
                    NSEnumerator *enumerator = [responseData objectEnumerator];
                    id value;
                    NSMutableArray *tRedeemCouponArray = [NSMutableArray new];
                    while ((value = [enumerator nextObject])) {
                        [tRedeemCouponArray addObject:value];
                    }
                    [[DataManager getInstance] setMRedeemCouponResponseArray:tRedeemCouponArray];
                }
                    
                    break;

                case kStoreQueryRequest:{
                    NSEnumerator *enumerator = [responseData objectEnumerator];
                    id value;
                    NSMutableArray *tStoresArray = [NSMutableArray new];
                    NSMutableArray *tLocationArray = [NSMutableArray new];
                    while ((value = [enumerator nextObject])) {
                        
                        Stores *tStores = [[Stores alloc] initWithEntity:[NSEntityDescription entityForName:@"Stores" inManagedObjectContext:tContext] insertIntoManagedObjectContext:nil];
                        [tStores storesWithDict:value];
                        [tStoresArray addObject:tStores];
                        
                        // StoreLocation
                        StoreLocations *tStoreLocations = [[StoreLocations alloc] initWithEntity:[NSEntityDescription entityForName:@"StoreLocations" inManagedObjectContext:tContext] insertIntoManagedObjectContext:nil];
                        [tStoreLocations storeLocationsWithDict:[value objectForKey:@"location"]];
                        [tLocationArray addObject:tStoreLocations];
                    }
                    [[DataManager getInstance] setMStoresArray:tStoresArray];
                    [[DataManager getInstance] setMStoresLocationArray:tLocationArray];
                        
                }
                    break;

                case kCouponQueryRequest:{
                    
                    NSEnumerator *enumerate = [responseData objectEnumerator];
                    id value;
                    //NSLog(@"%@",responseData);

                    while ((value = [enumerate nextObject])) {
                        [self saveCouponInDB:value downloaded:NO groupID:0];
                    }

                }
                    break;
                //Solr request
                case kNearMeCouponRequest:{
                    
                    NSMutableDictionary *response = [responseData objectForKey:@"response"];
                    NSMutableArray *tSolrCouponsDocs = [response objectForKey:@"docs"];
                    mIndex = 0;
                    
                    for (NSDictionary *tSolrCouponsDict in tSolrCouponsDocs) {
                        Coupon *tCoupon = [[Coupon alloc] initWithEntity:[NSEntityDescription entityForName:@"Coupon" inManagedObjectContext:tContext] insertIntoManagedObjectContext:nil];
                        [tCoupon solrCouponsWithDict:tSolrCouponsDict];
                        [self saveCouponInDB:tSolrCouponsDict downloaded:NO groupID:kNearMeGroup];
                        
                    }
                }
                    break;
                case kWhatsHotCouponRequest:{
                    
                    [[Repository sharedRepository] deleteAllUnMarkedCoupons];

                    NSMutableDictionary *response = [responseData objectForKey:@"response"];
                    NSMutableArray *tSolrCouponsDocs = [response objectForKey:@"docs"];
                    
                    mIndex = 0;
                    for (NSDictionary *tSolrCouponsDict in tSolrCouponsDocs) {
                        Coupon *tCoupon = [[Coupon alloc] initWithEntity:[NSEntityDescription entityForName:@"Coupon" inManagedObjectContext:tContext] insertIntoManagedObjectContext:nil];
                        [tCoupon solrCouponsWithDict:tSolrCouponsDict];
                        [self saveCouponInDB:tSolrCouponsDict downloaded:NO groupID:kWhatsHotGroup];
                        
                    }
                }
                    break;
                case kTodaysDealCouponRequest:{
                    NSMutableDictionary *response = [responseData objectForKey:@"response"];
                    NSMutableArray *tSolrCouponsDocs = [response objectForKey:@"docs"];
                    
                    mIndex = 0;
                    for (NSDictionary *tSolrCouponsDict in tSolrCouponsDocs) {
                        Coupon *tCoupon = [[Coupon alloc] initWithEntity:[NSEntityDescription entityForName:@"Coupon" inManagedObjectContext:tContext] insertIntoManagedObjectContext:nil];
                        [tCoupon solrCouponsWithDict:tSolrCouponsDict];
                        [self saveCouponInDB:tSolrCouponsDict downloaded:NO groupID:kBestDealGroup];
                        
                    }
                }
                    break;
                case kMostPopularCouponRequest:{
                    NSMutableDictionary *response = [responseData objectForKey:@"response"];
                    NSMutableArray *tSolrCouponsDocs = [response objectForKey:@"docs"];
                    
                    mIndex = 0;
                    for (NSDictionary *tSolrCouponsDict in tSolrCouponsDocs) {
                        Coupon *tCoupon = [[Coupon alloc] initWithEntity:[NSEntityDescription entityForName:@"Coupon" inManagedObjectContext:tContext] insertIntoManagedObjectContext:nil];
                        [tCoupon solrCouponsWithDict:tSolrCouponsDict];
                        [self saveCouponInDB:tSolrCouponsDict downloaded:NO groupID:kMostPopularGroup];
                        
                    }
                }
                    break;
                case kRecommendeCouponRequest:{
                    NSMutableDictionary *response = [responseData objectForKey:@"response"];
                    NSMutableArray *tSolrCouponsDocs = [response objectForKey:@"docs"];
                    
                    mIndex = 0;
                    for (NSDictionary *tSolrCouponsDict in tSolrCouponsDocs) {
                        Coupon *tCoupon = [[Coupon alloc] initWithEntity:[NSEntityDescription entityForName:@"Coupon" inManagedObjectContext:tContext] insertIntoManagedObjectContext:nil];
                        [tCoupon solrCouponsWithDict:tSolrCouponsDict];
                        [self saveCouponInDB:tSolrCouponsDict downloaded:NO groupID:kRemmendedGroup];
                        
                    }
                }
                    break;

                case kCategoriesRequest:{
                    
                    NSEnumerator *enumerator = [responseData objectEnumerator];
                    id value;
                    
                    while ((value = [enumerator nextObject]))
                    {
                        
                        Category *tCategories = [NSEntityDescription
                                           insertNewObjectForEntityForName:@"Categories"
                                           inManagedObjectContext:tContext];
                        [tCategories categoryWithDict:value];
                        
                        [[Repository sharedRepository].context insertObject:tCategories];
                        
                        NSError *error;
                        [[Repository sharedRepository].context save:&error];
                        
                    }

                    
                }
                    break;
                case kCouponQueryStorePostRequest:{
                    NSEnumerator *enumerate = [responseData objectEnumerator];
                    id value;
                    
                    
                    NSMutableArray *tStoreCouponArray = [[NSMutableArray alloc] init];

                    while ((value = [enumerate nextObject])) {
                        
                        Coupon *tCoupon = [[Coupon alloc] initWithEntity:[NSEntityDescription entityForName:@"Coupon" inManagedObjectContext:tContext] insertIntoManagedObjectContext:nil];
                        [tCoupon couponsWithDict:value];
                        [tStoreCouponArray addObject:tCoupon];
                    }
                    
                    if ([tStoreCouponArray count]) {
                        [[DataManager getInstance] setMStoreCheckInCouponArray:tStoreCouponArray];
                    } else {
                        [[DataManager getInstance].mStoreCheckInCouponArray removeAllObjects];
                    }
                }
                    break;
                case kCouponQueryBrandPostRequest:{
                    NSEnumerator *enumerate = [responseData objectEnumerator];
                    id value;
                    
                    
                    NSMutableArray *tBrandCouponArray = [[NSMutableArray alloc] init];
                    
                    while ((value = [enumerate nextObject])) {
                        //NSLog(@"BrandCoupon ..%@",value);
                        
                        Coupon *tCoupon = [[Coupon alloc] initWithEntity:[NSEntityDescription entityForName:@"Coupon" inManagedObjectContext:tContext] insertIntoManagedObjectContext:nil];
                        [tCoupon couponsWithDict:value];
                        [tBrandCouponArray addObject:tCoupon];
                    }
                    
                    if ([tBrandCouponArray count]) {
                        [[DataManager getInstance] setMBrandCheckInCouponArray:tBrandCouponArray];
                    } else {
                        [[DataManager getInstance].mBrandCheckInCouponArray removeAllObjects];
                    }
                }
                    break;
                case kKeyWordCouponPostRequest:{
                    NSEnumerator *enumerate = [responseData objectEnumerator];
                    id value;
                    
                    
                    NSMutableArray *tKeyWordCouponArray = [[NSMutableArray alloc] init];
                    
                    while ((value = [enumerate nextObject])) {
                        
                        Coupon *tCoupon = [[Coupon alloc] initWithEntity:[NSEntityDescription entityForName:@"Coupon" inManagedObjectContext:tContext] insertIntoManagedObjectContext:nil];
                        [tCoupon couponsWithDict:value];
                        [tKeyWordCouponArray addObject:tCoupon];
                    }
                    
                    if ([tKeyWordCouponArray count]) {
                        [[DataManager getInstance] setMKeywordCouponArray:tKeyWordCouponArray];
                    } else {
                        [[DataManager getInstance].mKeywordCouponArray removeAllObjects];
                    }
                }
                    break;
                case kGlobalSettingRequest:{
                    NSEnumerator *enumerator = [responseData objectEnumerator];
                    id value;
                    
                    while ((value = [enumerator nextObject]))
                    {
                        [[NSUserDefaults standardUserDefaults] setObject:[value objectForKey:@"value"] forKey:[value objectForKey:@"name"]];
                    }

                }
                    
                    break;
                case kCreateSubscriberPostRequest:{
                    if (jsonString != nil && [jsonString length] >0 ){
                        NSString *tSubscriberJSON = [[NSUserDefaults standardUserDefaults] objectForKey:@"subscriber"];
                        NSMutableDictionary* tSubscriberDictionary = (NSMutableDictionary*)[mJsonParser objectWithString:tSubscriberJSON error:nil];
                        
                        Subscriber *tSubscriber = [[Subscriber alloc] init];
                        [tSubscriber subscriberWithDict:tSubscriberDictionary];
                        //NSCharacterSet* tQuote = [NSCharacterSet characterSetWithCharactersInString:@"\""];
                        [tSubscriber setMId: jsonString];
                        
                        //NSLog(@"%@",tSubscriber.mId);
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[tSubscriber pToJSONString] forKey:@"subscriber"];
                        
                    }
                }
                    break;
                case kLoginRequest:{
                    
                    
                }
                    break;
                case kGiftCardsPostRequest:{
                    NSEnumerator *enumerator = [responseData objectEnumerator];
                    id value;
                    
                    NSMutableArray *tGiftCardArray = [NSMutableArray new];
                    while ((value = [enumerator nextObject]))
                    {
                        //GiftCards *tGiftCard = [NSEntityDescription insertNewObjectForEntityForName:@"GiftCards" inManagedObjectContext:tContext];
                        GiftCards *tGiftCard = [[GiftCards alloc] initWithEntity:[NSEntityDescription entityForName:@"GiftCards" inManagedObjectContext:tContext] insertIntoManagedObjectContext:nil];


                        [tGiftCard giftCardWithDict:value];
                        [tGiftCardArray addObject:tGiftCard];
                    }
                    
                    if ([tGiftCardArray count] > 0) {
                        [[DataManager getInstance] setMGiftCardsArray:tGiftCardArray];
                    } else {
                        [[DataManager getInstance].mGiftCardsArray removeAllObjects];

                    }
                    
                }
                    break;
                case kSubscriberByNameRequest:{
                    NSDictionary *tRewardDict = [responseData objectForKey:@"rewardCard"];
                    Subscriber *tSubscriber = [[Subscriber alloc] init];
                    [tSubscriber subscriberWithDict:responseData];
                    //NSLog(@"------tRewardDict:%@", [tSubscriber pToJSONString]);
                    [[NSUserDefaults standardUserDefaults] setObject:[tRewardDict JSONRepresentation] forKey:kRewardCardKey];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[tSubscriber pToJSONString] forKey:@"subscriber"];
                    NSString *subscriberJSON = [[NSUserDefaults standardUserDefaults] objectForKey:@"subscriber"];
                    NSDictionary *dictionary = [subscriberJSON JSONValue];
                    [tSubscriber subscriberWithDict:dictionary];
                    NSMutableArray *mTotalCouponArray = [NSMutableArray new];
                    for (int i=0; i<[tSubscriber.mCouponPreferencesArray count]; i++) {
                        [mTotalCouponArray addObject:[[tSubscriber.mCouponPreferencesArray objectAtIndex:i] valueForKey:@"categoryId"]];
                    }
                    [[NSUserDefaults standardUserDefaults] setObject:mTotalCouponArray forKey:@"CouponPrefences"];


                }
                    break;
                case kRedeemCouponRequest:{
                
                }
                    break;
                case kRedeemGiftCardRequest:{
                    
                    NSEnumerator *enumerator = [responseData objectEnumerator];
                    id value;
                    
                    while ((value = [enumerator nextObject]))
                    {
                        //NSLog(@"GiftCards ----------- ");

                        GiftCards *tGiftCard = [NSEntityDescription insertNewObjectForEntityForName:@"GiftCards" inManagedObjectContext:tContext];
                        [tGiftCard giftCardWithDict:value];
                        [[Repository sharedRepository].context insertObject:tGiftCard];
                        
                        NSError *error;
                        [[Repository sharedRepository].context save:&error];
                        ////NSLog(@"error:%@", error);

                    }
                }
                    break;
                case kAPNSRedeemGiftCardRequest:{
                    
                        //NSLog(@"ANPS_GiftCards ----------- ");
                    
                    GiftCards *tGiftCard = [NSEntityDescription insertNewObjectForEntityForName:@"GiftCards" inManagedObjectContext:tContext];
                    [tGiftCard giftCardWithDict:responseData];
                    [[Repository sharedRepository].context insertObject:tGiftCard];
                    
                    NSError *error;
                    [[Repository sharedRepository].context save:&error];
                    
                }
                    break;
                    
                case kAdvertsRequest:{
                    NSEnumerator *enumerator = [responseData objectEnumerator];
                    id value;
                    NSMutableArray *tADArray = [NSMutableArray new];

                    while ((value = [enumerator nextObject]))
                    {
                        Advertisement *tAdvertisement = [[Advertisement alloc] initWithDict:value];
                        [tADArray addObject:tAdvertisement];
                    }
                    
                    if ([tADArray count] > 0) {
                        //NSLog(@"\n-------Advertisement:%d", [tADArray count]);
                        [[DataManager getInstance] setMAdvertsArray:tADArray];
                    }
                }
                    break;
                case kAdClickRequest:{
                    
                }
                    break;
                case kCouponDetailRequest:{
                    NSEnumerator *enumerate = [responseData objectEnumerator];
                    id value;
                    
                    while ((value = [enumerate nextObject])) {
                        
                        Coupon *tCoupon = [[Coupon alloc] initWithEntity:[NSEntityDescription entityForName:@"Coupon" inManagedObjectContext:tContext] insertIntoManagedObjectContext:nil];
                        [tCoupon couponsWithDict:value];
                        [DataManager getInstance].mObjCouponDetail = tCoupon;
                    }
                    
                }
                    break;
                case kCouponDownload:{

                    NSEnumerator *enumerate = [responseData objectEnumerator];
                    id value;
                    
                    while ((value = [enumerate nextObject])) {
                        MyCoupons *tMyCoupons = [NSEntityDescription insertNewObjectForEntityForName:@"MyCoupons" inManagedObjectContext:tContext];
                        [tMyCoupons couponsWithDict:value];
                        tMyCoupons.mDownloaded = [NSNumber numberWithBool:YES];
                        tMyCoupons.mCouponExpireDate = [[DataManager getInstance] myCouponExpireDate:[tMyCoupons.mValidity intValue]];
                        [self saveMyCoupon:value];

                        [[Repository sharedRepository].context insertObject:tMyCoupons];
                        NSError *error;
                        [[Repository sharedRepository].context save:&error];

                    }
                }
                    break;
                case kCouponDownloadToTag:{
                    
                    NSEnumerator *enumerate = [responseData objectEnumerator];
                    id value;
                    //NSLog(@"...: %@",value);
                    while ((value = [enumerate nextObject])) {
                        MyCoupons *tMyCoupons = [NSEntityDescription insertNewObjectForEntityForName:@"MyCoupons" inManagedObjectContext:tContext];
                        [tMyCoupons couponsWithDict:value];
                        tMyCoupons.mDownloaded = [NSNumber numberWithBool:YES];
                        tMyCoupons.mCouponExpireDate = [[DataManager getInstance] myCouponExpireDate:[tMyCoupons.mValidity intValue]];
                        [self saveMyCoupon:value];

                        [DataManager getInstance].mObjCouponAddToTagDetail = tMyCoupons;


                    }
                }
                    break;
                
                case kSolrStoreMapRequest: // default fall through
                case kSolrStoreRequest:{
                    NSMutableDictionary *response = [responseData objectForKey:@"response"];
                    ////NSLog(@"RESPONSE DATA______:%@",Rewardlist);
                    NSMutableArray *storeList = [response objectForKey:@"docs"];
                    NSMutableArray *tStoresArray = [NSMutableArray new];
                    NSMutableArray *tLocationArray = [NSMutableArray new];

                    for (NSDictionary *tSolrStoreDict in storeList ) {
                        Stores *tStores = [[Stores alloc] initWithEntity:[NSEntityDescription entityForName:@"Stores" inManagedObjectContext:tContext] insertIntoManagedObjectContext:nil];
                        
                        [tStores storesWithSolrDict:tSolrStoreDict];
                        [tStoresArray addObject:tStores];
                        
                        // StoreLocation
                        StoreLocations *tStoreLocations = [[StoreLocations alloc] initWithEntity:[NSEntityDescription entityForName:@"StoreLocations" inManagedObjectContext:tContext] insertIntoManagedObjectContext:nil];
                        
                        [tStoreLocations storeLocationsWithSolrDict:tSolrStoreDict];
                        [tLocationArray addObject:tStoreLocations];
                    }
                    [[DataManager getInstance] setMStoresArray:tStoresArray];
                    [[DataManager getInstance] setMStoresLocationArray:tLocationArray];

                }
                    break;
                case kLogoutRequest:{
                    
                }
                    break;
                    case kShareCouponURLRequest:
                {
                    NSString *tCouponShareURL = [responseData objectForKey:@"text"];
                    [DataManager getInstance].mCouponShareURL = tCouponShareURL;
                    //NSLog(@"-------%@--------kShareCouponURLRequest",tCouponShareURL);
                }
                    break;
                case kStoreSearchRequest:
                {
                }
                    break;
                case kBrandSearchRequest:
                {
                }
                    break;
                case kCouponPlanRequest:
                {
                }
                    break;
                case kAddStorePreferencesRequest:{
                    
                        
                    StorePreferences *tStorePreference = [[StorePreferences alloc] initWithEntity:[NSEntityDescription entityForName:@"StorePreferences" inManagedObjectContext:tContext] insertIntoManagedObjectContext:nil];
                    [tStorePreference storePreferencesWithDict:responseData];
                    [DataManager getInstance].mObjStorePreferences = tStorePreference;
                    
                }
                    break;
                    //TO Do Update The Row
                case kEditStorePreferencesRequest: {
                    
                    StorePreferences *tStorePreference = [[StorePreferences alloc] initWithEntity:[NSEntityDescription entityForName:@"StorePreferences" inManagedObjectContext:tContext] insertIntoManagedObjectContext:nil];
                    [tStorePreference storePreferencesWithDict:responseData];
                    [DataManager getInstance].mObjStorePreferences = tStorePreference;


                }
                    break;
                    
                case kGetAllStorePreferenceRequest: {
                    
                    NSError * error = nil;
                    NSArray * tStorePreferencesArray = [[Repository sharedRepository] fetchAllStoresPreference:nil];
                    
                    for (NSManagedObject * tPreferenceList in tStorePreferencesArray) {
                        [tContext deleteObject:tPreferenceList];
                    }
                    NSError *saveError = nil;
                    [tContext save:&saveError];
                    NSEnumerator *enumerate = [responseData objectEnumerator];
                    id value;
                    while ((value = [enumerate nextObject])) {

                        StorePreferences *tStorePreferences = [NSEntityDescription
                                                               insertNewObjectForEntityForName:@"StorePreferences"
                                                               inManagedObjectContext:tContext];
                        [tStorePreferences storePreferencesWithDict:value];
                        [[Repository sharedRepository].context insertObject:tStorePreferences];
                        
                        [[Repository sharedRepository].context save:&error];
                        
                    }
                }
                    break;
                     

                default:
                    break;
            }
        }
       
        if (pRequestType != kReLoginRequest) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [tDelegate requestHandler:self withRequestType:pRequestType error:tAPIError];
            });
        }
        [mDelegateDictionary removeObjectForKey:tKeyString];
      
    }
}

- (void) saveCouponInDB:(NSDictionary *)pDict downloaded:(BOOL)pBool groupID:(NSInteger)pGroupID
{

    //NSLog(@"pDictionary :%@",pDict);
    NSError *error;
    NSManagedObjectContext *tContext = [Repository sharedRepository].context;
    
    NSManagedObject *tCouponGroup = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"CouponGroups"
                                     inManagedObjectContext:tContext];
    
    [tCouponGroup setValue:[NSNumber numberWithInteger:pGroupID] forKey:@"mGroupID"];
    [tCouponGroup setValue:[NSNumber numberWithInteger:[[pDict objectForKey:@"id"] intValue]] forKey:@"mCouponID"];
    [tCouponGroup setValue:[NSNumber numberWithInteger:mIndex] forKey:@"mIndex"];
    mIndex++;
    
    Coupon *tCoupon = [[Coupon alloc] initWithEntity:[NSEntityDescription entityForName:@"Coupon" inManagedObjectContext:tContext] insertIntoManagedObjectContext:nil];
    [tCoupon solrCouponsWithDict:pDict];
    tCoupon.mDownloaded = [NSNumber numberWithBool:pBool];
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Coupon"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"mID == %@",tCoupon.mID]];
    NSUInteger count = [tContext countForFetchRequest:fetchRequest error:&error];
    
    if (count == 0){
        [[Repository sharedRepository].context insertObject:tCoupon];
    }
    
    // Categories
    for (NSString *tCategoryIds in [pDict objectForKey:@"category_ids"]) {
        //  //NSLog(@"tCategoryIds:%@", tCategoryIds);
        
        NSManagedObject *tCategory = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"CouponCategories"
                                      inManagedObjectContext:tContext];
        
        [tCategory setValue:[NSNumber numberWithInteger:[tCategoryIds intValue]] forKey:@"mCategoryID"];
        [tCategory setValue:[NSNumber numberWithInteger:[[pDict objectForKey:@"id"] intValue]] forKey:@"mCouponID"];
        
        // [[Repository sharedRepository].context insertObject:tCategory];
        //[[Repository sharedRepository].context save:&error];
    }
    
    [[Repository sharedRepository].context save:&error];

    
 }

- (void) saveMyCoupon:(NSDictionary *)pDict {
    NSManagedObjectContext *tContext = [Repository sharedRepository].context;

    for (NSString *tCategoryIds in [pDict objectForKey:@"categoryIds"]) {
        
        NSManagedObject *tCategory = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"MyCouponCategories"
                                      inManagedObjectContext:tContext];
        
        [tCategory setValue:[NSNumber numberWithInteger:[tCategoryIds intValue]] forKey:@"mCategoryID"];
        [tCategory setValue:[NSNumber numberWithInteger:[[pDict objectForKey:@"id"] intValue]] forKey:@"mCouponID"];
        
    }
    
}

#pragma mark -
#pragma mark InternetCheckMethods
- (BOOL) checkInternet {
	
	return YES;
}


@end
