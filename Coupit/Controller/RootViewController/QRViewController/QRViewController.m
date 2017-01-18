//
//  QRViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "QRViewController.h"
#import "CardManager.h"
#import "FileUtils.h"
#import "RevealController.h"
#import "AppDelegate.h"
#import "Stores.h"
#import "StoreLocations.h"
#import "StoreListViewController.h"
#import "jsonparse.h"
#import "appcommon.h"
#import "LocalyticsSession.h"

#define kCameraTransform  1.0

@implementation QRViewController {
    NSTimer *mTimer;
    ProgressHudPresenter *mHudPresenter;
    UIImagePickerController *mPickerController;
    NSMutableDictionary *qrData;
    NSMutableArray *qrDownloadedCouponList,*qrstoreNameArray,*qrstoreThumbnail,*qrpointsarray,*qrstorenumber,*qrstoreaddress,*qrstorelatarray,*qrstorelongarray;

}
@synthesize mCameraView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mHudPresenter = [[ProgressHudPresenter alloc] init];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[LocalyticsSession shared] tagScreen:kQRCheckin];
}

-(void)zbarReaderView {
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    //reader.view.frame = CGRectMake(0, 44, 320, 300);
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.cameraOverlayView = [self setOverlayPickerView];
    reader.showsZBarControls = NO;
    
    ZBarImageScanner *scanner = reader.scanner;
    CGFloat x,y,width,height;
    x = [self setOverlayPickerView].frame.origin.x / reader.readerView.bounds.size.width;
    y = [self setOverlayPickerView].frame.origin.y / reader.readerView.bounds.size.height;
    width = [self setOverlayPickerView].frame.size.width / reader.readerView.bounds.size.width;
    height = [self setOverlayPickerView].frame.size.height / reader.readerView.bounds.size.height;
    
    reader.readerView.scanCrop = CGRectMake(x, y, width, height);
    [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];

    [self presentViewController:reader animated:NO completion:nil];

}

- (UIView *)setOverlayPickerView {
    
    UIView *tOverlayView=[[UIView alloc] initWithFrame:CGRectMake(60, 25, 200, 200)];
    [tOverlayView setBackgroundColor:[UIColor clearColor]];
    
    UIImage *image1 = [UIImage imageNamed:@"ScanCamera"];
    UIImageView *imageLogo1 = [[UIImageView alloc] initWithImage:image1];
    imageLogo1.frame = CGRectMake(35, 100, 250, 250);
    [tOverlayView addSubview:imageLogo1];
    
    UILabel *tMessageLabel = [[UILabel alloc] init];
    if (IS_IPHONE_5) {
        [tMessageLabel setFrame:CGRectMake(25, 390, 60, 30)];
    } else {
        [tMessageLabel setFrame:CGRectMake(25, 300, 60, 30)];

    }
    tMessageLabel.text = @"Align QR code within the frame to scan.";
    tMessageLabel.font = [UIFont systemFontOfSize:14.0f];
    tMessageLabel.textColor = [UIColor blackColor];
    tMessageLabel.backgroundColor = [UIColor clearColor];
    [tOverlayView addSubview:tMessageLabel];
    
    UIToolbar *tMyToolBar = [[UIToolbar alloc] init];
    UIBarButtonItem *tBackButton=[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissOverlayView:)];
    
    tMyToolBar.tintColor = [UIColor colorWithRed:51.0/255 green:179.0/255 blue:57.0/255 alpha:1];
//    [tMyToolBar setItems:[NSArray arrayWithObject:tBackButton]];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    tMyToolBar.items = [NSArray arrayWithObjects:flexible,tBackButton,nil];
    [tMyToolBar setBarStyle:UIBarStyleDefault];
    CGRect toolBarFrame;
    if (!IS_IPHONE_5) {
        toolBarFrame = CGRectMake(0, 0, 320, 44);
        
    } else {
        toolBarFrame = CGRectMake(0, 0, 320, 44);
    }
    [tMyToolBar setFrame:toolBarFrame];
    UIView *cancelOverlayView=[[UIView alloc] initWithFrame:CGRectMake(0, 480, 120, 110)];
    [cancelOverlayView setBackgroundColor:[UIColor clearColor]];
    
    [tOverlayView addSubview:tMyToolBar];
    
    return  tOverlayView;
}

- (void)dismissOverlayView:(id)sender {
    
    mTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self.navigationController.parentViewController selector:@selector(revealToggle:) userInfo:nil repeats: NO];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (void)cancel{
    //NSLog(@"cancel");
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];

}
- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    //  get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // just grab the first barcode
        break;
    
    // showing the result on textview
    NSString* tResultText = symbol.data;
    NSMutableDictionary *tRequestDict = [NSMutableDictionary new];
    [tRequestDict setObject:tResultText forKey:@"qrtext"];
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/store_qr_checkin.php?",BASE_URL];
    
    jsonparse *objJsonparse =[[jsonparse alloc]init];
    
    qrData = [[NSMutableDictionary alloc]init];
    
    qrData = [objJsonparse customejsonParsing:urlString bodydata:tRequestDict];
    
    qrDownloadedCouponList = [qrData valueForKey:@"data"];
    
    //NSLog(@"%@",qrDownloadedCouponList);
    if (qrDownloadedCouponList.count>0) {
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Store found with this Barcode" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlert show];
    }
    
    qrstoreNameArray=[qrDownloadedCouponList valueForKey:@"storename"];
    qrstoreThumbnail=[qrDownloadedCouponList valueForKey:@"storeimage"];
    qrpointsarray = [qrDownloadedCouponList valueForKey:@"checkinpoints"];
    qrstorenumber = [qrDownloadedCouponList valueForKey:@"storeid"];
    qrstoreaddress = [qrDownloadedCouponList valueForKey:@"address"];
    qrstorelatarray = [qrDownloadedCouponList valueForKey:@"latitude"];
    qrstorelongarray = [qrDownloadedCouponList valueForKey:@"longitude"];
    
    // dismiss the controller
    //[reader dismissViewControllerAnimated:YES completion:nil];
}
- (void) storeListViewController:(StoreListViewController *)pStoreList isBack:(BOOL)pValue {
    if (pValue) {
        [self zbarReaderView];
    }
}

-(void)barCodeScanner {
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    //reader.view.frame = CGRectMake(0, 44, 320, 300);
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.cameraOverlayView = [self setOverlayPickerView];
    reader.showsZBarControls = NO;
    
    ZBarImageScanner *scanner = reader.scanner;
    CGFloat x,y,width,height;
    x = [self setOverlayPickerView].frame.origin.x / reader.readerView.bounds.size.width;
    y = [self setOverlayPickerView].frame.origin.y / reader.readerView.bounds.size.height;
    width = [self setOverlayPickerView].frame.size.width / reader.readerView.bounds.size.width;
    height = [self setOverlayPickerView].frame.size.height / reader.readerView.bounds.size.height;
    
    reader.readerView.scanCrop = CGRectMake(x, y, width, height);
    [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
    
    [self presentViewController:reader animated:NO completion:nil];
}

- (void) requestHandler:(RequestHandler *)pRequestHandler withRequestType:(RequestType)pRequestType error:(APIError *)pError
{
    // run on main thread only
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self requestHandler:pRequestHandler withRequestType:pRequestType error:pError];
        });
        return;
    }
    
    [mHudPresenter hideHud];
    
    if (pRequestType == kStoreQueryRequest) {
        if (!pError) {
            NSMutableArray *tStoreArray = [[DataManager getInstance] mStoresArray];
            NSMutableArray *tStoreLocationArray = [[DataManager getInstance] mStoresLocationArray];
            if ([tStoreArray count]||[tStoreLocationArray count]) {
                Stores *tStores = [tStoreArray objectAtIndex:0];
                StoreLocations *tStoreLocations = [tStoreLocationArray objectAtIndex:0];
                
                StoreListViewController *tStoreListViewController = [[StoreListViewController alloc] initWithNibName:@"StoreListViewController" bundle:nil];
                tStoreListViewController.mDelegate = self;
                [self.navigationController pushViewController:tStoreListViewController animated:YES];
                tStoreListViewController.mStoreID = tStores.mID;
                [tStoreListViewController showCouponsForStore:tStores];
                [tStoreListViewController showLocationForStore:tStoreLocations];

            } else {
                UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"No Stores associated with this Barcode" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                tAlert.tag = 1;
                [tAlert show];
            }
            
        } else {
            
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Unable to fetch Stores" message:pError.mMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            tAlert.tag = 2;
            [tAlert show];
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView cancelButtonIndex] == buttonIndex) {
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];

        StoreListViewController *tStoreListViewController = [[StoreListViewController alloc] initWithNibName:@"StoreListViewController" bundle:nil];
        
        tStoreListViewController.titlestring = [qrstoreNameArray objectAtIndex:0];
        tStoreListViewController.addressstring = [qrstoreaddress objectAtIndex:0];
        tStoreListViewController.tempstring = [qrstoreThumbnail objectAtIndex:0];
        tStoreListViewController.storeID = [qrstorenumber objectAtIndex:0];
        tStoreListViewController.latstring = [qrstorelatarray objectAtIndex:0];
        tStoreListViewController.longstring = [qrstorelongarray objectAtIndex:0];
        tStoreListViewController.mDelegate = self;
        [self.navigationController pushViewController:tStoreListViewController animated:YES];
    }
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
