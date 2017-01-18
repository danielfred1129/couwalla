//
//  WalletCardViewerViewController.m
//  Coupit
//
//  Created by Raphael Caixeta on 1/29/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "WalletCardViewerViewController.h"
#import "ZXingObjC.h"
#import "CreateNewCardViewController.h"

@implementation WalletCardViewerViewController
@synthesize cardDetails;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Wallet Preview";
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
   
    //barCodeImage
    {
        NSString *pngBarcodeImageFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir, cardDetails[@"barcode_image"]];
        [generatedBarCode setImage:[UIImage imageWithContentsOfFile:pngBarcodeImageFilePath]];
        
        if(generatedBarCode.image==nil)
        {
            UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(10, 25, 280, 50)];
            lbl.textAlignment=NSTextAlignmentCenter;
            lbl.backgroundColor=[UIColor clearColor];
            lbl.textColor=[UIColor lightGrayColor];
            lbl.text=@"No Image Available";
            [generatedBarCode addSubview:lbl];
        }
    }
    
    //FrontImage
    {
        NSString *pngFrontFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir, cardDetails[@"front_pic_id"]];
        [frontPic setImage:[UIImage imageWithContentsOfFile:pngFrontFilePath]];
    }
    
    //BackImage
    {
        NSString *pngBackFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir, cardDetails[@"back_pic_id"]];
        [backPic setImage:[UIImage imageWithContentsOfFile:pngBackFilePath]];
        if(backPic.image==nil)
        {
            [backPic setImage:[UIImage imageNamed:@"photo_back.png"]];
        }
    }
    
    cardName.text=[NSString stringWithFormat:@"Card Name : %@",cardDetails[@"card_name"]];
    [barcodeLabel setText:cardDetails[@"barcode"]];
    
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
        rbackButton.frame = CGRectMake(0, 0, 50, 30);
        [rbackButton setImage:[UIImage imageNamed:@"button_edit"] forState:UIControlStateNormal];
       // [rbackButton sizeToFit];
        [rbackButton addTarget:self action:@selector(editCoupon) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rBackBar = [[UIBarButtonItem alloc]initWithCustomView:rbackButton];
        self.navigationItem.rightBarButtonItem = rBackBar;
    }
}

- (void)cancel:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)editCoupon
{
    CreateNewCardViewController *vc=[[CreateNewCardViewController alloc]init];
    vc.comesFromCardDetails=YES;
    vc.cardDetails = [cardDetails copy];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
