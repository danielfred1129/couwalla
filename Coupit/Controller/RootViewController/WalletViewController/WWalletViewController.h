//
//  WWalletViewController.h
//  Coupit
//
//  Created by geniemac4 on 06/11/13.
//  Copyright (c) 2013 Home. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CameraViewController.h"
#import "iCarousel.h"
#import "RequestHandler.h"
#import "IconDownloadManager.h"
#import "PageControl.h"
#import "Repository.h"

@interface WWalletViewController : BaseViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, CameraViewControllerDelegate, RequestHandlerDelegate, IconDownloadManagerDelegate ,PageControlDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property(nonatomic, retain) CameraViewController *mObjCameraController;
@property (nonatomic, retain) NSString *mSearchText;
@property BOOL mIsSearched;
- (void) notificationDictionary:(NSDictionary *)pDict;
@end
