//
//  CardManager.m
//  Coupit
//
//  Created by Vikas_headspire on 03/04/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "CardManager.h"

static CardManager *sharedInstance = nil;

@implementation CardManager {
    NSFileManager* mFileManager;
}

#pragma mark singleton class method
+ (CardManager *) getInstance
{
	@synchronized(self)
	{
		if(sharedInstance == nil)
		{
			sharedInstance = [[self alloc] init];
		}
	}
	
	return sharedInstance;
}

+ (id) allocWithZone:(NSZone*)zone
{
	@synchronized(self)
	{
		if(sharedInstance == nil)
		{
			sharedInstance = [super allocWithZone:zone];
			return sharedInstance;
		}
	}
	return nil;
}

- (id) init
{
	self = [super init];
	
	if (self != nil) {

	}
	return self;
}

- (id)copyWithZone:(NSZone*)zone
{
	return self;
}

-(void) changeDirectoryToWalletRoot {
    [mFileManager changeCurrentDirectoryPath: [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
}



@end


