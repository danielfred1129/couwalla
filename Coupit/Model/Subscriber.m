//
//  Subscriber.m
//  Coupit
//
//  Created by Vikas_headspire on 15/03/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "Subscriber.h"

@implementation Subscriber
{
    NSMutableDictionary *mSubscriberDict;
}
@synthesize  mId ,mFirstName,mLastName, mEmail, mPhone, mAddressLine, mZip, mCity, mState, mCountry, mProfile, mCredentials, mCouponPrefrences, mCouponPreferencesArray   ;

- (NSDictionary *) pToDictionary
{

    mSubscriberDict = [[NSMutableDictionary alloc] init];
    
    if (mId != NULL) {
        [mSubscriberDict setObject:mId forKey:@"id"];
    }

     if (mFirstName != NULL) {
        [mSubscriberDict setObject:mFirstName forKey:@"firstName"];
    }
    if (mLastName != NULL) {
        [mSubscriberDict setObject:mLastName forKey:@"lastName"];
    }
    if (mEmail != NULL) {
        [mSubscriberDict setObject:mEmail forKey:@"email"];
    }
        
     if (mPhone != NULL) {
        [mSubscriberDict setObject:mPhone forKey:@"phone"];
    }
    
     if (mAddressLine != NULL) {
        [mSubscriberDict setObject:mAddressLine forKey:@"addressLine"];
    }
        
     if (mZip != NULL) {
        [mSubscriberDict setObject:mZip forKey:@"zip"];
    }
    
     if (mCity != NULL) {
        [mSubscriberDict setObject:mCity forKey:@"city"];
    }
    
     if (mState != NULL) {
        [mSubscriberDict setObject:mState forKey:@"state"];
    }
    
     if (mCountry != NULL) {
        [mSubscriberDict setObject:mCountry forKey:@"country"];
    }
    
    if (mCredentials != NULL) {
        [mSubscriberDict setObject:[mCredentials pToDictionary] forKey:@"credentials"];
    }
    
     if (mProfile != NULL) {
        [mSubscriberDict setObject:[mProfile pToDictionary] forKey:@"profile"];
    }
    if (mCouponPrefrences != NULL) {
        [mSubscriberDict setObject:[mCouponPrefrences addCouponPrefrences] forKey:@"couponPreferences"];
    }
    if (mCouponPreferencesArray != NULL) {
        [mSubscriberDict setObject:mCouponPreferencesArray forKey:@"couponPreferences"];
    }

    

    return mSubscriberDict;
}


- (NSString* ) pToJSONString
{
    return [[self pToDictionary] JSONRepresentation];
}

- (void) subscriberWithDict:(NSDictionary *)pDict
{
    self.mId           = [pDict objectForKey:@"id"];
    self.mFirstName    = [pDict objectForKey:@"firstName"];
    self.mLastName     = [pDict objectForKey:@"lastName"];
    self.mEmail        = [pDict objectForKey:@"email"];
    self.mPhone        = [pDict objectForKey:@"phone"];
    self.mAddressLine  = [pDict objectForKey:@"addressLine"];
    self.mZip          = [pDict objectForKey:@"zip"];
    self.mCity         = [pDict objectForKey:@"city"];
    self.mState        = [pDict objectForKey:@"state"];
    self.mCountry      = [pDict objectForKey:@"country"];
    self.mCouponPreferencesArray = [pDict objectForKey:@"couponPreferences"];

    SubscriberProfile* profile = [[SubscriberProfile alloc] init];
    [profile profileWithDict: [pDict objectForKey:@"profile"]];
    self.mProfile = profile;
    
    SubscriberCredentials* credentials = [[SubscriberCredentials alloc] init];
    [credentials credentialWithDict: [pDict objectForKey:@"credentials"]];
    self.mCredentials = credentials;
    
    
}


@end
