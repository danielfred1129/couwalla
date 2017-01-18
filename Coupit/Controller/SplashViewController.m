//
//  SplashViewController.m
//  Coupit
//
//  Created by Canopus5 on 7/22/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "SplashViewController.h"
#import "AppDelegate.h"

@interface SplashViewController ()
{
    BOOL isStatusBarHidden;
}

@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    isStatusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    
    [self performSelector:@selector(startFirstLoadAnimation) withObject:nil afterDelay:3.0];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startFirstLoadAnimation
{
    [super startFirstLoadAnimation];
    
    //For performing the animations
    {
        [UIView animateWithDuration:3.0 animations:^{
            
        } completion:^(BOOL finished)
         {
             isStatusBarHidden = NO;
             [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
             
             //iOS 7
             if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
                 [self setNeedsStatusBarAppearanceUpdate];
             
             AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
             [appDelegate loginViewController:nil loginStatus:([[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"] != nil)];

         }];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
