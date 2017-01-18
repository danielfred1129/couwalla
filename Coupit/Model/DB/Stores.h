//
//  Stores.h
//  Coupit
//
//  Created by Deepak Kumar on 3/4/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LocationDocs.h"

@interface Stores : NSManagedObject

@property (nonatomic, retain) NSNumber * mActiveCouponCount;
@property (nonatomic, retain) NSNumber * mBrandId;
@property (nonatomic, retain) NSString * mFullImage;
@property (nonatomic, retain) NSString * mFullName;
@property (nonatomic, retain) NSNumber * mID;
@property (nonatomic, retain) NSDate   * mLastModified;
@property (nonatomic, retain) NSString * mLegalUrl;
@property (nonatomic, retain) NSString * mThumbnailImage;
@property (nonatomic, retain) NSString * mQRCode;
@property (nonatomic, retain) NSString * mDescription;
@property (nonatomic, retain) NSString * mBrandType;
@property (nonatomic, retain) NSString * mBrandName;

- (void) storesWithDict:(NSDictionary *)pDict;
- (void) storesWithSolrDict:(NSDictionary *)pDict;
@end
