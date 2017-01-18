//
//  CreateNewCardViewController.m
//  Coupit
//
//  Created by Raphael Caixeta on 1/29/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "CreateNewCardViewController.h"
#import "NewWalletViewController.h"

@implementation CreateNewCardViewController
{
    BOOL boolForMenuallyEnterCode;
    IBOutlet UILabel *customAlertMessage;
    IBOutlet UILabel *customAlertTitle;
    IBOutlet UIView *customAlertView;
    CustomIOS7AlertView *alertView;
}

- (IBAction)customAlertCancel:(id)sender {
    [alertView close];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"New Wallet Card";
    // setNevigation bar
    {
        UIButton *tbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tbackButton.frame = CGRectMake(0, 0, 38, 30);
        [tbackButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
        [tbackButton sizeToFit];
        [tbackButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *tBackBar = [[UIBarButtonItem alloc]initWithCustomView:tbackButton];
        self.navigationItem.leftBarButtonItem = tBackBar;
        
        
        UIButton *rbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rbackButton.frame = CGRectMake(0, 0, 38, 30);
        [rbackButton setImage:[UIImage imageNamed:@"button_save"] forState:UIControlStateNormal];
        [rbackButton sizeToFit];
        [rbackButton addTarget:self action:@selector(saveCard:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rBackBar = [[UIBarButtonItem alloc]initWithCustomView:rbackButton];
        self.navigationItem.rightBarButtonItem = rBackBar;
    }
    //setView
    {
        barcodeImageBGView.layer.cornerRadius=5.0f;
        reader = [ZBarReaderViewController new];
        frontImage = [[UIImage alloc] init];
        backImage = [[UIImage alloc] init];
        barcode = @"";
        barcodeType = @"";
        userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
        frontPic = NO;
        backPic = NO;
        hasSelectedFront = NO;
        hasSelectedBack = NO;
        hasBarcodeBeenScanned = NO;
        barCodeView.hidden=YES;
        
    }
    
    // add Constraint
    {
        NSLayoutConstraint *constraint;
        constraint = [NSLayoutConstraint constraintWithItem:upView
                                                  attribute:NSLayoutAttributeHeight
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self.view
                                                  attribute:NSLayoutAttributeHeight
                                                 multiplier:0.5
                                                   constant:0];
        
        
        [self.view addConstraint:constraint];
        constraint = [NSLayoutConstraint constraintWithItem:downView
                                                  attribute:NSLayoutAttributeHeight
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self.view
                                                  attribute:NSLayoutAttributeHeight
                                                 multiplier:0.5
                                                   constant:0];
        [self.view addConstraint:constraint];
        constraint = [NSLayoutConstraint constraintWithItem:barCodeView
                                                  attribute:NSLayoutAttributeHeight
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self.view
                                                  attribute:NSLayoutAttributeHeight
                                                 multiplier:0.5
                                                   constant:0];
        [self.view addConstraint:constraint];
    }
    
    if(self.comesFromCardDetails)
    {
        [self ifComesFromCardDetails];
    }
}


-(void)ifComesFromCardDetails
{
//    
//    "back_pic_id" = 7Uj9b03ifLmNsoeuLN0l7zzYL2TNjKzf;
//    barcode = 1234567978;
//    "barcode_image" = "";
//    "card_name" = rt;
//    "front_pic_id" = wXxdKRT4CZ0omyO4OMjwtR0jgaFtjLH9;
    
    NSString *cardName = self.cardDetails[@"card_name"];
    NSString *barcodeText = self.cardDetails[@"barcode"];
    
    NSString *front_pic_id = self.cardDetails[@"front_pic_id"];
    NSString *back_pic_id = self.cardDetails[@"back_pic_id"];
    NSString *barcode_image = self.cardDetails[@"barcode_image"];
   
    barcode = self.cardDetails[@"barcode"];
    barcodeType =self.cardDetails[@"barcode_type"];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *pngFrontFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir,front_pic_id];
    [frontImageView  setImage:[UIImage imageWithContentsOfFile:pngFrontFilePath]];
    frontImage=frontImageView.image;
    if(frontImageView.image!=nil)
    {
        hasSelectedFront=YES;
    }
    
    NSString *pngBackFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir,back_pic_id];
    [backImageView  setImage:[UIImage imageWithContentsOfFile:pngBackFilePath]];
    backImage=backImageView.image;
    if(backImageView.image!=nil)
    {
        hasSelectedBack=YES;
    }
    
    NSString *pngBarImageFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir,barcode_image];
    [barcodeImageview  setImage:[UIImage imageWithContentsOfFile:pngBarImageFilePath]];

    cardNameField.text=cardName;
    
    if([barcodeText length]>0)
        hasBarcodeBeenScanned=YES;
    
    if(barcodeImageview.image==nil)
    {
        boolForMenuallyEnterCode=YES;
        downView.hidden=NO;
        barCodeView.hidden=YES;
        barcodeTextField.text=barcodeText;
    }
    else
    {
        boolForMenuallyEnterCode=NO;
        downView.hidden=YES;
        barCodeView.hidden=NO;
        scanCodeTextField.text=barcodeText;
        
    }
    frontPic = NO;
    backPic = NO;
}



//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
////    if (self.interfaceOrientation != UIInterfaceOrientationPortrait)
////    {
////        // http://stackoverflow.com/questions/181780/is-there-a-documented-way-to-set-the-iphone-orientation
////        // http://openradar.appspot.com/radar?id=697
////        // [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait]; // Using the following code to get around apple's static analysis...
////        [[UIDevice currentDevice] performSelector:NSSelectorFromString(@"setOrientation:") withObject:(__bridge id)((void*)UIInterfaceOrientationPortrait)];
////    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [cardNameField resignFirstResponder];
    
}


#pragma mark - Custom Methods

- (NSString *)randomString:(int)len
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++)
    {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}

- (void)cancel:(id)sender
{
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Do you want to save this loyalty card?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    alert.tag=01;
    [alert show];
    
   
}

- (void)saveCard:(id)sender
{
    
    [cardNameField resignFirstResponder];
    
    if([self canSaveCard])
    {
        
        NSString *frontPicID;
        NSString *backPicID;
        NSString *barCodeImageID;
        
        
        if(!self.comesFromCardDetails)
        {
           frontPicID        = [self randomString:32];
           backPicID         = [self randomString:32];
           barCodeImageID    = [self randomString:32];
        }
        else
        {
         frontPicID        = self.cardDetails[@"front_pic_id"];
         backPicID         = self.cardDetails[@"back_pic_id"];
         barCodeImageID    = self.cardDetails[@"barcode_image"];
        }
        
        
        
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *pngFrontFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir, frontPicID];
        NSData *frontPicData = [NSData dataWithData:UIImagePNGRepresentation(frontImage)];
        if ([[NSFileManager defaultManager] fileExistsAtPath:pngFrontFilePath]) {
            
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtPath:pngFrontFilePath error:&error];
            NSLog(@"file removed: %@",error);
        }
        
       bool okk = [frontPicData writeToFile:pngFrontFilePath atomically:YES];
        
        NSString *pngBackFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir, backPicID];
        NSData *backPicData = [NSData dataWithData:UIImagePNGRepresentation(backImage)];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:pngBackFilePath]) {
            
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtPath:pngBackFilePath error:&error];
            NSLog(@"file removed: %@",error);
        }
        
        okk =[backPicData writeToFile:pngBackFilePath atomically:YES];
        
        NSString *pngBarcodeImageFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir, barCodeImageID];
        NSData *barCodeimageData = [NSData dataWithData:UIImagePNGRepresentation(barcodeImageview.image)];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:pngBarcodeImageFilePath]) {
            
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtPath:pngBarcodeImageFilePath error:&error];
            NSLog(@"file removed: %@",error);
        }
        
        okk = [barCodeimageData writeToFile:pngBarcodeImageFilePath atomically:YES];
    
        
        [ZeeSQLiteHelper initializeSQLiteDB];
        if(boolForMenuallyEnterCode)
        {
            barCodeImageID=@"";
        }
        
        if(boolForMenuallyEnterCode && [barcode length]<1)
        {
            barcode=barcodeTextField.text;
        }
        
        if(self.comesFromCardDetails)
        {
          //  "update contacts Set address = ?, phone = ?, image = ? Where name=?";
            
            [ZeeSQLiteHelper executeQuery:[NSString stringWithFormat:@"UPDATE wallet_cards  Set card_name ='%@',front_pic_id ='%@', back_pic_id ='%@', barcode_image ='%@', barcode ='%@', barcode_type ='%@', user_id ='%@' Where id='%@'",[cardNameField text],frontPicID,backPicID,barCodeImageID,barcode,barcodeType,userid,self.cardDetails[@"id"]]];
        }
        else
        {
        
        [ZeeSQLiteHelper executeQuery:[NSString stringWithFormat:@"INSERT INTO wallet_cards (card_name, front_pic_id, back_pic_id,barcode_image, barcode, barcode_type, user_id) VALUES('%@', '%@', '%@', '%@','%@', '%@' , '%@');", [cardNameField text], frontPicID, backPicID, barCodeImageID,barcode, barcodeType,userid]];
        }
        [ZeeSQLiteHelper closeDatabase];
        
        if(self.comesFromCardDetails)
        {
            for (UIViewController *vc in self.navigationController.viewControllers)
            {
                if([vc isKindOfClass:[NewWalletViewController class]])
                {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    else
    {
        alertView = [[CustomIOS7AlertView alloc] init];
        customAlertMessage.text=@"You are missing an attribute of this card. Please make sure you've provided a name, pictures, and scanned a barcode.";
        [alertView setContainerView:customAlertView];
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Try Again", nil]];
        [alertView setDelegate:self];
        [alertView show];
        
    }
    
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView1 clickedButtonAtIndex: (NSInteger)buttonIndex
{
    // NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", buttonIndex, [alertView tag]);
    [alertView1 close];
}
- (BOOL)canSaveCard
{
    
    [cardNameField resignFirstResponder];
    
    if([[cardNameField text] isEqualToString:@""]) {
        return NO;
    }
    
    if(!hasSelectedFront) {
        return NO;
    }
    
//    if(!hasSelectedBack) {
//        return NO;
//    }
    
    
    if(boolForMenuallyEnterCode)
    {
        if([barcodeTextField.text length])
        {
            hasBarcodeBeenScanned=YES;
        }
    }
    
    if(!hasBarcodeBeenScanned) {
        return NO;
    }
    
    return YES;
    
}

- (IBAction)takeFrontPic:(id)sender {
    
    [cardNameField resignFirstResponder];
    
    frontPic = YES;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
#if TARGET_IPHONE_SIMULATOR
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    picker.sourceType = picker.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)takeBackPick:(id)sender {
    
    [cardNameField resignFirstResponder];
    
    backPic = YES;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
#if TARGET_IPHONE_SIMULATOR
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    picker.sourceType = picker.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)scanCard:(id)sender {
    
    
    barcodeTextField.text=@"";
    [cardNameField resignFirstResponder];
    
    reader.supportedOrientationsMask=ZBarOrientationMask(0);
    reader.showsHelpOnFail = YES;
    reader.readerDelegate = self;
    [reader.scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    [reader.scanner setSymbology:ZBAR_UPCA config: ZBAR_CFG_ENABLE to:1];
    reader.readerView.zoom = 1.0;
    [self presentViewController:reader animated:YES completion:nil];
    
}

- (IBAction)enterManuallyAction:(id)sender
{
    boolForMenuallyEnterCode=YES;
    [barcodeTextField setUserInteractionEnabled:YES];
    [barcodeTextField becomeFirstResponder];
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [barcodeTextField setUserInteractionEnabled:NO];
    
    return YES;
}


-(BOOL)shouldAutorotate
{
    return NO;
}


#pragma mark - Text Field Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
}

#pragma mark - Scanning Methods

- (void)readerView:(ZBarReaderView*)view didReadSymbols:(ZBarSymbolSet*)syms fromImage:(UIImage*) img {
    /*
     for(ZBarSymbol *sym in syms) {
     //NSLog(@"From here: \n %@", sym.data);
     }
     */
}

#pragma mark - UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    if(frontPic || backPic)
    {
        
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        [picker dismissViewControllerAnimated:YES completion:NULL];
        
        if(frontPic)
        {
            [frontImageView setImage:chosenImage];
            frontImage = chosenImage;
            hasSelectedFront = YES;
            [frontButton setImage:[UIImage imageNamed:@"button_Retake00"] forState:UIControlStateNormal];

        }
        
        if(backPic)
        {
            [backImageView setImage:chosenImage];
            backImage = chosenImage;
            hasSelectedBack = YES;
            [backButton setImage:[UIImage imageNamed:@"button_Retake00"] forState:UIControlStateNormal];

        }
        
        frontPic = NO;
        backPic = NO;
        
    }
    else
    {
        id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
        ZBarSymbol *symbol = nil;
        for(symbol in results)
        {
            boolForMenuallyEnterCode=NO;
            barCodeView.hidden=NO;
            hasBarcodeBeenScanned = YES;
            scanCodeTextField.text = symbol.data;
            
            barcodeType = [NSString stringWithFormat:@"%u", symbol.type];
            NSLog(@"%u - %@", symbol.type, symbol.typeName);
            barcode = symbol.data;
            [self setBarCodeImage:symbol];
        }
        
    }
    
}

-(void)setBarCodeImage:(ZBarSymbol *)symbol
{
    
    NSError* error = nil;
    ZXBitMatrix *result = [[ZXBitMatrix alloc] init];
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    
    if([barcodeType isEqualToString:@"39"])
    {
        result = [writer encode:barcode  format:kBarcodeFormatCode39 width:320 height:100 error:&error];
    } else if([barcodeType isEqualToString:@"12"]) {
        result = [writer encode:barcode  format:kBarcodeFormatCode128 width:320 height:100 error:&error];
    } else if([barcodeType isEqualToString:@"8"]) {
        result = [writer encode:barcode  format:kBarcodeFormatEan8 width:320 height:100 error:&error];
    } else if([barcodeType isEqualToString:@"13"]) {
        result = [writer encode:barcode  format:kBarcodeFormatEan13 width:320 height:100 error:&error];
    } else if([barcodeType isEqualToString:@"15"]) {
        result = [writer encode:barcode  format:kBarcodeFormatCodabar width:320 height:100 error:&error];
    } else if([barcodeType isEqualToString:@"34"]) {
        result = [writer encode:barcode  format:kBarcodeFormatRSS14 width:320 height:100 error:&error];
    } else if([barcodeType isEqualToString:@"57"]) {
        result = [writer encode:barcode  format:kBarcodeFormatPDF417 width:320 height:100 error:&error];
    } else if([barcodeType isEqualToString:@"64"]) {
        result = [writer encode:barcode  format:kBarcodeFormatQRCode width:320 height:100 error:&error];
    } else if([barcodeType isEqualToString:@"93"]) {
        result = [writer encode:barcode  format:kBarcodeFormatCode93 width:320 height:100 error:&error];
    } else if([barcodeType isEqualToString:@"128"]) {
        result = [writer encode:barcode  format:kBarcodeFormatCode128 width:320 height:100 error:&error];
    }
    
    if(result)
    {
        
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        [barcodeImageview setImage:[UIImage imageWithCGImage:image]];
        
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Couwalla"
                              message:[NSString stringWithFormat:@"An error occurred while generating this code. %@", barcodeType]
                              delegate:self cancelButtonTitle:@"Close"
                              otherButtonTitles:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
        [alert show];
        
    }
    [reader dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)alertView:(UIAlertView *)alertView1 clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView1.tag==01)
    {
        if(buttonIndex==1)
        {
            if(self.comesFromCardDetails)
            {
                for (UIViewController *vc in self.navigationController.viewControllers)
                {
                    if([vc isKindOfClass:[NewWalletViewController class]])
                    {
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            [self performSelector:@selector(saveCard:) withObject:nil afterDelay:0.5];
        }
    }
}

@end
