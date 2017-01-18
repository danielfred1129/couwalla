//
//  LoginViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestHandler.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CouponsViewController.h"
#import "MBProgressHUD.h"
#import "GREST.h"

@class LoginViewController;
@protocol LoginViewControllerDelegate
- (void) loginViewController:(LoginViewController *)pController loginStatus:(BOOL)pBool;
@end

@interface LoginViewController : BaseViewController<UITextFieldDelegate, RequestHandlerDelegate,MBProgressHUDDelegate, GRESTDelegate>

@property (nonatomic, retain) id <LoginViewControllerDelegate> mDelegate;

@property BOOL mIsLogOut;
@property BOOL mIsPasswordChange;

@end
