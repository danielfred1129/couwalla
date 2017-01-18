//
//  CouponDetailCell.m
//  Coupit
//
//  Created by Deepak Kumar on 17.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CouponDetailCell.h"


@implementation CouponDetailCell
@synthesize mValidDateLabel, mCouponDetailLabel, mCouponCodeLabel, mCouponOfferLabel, mCouponTitleLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib {
	self.selectionStyle = UITableViewCellSelectionStyleNone;
    
     
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
