//
//  HttpRequest.h
//  NewtworkProgram
//
//  Created by Deepak Kumar on 16/06/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIError.h"

@class HttpRequest;
@protocol HttpRequestDelegate
- (void) responseHandler:(HttpRequest *)pController requestType:(RequestType)pRequestType status:(int) pStatusCode;
@end

@interface HttpRequest : NSOperation <NSURLConnectionDelegate> {
		
	NSURL *mRequestURL;
	NSMutableData *mResponseData;
	NSData *mBodyData;
	///////////////////////////
	RequestType mRequestType;
    int mStatusCode;
}

@property (nonatomic, retain) id <HttpRequestDelegate> mDelegate;
@property (nonatomic, retain) NSMutableData* mResponseData;

@property (nonatomic, retain) NSURL *mRequestURL;
@property (nonatomic, retain) NSData *mBodyData;

@property BOOL mIsPostRequest;
@property RequestType mRequestType;

- (id) initGetRequestWithURL:(NSString *)pURL requestType:(RequestType)pRequestType;
- (id) initPostRequestwithHostURL:(NSString *)pURL bodyPost:(NSString *)pBodyPost requestType:(RequestType)pRequestType;
- (void) sendPostData:(NSMutableURLRequest *) request;

- (NSString *)getURLPath;

@end
