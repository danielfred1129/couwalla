//
//  common.m
//  myproject
//
//  Created by GenieMAC2 on 11/29/13.
//  Copyright (c) 2013 GenieMAC2. All rights reserved.
//

#import "jsonparse.h"

@implementation jsonparse

//function for geeting json value of a url and send return value

-(NSMutableDictionary*) customejsonParsing: (NSMutableString*)urlString bodydata:(NSMutableDictionary*)bodydata
{
    
    @try
    {
    // convert string url into url variable
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:100.0];
    
    NSError *error;
    
    [request setTimeoutInterval:100.0];
    
    [request setURL:url];
    
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    //define body for sending with request
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"data\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *paramsJSONDictionaryData = [NSJSONSerialization dataWithJSONObject:bodydata options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonParamsString = [[NSString alloc] initWithData:paramsJSONDictionaryData encoding:NSUTF8StringEncoding];
    
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",jsonParamsString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];  // set body into request
    
    //end of setting body here
    
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] init];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSMutableDictionary *jsonResponseDictionary;
        if(responseData!=nil)
            jsonResponseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
          //  //NSLog(@" jsondata %@", jsonResponseDictionary);
        return jsonResponseDictionary;
    }
    @catch (NSException *exception) {
        //NSLog(@" exception %@", exception.reason);
        
    }
    
    // //NSLog(@"I am in common class%@",jsonResponseDictionary);

}

@end
