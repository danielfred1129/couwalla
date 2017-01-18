//
//  AES.h
//  KeyChain
//
//  Created by Deepak Kumar on 29/09/11.
//  COPYRIGHT © 2011 ALCATEL-LUCENT. ALL RIGHTS RESERVED.
//

#import <UIKit/UIKit.h>


@interface NSData (AES256) 

- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

+ (NSData *) encryptString:(NSString *)pString key:(NSString *)pKey;
+ (NSString *) decryptData:(NSData *)pData key:(NSString *)pKey;

@end
