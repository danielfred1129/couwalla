//
//  MenuProfileCell.h
//  Coupit
//
//  Created by Deepak Kumar on 17.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *mImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *mSelectedImageView;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *mTitleLabel;

@end
