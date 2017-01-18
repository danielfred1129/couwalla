//
//  CouponPrefrences.m
//  Coupit
//
//  Created by Vikas_headspire on 03/05/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "CouponPrefrences.h"

@implementation CouponPrefrences
@synthesize mCategoryid;

-(NSMutableArray *) addCouponPrefrences {
    self.mCategoryid = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"CouponPrefences"]];
    
    return mCategoryid;
}


@end
