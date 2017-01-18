//
//  NewLoginViewController.h
//  Coupit
//
//  Created by Canopus 4 on 19/05/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQDropDownTextField.h"

@interface NewLoginViewController : BaseViewController
@property (weak, nonatomic) IBOutlet IQDropDownTextField *genderTextfd;
- (BOOL)shouldAutorotate;
@end
