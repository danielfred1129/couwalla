//
//  Brands.h
//  Coupit
//
//  Created by Deepak Kumar on 3/4/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Brands : NSManagedObject

@property (nonatomic, retain) NSNumber * mActiveCouponCount;
@property (nonatomic, retain) NSString * mDescription;
@property (nonatomic, retain) NSString * mFullImage;
@property (nonatomic, retain) NSNumber * mID;
@property (nonatomic, retain) NSString * mLegalUrl;
@property (nonatomic, retain) NSString * mName;
@property (nonatomic, retain) NSString * mThumbnailImage;
@property (nonatomic, retain) NSNumber * mType;

-(void) brandsWithDict:(NSDictionary *)pDict;

@end
