//
//  SubscriberCredentials.h
//  Coupit
//
//  Created by Vikas_headspire on 15/03/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "tJSON.h"

@interface SubscriberCredentials : NSObject

@property (nonatomic, retain) NSString *mUserName;
@property (nonatomic, retain) NSString *mPassword;
//@property (nonatomic, retain) NSString *mDeviceType;
//@property (nonatomic, retain) NSString *mLoginMethod;

- (NSDictionary *) pToDictionary;
- (NSString*) pToJSONString;

- (void) credentialWithDict:(NSDictionary *)pDict;


@end
