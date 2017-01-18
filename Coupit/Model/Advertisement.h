//
//  Advertisement.h
//  Coupit
//
//  Created by Deepak Kumar on 4/9/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Advertisement : NSObject

@property (nonatomic, retain) NSNumber *mID;
@property (nonatomic, retain) NSString *mAdText;
@property (nonatomic, retain) NSString *mAdHyperlink;

@property (nonatomic, retain) NSNumber *mCouponId;
@property (nonatomic, retain) NSString *mBannerImage;
@property (nonatomic, retain) NSDate *mLastModified;

- (id) initWithDict:(NSDictionary *)pDict;


@end
