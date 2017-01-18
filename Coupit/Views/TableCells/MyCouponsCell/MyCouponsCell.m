//
//  MyCouponsCell.m
//  Coupit
//
//  Created by Deepak Kumar on 17.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyCouponsCell.h"


@implementation MyCouponsCell
@synthesize mCodeLabel, mCouponDetailLabel, mValidDateLabel, mTitleLabel, mBarCodeImageView, mCouponImageView, mDeleteButton, mFavouriteButton, mPlannerButton, mTermsAndConditionButton, mRedeemButton, mSeperatorImageView, mButtonsView, mTimerValue, mRedeemSelectButton, mCouponCodeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib
{
	self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CALayer *tImageLayer = mBarCodeImageView.layer;
    [tImageLayer setCornerRadius:5];
    [tImageLayer setBorderWidth:0.8];
    [tImageLayer setMasksToBounds:YES];
    tImageLayer.borderColor = [UIColor colorWithRed:(230/255) green:(231/255) blue:(225/255) alpha:0.3].CGColor;

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
