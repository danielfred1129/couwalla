//
//  CouponRedeemViewerViewController.h
//  Coupit
//
//  Created by Raphael Caixeta on 12/20/13.
//  Copyright (c) 2013 Home. All rights reserved.

#import <UIKit/UIKit.h>
#import "jsonparse.h"
#import "appcommon.h"
#import "GREST.h"
#import "RequestHandler.h"
#import "BaseViewController.h"

@interface CouponRedeemViewerViewController : UIViewController <GRESTDelegate> {
    
    IBOutlet UIImageView *couponView;
    IBOutlet UILabel *actualCodeView;
    
    GREST *api;
    
    UILabel *namelabel;
    NSTimer *timer;

    
}

- (NSString *)generateRandomString;

@property(nonatomic, retain) NSString *couponid;
@property(nonatomic, retain) UIImage *couponImage;
@property(nonatomic, retain) UILabel *namelabel;


- (IBAction)actionOnTearmCondition:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *tacbutton;

@property (weak, nonatomic) IBOutlet UIImageView *storenbrandImageView;

@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;

@property (weak, nonatomic) IBOutlet UILabel *storenbrandNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponSubDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *validLabel;
@property (weak, nonatomic) IBOutlet UILabel *barcodeNumberlabel;

@end