//
//  EditProfileCell.h
//  Coupit
//
//  Created by  on 10/2/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileItem.h"

@interface EditProfileCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, retain) UITextField *inputField;
@property (nonatomic, strong) ProfileItem *profileItem;

@end
