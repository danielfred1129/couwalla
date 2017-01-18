//
//  Created by Mohd Iftekhar Qurashi on 29/12/13.
//  Copyright (c) 2013 Iftekhar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IQWebServiceConstants.h"

@interface IQWebService : NSObject

@property(nonatomic, assign, getter = isLogEnabled) BOOL logEnabled;
@property(nonatomic, assign) IQRequestParameterType parameterType;
@property(nonatomic, retain) NSString *defaultContentType;
@property(nonatomic, retain) NSString *serverURL;
@property(nonatomic, retain) NSData *startBodyData;
@property(nonatomic, retain) NSData *endBodyData;

+(instancetype)service;

//Simple request
-(void)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//Download Upload Progress request
-(void)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;
-(void)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter uploadProgressBlock:(IQProgressBlock)uploadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;
-(void)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter uploadProgressBlock:(IQProgressBlock)uploadProgress downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//Simple request + HTTPResponse
-(void)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter responseBlock:(IQResponseBlock)response completionHandler:(IQDictionaryCompletionBlock)completionHandler;

//Download Upload Progress request + HTTPResponse
-(void)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter responseBlock:(IQResponseBlock)response downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;
-(void)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter responseBlock:(IQResponseBlock)response uploadProgressBlock:(IQProgressBlock)uploadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;
-(void)requestWithPath:(NSString*)path httpMethod:(NSString*)method parameter:(NSDictionary*)parameter responseBlock:(IQResponseBlock)response uploadProgressBlock:(IQProgressBlock)uploadProgress downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDictionaryCompletionBlock)completionHandler;

@end
