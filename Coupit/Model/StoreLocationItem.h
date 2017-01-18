//
//  StoreLocationItem.h
//  SimpleMapView
//


//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface StoreLocationItem : NSObject<MKAnnotation>{
    NSString *_name;
    NSString *_address;
    CLLocationCoordinate2D _coordinate;
}

@property ( copy) NSString*	name;
@property ( copy) NSString*	address;
@property (nonatomic, readonly)	CLLocationCoordinate2D	coordinate;

-(id)initWithName:(NSString*)ptitle Address:(NSString*)psubtitle Coordinate:(CLLocationCoordinate2D)pcoordinate;


@end