//
//  SafeInsert.m
//  Notch
//
//  Created by Andrey Cherkashin on 19.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSManagedObjectContext+SafeInsert.h"

@implementation NSManagedObjectContext (SafeInsert) 

-(void)safeInsert:(NSManagedObject*)object {
    if(object != nil) {
        if (object.managedObjectContext == nil) {
            [self insertObject:object];
        }
    }
}

@end
