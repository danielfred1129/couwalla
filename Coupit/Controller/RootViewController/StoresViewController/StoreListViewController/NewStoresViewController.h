//
//  NewStoresViewController.h
//  Coupit
//
//  Created by Canopus5 on 6/13/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GREST.h"
#import "tNSString+SBJSON.h"
#import "RequestHandler.h"

@interface NewStoresViewController : BaseViewController <GRESTDelegate,UIScrollViewDelegate>
{
    GREST *api;
}
@property (weak, nonatomic) IBOutlet UITableView *mTableView;


-(void)showGestureView;
-(void)hideGestureView;
-(void)menuButtonSelected;
-(void)menuButtonUnselected;

@end
