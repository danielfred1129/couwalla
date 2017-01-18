//
//  CategorysViewController.h
//  Coupit
//
//  Created by Canopus5 on 6/16/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GREST.h"
#import "tNSString+SBJSON.h"
#import "RequestHandler.h"

@interface CategorysViewController : BaseViewController<GRESTDelegate>
{
    GREST *api;
}
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (nonatomic, retain) NSString *mID;
@property (weak, nonatomic) IBOutlet UILabel *hideLabelForMassage;
@end
