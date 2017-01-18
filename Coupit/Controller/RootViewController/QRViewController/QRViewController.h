//
//  QRViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXingObjC.h"
#import "CouponsViewController.h"
#import "StoreListViewController.h"

@interface QRViewController : UIViewController <ZBarReaderDelegate, StoreListViewControllerDelegate>

@property (nonatomic, retain)IBOutlet UIView *mCameraView;


//-(void)showGestureView;
//-(void)hideGestureView;
//-(void)menuButtonSelected;
//-(void)menuButtonUnselected;

-(void)barCodeScanner;
//- (IBAction)cancel:(id)sender;

@end
