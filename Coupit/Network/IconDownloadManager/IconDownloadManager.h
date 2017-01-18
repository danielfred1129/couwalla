//
//  IconDownloadManager.h
//  Coupit
//
//  Created by Deepak Kumar on 3/6/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IconDownloader.h"

@class IconDownloadManager;

@protocol IconDownloadManagerDelegate
- (void) iconDownloadManager:(IconDownloadManager *)pIconDownloadManager indexPath:(NSIndexPath *)pIndexPath;

@end

@interface IconDownloadManager : NSObject<IconDownloaderDelegate>

+ (IconDownloadManager *) getInstance;

- (void) setScreen:(ScreenType)pScreenType delegate:(id)pDelegate filePath:(NSString *)pFilePath iconID:(NSString *)pIconID indexPath:(NSIndexPath *)pIndexPath;

- (void) startIconDownload:(Icon *)pIcon;
- (BOOL) checkInternet;

@end
