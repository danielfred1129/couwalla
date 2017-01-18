//
//  CouponView.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CouponView.h"
#import <QuartzCore/QuartzCore.h>


@implementation CouponView
@synthesize mItemButton,mButtomLable,mTopRightLabel,mTopRightView;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
   self.view.layer.cornerRadius = 0;//half of the width
    self.view.layer.borderColor=[UIColor colorWithRed:(230/255) green:(231/255) blue:(225/255) alpha:0.3].CGColor;
    self.view.layer.borderWidth=1.0f;
    
    [self.view addSubview:mItemButton];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}





@end

