//
//  DPKMakeURL.h
//  NewtworkProgram
//
//  Created by Deepak Kumar on 18/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DPKMakeURL : NSObject {
	NSMutableDictionary *mURLDictionary;
	NSString *mMainURL;
}

@property (nonatomic, retain) NSMutableDictionary *mURLDictionary;

- (id) initWithMainURL:(NSString *)pMainURL;

- (NSString *) getParamURL;
- (NSString *) getPreparedURL;

- (void) setParamValue:(NSString *)pValue forKey:(NSString *)pkey;

@end
