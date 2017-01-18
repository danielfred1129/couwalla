//
//  Created by Mohd Iftekhar Qurashi on 29/12/13.
//  Copyright (c) 2013 Iftekhar. All rights reserved.
//

#import <Foundation/NSURLConnection.h>
#import "IQWebServiceConstants.h"


@interface IQURLConnection : NSURLConnection

+ (IQURLConnection*)sendAsynchronousRequest:(NSURLRequest *)request responseBlock:(IQResponseBlock)responseBlock uploadProgressBlock:(IQProgressBlock)uploadProgress downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDataCompletionBlock)completion;

-(id)initWithRequest:(NSURLRequest *)request responseBlock:(IQResponseBlock*)responseBlock uploadProgressBlock:(IQProgressBlock*)uploadProgress downloadProgressBlock:(IQProgressBlock*)downloadProgress completionBlock:(IQDataCompletionBlock*)completion;

@end
