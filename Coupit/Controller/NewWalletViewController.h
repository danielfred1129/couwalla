//
//  NewWalletViewController.h
//  Coupit
//
//  Created by Raphael Caixeta on 1/29/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraViewController.h"
#import "iCarousel.h"
#import "RequestHandler.h"
#import "IconDownloadManager.h"
#import "PageControl.h"
#import "Repository.h"

#import "WalletCardView.h"
#import "CardManager.h"
#import "Card.h"
#import "FileUtils.h"
#import "AppDelegate.h"
#import "MyCouponsCell.h"
#import "Coupon.h"
#import "FileUtils.h"
#import "WebViewController.h"
#import "AppDelegate.h"
#import "BarCodeImageView.h"
#import "RedeemCouponViewController.h"

#import "CreateNewCardViewController.h"
#import "ZeeSQLiteHelper.h"
#import "WalletCardViewerViewController.h"

@interface NewWalletViewController : BaseViewController <UIAlertViewDelegate> {
    
    IBOutlet UITableView *mainTable;
    
    NSMutableArray *listofCards;
    
}

-(void)showGestureView;
-(void)hideGestureView;
-(void)menuButtonSelected;
-(void)menuButtonUnselected;

- (void)addCard:(id)sender;
- (void)reload;

@end
