//
//  ProgressHudPresenter.m
//  Coupit
//
//  Created by Eric Wilson on 03.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProgressHudPresenter.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "RequestHandler.h"

@implementation ProgressHudPresenter
{
    MBProgressHUD* progressHud;
}

+(instancetype)sharedHUD
{
    static ProgressHudPresenter *sharedInstance = nil;
    
    if (sharedInstance == nil)
    {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}


-(id)init {
    if (self = [super init]) {
        progressHud = [[MBProgressHUD alloc] initWithWindow:((AppDelegate *)[UIApplication sharedApplication].delegate).window];
        progressHud.mode = MBProgressHUDModeIndeterminate;
        progressHud.animationType = MBProgressHUDAnimationZoom;
        progressHud.labelText = NSLocalizedString(@"Loading", @"Loading"); //Default text
    }
    return self;
}

-(void)setTitle:(NSString *)title
{
    progressHud.labelText = title;
}

-(NSString*)title
{
    return progressHud.labelText;
}

-(void)presentHud {
    
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    //    NSLog(@"%@",window);
    [window addSubview:progressHud];
    [progressHud show:YES];
}

-(void)presentHud:(UIView *)pView {
    [pView addSubview:progressHud];
    [progressHud show:YES];
}

-(void)hideHud {
    
    //    if ([[RequestHandler getInstance] currentRequestCount] == 0)
    {
        [progressHud removeFromSuperview];
        [progressHud hide:YES];
        //        NSLog(@"%@",NSStringFromSelector(_cmd));
    }
    //    else
    //    {
    //        NSLog(@"Counter: %d",[[RequestHandler getInstance] currentRequestCount]);
    //    }
}

- (void) showSuccessHUD
{
    //[self hideHud];
    progressHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    progressHud.labelText = kCouponDownloadedMessage;
    progressHud.mode = MBProgressHUDModeCustomView;
    //[self presentHud];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideHud) userInfo:nil repeats:NO];
}


@end
