//
//  Card.h
//  Coupit
//
//  Created by Deepak Kumar on 4/30/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MyCoupons;

@interface Card : NSManagedObject

@property (nonatomic, retain) NSString *mBackImage;
@property (nonatomic, retain) NSNumber *mCardType;
@property (nonatomic, retain) NSString *mFrontImage;
@property (nonatomic, retain) NSString *mID;
@property (nonatomic, retain) NSNumber *mIsCameraImage;
@property (nonatomic, retain) NSNumber *mIsFliped;
@property (nonatomic, retain) NSString *mCardNumber;
@property (nonatomic, retain) NSString *mCardName;
@property (nonatomic, retain) NSString *mBarCodeImage;
@property (nonatomic, retain) NSString *mCardDescription;
@property (nonatomic, retain) NSString *mBarcodeType;
@property (nonatomic, retain) NSNumber *mHaveBarcodeImage;
@property (nonatomic, retain) NSNumber *mCardSavings;
@property (nonatomic, retain) NSString *mCardPin;
@property (nonatomic, retain) NSSet *coupons;
@end

@interface Card (CoreDataGeneratedAccessors)

- (void)addCouponsObject:(MyCoupons *)value;
- (void)removeCouponsObject:(MyCoupons *)value;
- (void)addCoupons:(NSSet *)values;
- (void)removeCoupons:(NSSet *)values;

@end
