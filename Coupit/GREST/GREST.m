//
//  GREST.m
//  GREST
//
//  Created by Raphael Caixeta on 8/9/11.
//  Copyright 2011 Grip'd LLC. All rights reserved.
//

#import "GREST.h"

@implementation GREST
@synthesize delegate, track_progress_bar;

- (id)init {
    self = [super init];
    if(self) {
        queue = [[ASINetworkQueue alloc] init];
        failed_request = [[ASIHTTPRequest alloc] init];
        user_agent = [[NSString alloc] initWithString:@"GREST"];
        last_request_status = YES;
        #if TARGET_OS_IPHONE
            track_progress_bar = [[UIProgressView alloc] init];
        #else
            track_progress_bar = [[NSProgressIndicator alloc] init];
        #endif
        [queue setRequestDidFinishSelector:@selector(requestDidComplete:)];
        [queue setRequestDidFailSelector:@selector(requestDidFail:)];
        [queue setQueueDidFinishSelector:@selector(queueDidComplete:)];
        [queue setShowAccurateProgress:YES];
        [queue setDelegate:self];
        [queue setDownloadProgressDelegate:track_progress_bar];
    }
    return self;
}

#pragma mark - Custom Methods

- (void)get_response:(NSURL *)request_url with_key:(NSString *)key {
    
    if(request_url == nil || request_url == NULL || [[request_url absoluteString] isEqualToString:@""]) {
        [NSException raise:@"GRESTInvalidRequest" format:@"Attempted to add request to queue with invalid NSURL"];
    }
    
    ASIHTTPRequest *request;
    request = [ASIHTTPRequest requestWithURL:request_url];
    [request addRequestHeader:@"User-Agent" value:user_agent];
    if(![key isEqualToString:@""] && key != nil && key != NULL) {
        [request setUserInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObject:key] forKeys:[NSArray arrayWithObject:@"request_key"]]];   
    }
    [queue addOperation:request];

}

- (void)connect:(NSURL *)request_url with_method:(NSString *)request_method params:(NSString *)parameters contentType:(NSString *)content_type with_key:(NSString *)key {
    
    if(request_url == nil || request_url == NULL || [[request_url absoluteString] isEqualToString:@""]) {
        [NSException raise:@"GRESTInvalidRequest" format:@"Attempted to add request to queue with invalid NSURL"];
    }
    
    if([parameters isEqualToString:@""] || parameters == nil || parameters == NULL) {
        [NSException raise:@"GRESTInvalidRequest" format:@"Attempted to add 'connect' method to queue without request's body"];
    }
    
    ASIFormDataRequest *request;
    NSData *request_data = [parameters dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *request_length = [NSString stringWithFormat:@"%d", [request_data length]];
    request = [ASIFormDataRequest requestWithURL:request_url];
    [request addRequestHeader:@"Content-Length" value:request_length];
    [request addRequestHeader:@"User-Agent" value:user_agent];
    if(![key isEqualToString:@""] && key != nil && key != NULL) {
        [request setUserInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObject:key] forKeys:[NSArray arrayWithObject:@"request_key"]]];   
    }
    if([request_method isEqualToString:@""] || request_method == nil || request_method == NULL) {
        [request setRequestMethod:@"POST"];
    } else {
        [request setRequestMethod:request_method];
    }
    if([content_type isEqualToString:@""] || content_type == nil || content_type == NULL) {
        [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    } else {
        [request addRequestHeader:@"Content-Type" value:content_type];
    }
    [request setPostBody:[NSMutableData dataWithData:request_data]];
    [queue addOperation:request];
    
}

- (void)get:(NSURL *)request_url with_params:(NSDictionary *)parameters contentType:(NSString *)content_type with_key:(NSString *)key {
    
    if(request_url == nil || request_url == NULL || [[request_url absoluteString] isEqualToString:@""])
    {
        [NSException raise:@"GRESTInvalidRequest" format:@"Attempted to add request to queue with invalid NSURL"];
    }
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:request_url];
    [request setRequestMethod:@"GET"];
    [request addRequestHeader:@"User-Agent" value:user_agent];
    if(![key isEqualToString:@""] && key != nil && key != NULL) {
        [request setUserInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObject:key] forKeys:[NSArray arrayWithObject:@"request_key"]]];   
    }
    if(parameters != nil && parameters != NULL && [parameters isKindOfClass:NSClassFromString(@"NSDictionary")]) {
        NSString *request_string = @"?";
        if([parameters count] > 0) {
            for(NSValue *key in [parameters allKeys]) {
                if([request_string isEqualToString:@"?"]) {
                    request_string = [request_string stringByAppendingFormat:@"%@=%@", (NSString *)key, [[parameters objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                } else {
                    request_string = [request_string stringByAppendingFormat:@"&%@=%@", (NSString *)key, [[parameters objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                }
            }
        }
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", (NSString *)request_url, request_string]]];
    }    
    if(content_type != nil && content_type != NULL && ![content_type isEqualToString:@""]) {
        [request addRequestHeader:@"Content-Type" value:content_type];
    }
    [queue addOperation:request];
    
}

- (void)post:(NSURL *)request_url with_params:(NSDictionary *)parameters contentType:(NSString *)content_type with_key:(NSString *)key {
    
    if(request_url == nil || request_url == NULL || [[request_url absoluteString] isEqualToString:@""]) {
        [NSException raise:@"GRESTInvalidRequest" format:@"Attempted to add request to queue with invalid NSURL"];
    }
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:request_url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"User-Agent" value:user_agent];
    if(![key isEqualToString:@""] && key != nil && key != NULL) {
        [request setUserInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObject:key] forKeys:[NSArray arrayWithObject:@"request_key"]]];   
    }
    if(parameters != nil && parameters != NULL && [parameters isKindOfClass:NSClassFromString(@"NSDictionary")]) {
        if([parameters count] > 0) {
            for(NSValue *key in [parameters allKeys]) {
                [request setPostValue:[parameters objectForKey:key] forKey:(NSString *)key];
            }
        }
    }
    if(content_type != nil && content_type != NULL && ![content_type isEqualToString:@""]) {
        [request addRequestHeader:@"Content-Type" value:content_type];
    }
    [queue addOperation:request];
    
}

- (void)start {
    
    [self queue_started];
    [queue go];
    
}

- (void)stop {
    
    [queue cancelAllOperations];
    
}

- (void)set_user_agent:(NSString *)new_agent {
 
    if([new_agent isEqualToString:@""] || new_agent == nil || new_agent == NULL) {
     
        [NSException raise:@"GRESTInvalidRequest" format:@"Attempted to set user agent to an invalid object"];
        
    } else {
        
        user_agent = new_agent;
        
    }
    
}

#if TARGET_OS_IPHONE
- (void)set_progress_bar:(UIProgressView *)progress_bar {
 
    if(progress_bar != nil && progress_bar != NULL && [progress_bar isKindOfClass:NSClassFromString(@"UIProgressView")]) {
        
        track_progress_bar = progress_bar;
        [queue setDownloadProgressDelegate:track_progress_bar];
        
    } else {
     
        [NSException raise:@"GRESTInvalidRequest" format:@"Attempted to set set_progress_bar to an invalid object"];
        
    }
}
#else
- (void)set_progress_bar:(NSProgressIndicator *)progress_bar {

    if(progress_bar != nil && progress_bar != NULL && [progress_bar isKindOfClass:NSClassFromString(@"NSProgressIndicator")]) {
    
        track_progress_bar = progress_bar;
        [queue setDownloadProgressDelegate:track_progress_bar];
    
    } else {
     
        [NSException raise:@"GRESTInvalidRequest" format:@"Attempted to set set_progress_bar to an invalid object"];
        
    }
    
}
#endif

#pragma mark - ASIHTTPRequest Methods

- (void)requestDidComplete:(ASIHTTPRequest *)the_request {
    
    last_request_status = YES;

    [self request_finished:[the_request responseString] for_key:[[the_request userInfo] objectForKey:@"request_key"] with_details:the_request];

}

- (void)requestDidFail:(ASIHTTPRequest *)the_request {
    
    last_request_status = NO;
    failed_request = the_request;
    
    [self request_failed:[the_request error] for_key:[[the_request userInfo] objectForKey:@"request_key"] with_details:the_request];
    
}

- (void)queueDidComplete:(ASINetworkQueue *)thequeue {
    
    if(last_request_status) {
        
        [self queue_completed:YES failed_request_key:nil];
        
    } else {
        
        [self queue_completed:NO failed_request_key:[[failed_request userInfo] objectForKey:@"request_key"]];
        
    }
    
}

#pragma mark - GRESTDelegate Methods

- (void)queue_started {
    if([self.delegate respondsToSelector:@selector(queue_started)]) {
        [self.delegate queue_started];
    }
}

- (void)request_finished:(NSString *)response for_key:(NSString *)request_key with_details:(ASIHTTPRequest *)request {
 
    if([self.delegate respondsToSelector:@selector(request_finished:for_key:with_details:)]) {
        [self.delegate request_finished:response for_key:request_key with_details:request];
    } else {
        [self.delegate request_finished:response for_key:request_key];
    }
    
}

- (void)request_failed:(NSError *)error for_key:(NSString *)request_key with_details:(ASIHTTPRequest *)request
{
 
    if([self.delegate respondsToSelector:@selector(request_failed:for_key:with_details:)])
    {
        [self.delegate request_failed:error for_key:request_key with_details:request];
    }
    else if([self.delegate respondsToSelector:@selector(request_failed:for_key:)])
    {
        [self.delegate request_failed:error for_key:request_key];
    }
    
}

- (void)queue_completed:(BOOL)status failed_request_key:(NSString *)request_key {
    
    #if TARGET_OS_IPHONE
        track_progress_bar.progress = 0.0;
    #else
        track_progress_bar.doubleValue = 0.0;
    #endif
    if([self.delegate respondsToSelector:@selector(queue_completed:failed_request_key:)]) {
        [self.delegate queue_completed:status failed_request_key:request_key];
    }
    
}
     
#pragma mark - Memory Management

- (void)dealloc
{
    [queue reset];
    [queue release];
    [failed_request release];
    [track_progress_bar release];
    
    [super dealloc];
    
}

@end
