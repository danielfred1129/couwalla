//
//  Created by Mohd Iftekhar Qurashi on 29/12/13.
//  Copyright (c) 2013 Iftekhar. All rights reserved.
//

#import "IQURLConnection.h"

@interface IQURLConnection ()
{
    IQDataCompletionBlock         _completion;
    IQProgressBlock           _uploadProgress;
    IQProgressBlock           _downloadProgress;
    IQResponseBlock           _responseBlock;
    
    NSURLResponse* _response;
    NSMutableData* _data;
}

@end

@implementation IQURLConnection

static NSOperationQueue *queue;

+(void)initialize
{
    [super initialize];
    
    queue = [[NSOperationQueue alloc] init];
}

+ (IQURLConnection*)sendAsynchronousRequest:(NSURLRequest *)request responseBlock:(IQResponseBlock)responseBlock uploadProgressBlock:(IQProgressBlock)uploadProgress downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDataCompletionBlock)completion
{
    IQURLConnection *asyncRequest = [[IQURLConnection alloc] initWithRequest:request responseBlock:&responseBlock uploadProgressBlock:&uploadProgress downloadProgressBlock:&downloadProgress completionBlock:&completion];
    [asyncRequest start];

    return asyncRequest;
}

-(id)initWithRequest:(NSURLRequest *)request responseBlock:(IQResponseBlock*)responseBlock uploadProgressBlock:(IQProgressBlock*)uploadProgress downloadProgressBlock:(IQProgressBlock*)downloadProgress completionBlock:(IQDataCompletionBlock*)completion
{
    if (self = [super initWithRequest:request delegate:self startImmediately:NO])
    {
        [self setDelegateQueue:queue];
        _uploadProgress = *uploadProgress;
        _downloadProgress = *downloadProgress;
        _completion = *completion;
        _responseBlock = *responseBlock;
        
        _data = [[NSMutableData alloc] init];
    }
    return self;
}

-(void)sendDownloadProgress:(CGFloat)progress
{
    if (_downloadProgress && _response.expectedContentLength!=NSURLResponseUnknownLength)
    {
        if ([NSThread isMainThread])
        {
            _downloadProgress(progress);
        }
        else
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                _downloadProgress(progress);
            });
        }
    }
}

-(void)sendUploadProgress:(CGFloat)progress
{
    if (_uploadProgress)
    {
        if ([NSThread isMainThread])
        {
            _uploadProgress(progress);
        }
        else
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                _uploadProgress(progress);
            });
        }
    }
}

-(void)sendCompletionData:(NSData*)data error:(NSError*)error
{
    if (_completion)
    {
        if ([NSThread isMainThread])
        {
            _completion(data,error);
        }
        else
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                _completion(data,error);
            });
        }
    }
}

-(void)sendResponse:(NSURLResponse*)response
{
    if (_responseBlock)
    {
        if ([NSThread isMainThread])
        {
            _responseBlock(response);
        }
        else
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                _responseBlock(response);
            });
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _response = response;
    [self sendResponse:_response];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if (![httpResponse isKindOfClass:[NSHTTPURLResponse class]]) {
        // I don't know what kind of request this is!
        return;
    }
    
    NSLog(@"%@",httpResponse.allHeaderFields);
    NSLog(@"%d",httpResponse.statusCode);
    NSLog(@"%@",[NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode]);

    

    
    switch (httpResponse.statusCode) {
        case 206: {
            NSString *range = [httpResponse.allHeaderFields valueForKey:@"Content-Range"];
            NSError *error = nil;
            NSRegularExpression *regex = nil;
            
            // Check to see if the server returned a valid byte-range
            regex = [NSRegularExpression regularExpressionWithPattern:@"bytes (\\d+)-\\d+/\\d+"
                                                              options:NSRegularExpressionCaseInsensitive
                                                                error:&error];
            if (error) {
                break;
            }
            
            // If the regex didn't match the number of bytes, start the download from the beginning
            NSTextCheckingResult *match = [regex firstMatchInString:range
                                                            options:NSMatchingAnchored
                                                              range:NSMakeRange(0, range.length)];
            if (match.numberOfRanges < 2) {
                break;
            }
            
            // Extract the byte offset the server reported to us, and truncate our
            // file if it is starting us at "0".  Otherwise, seek our file to the
            // appropriate offset.
            NSString *byteStr = [range substringWithRange:[match rangeAtIndex:1]];
            NSInteger bytes = [byteStr integerValue];
            if (bytes <= 0) {
                break;
            } else {
            }
            break;
        }
            
        default:
            break;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
    
    [self sendDownloadProgress:((CGFloat)_data.length/(CGFloat)_response.expectedContentLength)];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self sendCompletionData:_data error:error];
}

-(void)cancel
{
    [super cancel];
    [self sendCompletionData:_data error:[NSError errorWithDomain:@"UserCancelDomain" code:100 userInfo:nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self sendCompletionData:_data error:nil];
}

- (void)connectionDidResumeDownloading:(NSURLConnection *)connection totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long) expectedTotalBytes
{
    NSLog(@"Resuming");
}

- (void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long) expectedTotalBytes
{
    [self sendDownloadProgress:((CGFloat)_data.length/(CGFloat)_response.expectedContentLength)];
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    [self sendUploadProgress:((CGFloat)totalBytesWritten/(CGFloat)totalBytesExpectedToWrite)];
}

@end
