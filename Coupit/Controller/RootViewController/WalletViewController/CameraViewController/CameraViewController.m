//
//  CameraViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CameraViewController.h"
#import "CardManager.h"
#import "FileUtils.h"

#define kCameraTransform  1.0

#define kSection0 @"Card Details"
#define kSection1 @"Barcode Details"


@implementation CameraViewController {
    NSMutableArray *mCapturedImages;
    NSUInteger mIndex;
    UIImageView *mImageFrameView;
    Card *mCard;
    
    BOOL mIsFrontCam;
    NSString *mFilePath;
    UISwitch *mNotificationSwitch;
    UIButton *mScanBarCodeButton;
    UILabel *mBarCodeValueLabel;
    UILabel *mBarCodeTypeLabel;
    NSString *mBarCodeType;
    NSString *mBarCodeValue;
    UIImage *mBarCodeImage;
    UIImage *croppedImage;
    BOOL mScanBarCode;
    
    
}

@synthesize  mImagePickerReference, mPlaceHoldeImageView, mSelectionType, mCardType, mObjCard, mCardNumberTextField, mTableView,mCameraBackgroundView;
@synthesize mDelegate, mLeftPlaceHoldeImageView, mRightPlaceHoldeImageView;
@synthesize mCardInfoView, mCardNameTextField,mCameraToolBar, mAddCameraButton,mRetakeButton,mSaveImageButton, mCardPinTextField, mCardInfoNavigationItem;
@synthesize mCancelButton, mDoneButton, mTakePictureButton, mEditButtonClicked;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }

    
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        self.mImagePickerReference = [[UIImagePickerController alloc] init];
        self.mImagePickerReference.delegate = self;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [mCameraBackgroundView setHidden:YES];
    //NSLog(@"camera");
    mCapturedImages = [NSMutableArray array];
    
    //mEditButtonClicked = NO;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    
    mIsFrontCam = YES;
    
    if (mObjCard) {
        
    }
    else{
        mSelectionType = kFrontViewSelection;
    }
    
    mFilePath = [[NSString alloc] initWithString:documentsFilePath(kImagePathDownload)];
    NSString *version = [[UIDevice currentDevice] systemVersion];
    if ([version isEqualToString:@"7.0"]) {
    if (IS_IPHONE_5) {
        [self.view setFrame:CGRectMake(0, 0, 320, 568)];
        [self.mRetakeButton setCenter:CGPointMake(160, 518)];
        [self.mCancelButton setFrame:CGRectMake(12, 5, 55, 42)];
        [self.mDoneButton setFrame:CGRectMake(254, 5, 55, 42)];
        
        [self.mCameraBackgroundView setFrame:CGRectMake(0, 0, 320, 524)];
        [mCameraToolBar setFrame:CGRectMake(0, 475, 320, 88)];
        
    }
    }
    else{
        //  [self.mCameraToolBar setCenter:(0, 0, 320, 480)];
    }
    
    [mRetakeButton setHidden:YES];
}

-(void) viewDidAppear:(BOOL)animated {
    
    mIsFrontCam = YES;
    mSelectionType = kFrontViewSelection;
    if (mAddCameraButton) {
        [mRetakeButton setHidden:YES];
        [mCameraBackgroundView setHidden:YES];
        [self.mPlaceHoldeImageView setImage:[UIImage imageNamed:@"BG_CardPlaceholder"]];
        [self.mLeftPlaceHoldeImageView setImage:[UIImage imageNamed:@"BG_CardPlaceholder"]];
        [self.mRightPlaceHoldeImageView setImage:[UIImage imageNamed:@"BG_CardPlaceholder"]];
        
    } else {
        [mRetakeButton setHidden:NO];
        [mCameraBackgroundView setHidden:NO];
        
    }
    
}

- (void)leftImageTapped:(id)sender {
    [mRetakeButton setHidden:YES];
    if (mCard) {
        if (mCard.mFrontImage) {
            [self.mPlaceHoldeImageView setImage:mLeftPlaceHoldeImageView.image];
            [mCameraBackgroundView setHidden:NO];
            
        } else {
            [self.mPlaceHoldeImageView setImage:[UIImage imageNamed:@"BG_CardPlaceholder"]];
            [mCameraBackgroundView setHidden:YES];
            mIsFrontCam = !mIsFrontCam;
            if (mSelectionType == kBackViewSelection) {
                self.mSelectionType = kFrontViewSelection;
            }
        }
    } else {
        if (mObjCard.mFrontImage) {
            [self.mPlaceHoldeImageView setImage:mLeftPlaceHoldeImageView.image];
            [mCameraBackgroundView setHidden:NO];
            
        } else {
            [self.mPlaceHoldeImageView setImage:[UIImage imageNamed:@"BG_CardPlaceholder"]];
            [mCameraBackgroundView setHidden:YES];
            mIsFrontCam = !mIsFrontCam;
            if (mSelectionType == kBackViewSelection) {
                self.mSelectionType = kFrontViewSelection;
            }
        }
    }
    //NSLog(@"......................LeftImageTapped");
    
}

- (void)rightImageTapped:(id)sender {
    [mRetakeButton setHidden:YES];
    if (mCard) {
        if (mCard.mBackImage) {
            [self.mPlaceHoldeImageView setImage:mRightPlaceHoldeImageView.image];
            [mCameraBackgroundView setHidden:NO];
        } else {
            [self.mPlaceHoldeImageView setImage:[UIImage imageNamed:@"BG_CardPlaceholder"]];
            [mCameraBackgroundView setHidden:YES];
            mIsFrontCam = !mIsFrontCam;
            if (mSelectionType == kFrontViewSelection) {
                self.mSelectionType = kBackViewSelection;
            }
        }
    } else {
        if (mObjCard.mBackImage) {
            [self.mPlaceHoldeImageView setImage:mRightPlaceHoldeImageView.image];
            [mCameraBackgroundView setHidden:NO];
        } else {
            [self.mPlaceHoldeImageView setImage:[UIImage imageNamed:@"BG_CardPlaceholder"]];
            [mCameraBackgroundView setHidden:YES];
            mIsFrontCam = !mIsFrontCam;
            if (mSelectionType == kFrontViewSelection) {
                self.mSelectionType = kBackViewSelection;
            }
        }
        
    }
    //NSLog(@"......................RightImageTapped");
}



- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    mScanBarCode = NO;
    if (mObjCard) {
        
    } else {
        if (mCard == nil) {
            
            mCard = [NSEntityDescription
                     insertNewObjectForEntityForName:@"Card"
                     inManagedObjectContext:[Repository sharedRepository].context];
            if ([mCard.mHaveBarcodeImage boolValue] == NO) {
                [mNotificationSwitch setOn:NO];
                [mTableView reloadData];
            }
        }
        else{
            mCard = nil;
            mCard = [NSEntityDescription
                     insertNewObjectForEntityForName:@"Card"
                     inManagedObjectContext:[Repository sharedRepository].context];
            if ([mCard.mHaveBarcodeImage boolValue] == NO) {
                [mNotificationSwitch setOn:NO];
                [mTableView reloadData];
            }
        }
    }
    
    self.mImagePickerReference.sourceType = sourceType;
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        // user wants to use the camera interface
        mImagePickerReference.showsCameraControls = NO;
        mImagePickerReference.editing = NO;
        mImagePickerReference.navigationBarHidden = NO;
        mImagePickerReference.toolbarHidden = YES;
        mImagePickerReference.wantsFullScreenLayout = YES;
        mImagePickerReference.showsCameraControls = NO;
        mImagePickerReference.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        mImagePickerReference.cameraViewTransform = CGAffineTransformScale(mImagePickerReference.cameraViewTransform,kCameraTransform, kCameraTransform);
        if ([[self.mImagePickerReference.cameraOverlayView subviews] count] == 0)
        {
            // setup our custom overlay view for the camera
            // ensure that our custom view's frame fits within the parent frame
            CGRect overlayViewFrame = self.mImagePickerReference.cameraOverlayView.frame;
            CGRect newFrame = CGRectMake(0.0,
                                         CGRectGetHeight(overlayViewFrame) -
                                         self.view.frame.size.height - 20.0,
                                         CGRectGetWidth(overlayViewFrame),
                                         self.view.frame.size.height + 20.0);
            //NSLog(@"----------- newFramewidth:%0.2f || newFrameheight:%0.2f", newFrame.size.width, newFrame.size.height);
            if (!IS_IPHONE_5) {
                //  self.view.frame = newFrame;
            }
            
            self.mImagePickerReference.cameraOverlayView = self.view;
        }
    }
    if (mObjCard) {
        [self.mCameraBackgroundView setHidden:NO];
        [self.mRetakeButton setHidden:NO];
        [self.mLeftPlaceHoldeImageView setImage:[UIImage imageWithContentsOfFile:mObjCard.mFrontImage]];
        [self.mRightPlaceHoldeImageView setImage:[UIImage imageWithContentsOfFile:mObjCard.mBackImage]];
        [self.mPlaceHoldeImageView setImage:mLeftPlaceHoldeImageView.image];
        if ([mObjCard.mHaveBarcodeImage boolValue] == NO) {
            [mNotificationSwitch setOn:NO];
            [mTableView reloadData];
        } else {
            [mNotificationSwitch setOn:YES];
            [mTableView reloadData];
            
        }
        
    }
}


- (void)didTakePicture:(UIImage *)picture {
    if (IS_IPHONE_5) {
        CGSize tSize = CGSizeMake(320, 520);
        
        UIGraphicsBeginImageContext(tSize );
        [picture drawInRect:CGRectMake(0,0,tSize.width,tSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGSize newSize = CGSizeMake(230, 160);
        CGRect cropRect = CGRectMake(45, 130, newSize.width, newSize.height);
        CGImageRef imageRef = CGImageCreateWithImageInRect([newImage CGImage], cropRect);
        croppedImage = [UIImage imageWithCGImage:imageRef];
        
    } else {
        CGSize tSize = CGSizeMake(320, 480);
        
        UIGraphicsBeginImageContext(tSize );
        [picture drawInRect:CGRectMake(0,0,tSize.width,tSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGSize newSize = CGSizeMake(240, 160);
        CGRect cropRect = CGRectMake(45, 130, newSize.width, newSize.height);
        CGImageRef imageRef = CGImageCreateWithImageInRect([newImage CGImage], cropRect);
        croppedImage = [UIImage imageWithCGImage:imageRef];
        
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:mFilePath]){
        
        NSError* error;
        if([[NSFileManager defaultManager] createDirectoryAtPath:mFilePath withIntermediateDirectories:NO attributes:nil error:&error])
            ;// success
        else
        {
            //NSLog(@"[%@] ERROR: attempting to write create MyFolder directory", [self class]);
            NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
        }
    }
    NSString *uniqueFileName = [self pImageFolderName];
    NSString *savedImagePath = [mFilePath stringByAppendingPathComponent:[uniqueFileName stringByAppendingPathExtension:@"jpeg"]];
    
    // //NSLog(@"savedImagePath:%@", savedImagePath);
    if (mObjCard) {
        mObjCard.mIsFliped = [NSNumber numberWithBool:NO];
        mObjCard.mID = uniqueFileName;
        
        if (mIsFrontCam) {
            mObjCard.mFrontImage = savedImagePath;
            //NSLog(@"tcardFrontImage :%@",mObjCard.mFrontImage);
            
            self.mLeftPlaceHoldeImageView.image = croppedImage;
        }
        else{
            mObjCard.mBackImage = savedImagePath;
            self.mRightPlaceHoldeImageView.image = croppedImage;
            
        }
    }
    else{
        
        mCard.mIsFliped = [NSNumber numberWithBool:NO];
        mCard.mID = uniqueFileName;
        
        if (mIsFrontCam) {
            mCard.mFrontImage = savedImagePath;
            self.mLeftPlaceHoldeImageView.image = croppedImage;
        }
        else{
            mCard.mBackImage = savedImagePath;
            self.mRightPlaceHoldeImageView.image = croppedImage;
        }
    }
    
    
    [self.mPlaceHoldeImageView setImage:croppedImage];
    
    NSData *imgData = UIImageJPEGRepresentation(croppedImage, 0.5);
    [imgData writeToFile:savedImagePath atomically:NO];
    [mCameraBackgroundView setHidden:NO];
    [mRetakeButton setHidden:NO];
}

- (IBAction)flipView:(id)sender {
    if (mCard) {
        mIsFrontCam = !mIsFrontCam;
        if (mSelectionType == kFrontViewSelection) {
            self.mSelectionType = kBackViewSelection;
            if (mCard.mBackImage) {
                [mCameraBackgroundView setHidden:NO];
                [mRetakeButton setHidden:NO];
                
            } else {
                [mRetakeButton setHidden:YES];
                [mCameraBackgroundView setHidden:YES];
                
            }
            [self.mPlaceHoldeImageView setImage:mRightPlaceHoldeImageView.image];
        }
        else {
            if (mCard.mFrontImage) {
                [mCameraBackgroundView setHidden:NO];
                [mRetakeButton setHidden:NO];
            } else {
                [mRetakeButton setHidden:YES];
                [mCameraBackgroundView setHidden:YES];
                
            }
            self.mSelectionType = kFrontViewSelection;
            //NSLog(@"BackViewSelection :%@",mCard.mBackImage);
            [self.mPlaceHoldeImageView setImage:mLeftPlaceHoldeImageView.image];
            //[self.mPlaceHoldeImageView setImage:[UIImage imageWithContentsOfFile:mCard.mFrontImage]];
            
        }
    } else {
        mIsFrontCam = !mIsFrontCam;
        if (mSelectionType == kFrontViewSelection) {
            self.mSelectionType = kBackViewSelection;
            if (mObjCard.mBackImage) {
                [mCameraBackgroundView setHidden:NO];
                [mRetakeButton setHidden:NO];
                
            } else {
                [mRetakeButton setHidden:YES];
                [mCameraBackgroundView setHidden:YES];
                
            }
            [self.mPlaceHoldeImageView setImage:mRightPlaceHoldeImageView.image];
        }
        else {
            if (mObjCard.mFrontImage) {
                [mCameraBackgroundView setHidden:NO];
                [mRetakeButton setHidden:NO];
            } else {
                [mRetakeButton setHidden:YES];
                [mCameraBackgroundView setHidden:YES];
                
            }
            self.mSelectionType = kFrontViewSelection;
            //NSLog(@"BackViewSelection :%@",mObjCard.mBackImage);
            [self.mPlaceHoldeImageView setImage:[UIImage imageWithContentsOfFile:mObjCard.mFrontImage]];
            
        }
        
        
    }
    
    //[self.mPlaceHoldeImageView setImage:[UIImage imageNamed:@"BG_CardPlaceholder"]];
}


-(IBAction)takePhoto:(id)sender {
    
    [self.mImagePickerReference takePicture];
}


- (IBAction)cancelButton:(id)sender {
    if (mAddCameraButton) {
        [self.mImagePickerReference dismissViewControllerAnimated:YES completion:nil];
        [self.mPlaceHoldeImageView setImage:[UIImage imageNamed:@"BG_CardPlaceholder"]];
        NSError *error;
        [[Repository sharedRepository].context deleteObject:mCard];
        [[Repository sharedRepository].context save:&error];
        mCard  = nil;
    } else {
        [self.mImagePickerReference dismissViewControllerAnimated:YES completion:nil];
        [self.mPlaceHoldeImageView setImage:[UIImage imageNamed:@"BG_CardPlaceholder"]];
        mObjCard = nil;
        
        
    }
    mCardNameTextField.text = nil;
    mCardNumberTextField.text = nil;
    mCardPinTextField.text = nil;
    mBarCodeValueLabel.text = nil;
    mBarCodeTypeLabel.text = nil;
    
    
}

- (NSString *)pImageFolderName
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    // [dateString stringByAppendingFormat:@"%d",arc4random()%1000];
    return dateString;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = kSection0;
            break;
        case 1:
            sectionName = kSection1;
            break;
            
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *tSectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (tSectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *tSectionTitleLabel = [[UILabel alloc] init];
    tSectionTitleLabel.frame = CGRectMake(20, 10, 300, 15);
    tSectionTitleLabel.backgroundColor = [UIColor clearColor];
    tSectionTitleLabel.textColor = [UIColor colorWithRed:(77.0/255.0) green:(77.0/255.0) blue:(77.0/255.0) alpha:1];
    tSectionTitleLabel.shadowColor = [UIColor whiteColor];
    tSectionTitleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    tSectionTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    tSectionTitleLabel.text = tSectionTitle;
    
    // Create header view and add label as a subview
    UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    [tView addSubview:tSectionTitleLabel];
    return tView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            return 3;
        }
            break;
        case 1:
        {
            if (!mNotificationSwitch.on) {
                return 1;
            }else {
                return 4;
            }
        }
            break;
            
        default:
        {
            return 0;
        }
            break;
    }
    
    return section;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d|section%d",indexPath.row,indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        
        switch (indexPath.section) {
            case 0:
                if (indexPath.section == 0) {
                    if (indexPath.row == 0) {
                        if (mCardNameTextField == nil) {
                            
                            mCardNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, 300, 30)];
                            mCardNameTextField.delegate = self;
                            // Border Style None
                            [mCardNameTextField setBorderStyle:UITextBorderStyleNone];
                            mCardNameTextField.font = [UIFont systemFontOfSize:14.0];
                            mCardNameTextField.keyboardType = UIKeyboardTypeDefault;
                            mCardNameTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
                            mCardNameTextField.returnKeyType = UIReturnKeyNext;
                            mCardNameTextField.placeholder = @"Title";
                            mCardNameTextField.textAlignment = NSTextAlignmentLeft;
                            mCardNameTextField.textColor = [UIColor colorWithRed:(72/255.0) green:(72/255.0) blue:(72/255.0) alpha:1.0];
                            mCardNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
                            mCardNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                            mCardNameTextField.tag = indexPath.row;
                            mCardNameTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
                            [cell.contentView addSubview:mCardNameTextField];
                        }
                    } else if (indexPath.row == 1){
                        if (mCardNumberTextField == nil) {
                            
                            mCardNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, 300, 30)];
                            mCardNumberTextField.delegate = self;
                            mCardNumberTextField.secureTextEntry = NO;
                            mCardNumberTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
                            [mCardNumberTextField setBorderStyle:UITextBorderStyleNone];
                            mCardNumberTextField.font = [UIFont systemFontOfSize:14.0];
                            mCardNumberTextField.keyboardType = UIKeyboardTypeDefault;
                            mCardNumberTextField.returnKeyType = UIReturnKeyNext;
                            mCardNumberTextField.placeholder = @"Description";
                            mCardNumberTextField.textAlignment = NSTextAlignmentLeft;
                            mCardNumberTextField.textColor = [UIColor colorWithRed:(72/255.0) green:(72/255.0) blue:(72/255.0) alpha:1.0];
                            mCardNumberTextField.autocorrectionType = UITextAutocorrectionTypeNo;
                            mCardNumberTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                            mCardNumberTextField.tag = indexPath.row;
                            mCardNumberTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
                            
                            [cell.contentView addSubview:mCardNumberTextField];
                        }
                    } else if (indexPath.row == 2){
                        if (mCardPinTextField == nil) {
                            mCardPinTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, 300, 30)];
                            mCardPinTextField.delegate = self;
                            mCardPinTextField.secureTextEntry = NO;
                            mCardPinTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
                            [mCardPinTextField setBorderStyle:UITextBorderStyleNone];
                            mCardPinTextField.font = [UIFont systemFontOfSize:14.0];
                            mCardPinTextField.keyboardType = UIKeyboardTypeDefault;
                            mCardPinTextField.returnKeyType = UIReturnKeyDone;
                            mCardPinTextField.placeholder = @"Pin";
                            mCardPinTextField.textAlignment = NSTextAlignmentLeft;
                            mCardPinTextField.textColor = [UIColor colorWithRed:(72/255.0) green:(72/255.0) blue:(72/255.0) alpha:1.0];
                            mCardPinTextField.autocorrectionType = UITextAutocorrectionTypeNo;
                            mCardPinTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                            mCardPinTextField.tag = indexPath.row;
                            mCardPinTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
                            
                            [cell.contentView addSubview:mCardPinTextField];
                        }
                    }
                }
                break;
            case 1:
                if (indexPath.section == 1) {
                    if (indexPath.row == 0) {
                        cell.textLabel.text = @"Barcode";
                        mNotificationSwitch = [[UISwitch alloc] init];
                        mNotificationSwitch.frame = CGRectMake(215, 7, 30, 30);
                        if ([mObjCard.mHaveBarcodeImage boolValue] == YES)  {
                            mNotificationSwitch.on = YES;
                            [mTableView reloadData];
                        }
                        [mNotificationSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
                        [cell.contentView addSubview:mNotificationSwitch];
                        //NSLog(@"Have Bar Code Image : %@",mCard.mHaveBarcodeImage);
                        
                    }
                    else if (indexPath.row == 1) {
                        cell.textLabel.text = @"Scan Barcode";
                        mScanBarCodeButton = [[UIButton alloc] init];
                        mScanBarCodeButton.frame = CGRectMake(250, 7, 30, 30);
                        [mScanBarCodeButton setImage:[UIImage imageNamed:@"icon_cameraScan"] forState:UIControlStateNormal];
                        [mScanBarCodeButton sizeToFit];
                        [mScanBarCodeButton addTarget:self action:@selector(scanBarCode:) forControlEvents:UIControlEventTouchUpInside];
                        [cell.contentView addSubview:mScanBarCodeButton];
                        
                    } else if (indexPath.row == 2) {
                        cell.textLabel.text = @"Barcode Type";
                        mBarCodeTypeLabel = [[UILabel alloc] init];
                        mBarCodeTypeLabel.frame = CGRectMake(140, 7, 145, 30);
                        mBarCodeTypeLabel.backgroundColor = [UIColor clearColor];
                        mBarCodeTypeLabel.textAlignment = NSTextAlignmentRight;
                        mBarCodeTypeLabel.font = [UIFont systemFontOfSize:12.0];
                        [cell.contentView addSubview:mBarCodeTypeLabel];
                        
                    } else if (indexPath.row == 3) {
                        cell.textLabel.text = @"Card No";
                        mBarCodeValueLabel = [[UILabel alloc] init];
                        mBarCodeValueLabel.frame = CGRectMake(140, 7, 145, 30);
                        mBarCodeValueLabel.backgroundColor = [UIColor clearColor];
                        mBarCodeValueLabel.textAlignment = NSTextAlignmentRight;
                        mBarCodeValueLabel.font = [UIFont systemFontOfSize:12.0];
                        [cell.contentView addSubview:mBarCodeValueLabel];
                        
                    }
                }
                break;
                
            default:
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
}

- (void)switchChanged:(id)sender {
    if (mNotificationSwitch.on) {
        mCard.mHaveBarcodeImage = [NSNumber numberWithBool:YES];
        mObjCard.mHaveBarcodeImage = [NSNumber numberWithBool:YES];
        
        mBarCodeTypeLabel.text = nil;
        mBarCodeValueLabel.text = nil;
        [self scanBarCode:sender];
    } else {
        mCard.mHaveBarcodeImage = [NSNumber numberWithBool:NO];
        mObjCard.mHaveBarcodeImage = [NSNumber numberWithBool:NO];
    }
    [mTableView reloadData];
}

- (void)scanBarCode:(id)sender {
    mScanBarCode = YES;
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.showsZBarControls = NO;
    reader.cameraOverlayView = [self setOverlayPickerView];
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentViewController:reader animated:YES completion:nil];
    
    
}
- (UIView *)setOverlayPickerView {
    //TO DO: Set Overlay For BarCode(Current is for the QR Code)
    UIView *tOverlayView=[[UIView alloc] initWithFrame:CGRectMake(60, 25, 200, 350)];
    tOverlayView.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin;
    [tOverlayView setBackgroundColor:[UIColor clearColor]];
    
    
    UIToolbar *tMyToolBar = [[UIToolbar alloc] init];
    UIBarButtonItem *tBackButton=[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissOverlayView:)];
    tMyToolBar.tintColor = [UIColor colorWithRed:51.0/255 green:179.0/255 blue:57.0/255 alpha:1];
    [tMyToolBar setItems:[NSArray arrayWithObject:tBackButton]];
    [tMyToolBar setBarStyle:UIBarStyleDefault];
    CGRect toolBarFrame;
    if (!IS_IPHONE_5) {
        toolBarFrame = CGRectMake(0, 436, 320, 44);
        
    } else {
        toolBarFrame = CGRectMake(0, 525, 320, 44);
    }
    [tMyToolBar setFrame:toolBarFrame];
    [tOverlayView addSubview:tMyToolBar];
    return  tOverlayView;
}

- (void)dismissOverlayView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)cameraDone:(id)sender
{
    if (!mEditButtonClicked) {
        if (!mCard.mFrontImage) {
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Please take the front image of card" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
            return;
            
        } else if (!mCard.mBackImage) {
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Please take the back image of card" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
            return;
            
        }
        
    }
    
    if (IS_IPHONE_5) {
        [self.mCardInfoView setFrame:CGRectMake(0, 0, 320, 568)];
        self.mCardInfoView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background" ]];
    }
    else{
        [self.mCardInfoView setFrame:CGRectMake(0, 0, 320, 480)];
        self.mTableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background" ]];
        
    }
    if (mCardType == kLoyaltyCard) {
        mCardInfoNavigationItem.title = @"Loyalty Card";
    } else {
        mCardInfoNavigationItem.title = @"Gift Card";
    }
    
    [self.mCardInfoView setHidden:NO];
    if (mObjCard) {
        mCard.mHaveBarcodeImage = [NSNumber numberWithBool:YES];
        self.mCardNameTextField.text = mObjCard.mCardName;
        self.mCardNumberTextField.text = mObjCard.mCardDescription;
        mBarCodeValueLabel.text = mObjCard.mCardNumber;
        mBarCodeTypeLabel.text = mObjCard.mBarcodeType;
        
    }
    
    [self.mCardNameTextField becomeFirstResponder];
}


- (IBAction)reTakePicture:(id)sender {
    [self.mPlaceHoldeImageView setImage:[UIImage imageNamed:@"BG_CardPlaceholder"]];
    [mRetakeButton setHidden:YES];
    [mCameraBackgroundView setHidden:YES];
    
}

- (void)scanBarCode:(NSString *)pBarCodeType barCodeValue:(NSString *)pBarCodeValue barCodeImage:(NSString *)pBarCodeImage {
    NSError* error = nil;
    ZXBarcodeFormat *tFormat = NULL;
    int width = 87;
    int height = 250;
    
    if ([pBarCodeType isEqualToString:@"CODE-128"]) {
        tFormat = kBarcodeFormatCode128;
    } else if ([pBarCodeType isEqualToString:@"QR-Code"]) {
        tFormat = kBarcodeFormatQRCode;
        width = 100;
        height = 80;
    } else if ([pBarCodeType isEqualToString:@"CODE-39"]) {
        tFormat = kBarcodeFormatCode39;
    } else if ([pBarCodeType isEqualToString:@"EAN-8"]) {
        tFormat = kBarcodeFormatEan8;
    } else if ([pBarCodeType isEqualToString:@"EAN-13"]) {
        tFormat = kBarcodeFormatEan13;
    }
    
    if (tFormat != NULL) {
        ZXMultiFormatWriter* writer = [ZXMultiFormatWriter writer];
        ZXBitMatrix* result = [writer encode:pBarCodeValue
                                      format:tFormat
                                       width:width
                                      height:height
                                       error:&error];
        if (result) {
            CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
            
            mBarCodeImage = [UIImage imageWithCGImage:image scale:NO orientation:UIImageOrientationLeft];
            //mBarCodeImage = [UIImage imageWithCGImage:image scale:NO orientation:NO];
            
        } else {
            NSString* errorMessage = [error localizedDescription];
            //NSLog(@"Error Message :%@", errorMessage);
        }
        
        NSData *imgData = UIImageJPEGRepresentation(mBarCodeImage, 0.5);
        [imgData writeToFile:pBarCodeImage atomically:NO];
        if (mObjCard) {
            NSFileManager *fileMgr = [[NSFileManager alloc] init];
            [fileMgr removeItemAtPath:mObjCard.mBarCodeImage error:&error];
            [[Repository sharedRepository].context save:&error];
            mObjCard.mBarCodeImage = pBarCodeImage;
            //NSLog(@"--------mCardType:%d", mCardType);
            mObjCard.mCardName = self.mCardNameTextField.text;
            mObjCard.mCardNumber = mBarCodeValueLabel.text;
            mObjCard.mCardDescription = self.mCardNumberTextField.text;
            mObjCard.mCardPin = self.mCardPinTextField.text;
            mObjCard.mBarcodeType = mBarCodeTypeLabel.text;
            mObjCard.mCardType = [NSNumber numberWithInt:mCardType];
            mObjCard.mHaveBarcodeImage = [NSNumber numberWithBool:YES];
            mObjCard.mIsCameraImage = [NSNumber numberWithBool:YES];
            
            [[Repository sharedRepository].context save:nil];
        } else {
            mCard.mBarCodeImage = pBarCodeImage;
            mCard.mCardName = self.mCardNameTextField.text;
            mCard.mCardDescription = self.mCardNumberTextField.text;
            mCard.mCardNumber = mBarCodeValueLabel.text;
            mCard.mBarcodeType = mBarCodeTypeLabel.text;
            mCard.mCardPin = mCardPinTextField.text;
            mCard.mCardType = [NSNumber numberWithInt:mCardType];
            mCard.mHaveBarcodeImage = [NSNumber numberWithBool:YES];
            mCard.mIsCameraImage = [NSNumber numberWithBool:YES];
            [[Repository sharedRepository].context insertObject:mCard];
            [[Repository sharedRepository].context save:&error];
            
        }
    } else {
        UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"BarCode Format is not supported" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [tAlertView show];
        return;
        
    }
    
}


- (IBAction) cardInfoDone:(id)sender
{
    
    if ([self.mCardNameTextField.text length] == 0) {
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:kTextFieldValidationMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlert show];
        return;
    } else if ([mBarCodeTypeLabel.text length]==0) {
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Scan Barcode of Loyalty Card" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlert show];
        return;
        
    }
    NSError* error = nil;
    [self.mCardInfoView setHidden:YES];
    if (mObjCard) {
        if ([mObjCard.mHaveBarcodeImage boolValue] == YES) {
            //NSLog(@"--------mCardType:%d", mCardType);
            NSString *uniqueFileName = [self pImageFolderName];
            NSString *savedImagePath = [mFilePath stringByAppendingPathComponent:[uniqueFileName stringByAppendingPathExtension:@"jpeg"]];
            [self scanBarCode:mBarCodeTypeLabel.text barCodeValue:mBarCodeValueLabel.text barCodeImage:savedImagePath];
        } else {
            mObjCard.mCardName = self.mCardNameTextField.text;
            mObjCard.mCardDescription = self.mCardNumberTextField.text;
            mObjCard.mCardPin = self.mCardPinTextField.text;
            mObjCard.mCardType = [NSNumber numberWithInt:mCardType];
            mObjCard.mIsCameraImage = [NSNumber numberWithBool:YES];
            [[Repository sharedRepository].context save:&error];
        }
    } else {
        if ([mCard.mHaveBarcodeImage boolValue] == YES) {
            //NSLog(@"--------mCardType:%d", mCardType);
            NSString *uniqueFileName = [self pImageFolderName];
            NSString *savedImagePath = [mFilePath stringByAppendingPathComponent:[uniqueFileName stringByAppendingPathExtension:@"jpeg"]];
            [self scanBarCode:mBarCodeTypeLabel.text barCodeValue:mBarCodeValueLabel.text barCodeImage:savedImagePath];
        } else {
            mCard.mCardName = self.mCardNameTextField.text;
            mCard.mCardDescription = self.mCardNumberTextField.text;
            mCard.mCardPin = self.mCardPinTextField.text;
            mCard.mCardType = [NSNumber numberWithInt:mCardType];
            mCard.mIsCameraImage = [NSNumber numberWithBool:YES];
            [[Repository sharedRepository].context insertObject:mCard];
            [[Repository sharedRepository].context save:&error];
        }
    }
    
    [mDelegate cameraViewController:self captureImage:YES];
    [self.mImagePickerReference dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self.mPlaceHoldeImageView setImage:[UIImage imageNamed:@"BG_CardPlaceholder"]];
    [self.mLeftPlaceHoldeImageView setImage:[UIImage imageNamed:@"BG_CardPlaceholder"]];
    [self.mRightPlaceHoldeImageView setImage:[UIImage imageNamed:@"BG_CardPlaceholder"]];
    mIsFrontCam = YES;
    mCardNameTextField.text = nil;
    mCardNumberTextField.text = nil;
    mCardPinTextField.text = nil;
    mBarCodeValueLabel.text = nil;
    mBarCodeTypeLabel.text = nil;
    
}

- (IBAction) clearCardInfo:(id)sender
{
    [self.mCardInfoView setHidden:YES];
    [self.mCardNameTextField resignFirstResponder];
    [self.mCardNumberTextField resignFirstResponder];
    [self cancelButton:sender];
    
    //    [self.mCardNameTextField setText:@""];
    //    [self.mCardNumberTextField setText:@""];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == mCardNameTextField) {
        [mCardNumberTextField becomeFirstResponder];
    }
    else if (textField == mCardNumberTextField) {
        [mCardPinTextField becomeFirstResponder];
    }
    else if (textField == mCardPinTextField){
        [mCardPinTextField resignFirstResponder];
    }
    return YES;
}



#pragma mark -
#pragma mark UIImagePickerControllerDelegate

// this get called when an image has been chosen from the library or taken from the camera
//
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (mScanBarCode) {
        // ADD: get the decode results
        id<NSFastEnumeration> results =
        [info objectForKey: ZBarReaderControllerResults];
        ZBarSymbol *symbol = nil;
        for(symbol in results)
            // EXAMPLE: just grab the first barcode
            break;
        mBarCodeValue = symbol.data;
        mBarCodeType = symbol.typeName;
        
        mBarCodeTypeLabel.text = mBarCodeType;
        mBarCodeValueLabel.text = mBarCodeValue;
        [picker dismissViewControllerAnimated:picker completion:nil];
        //NSLog(@"BarCode Value %@", mBarCodeValue);
        //NSLog(@"BarCode Type %@", mBarCodeType);
        
    } else {
        
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        
        //CGImageRelease(imageRef);
        
        [self didTakePicture:image];
    }
    
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //[self didFinishWithCamera];
    
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
