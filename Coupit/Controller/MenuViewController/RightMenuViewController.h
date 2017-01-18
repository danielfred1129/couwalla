//
//  RightMenuViewController.h
//  Coupit
//
//  Created by Genie Technology on 04/10/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "StoresViewController.h"
#import "NewStoresViewController.h"

@interface RightMenuViewController : UIViewController <UIActionSheetDelegate>
{
    
}
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *rightMenuTableView;
@property (nonatomic, retain) NewStoresViewController *mObjCouponsViewController;


- (void) notificationDictionary:(NSDictionary *)pDict;

- (void) showOverlayView;
- (void) hideOverlayView;
@end
