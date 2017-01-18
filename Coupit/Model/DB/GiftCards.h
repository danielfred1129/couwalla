//
//  GiftCards.h
//  Coupit
//
//  Created by Deepak Kumar on 4/8/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GiftCards : NSManagedObject

@property (nonatomic, retain) NSNumber *mDirectoryState;
@property (nonatomic, retain) NSNumber *mID;
@property (nonatomic, retain) NSNumber *mPoints;
@property (nonatomic, retain) NSNumber *mSavings;
@property (nonatomic, retain) NSNumber *mSequenceNo;
@property (nonatomic, retain) NSNumber *mBrandID;

@property (nonatomic, retain) NSString *mBackImage;

@property (nonatomic, retain) NSString *mBarCode;
@property (nonatomic, retain) NSString *mDescription;
@property (nonatomic, retain) NSString *mDisplayName;
@property (nonatomic, retain) NSString *mFrontImage;

@property (nonatomic, retain) NSString *mImageWithoutBarcode;
@property (nonatomic, retain) NSString *mLegalUrl;
@property (nonatomic, retain) NSString *mLongPromoText;
@property (nonatomic, retain) NSString *mShortPromoText;
@property (nonatomic, retain) NSString *mThumbNail;
@property (nonatomic, retain) NSString *mBarcodeType;

@property (nonatomic, retain) NSDate *mValidFrom;
@property (nonatomic, retain) NSDate *mValidTill;
@property (nonatomic, retain) NSDate *mLastModified;

- (void) giftCardWithDict:(NSDictionary *)pDict;

@end
