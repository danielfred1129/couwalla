//
//  RedeemAllCell.h
//  Coupit
//
//  Created by Canopus5 on 6/16/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedeemAllCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *barCodeTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *tncButton;
@property (weak, nonatomic) IBOutlet UIView *imageBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *barImageView;
@property (weak, nonatomic) IBOutlet UILabel *barNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *hideLabel;

@end
