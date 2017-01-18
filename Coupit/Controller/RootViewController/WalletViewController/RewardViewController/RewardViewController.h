//
//  RewardViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloadManager.h"


@interface RewardViewController : BaseViewController<IconDownloadManagerDelegate> {

}

@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) IBOutlet UIImageView *mCardImageView;
@property (nonatomic, retain) IBOutlet UILabel *mRewardCardLabel;
@property (nonatomic, retain) IBOutlet UILabel *mValidFromLabel;
@property (nonatomic, retain) IBOutlet UILabel *mValidTillLabel;
@property (nonatomic, retain) IBOutlet UILabel *mNameLabel;



-(void)showGestureView;
-(void)hideGestureView;
-(void)menuButtonSelected;
-(void)menuButtonUnselected;

- (IBAction) redeemPoints:(UIButton *)pSender;
- (void) notificationDictionary:(NSDictionary *)pDict;

@end
