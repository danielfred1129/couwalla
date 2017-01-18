//
//  VBAnnotationView.m
//  Annotations
//
//  Created by Véronique Brossier on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VBAnnotationView.h"
#import "annotationclass.h"

@implementation VBAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    // Get a referene to the annotation to get its state value
    annotationclass *myAnnotation = (annotationclass *)annotation;
    
    NSString *myImage;
    if ([myAnnotation.state isEqualToString:@"california"]) {
         myImage = @"sun.png";
    } else if ([myAnnotation.state isEqualToString:@"nevada"]) {
        myImage = @"cactus.png";
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:myImage]];
    self.leftCalloutAccessoryView = imageView;
   
    if (myAnnotation) {
        self.image = [UIImage imageNamed:@"map_pin_yellow.png"];
        
    }
    self.enabled = YES;
    self.canShowCallout = YES;
    
    return self;
}

@end