//
//  NewMyCouponsCell.h
//  Coupit
//
//  Created by Canopus5 on 6/9/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMyCouponsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *couponImage;
@property (weak, nonatomic) IBOutlet UIButton *redeemButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *discriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerLabel;
@property (weak, nonatomic) IBOutlet UILabel *validLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkMarkButton;


@end
