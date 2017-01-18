//
//  DPKRequestHandler.h
//  NewtworkProgram
//
//  Created by Deepak Kumar on 16/06/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest.h"
#import "tJSON.h"
#import "APIError.h"
#import <FacebookSDK/FacebookSDK.h>
//#import "SBJSON.h"
@class RequestHandler;

@protocol RequestHandlerDelegate
- (void) requestHandler:(RequestHandler *)pRequestHandler withRequestType:(RequestType)pRequestType error:(APIError *)pError;

@end

@interface RequestHandler : NSObject<HttpRequestDelegate, UIAlertViewDelegate> {
	
	UIAlertView *mAlertView;
	// the queue to run our Operation
    NSOperationQueue *mQueue;
	id delegate;
	////////////////////////////////////
	NSString *mURL;
    NSString *mPostBodyString;
    BOOL mIsPostRequest;
    
	NSData *mData;
	id mParser;
	RequestType mRequestType;
	BOOL AlertVisible;
    tSBJSON *mJsonParser;
    NSInteger mGroupID;
}

@property (nonatomic,retain) NSMutableDictionary *mDelegateDictionary;
@property (nonatomic, retain) NSString* mAuthKey;

+ (RequestHandler *) getInstance;
- (NSArray *) requests;

- (void) cancellAllRequest;

- (void) getRequestURL:(NSString *)pURL delegate:(id)pDelegate requestType:(RequestType)pRequestType;
- (void) postRequestwithHostURL:(NSString *)pHostURL bodyPost:(NSString *)pBodyPost delegate:(id)pDelegate requestType:(RequestType)pRequestType;

- (BOOL) checkInternet;
- (void) saveCouponInDB:(NSDictionary *)pDict downloaded:(BOOL)pBool groupID:(NSInteger)pGroupID;
//- (void) saveCouponInDB:(NSDictionary *)pDict downloaded:(NSNumber *)pBool;

@end
