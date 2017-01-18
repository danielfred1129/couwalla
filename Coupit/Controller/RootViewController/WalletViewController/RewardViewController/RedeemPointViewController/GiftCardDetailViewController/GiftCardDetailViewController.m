//
//  CouponDetailViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GiftCardDetailViewController.h"
#import "tJSON.h"
#import "FileUtils.h"
#import "RewardCard.h"
#import "AppDelegate.h"
#import "WebViewController.h"

@implementation GiftCardDetailViewController
{
    NSString *mDetailText;
    ProgressHudPresenter *mHudPresenter;
    NSInteger mSelectedQuanity, mTempQuanity;
    RewardCard *mRewardCard;

}

@synthesize mTableView, mGiftCard, mLongPromoLabel, mShortPromoLabel, mFullImageView;
@synthesize mPickerOverlayView, mPickerView, mSubmitButton,mPointExceedLabel;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = mGiftCard.mDisplayName;
    mTempQuanity = mSelectedQuanity = 1;
    [mPointExceedLabel setHidden:YES];
    
    self.navigationItem.hidesBackButton = YES;
    mHudPresenter = [[ProgressHudPresenter alloc] init];
    
    //Back Button.
    UIButton *tbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tbackButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tbackButton sizeToFit];
    [tbackButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tBackBar = [[UIBarButtonItem alloc]initWithCustomView:tbackButton];
    self.navigationItem.leftBarButtonItem = tBackBar;
    
    [self.mTableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]]];
    self.mLongPromoLabel.text = mGiftCard.mLongPromoText;
    self.mShortPromoLabel.text = [NSString stringWithFormat:@"%@ USD for %@ points", mGiftCard.mSavings ,mGiftCard.mPoints];
    
    NSString *tFileName = [mGiftCard.mImageWithoutBarcode lastPathComponent];
    NSString *fmtFileName = makeFileName([mGiftCard.mID stringValue], tFileName);
    if (isFileExists(fmtFileName)) {
        [self.mFullImageView setImage:[UIImage imageWithContentsOfFile:imageFilePath(fmtFileName)]];
    }
    else {
        [self.mFullImageView setImage:[UIImage imageNamed:@"GiftDetailDefaultImage"]];
        [[IconDownloadManager getInstance] setScreen:kGiftCardScreen delegate:self filePath:mGiftCard.mImageWithoutBarcode iconID:[mGiftCard.mID stringValue] indexPath:[NSIndexPath indexPathForRow:-1 inSection:0]];
    }
    mRewardCard = [[DataManager getInstance] getRewardCardObject];

  
}

- (void) iconDownloadManager:(IconDownloadManager *)pIconDownloadManager indexPath:(NSIndexPath *)pIndexPath {
    
    NSString *tFileName = [mGiftCard.mImageWithoutBarcode lastPathComponent];
    NSString *fmtFileName = makeFileName([mGiftCard.mID stringValue], tFileName);
    //NSLog(@"iconDownloadManager_fmtFileName:%@", fmtFileName);

    [self performSelectorOnMainThread:@selector(displayBanner:) withObject:imageFilePath(fmtFileName) waitUntilDone:NO];
}

- (void) displayBanner:(NSString *)pFilePath {
    [self.mFullImageView setImage:[UIImage imageWithContentsOfFile:pFilePath]];

}

- (IBAction) tearmAndConditionButton:(id)sender {
    
    WebViewController *tWebViewController = [WebViewController new];
    [tWebViewController openURLString:[[DataManager getInstance] getLegalURL]];
    [self presentViewController:tWebViewController animated:YES completion:^{
        
    }];
}

- (IBAction) doneButton:(id)sender {
    NSInteger tPointsRemaining = [mRewardCard.mPoints integerValue] - [mGiftCard.mPoints integerValue]*(mTempQuanity+1);
    
    if (tPointsRemaining >= 0 ) {
        mSelectedQuanity = mTempQuanity+1;

        [self.mPickerOverlayView removeFromSuperview];
        [self.mTableView reloadData];
        [mSubmitButton setHidden:NO];
        [mPointExceedLabel setHidden:YES];

    }
    else {
        
        mSelectedQuanity = mTempQuanity+1;

        [mPointExceedLabel setHidden:NO];
        [mSubmitButton setHidden:YES];
        [self.mPickerOverlayView removeFromSuperview];
        [self.mTableView reloadData];
    }
    
}

- (IBAction) cancelButton:(id)sender {
    [self.mPickerOverlayView removeFromSuperview];
}


- (IBAction) submitGiftCard:(id)sender
{
   
    [mHudPresenter presentHud];
    [[RequestHandler getInstance] getRequestURL:kGetRedeemGiftCardURL([mGiftCard.mID stringValue], mSelectedQuanity) delegate:self requestType:kRedeemGiftCardRequest];
     
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
        if (pRequestType == kRedeemGiftCardRequest) {
            if (!pError) {
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate makeSubscriberGetRequestByName];
                [appDelegate fetchGiftCardsImages];
                [self.navigationController popViewControllerAnimated:YES];

            } else {
                UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Message" message:pError.mMessage  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                
                [tAlert show];
            }
        }
    /*
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Message" message:kGiftCardAddedMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];

        [tAlert show];
     */
}
/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView cancelButtonIndex] == buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
*/

- (void) showSuccessAlert {
    [mHudPresenter showSuccessHUD];

}


- (void)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES ];
}



//ActionSheet Function.
-(IBAction)ShareTheCoupon:(id)sender{

//    UIActionSheet *tActionSheet = [[UIActionSheet alloc]initWithTitle:@"Share Deal"
//                                delegate:self cancelButtonTitle:@"Cancel"
//                                destructiveButtonTitle:nil otherButtonTitles:@"Email",
//                                @"Four Square",@"Facebook",@"Twitter", nil];
//    tActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//    [tActionSheet showInView:self.view];
//    //[tActionSheet showFromBarButtonItem:sender animated:NO];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.detailTextLabel.textColor = [UIColor colorWithRed:(51/255.0) green:(179/255.0) blue:(57/255.0) alpha:1.0];
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:15.0];
        
        
    }
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"Quantity";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", mSelectedQuanity];
            
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"Total Point Redeemed";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [mGiftCard.mPoints integerValue]*mSelectedQuanity];
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"Total Point Available";
            if ([mRewardCard.mPoints integerValue] >= [mGiftCard.mPoints integerValue]*mSelectedQuanity) {
                cell.detailTextLabel.textColor = [UIColor colorWithRed:(51/255.0) green:(179/255.0) blue:(57/255.0) alpha:1.0];
                cell.detailTextLabel.text = mRewardCard.mPoints;
            } else {
                [mSubmitButton setHidden:YES];
                [mPointExceedLabel setHidden:NO];
                cell.detailTextLabel.textColor = [UIColor colorWithRed:(255/255.0) green:(0/255.0) blue:(0/255.0) alpha:1.0];
                cell.detailTextLabel.text = mRewardCard.mPoints;
            }
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"Remaining Points";

            NSInteger tPointsRemaining = [mRewardCard.mPoints integerValue] - [mGiftCard.mPoints integerValue]*mSelectedQuanity;
            if (tPointsRemaining > 0 ) {
                cell.detailTextLabel.textColor = [UIColor colorWithRed:(51/255.0) green:(179/255.0) blue:(57/255.0) alpha:1.0];
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", tPointsRemaining];
            }
            else{
                //cell.detailTextLabel.textColor = [UIColor colorWithRed:(255/255.0) green:(0/255.0) blue:(0/255.0) alpha:1.0];
                cell.detailTextLabel.textColor = [UIColor colorWithRed:(51/255.0) green:(179/255.0) blue:(57/255.0) alpha:1.0];
                //cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", tPointsRemaining];
                cell.detailTextLabel.text =@"-";

            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    
    if (indexPath.row == 0) {

        [self.view addSubview:self.mPickerOverlayView];
    }
}


#pragma mark -
#pragma mark PickerView DataSource
- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return kPickerLimit;
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%d", row+1];
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    mTempQuanity = row;
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
