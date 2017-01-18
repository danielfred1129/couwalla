//
//  annotationclass.m
//  Coupit
//
//  Created by geniemac5 on 21/10/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "annotationclass.h"

@implementation annotationclass
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize name;
@synthesize state;

- initWithPosition:(CLLocationCoordinate2D)coords {
    if (self = [super init]) {
        self.coordinate = coords;
    }
    return self;
}
@end
