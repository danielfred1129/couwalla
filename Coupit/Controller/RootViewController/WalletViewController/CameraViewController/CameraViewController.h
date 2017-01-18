//
//  CameraViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
#import "ZXingObjC.h"


typedef enum {
    kFrontViewSelection = 0,
    kBackViewSelection
}WalletScreenSelectionType;

@class CameraViewController;
@protocol CameraViewControllerDelegate
- (void) cameraViewController:(CameraViewController *)pController captureImage:(BOOL)pBool;
@end


@interface CameraViewController : BaseViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,ZBarReaderDelegate>

@property WalletScreenSelectionType mSelectionType;
@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property(nonatomic, retain) UIImagePickerController *mImagePickerReference;
@property(nonatomic, retain) IBOutlet UIImageView *mPlaceHoldeImageView;

@property(nonatomic, retain) IBOutlet UIImageView *mLeftPlaceHoldeImageView;
@property(nonatomic, retain) IBOutlet UIImageView *mRightPlaceHoldeImageView;
@property(nonatomic, retain) IBOutlet UIView *mCameraBackgroundView;
@property(nonatomic, retain) IBOutlet UIView *mCardInfoView;
@property(nonatomic, retain) IBOutlet UITextField *mCardNameTextField;
@property(nonatomic, retain) IBOutlet UITextField *mCardNumberTextField;
@property(nonatomic, retain) IBOutlet UITextField *mCardPinTextField;

@property(nonatomic, retain) IBOutlet UIToolbar *mCameraToolBar;
@property(weak, nonatomic)   IBOutlet UIButton *mRetakeButton;
@property(weak, nonatomic)   IBOutlet UIButton *mCancelButton;
@property(weak, nonatomic)   IBOutlet UIButton *mDoneButton;
@property(weak, nonatomic)   IBOutlet UIButton *mTakePictureButton;

@property(weak, nonatomic)   IBOutlet UIBarButtonItem *mSaveImageButton;
@property(nonatomic, retain) IBOutlet UINavigationItem *mCardInfoNavigationItem;

@property(nonatomic) BOOL *mAddCameraButton;
@property(nonatomic) BOOL mEditButtonClicked;

@property(nonatomic, retain) Card *mObjCard;

@property (nonatomic, retain) id <CameraViewControllerDelegate> mDelegate;

@property CardType mCardType;


- (IBAction)cancelButton:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)flipView:(id)sender;
- (IBAction)cameraDone:(id)sender;
- (IBAction)reTakePicture:(id)sender;

- (IBAction) cardInfoDone:(id)sender;
- (IBAction) clearCardInfo:(id)sender;

- (void)didTakePicture:(UIImage *)picture;
//- (void)didFinishWithCamera;
- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType;


@end
