//
//  SubscriberProfile.h
//  Coupit
//
//  Created by Vikas_headspire on 15/03/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "tJSON.h"

@interface SubscriberProfile : NSObject

//@property (nonatomic, retain) NSNumber *mAge;
@property (nonatomic, retain) NSString *mDOB;
@property (nonatomic, retain) NSNumber *mSex;
@property (nonatomic, retain) NSNumber *mFamilyNumbers;
@property (nonatomic, retain) NSString *mChildren;
@property (nonatomic, retain) NSNumber *mPets;
@property (nonatomic, retain) NSString *mHouseHoldIncome;
@property (nonatomic, retain) NSString *mMaritalStatus;
@property (nonatomic, retain) NSString *mEthnicity;



- (NSDictionary*) pToDictionary;
- (NSString*) pToJSONString;

- (void) profileWithDict:(NSDictionary *)pDict;
//- (id)initWithDict:(NSDictionary *)pDict;

@end
