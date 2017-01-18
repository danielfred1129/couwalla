//
//  Groups.h
//  Coupit
//
//  Created by Deepak Kumar on 3/4/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Groups : NSObject

@property (nonatomic, retain) NSString *mName;
@property GroupType mGroupType;

- (id)initGroupName:(NSString *)pName groupType:(GroupType)pGroupType;

@end
