//
//  SubCategories.m
//  Coupit
//
//  Created by Vikas_headspire on 04/03/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "SubCategories.h"


@implementation SubCategories

@dynamic mID;
@dynamic mName;


-(void) subCategoryWithDict:(NSDictionary *)pDict
{
    self.mID    = [NSNumber numberWithInteger:[[pDict objectForKey:@"id"]intValue]];
    self.mName  = [pDict objectForKey:@"name"];
}
@end
