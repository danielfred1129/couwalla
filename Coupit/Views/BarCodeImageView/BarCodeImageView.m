//
//  BarCodeImageView.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "BarCodeImageView.h"
#import <QuartzCore/QuartzCore.h>


@implementation BarCodeImageView
@synthesize mImageView, mBarCodeImageView,mCardDescriptionLabel, mCardNumberLabel, mCardTitleLabel;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    mBarCodeImageView.backgroundColor = [UIColor blackColor];
    
    
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

