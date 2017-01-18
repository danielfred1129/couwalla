//
//  CoupitService.h
//  Coupit
//
//  Created by Canopus 4 on 20/05/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "IQWebService.h"

@interface CoupitService : IQWebService

#pragma mark -
#pragma mark - User

//{"loginid":"example@domain.com", "password":"0000"}
-(void)loginUser                    :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//{“email”:”jrappaport@gold-mobile.com”, “password”:”0000”}
-(void)signupUser                   :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//{"name":"Example","loginid":"example@domain.com","fb_id":"12345798413"}
-(void)fbLoginUser                  :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//{"userid":"1","oldPassword":"1234","newPassword":"0000"}
-(void)changePassword               :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//{"username":"example@domain.com"}
-(void)forgotPassword               :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//{"userid":"1"}
-(void)myProfile                    :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//{"First Name":"Example","Last Name":"Example","Email":"example@domain.com","Sex":"male","DOB":"1992-05-15","Ethnicity":"none","State":"mah","Zip":"123456","No. of Childern":"5","Have Pets":"yes","Yearly Income":"500000","Marital Status":"Married"}
-(void)updateProfile                :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;


/*-----------------------------------*/
#pragma mark -
#pragma mark - Coupons

//{"userid":"1"}
-(void)myCoupons                    :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//{"userid":"1","couponid":"2"}
-(void)addToMyCoupons               :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//{"userid":"1","couponid":"2"}
-(void)removeFromMyCoupon           :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//{"userid":"1","couponid":"2"}
-(void)redeemCoupon                 :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//{"search_text":"levis"}
-(void)searchManufacturerCoupons    :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//{"retailer_id":"3"}
-(void)retailerCoupons              :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//{"category_id":"4"}
-(void)categoryCoupons              :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//{"categoryid":"4","userid":"1"}
-(void)homepageCoupons              :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//{"userid":"1"}
-(void)nearbyCoupons                :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//{"zip":"123456"}
-(void)twentyCoupons                :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;


/*-----------------------------------*/
#pragma mark -
#pragma mark - Planner

//{"userid":"1"}
-(void)plannerList                  :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//{"userid":"1","couponid":"2"}
-(void)addToPlanner                 :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//{"userid":"1","couponid":"2"}
-(void)removeFromPlanner            :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;


/*-----------------------------------*/
#pragma mark -
#pragma mark - Gift Cards

//{"user_id":"1"}
-(void)giftCards                    :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//{"user_id":"1","giftcard_id":"5"}
-(void)redeemGiftCard               :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;


/*-----------------------------------*/
#pragma mark -
#pragma mark - Store

//{}
-(void)storesWithCompletionHandler:(IQDictionaryCompletionBlock)completionHandler;

//{"qrtext":"LevisStore402320232"}
-(void)storeQRCheckIn               :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//{"userid":"1"}
-(void)myStores                     :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//{"userid":"1","storeid":"6"}
-(void)addToMyStore                 :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;


/*-----------------------------------*/
#pragma mark -
#pragma mark - Retailer-Manufacturer

//{}
-(void)retailersWithCompletionHandler           :(IQDictionaryCompletionBlock)completionHandler;

//{}
-(void)manufacturesWithCompletionHandler        :(IQDictionaryCompletionBlock)completionHandler;

//{"userid":"1"}
-(void)nearbyRetailerManufacturer   :(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;


/*-----------------------------------*/
#pragma mark -
#pragma mark - Categories

//{}
-(void)categoriesWithCompletionHandler          :(IQDictionaryCompletionBlock)completionHandler;


/*-----------------------------------*/
#pragma mark -
#pragma mark - Other

//{}
-(void)advertisementsWithCompletionHandler      :(IQDictionaryCompletionBlock)completionHandler;

//{}
-(void)termsAndConditionsWithCompletionHandler  :(IQDictionaryCompletionBlock)completionHandler;

//{}
-(void)privacyPolicyWithCompletionHandler       :(IQDictionaryCompletionBlock)completionHandler;



-(void)nearbyStoreWithCompletionHandler:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;

-(void)nearbyBrandWithCompletionHandler:(NSDictionary*)userAttribute completionHandler:(IQDictionaryCompletionBlock)completionHandler;


@end
