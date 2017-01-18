//
//  countdownManager.h
//  Coupit
//
//  Created by Canopus5 on 6/21/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "jsonparse.h"


@interface countdownManager : NSObject

+ (countdownManager *) shareManeger;

+(void)callWebServiceForLocationUpdate;

@property (nonatomic,strong) NSMutableDictionary *timerDictionaryForSingalCoupon;
@property BOOL userLocationDidUpdate;
@property BOOL opensidemenu;


@end
