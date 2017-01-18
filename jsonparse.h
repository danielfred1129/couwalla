//
//  jsonparse.h
//  myproject
//
//  Created by GenieMAC2 on 11/29/13.
//  Copyright (c) 2013 GenieMAC2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface jsonparse : NSObject

-(NSMutableDictionary*) customejsonParsing: (NSMutableString*)urlString bodydata:(NSMutableDictionary*)bodydata;

@end
