//
//  Icon.h
//  Coupit
//
//  Created by Deepak Kumar on 3/6/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Icon : NSObject

@property (nonatomic, retain) NSString *mIconID;
@property (nonatomic, retain) NSString *mFileURL;
@property (nonatomic, retain) NSIndexPath *mIndexPath;
@property ScreenType mScreenType;

@end


