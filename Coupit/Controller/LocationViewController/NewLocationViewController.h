//
//  NewLocationViewController.h
//  Coupit
//
//  Created by Hashim on 23/06/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewLocationViewController : BaseViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textFieldOtherZip;
@property (strong, nonatomic) IBOutlet UITextField *textFieldHomeZip;
@property (strong, nonatomic) IBOutlet UILabel *labelOtherZipCode;
@property (strong, nonatomic) IBOutlet UILabel *labelHomeZipCode;
@property (strong, nonatomic) IBOutlet UIButton *useCurrentLocationButon;
@property (strong, nonatomic) IBOutlet UIButton *useHomeZipLocationButton;
@property (strong, nonatomic) IBOutlet UIButton *useOtherZipLocationCode;

@end
