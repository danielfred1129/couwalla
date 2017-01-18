//
//  MyCouponCategories.h
//  Coupit
//
//  Created by VIKAS MISHRA on 24/07/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MyCouponCategories : NSManagedObject

@property (nonatomic, retain) NSNumber * mCategoryID;
@property (nonatomic, retain) NSNumber * mCouponID;

@end
