//
//  SafeInsert.h
//  Notch
//
//  Created by Andrey Cherkashin on 19.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (SafeInsert)

-(void)safeInsert:(NSManagedObject*)object;

@end
