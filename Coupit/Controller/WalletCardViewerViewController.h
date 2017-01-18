//
//  WalletCardViewerViewController.h
//  Coupit
//
//  Created by Raphael Caixeta on 1/29/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletCardViewerViewController : BaseViewController
{
    NSDictionary *cardDetails;
    IBOutlet UIImageView *generatedBarCode, *frontPic, *backPic;
    IBOutlet UILabel *barcodeLabel;
    
    IBOutlet UILabel *cardName;
}

@property(nonatomic, retain) NSDictionary *cardDetails;

@end
