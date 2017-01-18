//
//  MenuViewController.h
//  iTestPro
//
//  Created by Deepak Kumar on 2/3/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponsViewController.h"
#import "LoginViewController.h"


@interface MenuViewController : BaseViewController <UITextFieldDelegate>{
    
}
@property (strong, nonatomic) IBOutlet UIView *bgViewForLocation;

@property (unsafe_unretained, nonatomic) IBOutlet UITableView *mTableView;
@property (unsafe_unretained, nonatomic) IBOutlet UISearchBar *mSearchBar;
@property (nonatomic, retain) CouponsViewController *mObjCouponsViewController;
@property (strong, nonatomic) IBOutlet UIButton *btnBackForOverlay;
@property (strong, nonatomic) IBOutlet UITextField *textFieldOtherZip;

@property (strong, nonatomic) IBOutlet UILabel *labelOtherZipCode;
@property (strong, nonatomic) IBOutlet UIButton *useCurrentLocationButon;
@property (strong, nonatomic) IBOutlet UIButton *useHomeZipLocationButton;
@property (strong, nonatomic) IBOutlet UIButton *useOtherZipLocationCode;
-(IBAction)selectButtonAction:(UIButton *)sender;
- (void) notificationDictionary:(NSDictionary *)pDict;

- (void) showOverlayView;
- (void) hideOverlayView;

@end
