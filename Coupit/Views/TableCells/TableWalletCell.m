//
//  TableWalletCell.m
//  Coupit
//
//  Created by Canopus5 on 7/7/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "TableWalletCell.h"

@implementation TableWalletCell
@synthesize imageViewWallet,barcodeWallet,cardNameWallet;

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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
