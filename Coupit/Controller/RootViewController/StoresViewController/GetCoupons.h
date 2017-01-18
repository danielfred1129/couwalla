//
//  GetCoupons.h
//  Coupit
//
//  Created by Canopus5 on 6/16/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GREST.h"
#import "tNSString+SBJSON.h"
#import "RequestHandler.h"

@interface GetCoupons : BaseViewController<GRESTDelegate>
{
    GREST *api;
}
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (nonatomic, retain) NSString *mID;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *msgtitle;



@end
