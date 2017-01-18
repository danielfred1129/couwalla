//
//  StoreListCell.h
//  Coupit
//
//  Created by Deepak Kumar on 17.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreListCell : UITableViewCell

@property(unsafe_unretained, nonatomic) IBOutlet UIImageView *mImageView;
@property(unsafe_unretained, nonatomic) IBOutlet UILabel *mStoreTitleLabel;
@property(unsafe_unretained, nonatomic) IBOutlet UILabel *mActiveCouponsLabel;
@property(unsafe_unretained, nonatomic) IBOutlet UILabel *mDistanceLabel;
@property(unsafe_unretained, nonatomic) IBOutlet UIButton *mCheckInButton;
@property(unsafe_unretained, nonatomic) IBOutlet UILabel *mDiscountLabel;
@property(unsafe_unretained, nonatomic) IBOutlet UIImageView *mSeperatorImageView;



@end
