//
//  GRESTDelegate.h
//  GREST
//
//  Created by raphaelcaixeta on 8/10/11.
//  Copyright 2011 Grip'd LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GRESTDelegate <NSObject>

@required

@optional

/* queue_started is called when the request queue starts executing the requests */
- (void)queue_started;

/* 
    queue_completed is called when every request in the queue has been completed or a request has failed
    status: YES/NO; If YES, the queue completed with no errors
    request_key: NSString of the unique key for this request
    NOTES: You'll get an exact trace of failed requests if you're implementing the request_failed method
*/
- (void)queue_completed:(BOOL)status failed_request_key:(NSString *)request_key;

/*
 Each request that completes with success in the queue will call this method
 response: NSString with the request's response
 request_key: NSString of the unique key for the request that has completed
 */
- (void)request_finished:(NSString *)response for_key:(NSString *)request_key;

/*
 Each request that fails in the queue will call this method
 error: NSError so you can further debug what went wrong
 request_key: NSString of the unique key for the request that has completed
 */
- (void)request_failed:(NSError *)error for_key:(NSString *)request_key;

/* 
    Same methods as the required ones, but includes the original ASIHTTPRequest for debugging. 
    If these methods are implemented, the ones above will not be called. 
*/
- (void)request_finished:(NSString *)response for_key:(NSString *)request_key with_details:(ASIHTTPRequest *)request;
- (void)request_failed:(NSError *)error for_key:(NSString *)request_key with_details:(ASIHTTPRequest *)request;

@end
