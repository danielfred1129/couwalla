//
//  CouponsListCell.m
//  Coupit
//
//  Created by Deepak Kumar on 17.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CouponsListCell.h"


@implementation CouponsListCell
@synthesize mImageView, mTitleLabel, mCodeLabel, mCouponDetailLabel, mValidDateLabel, mCouponDiscountLabel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //Initialization code
    }
    return self;
}

-(void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
