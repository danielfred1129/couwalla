//
//  Request.h
//  Coupit
//
//  Created by Deepak Kumar on 6/19/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Request : NSObject

@property (nonatomic, retain) NSString *mRequestURL;
@property RequestType mRequestType;

- (id)initWithRequestURL:(NSString *)pRequest type:(RequestType)pRequestType;

@end
