//
//  NewMyCouponsCell.m
//  Coupit
//
//  Created by Canopus5 on 6/9/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "NewMyCouponsCell.h"

@implementation NewMyCouponsCell
@synthesize imageView,titleLabel,discriptionLabel,offerLabel,validLabel;

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
    
    [imageView.layer setBorderWidth:10.0];
    imageView.layer.borderColor = [UIColor redColor].CGColor;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
