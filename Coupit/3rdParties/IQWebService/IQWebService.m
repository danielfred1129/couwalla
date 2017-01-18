//
//  Created by Mohd Iftekhar Qurashi on 29/12/13.
//  Copyright (c) 2013 Iftekhar. All rights reserved.
//

#import "IQWebService.h"
#import "IQURLConnection.h"

@implementation IQWebService

@synthesize logEnabled = _logEnabled;

+(instancetype)service
{
    static IQWebService *sharedService;
    if (sharedService == nil)
    {
        sharedService = [[self alloc] init];
    }
    
    return sharedService;
}

-(BOOL)isLogEnabled
{
	return _logEnabled;
}

+(NSString*)httpParameterString:(NSDictionary*)dictionary
{
    NSMutableString *parameterString = [[NSMutableString alloc] init];
    
    for (NSString *aKey in [dictionary allKeys])
    {
        [parameterString appendFormat:@"%@=%@&",aKey,[dictionary objectForKey:aKey]];
    }
    
    if ([parameterString length])
    {
        [parameterString replaceCharactersInRange:NSMakeRange(parameterString.length-2, 1) withString:@""];
    }
    
    return parameterString;
}

+(NSMutableURLRequest*)requestWithURL:(NSURL*)url httpMethod:(NSString*)httpMethod contentType:(NSString*)contentType body:(NSData*)body
{
    if (url != nil)
    {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:300];
        
        if ([httpMethod length])    [request setHTTPMethod:httpMethod];
        if ([contentType length])   [request addValue:contentType forHTTPHeaderField:kIQContentType];
        if ([body length])
        {
            [request setHTTPBody:body];
            [request addValue:[NSString stringWithFormat:@"%d",[body length]] forHTTPHeaderField:kIQContentLength];
        }
        return request;
    }
    else
    {
        return nil;
    }
}

//Simple request
-(void)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    [self requestWithPath:path httpMethod:method parameter:parameter responseBlock:nil uploadProgressBlock:nil downloadProgressBlock:nil completionHandler:completionHandler];
}

//Download Upload Progress request
-(void)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;
{
    [self requestWithPath:path httpMethod:method parameter:parameter responseBlock:nil uploadProgressBlock:nil downloadProgressBlock:downloadProgress completionHandler:completionHandler];
}

-(void)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter uploadProgressBlock:(IQProgressBlock)uploadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;
{
    [self requestWithPath:path httpMethod:method parameter:parameter responseBlock:nil uploadProgressBlock:uploadProgress downloadProgressBlock:nil completionHandler:completionHandler];
}

-(void)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter uploadProgressBlock:(IQProgressBlock)uploadProgress downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;
{
    [self requestWithPath:path httpMethod:method parameter:parameter responseBlock:nil uploadProgressBlock:uploadProgress downloadProgressBlock:downloadProgress completionHandler:completionHandler];
}

//Simple request + HTTPResponse
-(void)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter responseBlock:(IQResponseBlock)response completionHandler:(IQDictionaryCompletionBlock)completionHandler;
{
    [self requestWithPath:path httpMethod:method parameter:parameter responseBlock:response uploadProgressBlock:nil downloadProgressBlock:nil completionHandler:completionHandler];
}

//Download Upload Progress request + HTTPResponse
-(void)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter responseBlock:(IQResponseBlock)response downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;
{
    [self requestWithPath:path httpMethod:method parameter:parameter responseBlock:response uploadProgressBlock:downloadProgress downloadProgressBlock:nil completionHandler:completionHandler];
}

-(void)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter responseBlock:(IQResponseBlock)response uploadProgressBlock:(IQProgressBlock)uploadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;
{
    [self requestWithPath:path httpMethod:method parameter:parameter responseBlock:response uploadProgressBlock:uploadProgress downloadProgressBlock:nil completionHandler:completionHandler];
}

-(void)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter responseBlock:(IQResponseBlock)response uploadProgressBlock:(IQProgressBlock)uploadProgress downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler
{
    NSURL *url = nil;
    NSData *httpBody = nil;
    
    if ([method isEqualToString:kIQHTTPMethodGET])
    {
        NSMutableString *parameterString = [[NSMutableString alloc] init];
        if ([path hasSuffix:@"?"] == NO)    [parameterString appendString:@"?"];
        
        [parameterString appendString:[[self class] httpParameterString:parameter]];
        
        url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@%@",self.serverURL,path,parameterString] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    }
    else if ([method isEqualToString:kIQHTTPMethodPOST])
    {
        url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",self.serverURL,path] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        
        NSData *originalData = [[NSData alloc] init];
        
        if (self.parameterType == IQRequestParameterTypeJSON)
        {
            originalData = [NSJSONSerialization dataWithJSONObject:parameter options:0 error:nil];
        }
        else if (self.parameterType == IQRequestParameterTypeHTTP)
        {
            NSString *parameterString = [[self class] httpParameterString:parameter];
            originalData = [parameterString dataUsingEncoding:NSUTF8StringEncoding];
        }
        
        if ([originalData length])
        {
            NSMutableData *editedData = [[NSMutableData alloc] init];
            
            if (self.startBodyData) [editedData appendData:self.startBodyData];
            if (originalData)       [editedData appendData:originalData];
            if (self.endBodyData)   [editedData appendData:self.endBodyData];
            
            httpBody = editedData;
        }
    }
    
    NSURLRequest *request = [IQWebService requestWithURL:url httpMethod:method contentType:self.defaultContentType body:httpBody];
    
    if (_logEnabled)
	{
		NSLog(@"RequestURL:- %@",request.URL);
		NSLog(@"HTTPHeaderFields:- %@",request.allHTTPHeaderFields);
		NSLog(@"Body:- %@",[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
	}
    
    [IQURLConnection sendAsynchronousRequest:request responseBlock:response uploadProgressBlock:uploadProgress downloadProgressBlock:downloadProgress completionHandler:^(NSData *result, NSError *error) {
        if (_logEnabled)
        {
            NSLog(@"URL:- %@",request.URL);
            NSLog(@"error:- %@",error);
            NSLog(@"Response:- %@",[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]);
        }
        
        if (completionHandler != NULL)
        {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(response, error);
            });
        }
    }];
}

@end


