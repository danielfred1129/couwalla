//
//  ProfileItem.h
//  Coupit
//
//  Created by Deepak Kumar on 2/5/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileItem : NSObject

@property (nonatomic, retain) NSString *mTitle;
@property (nonatomic, retain) NSString *mValue;
@property (nonatomic, retain) NSString *mServerKey;
@property BOOL mIsUpdate;

- (id)initWithTitle:(NSString *)pTitle value:(NSString *)pValue serverKey:(NSString *)pKey;

@end
