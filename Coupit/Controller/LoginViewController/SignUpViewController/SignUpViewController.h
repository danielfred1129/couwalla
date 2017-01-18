//
//  SignUpViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestHandler.h"
#import "Subscriber.h"
#import <FacebookSDK/FacebookSDK.h>
#import "User.h"
typedef enum {
    kCountrySelected,
    kEthnicitySelected
}PickerViewSelected;


@interface SignUpViewController : UITableViewController<UITextFieldDelegate, UIAlertViewDelegate>


@property (nonatomic, retain) IBOutlet UIView *mPickerOverlayView;
@property (nonatomic, retain) IBOutlet UIPickerView *mPickerView;

@property (nonatomic, retain) IBOutlet UIView *mDatePickerOverlayView;
@property (nonatomic, retain) IBOutlet UIDatePicker *mDatePickerView;
@property PickerViewSelected mPickerSelected;
@property (nonatomic,retain) UIButton *privicyCheckeButton,*termsandConditionsButton;
@property (nonatomic, retain) IBOutlet UIView *SubmitView;
- (IBAction) cancelButton:(id)sender;
- (IBAction)doneButton:(id)sender;
- (IBAction)submitButton:(id)sender;
- (IBAction)dateChanged:(id)sender;
- (IBAction)privacyPolicy:(id)sender;
- (void) setUser:(User *)pUser;
-(IBAction)PrivacyChanged:(id)sender;

@end
