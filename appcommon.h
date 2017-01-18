//
//  appcommon.h
//  Dr_College
//
//  Created by geniemac5 on 05/12/13.
//  Copyright (c) 2013 GenieMAC2. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define BASE_URL @"http://api.couwallabi.com/api"

//#define BASE_URL [NSString stringWithFormat:@"http://api.couwallabi.com/v%d",[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] intValue]]

#define BASE_URL [NSString stringWithFormat:@"http://dev.couwallabi.com/v%d",[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] intValue]]



//extern NSString* BASE_URL;

@interface appcommon : NSObject

@property(nonatomic,retain)NSString *REGISTRATIONURL;

@end
