//
//  EditProfileListCell.h
//  Coupit
//
//  Created by Canopus 4 on 14/05/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQDropDownTextField.h"

@class ProfileItem;

@interface EditProfileListCell : UITableViewCell

@property (nonatomic, retain) IQDropDownTextField *inputField;
@property (nonatomic, strong) ProfileItem *profileItem;

@end
