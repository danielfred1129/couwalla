//
//  HttpRequest.m
//  NewtworkProgram
//
//  Created by Deepak Kumar on 16/06/10.
//  Copyright 2010 home. All rights reserved.
//

#import "HttpRequest.h"
#import "NSURLRequest+IgnoreSSL.h"
#import "RequestHandler.h"
#import "Location.h"

@implementation HttpRequest
@synthesize mDelegate;
@synthesize mResponseData;
@synthesize mIsPostRequest;
@synthesize mRequestType, mRequestURL, mBodyData;

- (id) initGetRequestWithURL:(NSString *)pURL requestType:(RequestType)pRequestType
{
    if ([pURL isEqual:nil]) {
        return nil;
    } else {
        self = [super init];
        if (self != nil)
        {
            mRequestURL = [[NSURL alloc] initWithString:pURL];
            mRequestType = pRequestType;
            mIsPostRequest = NO;
            
        }
        return self;
    }
	self = [super init];
    if (self != nil)
    {
		mRequestURL = [[NSURL alloc] initWithString:pURL];
        mRequestType = pRequestType;
        mIsPostRequest = NO;
        
	}
    return self;
}


- (id) initPostRequestwithHostURL:(NSString *)pURL bodyPost:(NSString *)pBodyPost requestType:(RequestType)pRequestType
{
	self = [super init];
    if (self != nil)
    {
        //NSLog(@"pBodyPost:%@", pBodyPost);
		//mRequestURL = [[NSURL alloc] initWithString:[pURL stringByAppendingString:[NSString stringWithFormat:@"/%@",[[DataManager getInstance] mCSRFToken]]]];
        mRequestURL = [[NSURL alloc] initWithString:pURL];
        mRequestType = pRequestType;
        mBodyData = [pBodyPost dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];

       // mBodyData = [[NSData alloc] initWithData:[pBodyPost dataUsingEncoding:NSUTF8StringEncoding]];
	}
    return self;
}

- (NSString *)getURLPath
{
    return [mRequestURL absoluteString];
}

- (void) main
{
	@autoreleasepool {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        //NSLog(@"mRequestURL:%@", [mRequestURL absoluteString]);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:mRequestURL];
        
        NSString *authKey = [[RequestHandler getInstance] mAuthKey];
        if ([authKey length] > 0)
        {
            [request setValue:authKey forHTTPHeaderField:@"X-Auth-Key"];
        }
        
        NSString *locKey = [[Location getInstance] userLocation];
        
        //NSLog(@"locKey:%@", locKey);
        if ([locKey length] > 0)
        {
            [request setValue:locKey forHTTPHeaderField:@"X-Client-Location"];
        }
        
        if (mIsPostRequest) {

            [self sendPostData:request];
        }
        else{
            NSURLConnection *makeConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            if(makeConnection)
                [[NSRunLoop currentRunLoop] run];
        }
    }
}

#pragma mark sendPostData
- (void) sendPostData:(NSMutableURLRequest *) request
{
    //NSLog(@"mBodyData Length:%d", [mBodyData length]);

    //[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

	NSString *postLength = [NSString stringWithFormat:@"%d", [mBodyData length]];

    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [request setHTTPBody:mBodyData];

    [NSURLRequest allowsAnyHTTPSCertificateForHost:[mRequestURL host]];

	// contentType
	//[request setValue:CONTENT_TYPE forHTTPHeaderField:@"Content-type"];
	// User-Agent
	//[request setValue:USER_AGENT forHTTPHeaderField:@"User-Agent"];

    
    //NSLog(@"Connection Created for post--");
    
    NSURLConnection *makeConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(makeConnection)
        //NSLog(@"Connection Created");
    
    [[NSRunLoop currentRunLoop] run];

    
    /*
    NSError *error;
    NSURLResponse *response;
    mResponseData = (NSMutableData *)[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	//NSLog(@"appendData:%u",[mResponseData length]);
    [mDelegate requestHandler:self requestType:mRequestType error:nil];
     */
}

#pragma mark -
#pragma mark CallBack Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
	NSDictionary *headerDictionary = [(NSHTTPURLResponse *)response allHeaderFields];
    NSString* authKey = [headerDictionary objectForKey:@"X-Auth-Key"];
    //NSLog(@"authKey:%@", authKey);
    if ([authKey length] > 0)
    {
        //NSLog(@"Setting Auth Key: %@", authKey);
        [[RequestHandler getInstance] setMAuthKey:authKey];
    }
    
//    else{
//        [RequestHandler getInstance].mAuthKey = @"";
//    }
    
    mStatusCode = [(NSHTTPURLResponse *)response statusCode];
    //NSLog(@"---------- HTTP Status Code: %d", mStatusCode);
}	

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)tempData 
{ 
	////NSLog(@"appendData");
	if(mResponseData == nil)
		mResponseData = [[NSMutableData alloc] initWithCapacity:4096];	
	
	[mResponseData appendData:tempData];	
} 


#pragma mark -
#pragma mark Newtwork Request Completed
/*
 * This method invokes by the class when network finished with the loading of the request.
 */
- (void) connectionDidFinishLoading:(NSURLConnection *)connection 
{	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	//NSLog(@"appendData:%u",[mResponseData length]);
    [mDelegate responseHandler:self requestType:mRequestType status: mStatusCode];
}

#pragma mark -
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// NO INTERNET //
    
	//NSLog(@"Error NetWork code:%d withDescp:%@",error.code, [error localizedDescription]);
	[mDelegate responseHandler:self requestType:mRequestType status:error.code];

	if(error.code == -1001){
		//Post notifications...
	}
}


@end
