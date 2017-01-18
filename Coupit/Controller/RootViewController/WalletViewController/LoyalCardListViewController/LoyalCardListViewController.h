//
//  LoyalCardListViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 5/11/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@class LoyalCardListViewController;
@protocol LoyalCardListViewControllerDelegate
- (void) loyalCardListViewController:(LoyalCardListViewController *)pController selectedCard:(Card *)pCard;
@end

@interface LoyalCardListViewController : UITableViewController<UIAlertViewDelegate>

@property (nonatomic, retain) id <LoyalCardListViewControllerDelegate> mDelegate;

@end
