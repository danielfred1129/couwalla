//
//  SubscriberProfile.m
//  Coupit
//
//  Created by Vikas_headspire on 15/03/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "SubscriberProfile.h"

@implementation SubscriberProfile
{
     NSMutableDictionary *mSubscriberProfileDict;
}
@synthesize mChildren, mFamilyNumbers, mHouseHoldIncome, mPets, mSex, mDOB, mEthnicity, mMaritalStatus;


- (NSDictionary*) pToDictionary
{
    
    //NSMutableArray *tKeys =    [NSArray arrayWithObjects:@"age", @"sex", @"familyMembers", @"children", @"pets", @"householdIncome", nil];
    //NSMutableArray *tObjects = [NSArray arrayWithObjects:mAge,   mSex,   mFamilyNumbers,   mChldren,    mPets,   mHouseHoldIncome,   nil];
    
    
     //NSDictionary *tSubscriberProfileDict = [NSDictionary dictionaryWithObjects:tObjects forKeys:tKeys];

    mSubscriberProfileDict = [[NSMutableDictionary alloc] init];
    
    if (mDOB != NULL) {
        [mSubscriberProfileDict setObject:mDOB forKey:@"dob"];
    }
    
     if (mSex != NULL) {
        [mSubscriberProfileDict setObject:mSex forKey:@"sex"];
    }
    
     if (mFamilyNumbers != NULL) {
        [mSubscriberProfileDict setObject:mFamilyNumbers forKey:@"familyMembers"];
    }
    

     if (mChildren != NULL) {
        [mSubscriberProfileDict setObject:mChildren forKey:@"children"];
    }
    
     if (mPets != NULL) {
        [mSubscriberProfileDict setObject:mPets forKey:@"pets"];
    }
   
     if (mHouseHoldIncome != NULL) {
        [mSubscriberProfileDict setObject:mHouseHoldIncome forKey:@"householdIncome"];
    }
    if (mMaritalStatus != NULL) {
        [mSubscriberProfileDict setObject:mMaritalStatus forKey:@"maritalStatus"];
    }
    if (mEthnicity != NULL) {
        [mSubscriberProfileDict setObject:mEthnicity forKey:@"ethinicity"];
    }

   
        return mSubscriberProfileDict;

}

- (NSString*) pToJSONString
{
    return [[self pToDictionary] JSONRepresentation];
}


- (void) profileWithDict:(NSDictionary *)pDict
{
    self.mDOB          = [pDict objectForKey:@"dob"];
    self.mSex          = [NSNumber numberWithInteger:[[pDict objectForKey:@"sex"] intValue]];
    self.mFamilyNumbers= [NSNumber numberWithInteger:[[pDict objectForKey:@"familyMembers"] intValue]];
    self.mChildren     = [pDict objectForKey:@"children"];
    self.mPets         = [NSNumber numberWithInteger:[[pDict objectForKey:@"pets"] intValue]];
    self.mHouseHoldIncome =  [pDict objectForKey:@"householdIncome"];
    self.mMaritalStatus =[pDict objectForKey:@"maritalStatus"];
    self.mEthnicity    = [pDict objectForKey:@"ethinicity"];

    

}

/*
- (id)initWithDict:(NSDictionary *)pDict
{
    self = [super init];
    
    if (self)
    {
        self.mAge  = [pDict objectForKey:@"age"];
        self.mSex  =  [pDict objectForKey:@"sex"];
        self.mFamilyNumbers  =  [pDict objectForKey:@"familyMembers"];
        self.mChildren  =  [pDict objectForKey:@"children"];
        self.mPets  =  [pDict objectForKey:@"pets"];
        self.mHouseHoldIncome  =  [pDict objectForKey:@"householdIncome"];
    }
    return self;
}
*/

@end
