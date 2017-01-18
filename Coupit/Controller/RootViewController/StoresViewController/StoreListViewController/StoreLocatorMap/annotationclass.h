//
//  annotationclass.h
//  Coupit
//
//  Created by geniemac5 on 21/10/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface annotationclass : NSObject<MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *name;

- initWithPosition:(CLLocationCoordinate2D)coords;
@end
