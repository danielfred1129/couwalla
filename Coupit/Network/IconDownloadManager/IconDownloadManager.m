//
//  IconDownloadManager.m
//  Coupit
//
//  Created by Deepak Kumar on 3/6/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "IconDownloadManager.h"
#import "Reachability.h"
#import "Icon.h"

@implementation IconDownloadManager
{
    NSMutableDictionary *mIconDownloaderDict;
    NSMutableDictionary *mDelegateDictionary;
}

static IconDownloadManager *sharedInstance = nil;
#pragma mark IconDownloadManager singleton class method
+ (IconDownloadManager *) getInstance
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

- (void) setScreen:(ScreenType)pScreenType delegate:(id)pDelegate filePath:(NSString *)pFilePath iconID:(NSString *)pIconID indexPath:(NSIndexPath *)pIndexPath
{
    if ([self checkInternet]) {
        
        if (!mDelegateDictionary) {
            mDelegateDictionary = [NSMutableDictionary dictionary];
        }
        
        //pIconID:(null) x.x.x
        
        id tDelegate = [mDelegateDictionary objectForKey:pIconID];

        
        if (tDelegate == nil){
            [mDelegateDictionary setObject:pDelegate forKey:pIconID];
        }
    
        Icon *tIcon = [Icon new];
        tIcon.mIconID = pIconID;

        tIcon.mIndexPath = pIndexPath;
        tIcon.mFileURL = pFilePath;
        tIcon.mScreenType = pScreenType;

        [self startIconDownload:tIcon];
	}
}

- (void) startIconDownload:(Icon *)pIcon
{
    if (!mIconDownloaderDict) {
        mIconDownloaderDict = [NSMutableDictionary dictionary];
    }
    IconDownloader *iconDownloader = [mIconDownloaderDict objectForKey:pIcon.mIconID];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.mIcon = pIcon;
        iconDownloader.mDelegate = self;
        [mIconDownloaderDict setObject:iconDownloader forKey:pIcon.mIconID];
        [iconDownloader startDownload];
        // [iconDownloader release];
    } 
}

- (void)appImageDidLoad:(Icon *)pIcon
{
    IconDownloader *iconDownloader = [mIconDownloaderDict objectForKey:pIcon.mIconID];
    if (iconDownloader != nil)
    {
        //NSString *tKeyString = [NSString stringWithFormat:@"k_ScreenDelegate%d", pIcon.mScreenType];
        
        id tDelegate = [mDelegateDictionary objectForKey:pIcon.mIconID];
        
        if (tDelegate != nil)
        {
            [tDelegate iconDownloadManager:self indexPath:pIcon.mIndexPath];
            [mDelegateDictionary removeObjectForKey:pIcon.mIconID];
            [mIconDownloaderDict removeObjectForKey:pIcon.mIconID];
        }
    }
}

#pragma mark -
#pragma mark InternetCheckMethods
- (BOOL) checkInternet{
    
	return YES;
}



@end
