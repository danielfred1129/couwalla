//
//  TableWalletCell.h
//  Coupit
//
//  Created by Canopus5 on 7/7/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableWalletCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewWallet;
@property (weak, nonatomic) IBOutlet UILabel *cardNameWallet;
@property (weak, nonatomic) IBOutlet UILabel *barcodeWallet;

@end
