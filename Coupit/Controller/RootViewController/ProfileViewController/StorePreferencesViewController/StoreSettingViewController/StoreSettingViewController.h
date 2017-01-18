//
//  StoreSettingViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StorePreferences.h"

@interface StoreSettingViewController : UITableViewController {

}
@property (nonatomic, retain) NSString *mStoreName;
@property (nonatomic, retain) NSString *mBrandName;
@property (nonatomic, retain) IBOutlet UIView *mPickerOverlayView;
@property (nonatomic, retain) IBOutlet UIPickerView *mPickerView;
@property (nonatomic, retain) StorePreferences *mStorePreferencesSetting;
@property StorePreferencesType mStorePreferencesType;


- (void) getStoreWithStoreID:(NSString *)pStoreID withBrandID:(NSString *)pBrandID withEntityType:(NSInteger)pEntityType;

- (IBAction) doneButton:(id)sender;
- (IBAction) cancelButton:(id)sender;
@end
