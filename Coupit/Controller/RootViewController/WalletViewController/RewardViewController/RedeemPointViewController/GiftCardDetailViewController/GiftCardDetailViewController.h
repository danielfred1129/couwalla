//
//  CouponDetailViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestHandler.h"
#import "IconDownloadManager.h"

#import "GiftCards.h"

@interface GiftCardDetailViewController : BaseViewController<UIActionSheetDelegate, IconDownloadManagerDelegate, RequestHandlerDelegate>

@property (nonatomic, retain) IBOutlet UITableView *mTableView;

@property (nonatomic, retain) IBOutlet UILabel *mShortPromoLabel;
@property (nonatomic, retain) IBOutlet UILabel *mLongPromoLabel;
@property (nonatomic, retain) IBOutlet UILabel *mPointExceedLabel;

@property (nonatomic, retain) IBOutlet UIButton *mSubmitButton;


@property (nonatomic, retain) IBOutlet UIImageView *mFullImageView;

@property (nonatomic, retain) IBOutlet UIView *mPickerOverlayView;
@property (nonatomic, retain) IBOutlet UIPickerView *mPickerView;

@property (nonatomic, retain) GiftCards *mGiftCard;


- (IBAction) submitGiftCard:(id)sender;
- (IBAction) tearmAndConditionButton:(id)sender;

- (IBAction) doneButton:(id)sender;
- (IBAction) cancelButton:(id)sender;

@end
