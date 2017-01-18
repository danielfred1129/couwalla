//
//  GiftcardsViewController.h
//  Coupit
//
//  Created by geniemac5 on 11/01/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftcardsViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *gTableview;
- (void) notificationDictionary:(NSDictionary *)pDict;
@end
