//
//  StoreMapOverlayView.m
//  Coupit
//
//  Created by Deepak Kumar on 3/21/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "StoreMapOverlayView.h"

@interface StoreMapOverlayView ()

@end

@implementation StoreMapOverlayView

@synthesize mActiveCouponCount, mStoreName, mDistance, mThumbnail, mCheckIn, mAddress;
@synthesize mActiveCouponCountLabel, mStoreNameLabel, mDistanceLabel, mImagePath, mAddressLabel;

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
    // Do any additional setup after loading the view from its nib.
    mStoreName.text = mStoreNameLabel;
    mDistance.text = mDistanceLabel;
    mActiveCouponCount.text = mActiveCouponCountLabel;
    
    if (mImagePath) {
        [self.mThumbnail setImage:[UIImage imageWithContentsOfFile:mImagePath]];
    }
    else{
        [self.mThumbnail setImage:[UIImage imageNamed:@"t_MyCoupons"]];
    }
    mAddress.text = mAddressLabel;


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
