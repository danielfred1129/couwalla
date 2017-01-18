//
//  Category.h
//  Coupit
//
//  Created by Deepak Kumar on 3/4/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSNumber * mID;
@property (nonatomic, retain) NSString * mName;
@property (nonatomic, retain) NSNumber * mChild;
@property (nonatomic, retain) NSSet *rChildren;

-(void) categoryWithDict:(NSDictionary *)pDict;
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addRChildrenObject:(Category *)value;
- (void)removeRChildrenObject:(Category *)value;
- (void)addRChildren:(NSSet *)values;
- (void)removeRChildren:(NSSet *)values;

@end
