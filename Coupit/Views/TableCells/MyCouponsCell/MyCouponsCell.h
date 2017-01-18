//
//  MyCouponsCell.h
//  Coupit
//
//  Created by Deepak Kumar on 17.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface MyCouponsCell : UITableViewCell

@property(unsafe_unretained, nonatomic) IBOutlet UIImageView *mCouponImageView;
@property(unsafe_unretained, nonatomic) IBOutlet UIImageView *mBarCodeImageView;
@property(unsafe_unretained, nonatomic) IBOutlet UILabel *mTitleLabel;
@property(unsafe_unretained, nonatomic) IBOutlet UILabel *mCodeLabel;
@property(unsafe_unretained, nonatomic) IBOutlet UILabel *mCouponCodeLabel;
@property(unsafe_unretained, nonatomic) IBOutlet UILabel *mCouponDetailLabel;
@property(unsafe_unretained, nonatomic) IBOutlet UILabel *mValidDateLabel;
@property(unsafe_unretained, nonatomic) IBOutlet UIButton *mFavouriteButton;
@property(unsafe_unretained, nonatomic) IBOutlet UIButton *mPlannerButton;
@property(unsafe_unretained, nonatomic) IBOutlet UIButton *mDeleteButton;
@property(unsafe_unretained, nonatomic) IBOutlet UIButton *mTermsAndConditionButton;
@property(unsafe_unretained, nonatomic) IBOutlet UIButton *mRedeemButton;
@property(unsafe_unretained, nonatomic) IBOutlet UIButton *mRedeemSelectButton;
@property(unsafe_unretained, nonatomic) IBOutlet UIImageView *mSeperatorImageView;
@property(unsafe_unretained, nonatomic) IBOutlet UIView *mButtonsView;
@property(unsafe_unretained, nonatomic) IBOutlet UILabel *mTimerValue;





@end
