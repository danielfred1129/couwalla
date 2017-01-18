//
//  CouponsListCell.h
//  Coupit
//
//  Created by Deepak Kumar on 17.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CouponsListCell : UITableViewCell

@property(unsafe_unretained, nonatomic) IBOutlet UIImageView *mImageView;
@property(unsafe_unretained, nonatomic) IBOutlet UILabel *mTitleLabel;
@property(unsafe_unretained, nonatomic) IBOutlet UILabel *mCodeLabel;
@property(unsafe_unretained, nonatomic) IBOutlet UILabel *mCouponDetailLabel;
@property(unsafe_unretained, nonatomic) IBOutlet UILabel *mValidDateLabel;
@property(unsafe_unretained, nonatomic) IBOutlet UILabel *mCouponDiscountLabel;


@end


