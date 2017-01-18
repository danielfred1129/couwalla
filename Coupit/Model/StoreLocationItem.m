//
//  StoreLocationItem.m
//  SimpleMapView
//


//

#import "StoreLocationItem.h"


@implementation StoreLocationItem

@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;

-(id)initWithName:(NSString*)ptitle Address:(NSString*)psubtitle Coordinate:(CLLocationCoordinate2D)pcoordinate
{
	
	if ((self = [super init])) {
        _name = [ptitle copy];
        _address = [psubtitle copy];
        _coordinate = pcoordinate;
    }
    return self;
}

- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]])
        return @"Unknown charge";
    else
        return _name;
}

- (NSString *)subtitle {
    return _address;
}
@end