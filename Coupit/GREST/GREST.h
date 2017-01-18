//
//  GREST.h
//  GREST
//
//  Created by Raphael Caixeta on 8/9/11.
//  Copyright 2011 Grip'd LLC. All rights reserved.
//

/*
    Make sure you've added the following frameworks to your project!
    iOS: CFNetwork, SystemConfiguration, MobileCoreServices, CoreGraphics, libz
    Mac OSX: CoreServices, SystemConfiguration, libz
*/

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "ASIProgressDelegate.h"
#import "GRESTDelegate.h"

@class ASIHTTPRequest, ASINetworkQueue, ASIFormDataRequest;

@interface GREST : NSObject <GRESTDelegate> {
    id<GRESTDelegate>delegate;
    ASIHTTPRequest *failed_request;
    ASINetworkQueue *queue;
    NSString *user_agent;
    #if TARGET_OS_IPHONE
        UIProgressView *track_progress_bar;
    #else
        NSProgressIndicator *track_progress_bar;
    #endif
    BOOL last_request_status;
}

#pragma mark - Custom Methods

/*
    SENDS A BASIC HTTP REQUEST TO THE request_url
    request_url: NSURL of where request will be made
    with_key: A Unique NSString tag for this request
*/
- (void)get_response:(NSURL *)request_url with_key:(NSString *)key;

/*
    CUSTOM HTTP REQUEST
    request_url: NSURL of where request will be made
    with_method: The HTTP method; defaults to POST
    parameters: NSString with the body for the HTTP request
    content_type: The HTTP Content-Type header; defaults to application/x-www-form-urlencoded
    with_key: A Unique NSString tag for this request
*/
- (void)connect:(NSURL *)request_url with_method:(NSString *)request_method params:(NSString *)parameters contentType:(NSString *)content_type with_key:(NSString *)key;

/*
    GET HTTP REQUEST
    request_url: NSURL of where request will be made
    parameters: NSDictionary with the request's parameters
    content_type: The HTTP Content-Type header; defaults to application/x-www-form-urlencoded
    with_key: A Unique NSString tag for this request
*/
- (void)get:(NSURL *)request_url with_params:(NSDictionary *)parameters contentType:(NSString *)content_type with_key:(NSString *)key;

/*
    POST HTTP REQUEST
    request_url: NSURL of where request will be made
    parameters: NSDictionary with the request's parameters
    content_type: The HTTP Content-Type header;
    with_key: A Unique NSString tag for this request
*/
- (void)post:(NSURL *)request_url with_params:(NSDictionary *)parameters contentType:(NSString *)content_type with_key:(NSString *)key;

/*
    START
    Once you are done adding requests to the queue, call this method to start everything
    If you are implementing the GRESTDelegate, you'll receive notifications on each request and when the queue is completed.
*/
- (void)start;

/*
    STOP
    Stop & cancel the queue; If you need to abort a queue once it's started, call this method.
    Any requests that have been completed cannot be undone.
*/
- (void)stop;

/*
    SET USER AGENT
    By default GREST will send the USER_AGENT HTTP header as "GREST"; you can set what the USER_AGENT is by calling this method
    new_agent: Your custom USER_AGENT
    Please note: This is universally set for the queue. You cannot set a USER_AGENT on a per request basis.
*/
- (void)set_user_agent:(NSString *)new_agent;

/*
    SET PROGRESS BAR
    If you would like your queue's progress to be tracked call this method before [GREST start];
    progress_bar: UIProgressView object
*/
#if TARGET_OS_IPHONE
- (void)set_progress_bar:(UIProgressView *)progress_bar;
#else
- (void)set_progress_bar:(NSProgressIndicator *)progress_bar;
#endif

#pragma mark - ASIHTTPRequest Methods

/* DON'T BOTHER WITH THESE METHODS; THEY DO NOTHING FOR YOU. */
- (void)requestDidComplete:(ASIHTTPRequest *)the_request;
- (void)requestDidFail:(ASIHTTPRequest *)the_request;
- (void)queueDidComplete:(ASINetworkQueue *)thequeue;

@property(nonatomic, retain) id<GRESTDelegate>delegate;
#if TARGET_OS_IPHONE
@property(nonatomic, retain) UIProgressView *track_progress_bar;
#else
@property(nonatomic, retain) NSProgressIndicator *track_progress_bar;
#endif

@end
