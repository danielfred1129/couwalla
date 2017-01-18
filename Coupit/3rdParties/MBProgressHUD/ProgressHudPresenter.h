//
//  ProgressHudPresenter.h
//  Coupit
//
//  Created by Eric Wilson on 03.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressHudPresenter : NSObject

@property(nonatomic, retain) NSString* title;

+(instancetype)sharedHUD;

-(void)presentHud;
-(void)presentHud:(UIView *)pView;

-(void)hideHud;
-(void) showSuccessHUD;

@end
