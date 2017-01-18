//
//  RewardCard.h
//  Coupit
//
//  Created by Deepak Kumar on 4/7/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RewardCard : NSObject

@property (nonatomic, retain) NSString *mBackImage;
@property (nonatomic, retain) NSString *mBarCode;

@property (nonatomic, retain) NSString *mBarCodeType;
@property (nonatomic, retain) NSString *mDescription;
@property (nonatomic, retain) NSString *mFrontImage;

@property (nonatomic, retain) NSString *mID;
@property (nonatomic, retain) NSString *mLastModified;

@property (nonatomic, retain) NSString *mLongPromoText;
@property (nonatomic, retain) NSString *mShortPromoText;
@property (nonatomic, retain) NSString *mPoints;
@property (nonatomic, retain) NSDate *mValidFrom;
@property (nonatomic, retain) NSDate *mValidTill;

@property (nonatomic, retain) NSString *mCardName;
@property (nonatomic, retain) NSString *mCardNumber;
@property (nonatomic, retain) NSString *mCardType;
@property (nonatomic, retain) NSString *mSubscriberId;
@property (nonatomic, retain) NSString *mSecurityCode;


- (void) rewardCardWithDict:(NSDictionary *)pDict;

@end
