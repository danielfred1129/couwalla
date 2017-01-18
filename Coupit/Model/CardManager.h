//
//  CardManager.h
//  Coupit
//
//  Created by Vikas_headspire on 03/04/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

#define kWalletRootDirectory @"wallet-cards"
#define kGiftCardRootDirectory kWalletRootDirectory @"/gift-cards"
#define kLoyaltyCardRootDirectory kWalletRootDirectory @"/loyalty-cards"
#define kFrontPhotoFileName @"front.jpeg"
#define kBackPhotoFileName @"back.jpeg"

@interface CardManager : NSObject
    
+ (CardManager *) getInstance;


@end
