//
//  SubCategories.h
//  Coupit
//
//  Created by Vikas_headspire on 04/03/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Category.h"


@interface SubCategories : Category

@property (nonatomic, retain) NSNumber * mID;
@property (nonatomic, retain) NSString * mName;

-(void) subCategoryWithDict:(NSDictionary *)pDict;

@end
