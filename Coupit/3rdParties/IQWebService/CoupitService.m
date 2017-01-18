//
//  CoupitService.m
//  Coupit
//
//  Created by Canopus 4 on 20/05/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "CoupitService.h"
#import "appcommon.h"

@implementation CoupitService

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setLogEnabled:YES];
        [self setParameterType:IQRequestParameterTypeJSON];
        [self setServerURL:BASE_URL];
        
        NSLog(@"%@",BASE_URL);
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        
        [self setDefaultContentType:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary]];
        
        NSMutableData *startData = [[NSMutableData alloc] init];
        [startData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [startData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [startData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"data\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [self setStartBodyData:startData];
        
        NSMutableData *endData = [[NSMutableData alloc] init];
        [endData appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [self setEndBodyData:endData];
    }
    return self;
}

-(void)loginUser:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/signin.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)signupUser:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/signup.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)fbLoginUser:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/fb_login.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)changePassword:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/change_password.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)addToMyCoupons:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/addtomycoupons.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)plannerList:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/get_plannerslist.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)myCoupons:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/mycoupons.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)addToPlanner:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/add_to_planner.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)removeFromMyCoupon:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/remove_from_mycoupon.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)redeemCoupon:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/redeem_coupon.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)removeFromPlanner:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/remove_from_planner.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)myProfile:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/get_myprofile_data.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)updateProfile:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/update_profile.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)storeQRCheckIn:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/store_qr_checkin.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)myStores:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/get_mystores.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)giftCards:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/get_gift_cards.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)redeemGiftCard:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/redeem_gift_card.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)searchManufacturerCoupons:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/search_manufacturer_coupons?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)retailerCoupons:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/get_retailer_coupons.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)categoryCoupons:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/get_category_coupons.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)addToMyStore:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/add_to_my_stores.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)nearbyRetailerManufacturer:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/get_nearby_retailer_manufacturer.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)forgotPassword:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/forgotpassword.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)homepageCoupons:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/get_homepage_coupons.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)nearbyCoupons:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/get_nearby_coupons.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}

-(void)twentyCoupons:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/get_20coupons.php?" httpMethod:kIQHTTPMethodPOST parameter:userAttribute completionHandler:completionHandler];
}


//GET

-(void)storesWithCompletionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/get_stores.php?" httpMethod:kIQHTTPMethodGET parameter:nil completionHandler:completionHandler];
}

-(void)nearbyStoreWithCompletionHandler:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/get_nearby_stores.php?" httpMethod:kIQHTTPMethodGET parameter:userAttribute completionHandler:completionHandler];
}

-(void)nearbyBrandWithCompletionHandler:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/get_nearby_brands.php?" httpMethod:kIQHTTPMethodGET parameter:userAttribute completionHandler:completionHandler];
}

-(void)categoriesWithCompletionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/get_categories.php?" httpMethod:kIQHTTPMethodGET parameter:nil completionHandler:completionHandler];
}

-(void)advertisementsWithCompletionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/get_advertisements.php?" httpMethod:kIQHTTPMethodGET parameter:nil completionHandler:completionHandler];
}

-(void)manufacturesWithCompletionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/get_manufactures.php?" httpMethod:kIQHTTPMethodGET parameter:nil completionHandler:completionHandler];
}

-(void)retailersWithCompletionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/get_retailers.php?" httpMethod:kIQHTTPMethodGET parameter:nil completionHandler:completionHandler];
}

-(void)termsAndConditionsWithCompletionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/get_terms_conditions.php?" httpMethod:kIQHTTPMethodGET parameter:nil completionHandler:completionHandler];
}

-(void)privacyPolicyWithCompletionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:@"/privacy_policy/privacy_policy.html?" httpMethod:kIQHTTPMethodGET parameter:nil completionHandler:completionHandler];
}


@end
