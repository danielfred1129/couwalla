//
//  DPKMakeURL.m
//  NewtworkProgram
//
//  Created by Deepak Kumar on 18/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DPKMakeURL.h"
#import "NSDictionary+extras.h"

@implementation DPKMakeURL
@synthesize mURLDictionary;

- (id) initWithMainURL:(NSString *)pMainURL 
{
	self = [super init];
    if (self) {
		mMainURL = pMainURL;
        self.mURLDictionary = [NSMutableDictionary new];
	}
	return self;
}

- (void) setParamValue:(NSString *)pValue forKey:(NSString *)pkey
{
	[mURLDictionary setObject:pValue forKey:pkey];
}

- (NSString *) getParamURL
{
	//return [mURLDictionary joinUsingPairsSeparator:@"&" kvSeparator:@"=" kvTransformationSelector:@selector(percentEncodedString)];
    
     NSMutableString *resultString = [NSMutableString string];
     for (NSString* key in [mURLDictionary allKeys]){
         if ([resultString length]>0)
         [resultString appendString:@"&"];
         [resultString appendFormat:@"%@=%@", key, [mURLDictionary objectForKey:key]];
     }
    
    NSString *escapedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL,
                                                                                  (CFStringRef)resultString,
                                                                                  NULL,
                                                                                  CFSTR("!*'();:@+$,/?%#[]"),
                                                                                  kCFStringEncodingUTF8);
    return escapedString;
}

- (NSString *) getPreparedURL
{
	NSString *url;
	if (mMainURL == nil) {
		url = [self getParamURL];
	}
	else {
		url = [mMainURL stringByAppendingFormat:@"?%@", [self getParamURL]];
	}
	return url;
}

- (void)dealloc {
    if (mURLDictionary) {
        [mURLDictionary release];
        mURLDictionary = nil;
    }
    [super dealloc];
}


@end
