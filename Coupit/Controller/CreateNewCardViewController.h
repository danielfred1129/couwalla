//
//  CreateNewCardViewController.h
//  Coupit
//
//  Created by Raphael Caixeta on 1/29/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZeeSQLiteHelper.h"
#import "zbar.h"
#import "ZBarReaderViewController.h"
#import "ZBarReaderController.h"
#import "ZBarReaderView.h"
#import "AppDelegate.h"
#import "CustomIOS7AlertView.h"



@interface CreateNewCardViewController : BaseViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ZBarReaderViewDelegate, ZBarReaderDelegate,CustomIOS7AlertViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UITextField *cardNameField;
    IBOutlet UIImageView *frontImageView;
    IBOutlet UIImageView *backImageView;
    
    ZBarReaderViewController *reader;
    
    NSString *barcodeType, *barcode;
    
    UIImage *frontImage, *backImage;
    
    BOOL frontPic, backPic, hasBarcodeBeenScanned, hasSelectedFront, hasSelectedBack;
    
    NSString * userid;
    
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *frontButton;
    IBOutlet UITextField *scanCodeTextField;
    IBOutlet UIView *downView;
    IBOutlet UIView *upView;
    IBOutlet UITextField *barcodeTextField;
    IBOutlet UIImageView *barcodeImageview;
    IBOutlet UIView *barCodeView;
    IBOutlet UIView *barcodeImageBGView;
}

- (IBAction)takeFrontPic:(id)sender;
- (IBAction)takeBackPick:(id)sender;
- (IBAction)scanCard:(id)sender;
- (IBAction)enterManuallyAction:(id)sender;


- (void)cancel:(id)sender;
- (void)saveCard:(id)sender;

- (NSString *)randomString:(int)len;
- (BOOL)canSaveCard;


@property(nonatomic, retain) NSDictionary *cardDetails;
@property BOOL comesFromCardDetails;



@end