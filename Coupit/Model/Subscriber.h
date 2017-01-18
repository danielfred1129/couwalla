//
//  Subscriber.h
//  Coupit
//
//  Created by Vikas_headspire on 15/03/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubscriberCredentials.h"
#import "SubscriberProfile.h"
#import "tJSON.h"
#import "CouponPrefrences.h"
@interface Subscriber : NSObject

@property (nonatomic, retain) NSString *mId;
@property (nonatomic, retain) NSString *mFirstName;
@property (nonatomic, retain) NSString *mLastName;
@property (nonatomic, retain) NSString *mEmail;
@property (nonatomic, retain) NSString *mPhone;
@property (nonatomic, retain) NSString *mAddressLine;
@property (nonatomic, retain) NSString *mZip;
@property (nonatomic, retain) NSString *mCity;
@property (nonatomic, retain) NSString *mState;
@property (nonatomic, retain) NSString *mCountry;
@property (nonatomic, retain) NSMutableArray *mCouponPreferencesArray;
@property (nonatomic, retain) SubscriberProfile *mProfile;
@property (nonatomic, retain) SubscriberCredentials *mCredentials;
@property (nonatomic, retain) CouponPrefrences *mCouponPrefrences;

//@property (nonatomic, retain) NSString *mName;


- (NSDictionary *) pToDictionary;
- (NSString* ) pToJSONString;

- (void) subscriberWithDict:(NSDictionary *)pDict;



@end
