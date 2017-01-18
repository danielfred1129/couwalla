//
//  CouponView.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CouponView : BaseViewController

@property (nonatomic, retain) IBOutlet UIButton *mItemButton;

@property (strong, nonatomic) IBOutlet UILabel *mButtomLable;
@property (strong, nonatomic) IBOutlet UILabel *mTopRightLabel;
@property (strong, nonatomic) IBOutlet UIView *mTopRightView;

@end
