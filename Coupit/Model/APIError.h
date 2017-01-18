//
//  APIError.h
//  Coupit
//
//  Created by Vikas_headspire on 06/04/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIError : NSObject

@property (nonatomic, retain) NSNumber *mErrorCode;
@property (nonatomic, retain) NSString *mMessage;

- (id) initWithDict:(NSDictionary *)pDict;

@end
