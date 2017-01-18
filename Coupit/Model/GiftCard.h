//
//  GiftCard.h
//  Coupit
//
//  Created by Vikas_headspire on 08/04/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftCard : NSObject

@property (nonatomic, retain) UIImage *mFrontImageLocal;
@property (nonatomic, retain) UIImage *mBackImageLocal;
@property (nonatomic, retain) NSString *mID;
@property CardType mCardType;
@property BOOL mIsFlip;

@end
