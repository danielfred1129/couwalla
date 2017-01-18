//
//  CouponDetailCell.h
//  Coupit
//
//  Created by Deepak Kumar on 17.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CouponDetailCell : UITableViewCell

@property(unsafe_unretained, nonatomic) IBOutlet UILabel *mCouponTitleLabel;
@property(unsafe_unretained, nonatomic) IBOutlet UILabel *mCouponCodeLabel;
@property(unsafe_unretained, nonatomic) IBOutlet UILabel *mCouponDetailLabel;
@property(unsafe_unretained, nonatomic) IBOutlet UILabel *mCouponOfferLabel;
@property(unsafe_unretained, nonatomic) IBOutlet UILabel *mValidDateLabel;

@end
