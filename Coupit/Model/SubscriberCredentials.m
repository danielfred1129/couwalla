//
//  SubscriberCredentials.m
//  Coupit
//
//  Created by Vikas_headspire on 15/03/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "SubscriberCredentials.h"

@implementation SubscriberCredentials
@synthesize mUserName, mPassword;


-(NSDictionary *) pToDictionary
{
    
    NSMutableDictionary *tCredentialDictionary = [[NSMutableDictionary alloc] init];
    
    if (mUserName != NULL) {
        [tCredentialDictionary setObject:mUserName forKey:@"username"];
    }
    if (mPassword != NULL) {
        [tCredentialDictionary setObject:mPassword forKey:@"password"];
    }
//    if (mDeviceType != NULL) {
//        [tCredentialDictionary setObject:mDeviceType forKey:@"deviceType"];
//    }
//    if (mLoginMethod != NULL) {
//        [tCredentialDictionary setObject:mLoginMethod forKey:@"loginMethod"];
//    }

    return tCredentialDictionary;

}

- (NSString*) pToJSONString
{
    return [[self pToDictionary] JSONRepresentation];
}

- (void) credentialWithDict:(NSDictionary *)pDict
{
    self.mUserName  =  [pDict objectForKey:@"username"];
    self.mPassword  =  [pDict objectForKey:@"password"];
//    self.mDeviceType = [pDict objectForKey:@"deviceType"];
//    self.mLoginMethod =[pDict objectForKey:@"loginMethod"];
    
}


@end
