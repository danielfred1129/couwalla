//
//  RedeemAllCell.m
//  Coupit
//
//  Created by Canopus5 on 6/16/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "RedeemAllCell.h"
#import "UIColor+AppTheme.h"

@implementation RedeemAllCell

@synthesize barCodeTitleLabel,tncButton,imageBackgroundView,barImageView,barNumberLabel,hideLabel;

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
    imageBackgroundView.layer.cornerRadius=7.0f;
    
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:tncButton.titleLabel.text];
    
    NSRange rangeTermsAndConditions = [string.string rangeOfString:@"*TERMS & CONDITIONS APPLY" options:NSRegularExpressionCaseInsensitive];
    
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:NSUnderlineStyleSingle],NSUnderlineStyleAttributeName,[UIColor appGreenColor],NSUnderlineColorAttributeName,[UIColor appGreenColor],NSForegroundColorAttributeName, nil];
    [string setAttributes:attribute range:rangeTermsAndConditions];
    tncButton.titleLabel.attributedText = string;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
