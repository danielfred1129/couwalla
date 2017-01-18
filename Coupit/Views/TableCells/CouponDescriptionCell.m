//
//  CouponDescriptionCell.m
//  Coupit
//
//  Created by Vikas_headspire on 07/03/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "CouponDescriptionCell.h"

@implementation CouponDescriptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews{
    CGSize size = self.bounds.size;
    CGPoint tPoint = self.bounds.origin;
    [self.textLabel setFrame:CGRectMake(15, tPoint.y, size.width-25, size.height)];
    
}

@end
