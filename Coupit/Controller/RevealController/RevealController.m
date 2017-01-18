/*
 
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of Philip Kluz, 'zuui.org' nor the names of its contributors may
 be used to endorse or promote products derived from this software
 without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL PHILIP KLUZ BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */

#import "RevealController.h"
#import "CouponsViewController.h"
#import "ProfileViewController.h"
#import "NewWalletViewController.h"
#import "NewStoresViewController.h"
#import "FavouriteViewController.h"
#import "MyCouponViewController.h"
#import "LocationViewController.h"
#import "RewardViewController.h"
#import "CouponListViewController.h"
#import "SearchViewController.h"
#import "LoginViewController.h"
#import "FeedbackViewController.h"
#import "QRViewController.h"
#import "MenuViewController.h"
#import "CategoriesViewController.h"
#import "GTScrollNavigationBar.h"
#import "CouwallaHelpViewController.h"

@implementation RevealController
{
    CouponsViewController     *mObjCouponsViewController;
    ProfileViewController     *mObjProfileViewController;
    NewWalletViewController      *mObjWalletViewController;
    NewStoresViewController      *mObjNewStoresViewController;
    FavouriteViewController   *mObjFavouriteViewController;
    MyCouponViewController    *mObjMyCouponViewController;
    LocationViewController    *mObjLocationViewController;
    RewardViewController      *mObjRewardViewController;
    CouponListViewController  *mObjCouponListViewController;
    SearchViewController      *mObjSearchViewController;
    LoginViewController       *mObjLoginViewController;
    FeedbackViewController    *mObjFeedbackViewController;
    QRViewController          *mObjQRViewController;
    CategoriesViewController  *mObjCategoriesViewController;
    CouwallaHelpViewController *mObjCouwallaHelpViewController;
}

#pragma mark - Initialization

- (id)initWithFrontViewController:(UIViewController *)aFrontViewController rearViewController:(UIViewController *)aBackViewController
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithNavigationBarClass:[GTScrollNavigationBar class] toolbarClass:nil];
    [navigationController setViewControllers:[NSArray arrayWithObjects:aFrontViewController, nil]];
	self = [super initWithFrontViewController:navigationController rearViewController:aBackViewController];
	
	if (nil != self)
	{
        // mObjCouponsViewController = [CouponsViewController new];
        
        mObjCouponsViewController = (CouponsViewController *)aFrontViewController;
        mObjProfileViewController = [ProfileViewController new];
        mObjWalletViewController  = [NewWalletViewController new];
        mObjNewStoresViewController  = [NewStoresViewController new];
        mObjFavouriteViewController = [FavouriteViewController new];
        mObjMyCouponViewController  = [MyCouponViewController new];
        mObjLocationViewController  = [LocationViewController new];
        mObjRewardViewController    = [RewardViewController new];
        mObjCouponListViewController= [CouponListViewController new];
        mObjSearchViewController    = [SearchViewController new];
        mObjLoginViewController     = [LoginViewController new];
        mObjFeedbackViewController  = [FeedbackViewController new];
        mObjQRViewController        = [QRViewController new];
        mObjCategoriesViewController= [CategoriesViewController new];
        mObjCouwallaHelpViewController = [CouwallaHelpViewController new];
        
		self.delegate = self;
	}
	
	return self;
}

#pragma - ZUUIRevealControllerDelegate Protocol.

/*
 * All of the methods below are optional. You can use them to control the behavior of the ZUUIRevealController,
 * or react to certain events.
 */
- (BOOL)revealController:(ZUUIRevealController *)revealController shouldRevealRearViewController:(UIViewController *)rearViewController
{
	return YES;
}

- (BOOL)revealController:(ZUUIRevealController *)revealController shouldHideRearViewController:(UIViewController *)rearViewController
{
	return YES;
}

- (void)revealController:(ZUUIRevealController *)revealController willRevealRearViewController:(UIViewController *)rearViewController
{
	////NSLog(@"%@", NSStringFromSelector(_cmd));
    
    UIViewController *topViewController = ((UINavigationController *)revealController.frontViewController).topViewController;
    
    
        if ([topViewController isKindOfClass:[CouponsViewController class]])
        {
            [mObjCouponsViewController menuButtonSelected];
        }
        else if ([topViewController isKindOfClass:[ProfileViewController class]]) {
            [mObjProfileViewController menuButtonSelected];
        }
        else if ([topViewController isKindOfClass:[NewWalletViewController class]]) {
            [mObjWalletViewController menuButtonSelected];
        }
        
        else if ([topViewController isKindOfClass:[NewStoresViewController class]]){
            [mObjNewStoresViewController menuButtonSelected];
        }
        else if ([topViewController isKindOfClass:[FavouriteViewController class]]){
            [mObjFavouriteViewController menuButtonSelected];
        }
        else if ([topViewController isKindOfClass:[MyCouponViewController class]]){
            [mObjMyCouponViewController menuButtonSelected];
        }
        else if ([topViewController isKindOfClass:[LocationViewController class]]){
            [mObjLocationViewController menuButtonSelected];
        }
        else if ([topViewController isKindOfClass:[RewardViewController class]]){
            [mObjRewardViewController menuButtonSelected];
        }
        else if ([topViewController isKindOfClass:[CouponListViewController class]]){
            [mObjCouponListViewController menuButtonSelected];
        }
        else if ([topViewController isKindOfClass:[SearchViewController class]]){
            [mObjSearchViewController menuButtonSelected];
        }
        else if ([topViewController isKindOfClass:[FeedbackViewController class]]){
            [mObjFeedbackViewController menuButtonSelected];
        }
        else if ([topViewController isKindOfClass:[QRViewController class]]){
            //[mObjQRViewController menuButtonSelected];
        }
        else if ([topViewController isKindOfClass:[CategoriesViewController class]]){
            [mObjCategoriesViewController menuButtonSelected];
        }
        else if ([topViewController isKindOfClass:[CouwallaHelpViewController class]]){
            [mObjCouwallaHelpViewController menuButtonSelected];
        }
 
}

- (void)revealController:(ZUUIRevealController *)revealController didRevealRearViewController:(UIViewController *)rearViewController
{
	////NSLog(@"%@", NSStringFromSelector(_cmd));
    
     UIViewController *topViewController = ((UINavigationController *)revealController.frontViewController).topViewController;
    
    
    if ([topViewController isKindOfClass:[CouponsViewController class]]) {
        mObjCouponsViewController = ((CouponsViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjCouponsViewController menuButtonSelected];
        [mObjCouponsViewController showGestureView];
    }
    else if ([topViewController isKindOfClass:[ProfileViewController class]]) {
        mObjProfileViewController = ((ProfileViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
       // [mObjProfileViewController menuButtonSelected];
        [mObjProfileViewController showGestureView];
    }
    else if ([topViewController isKindOfClass:[NewWalletViewController class]]){
        mObjWalletViewController = ((NewWalletViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjWalletViewController menuButtonSelected];
        [mObjWalletViewController showGestureView];
    }
    else if ([topViewController isKindOfClass:[NewStoresViewController class]]){
        mObjNewStoresViewController = ((NewStoresViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjNewStoresViewController menuButtonSelected];
        [mObjNewStoresViewController showGestureView];
    }
    else if ([topViewController isKindOfClass:[FavouriteViewController class]]){
        mObjFavouriteViewController = ((FavouriteViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjFavouriteViewController menuButtonSelected];
        [mObjFavouriteViewController showGestureView];
    }
    else if ([topViewController isKindOfClass:[MyCouponViewController class]]){
        mObjMyCouponViewController = ((MyCouponViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjMyCouponViewController menuButtonSelected];
        [mObjMyCouponViewController showGestureView];
    }
    else if ([topViewController isKindOfClass:[LocationViewController class]]){
        mObjLocationViewController = ((LocationViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjLocationViewController menuButtonSelected];
        [mObjLocationViewController showGestureView];
    }
    else if ([topViewController isKindOfClass:[RewardViewController class]]){
        mObjRewardViewController = ((RewardViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjRewardViewController menuButtonSelected];
        [mObjRewardViewController showGestureView];
    }
    else if ([topViewController isKindOfClass:[CouponListViewController class]]) {
        mObjCouponListViewController = ((CouponListViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjCouponListViewController menuButtonSelected];
        [mObjCouponListViewController showGestureView];
    }
    else if ([topViewController isKindOfClass:[SearchViewController class]]) {
        mObjSearchViewController = ((SearchViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjSearchViewController menuButtonSelected];
        [mObjSearchViewController showGestureView];
    }
    else if ([topViewController isKindOfClass:[FeedbackViewController class]]) {
        mObjFeedbackViewController = ((FeedbackViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjFeedbackViewController menuButtonSelected];
        [mObjFeedbackViewController showGestureView];
    }
    else if ([topViewController isKindOfClass:[QRViewController class]]) {
        mObjQRViewController = ((QRViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        //[mObjQRViewController menuButtonSelected];
        //[mObjQRViewController showGestureView];
        
    }
    else if ([topViewController isKindOfClass:[CategoriesViewController class]])
     {
         if([((UINavigationController*)self.frontViewController).viewControllers count]<3)
         {
             mObjCategoriesViewController = ((CategoriesViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:1]);
         }
         else
         {
             mObjCategoriesViewController = ((CategoriesViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:2]);
             
         }
        
        [mObjCategoriesViewController menuButtonSelected];
        [mObjCategoriesViewController showGestureView];
    }
    else if ([topViewController isKindOfClass:[CouwallaHelpViewController class]])
    {
        mObjCouwallaHelpViewController = ((CouwallaHelpViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjCouwallaHelpViewController menuButtonSelected];
        [mObjCouwallaHelpViewController showGestureView];
    }
    
    
}

- (void)revealController:(ZUUIRevealController *)revealController willHideRearViewController:(UIViewController *)rearViewController
{
	////NSLog(@"%@", NSStringFromSelector(_cmd));
    
    UIViewController *topViewController = ((UINavigationController *)revealController.frontViewController).topViewController;
    
    if ([topViewController isKindOfClass:[CouponsViewController class]]) {
        mObjCouponsViewController = ((CouponsViewController*)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjCouponsViewController menuButtonUnselected];
    }
    else if ([topViewController isKindOfClass:[ProfileViewController class]]) {
        mObjProfileViewController = ((ProfileViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjProfileViewController menuButtonUnselected];
    }
    else if ([topViewController isKindOfClass:[NewWalletViewController class]]) {
        mObjWalletViewController = ((NewWalletViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjWalletViewController menuButtonUnselected];
    }
    else if ([topViewController isKindOfClass:[NewStoresViewController class]]){
        mObjNewStoresViewController = ((NewStoresViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjNewStoresViewController menuButtonUnselected];
    }
    else if ([topViewController isKindOfClass:[FavouriteViewController class]]){
        mObjFavouriteViewController = ((FavouriteViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjFavouriteViewController menuButtonUnselected];
    }
    else if ([topViewController isKindOfClass:[MyCouponViewController class]]){
        mObjMyCouponViewController = ((MyCouponViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjMyCouponViewController menuButtonUnselected];
    }
    else if ([topViewController isKindOfClass:[LocationViewController class]]){
        mObjLocationViewController = ((LocationViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjLocationViewController menuButtonUnselected];
    }
    else if ([topViewController isKindOfClass:[RewardViewController class]]){
        mObjRewardViewController = ((RewardViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjRewardViewController menuButtonUnselected];
    }
    else if ([topViewController isKindOfClass:[CouponListViewController class]]) {
        mObjCouponListViewController = ((CouponListViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjCouponListViewController menuButtonUnselected];
    }
    else if ([topViewController isKindOfClass:[SearchViewController class]]) {
        mObjSearchViewController = ((SearchViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjSearchViewController menuButtonUnselected];
    }
    else if ([topViewController isKindOfClass:[FeedbackViewController class]]) {
        mObjFeedbackViewController = ((FeedbackViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjFeedbackViewController menuButtonUnselected];
    }
    else if ([topViewController isKindOfClass:[QRViewController class]]) {
        mObjQRViewController = ((QRViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        //[mObjQRViewController menuButtonUnselected];
    }
    else if ([topViewController isKindOfClass:[CategoriesViewController class]]) {
        mObjCategoriesViewController = ((CategoriesViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:1]);
        
        [mObjCategoriesViewController menuButtonUnselected];
    }
    else if ([topViewController isKindOfClass:[CouwallaHelpViewController class]]) {
        mObjCouwallaHelpViewController = ((CouwallaHelpViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjCouwallaHelpViewController menuButtonUnselected];
    }

    
}

- (void)revealController:(ZUUIRevealController *)revealController didHideRearViewController:(UIViewController *)rearViewController
{
	////NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if ([((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[CouponsViewController class]]) {
        mObjCouponsViewController = ((CouponsViewController*)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjCouponsViewController menuButtonUnselected];
        [mObjCouponsViewController hideGestureView];
    }
    else if ([((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[ProfileViewController class]]) {
        mObjProfileViewController = ((ProfileViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjProfileViewController menuButtonUnselected];
        [mObjProfileViewController hideGestureView];
    }
    else if ([((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[NewWalletViewController class]]) {
        mObjWalletViewController = ((NewWalletViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjWalletViewController menuButtonUnselected];
        [mObjWalletViewController hideGestureView];
    }
    else if ([((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[NewStoresViewController class]]) {
        mObjNewStoresViewController = ((NewStoresViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjNewStoresViewController menuButtonUnselected];
        [mObjNewStoresViewController hideGestureView];
    }
    else if ([((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[FavouriteViewController class]]) {
        mObjFavouriteViewController = ((FavouriteViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjFavouriteViewController menuButtonUnselected];
        [mObjFavouriteViewController hideGestureView];
    }
    else if ([((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[MyCouponViewController class]]) {
        mObjMyCouponViewController = ((MyCouponViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjMyCouponViewController menuButtonUnselected];
        [mObjMyCouponViewController hideGestureView];
    }
    else if ([((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[LocationViewController class]]) {
        mObjLocationViewController = ((LocationViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjLocationViewController menuButtonUnselected];
        [mObjLocationViewController hideGestureView];
    }
    else if ([((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[RewardViewController class]]) {
        mObjRewardViewController = ((RewardViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjRewardViewController menuButtonUnselected];
        [mObjRewardViewController hideGestureView];
    }
    else if ([((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[CouponListViewController class]]) {
        mObjCouponListViewController = ((CouponListViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjCouponListViewController menuButtonUnselected];
        [mObjCouponListViewController hideGestureView];
    }
    else if ([((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[SearchViewController class]]) {
        mObjSearchViewController = ((SearchViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjSearchViewController menuButtonUnselected];
        [mObjSearchViewController hideGestureView];
    }
    else if ([((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[FeedbackViewController class]]) {
        mObjFeedbackViewController = ((FeedbackViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjFeedbackViewController menuButtonUnselected];
        [mObjFeedbackViewController hideGestureView];
    }
    else if ([((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[QRViewController class]]) {
        mObjQRViewController = ((QRViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        //[mObjQRViewController menuButtonUnselected];
        //[mObjQRViewController hideGestureView];
    }
    else if ([((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[CategoriesViewController class]])
    {
        mObjCategoriesViewController = ((CategoriesViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:1]);
        
        [mObjCategoriesViewController menuButtonUnselected];
        [mObjCategoriesViewController hideGestureView];
    }
    else if ([((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[CouwallaHelpViewController class]]) {
        mObjCouwallaHelpViewController = ((CouwallaHelpViewController *)[((UINavigationController*)self.frontViewController).viewControllers objectAtIndex:0]);
        
        [mObjCouwallaHelpViewController menuButtonUnselected];
        [mObjCouwallaHelpViewController hideGestureView];
    }

}


//- (void)setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation
//{
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//
//}

- (void)revealController:(ZUUIRevealController *)revealController willResignRearViewControllerPresentationMode:(UIViewController *)rearViewController
{
	//NSLog(@"Testt1");
}

- (void)revealController:(ZUUIRevealController *)revealController didResignRearViewControllerPresentationMode:(UIViewController *)rearViewController
{
	//NSLog(@"Testt2");
}

- (void)revealController:(ZUUIRevealController *)revealController willEnterRearViewControllerPresentationMode:(UIViewController *)rearViewController
{
	//NSLog(@"Testt3");
}

- (void)revealController:(ZUUIRevealController *)revealController didEnterRearViewControllerPresentationMode:(UIViewController *)rearViewController
{
	//NSLog(@"Testt4");
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end