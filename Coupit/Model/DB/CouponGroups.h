//
//  CouponGroups.h
//  Coupit
//
//  Created by VIKAS MISHRA on 02/08/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CouponGroups : NSManagedObject

@property (nonatomic, retain) NSNumber * mCouponID;
@property (nonatomic, retain) NSNumber * mGroupID;
@property (nonatomic, retain) NSNumber * mIndex;

@end
