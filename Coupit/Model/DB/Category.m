//
//  Category.m
//  Coupit
//
//  Created by Deepak Kumar on 3/4/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "Category.h"
#import "SubCategories.h"


@implementation Category

@dynamic mID;
@dynamic mName;
@dynamic mChild;

@dynamic rChildren;

-(void) categoryWithDict:(NSDictionary *)pDict
{
        self.mID    = [NSNumber numberWithInteger:[[pDict objectForKey:@"id"]intValue]];
        self.mName  = [pDict objectForKey:@"name"];
        ////NSLog(@"mName:%@", self.mName);
    
        // children
    //NSLog(@"Dictionary is %@",pDict);
    
        for (NSDictionary *subCategory in [pDict objectForKey:@"children"])
        {
            if (subCategory) {
                Category *tCategories = [NSEntityDescription
                                         insertNewObjectForEntityForName:@"Categories"
                                         inManagedObjectContext:[Repository sharedRepository].context];
                tCategories.mChild = [NSNumber numberWithBool:YES];
                
                [tCategories categoryWithDict:subCategory];
                [self addRChildrenObject:tCategories];
            }
        }
     
    
        /*
        self.mSubCategories = [NSMutableArray new];
        for (NSDictionary *subCategory in [pDict objectForKey:@"children"])
            [self.mSubCategories addObject:[[SubCategory alloc] initWithDict:subCategory]];
        
        ////NSLog(@"mSubCategories:%d", [mSubCategories count]);
         */
    
}






@end
