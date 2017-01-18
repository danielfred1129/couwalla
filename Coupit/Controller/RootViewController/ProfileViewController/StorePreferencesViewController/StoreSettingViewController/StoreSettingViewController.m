//
//  StoreSettingViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "StoreSettingViewController.h"
#import "tJSON.h"
#import "RequestHandler.h"
#import "StoreListViewController.h"
#define kSection0 @"Preferences"

@implementation StoreSettingViewController
{
    UIButton *mSaveButton;
    UIButton *mEditButton;
    NSMutableDictionary *mItemArrayDictionary;
    NSInteger mSelectedQuanity, mTempQuanity, mEntityType;
    NSMutableArray *mStoreArray;
    NSInteger mStoreID, mBrandID;
    ProgressHudPresenter *mHudPresenter;
    UISwitch *mNotificationSwitch,*mFavoriteSwitch;
    BOOL *mNotificationEnabled,mStoreSwitch;



}
@synthesize mPickerOverlayView, mPickerView, mStoreName, mStorePreferencesSetting, mStorePreferencesType;
@synthesize mBrandName;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Notification Settings";
    mItemArrayDictionary = [NSMutableDictionary new];
    mTempQuanity = mSelectedQuanity = 1;
    mHudPresenter = [ProgressHudPresenter new];

    UIButton *tBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tBackButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tBackButton sizeToFit];
    [tBackButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tcategoryCancel = [[UIBarButtonItem alloc]initWithCustomView:tBackButton];
    self.navigationItem.leftBarButtonItem = tcategoryCancel;
    
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]]];
    if (mStorePreferencesType == kAddStorePreferenes) {
        // Save Button
        mSaveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [mSaveButton setImage:[UIImage imageNamed:@"btn_save"] forState:UIControlStateNormal];
        [mSaveButton sizeToFit];
        [mSaveButton addTarget:self action:@selector(saveStorePreferences:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *tSaveBar = [[UIBarButtonItem alloc]initWithCustomView:mSaveButton];
        self.navigationItem.rightBarButtonItem = tSaveBar;

    }
    else if (mStorePreferencesType == kEditStorePreferences) {
        mTempQuanity = mSelectedQuanity = [mStorePreferencesSetting.mDistanceAway integerValue];
        mBrandID = [mStorePreferencesSetting.mBrandID integerValue];
        mEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [mEditButton setImage:[UIImage imageNamed:@"btn_save"] forState:UIControlStateNormal];
        [mEditButton sizeToFit];
        [mEditButton addTarget:self action:@selector(editStorePreferences:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *tEditBar = [[UIBarButtonItem alloc]initWithCustomView:mEditButton];
        self.navigationItem.rightBarButtonItem = tEditBar;
    }
    [mPickerView selectRow:mSelectedQuanity - 1 inComponent:0 animated:NO];

}

- (void) getStoreWithStoreID:(NSString *)pStoreID withBrandID:(NSString *)pBrandID withEntityType:(NSInteger)pEntityType {

    mStoreArray = [NSMutableArray new];
    mStoreArray = [[DataManager getInstance] mStoresArray];
    mStoreID = [pStoreID integerValue];
    mBrandID = [pBrandID integerValue];
    mEntityType = pEntityType;
    //NSLog(@" Store ID :%d |Brand ID :%d | Store Name :%@ | BrandName :%@ | EntityType :%d",mStoreID, mBrandID, mStoreName, mBrandName, mEntityType);
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = kSection0;
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
    tSectionTitleLabel.frame = CGRectMake(20, 6, 300, 30);
    tSectionTitleLabel.backgroundColor = [UIColor clearColor];
    tSectionTitleLabel.textColor = [UIColor colorWithRed:(77.0/255.0) green:(77.0/255.0) blue:(77.0/255.0) alpha:1];
    tSectionTitleLabel.shadowColor = [UIColor whiteColor];
    tSectionTitleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    tSectionTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    tSectionTitleLabel.text = tSectionTitle;
    
    // Create header view and add label as a subview
    UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    [tView addSubview:tSectionTitleLabel];
    return tView;
    
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
    }
    
    UIFont *tFont = [ UIFont fontWithName: @"HelveticaNeue-Bold" size: 17.0 ];
    cell.textLabel.font = tFont;
    cell.textLabel.textColor = [UIColor colorWithRed:(44/255.0) green:(44/255.0) blue:(44/255.0) alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (mStorePreferencesType == kAddStorePreferenes) {
        switch (indexPath.row) {
            case 0:
            {
                if (mEntityType == 1) {
                    cell.textLabel.text = @"Brand Name";
                    cell.detailTextLabel.text = mBrandName;
                } else {
                    cell.textLabel.text = @"Store Name";
                    cell.detailTextLabel.text = mStoreName;
                }
                
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"Notification Required";
                mNotificationSwitch = [[UISwitch alloc] init];
                mNotificationSwitch.frame = CGRectMake(215, 7, 30, 30);
                [mNotificationSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:mNotificationSwitch];
                if (mNotificationEnabled) {
                    [mNotificationSwitch setOn:YES];
                }
                else {
                    [mNotificationSwitch setOn:NO];
                }

            }
                break;
            case 2:
            {
                cell.textLabel.text = @"Distance";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d miles", mSelectedQuanity];

            }
                break;
                
            case 3:
            {
                
                cell.textLabel.text = @"Make as Favorite";
                mFavoriteSwitch = [[UISwitch alloc] init];
                mFavoriteSwitch.frame = CGRectMake(215, 7, 30, 30);
                [mFavoriteSwitch  setSelected:false];
                [mFavoriteSwitch addTarget:self action:@selector(favswitchChanged:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:mFavoriteSwitch];
                if (mFavoriteSwitch) {
                    [mFavoriteSwitch setOn:YES];
                }
                else {
                    [mFavoriteSwitch setOn:NO];
                }
                
            }
                break;
                
            default:
                break;
        }

    }
    else {
    
    switch (indexPath.row) {
        case 0:
        {
            if ([mStorePreferencesSetting.mEntityType isEqualToNumber:[NSNumber numberWithInt:1]]) {
                cell.textLabel.text = @"Brand Name";
                cell.detailTextLabel.text = mStorePreferencesSetting.mBrandName;
            } else {
                cell.textLabel.text = @"Store Name";
                cell.detailTextLabel.text = mStorePreferencesSetting.mStoreName;
            }
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"Notification Required";
            mNotificationSwitch = [[UISwitch alloc] init];
            mNotificationSwitch.frame = CGRectMake(215, 7, 30, 30);
            [mNotificationSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:mNotificationSwitch];
            mNotificationEnabled = [mStorePreferencesSetting.mNotificationEnabled boolValue];
            if (mNotificationEnabled) {
                [mNotificationSwitch setOn:YES];
            }
            else {
                [mNotificationSwitch setOn:NO];
            }
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"Distance";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d miles", mSelectedQuanity];

        }
            break;
            
        case 3:
        {
            
            cell.textLabel.text = @"Make as Favorite";
            mFavoriteSwitch = [[UISwitch alloc] init];
            mFavoriteSwitch.frame = CGRectMake(215, 7, 30, 30);
            [mFavoriteSwitch addTarget:self action:@selector(favswitchChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:mFavoriteSwitch];
            if (mFavoriteSwitch) {
                [mFavoriteSwitch setOn:YES];
            }
            else {
                [mFavoriteSwitch setOn:NO];
            }
            
        }
            break;
            
        default:
            break;
    }
}
    
    
    return cell;
}

- (void)favswitchChanged:(id)sender{
    if (mFavoriteSwitch.on) {
        mStoreSwitch = YES;
    }
    else {
        mNotificationEnabled = NO;
        
    }
}


- (void)switchChanged:(id)sender {
    
    if (mNotificationSwitch.on) {
        mNotificationEnabled = YES;
    }
    else {
        mNotificationEnabled = NO;
        
    }
    
}

- (void)saveStorePreferences:(id)sender {
    
    NSMutableArray *tKeys =    [NSArray arrayWithObjects:@"distanceAway", @"storeId",@"brandId", @"notificationEnabled",@"entityType", nil];
    NSMutableArray *tObjects = [NSArray arrayWithObjects:[NSNumber numberWithInteger:mSelectedQuanity],[NSNumber numberWithInteger:mStoreID],[NSNumber numberWithInteger:mBrandID],[NSNumber numberWithBool:mNotificationEnabled],[NSNumber numberWithInteger:mEntityType], nil];
    
    NSDictionary *tSaveStorePreferencesDict = [NSDictionary dictionaryWithObjects:tObjects forKeys:tKeys];
    NSString *jsonRequest = [tSaveStorePreferencesDict JSONRepresentation];
    //NSLog(@"jsonRequest for Coupon: %@", jsonRequest);
    
    [mHudPresenter presentHud];
    [[RequestHandler getInstance] postRequestwithHostURL:KURL_AddStorePreferences bodyPost:jsonRequest delegate:self requestType:kAddStorePreferencesRequest];
    
    
}

- (void)editStorePreferences:(id)sender {
    
    NSMutableArray *tKeys =    [NSArray arrayWithObjects:@"distanceAway", @"storeId",@"notificationEnabled",@"brandId",@"id",@"entityType",@"brandName", nil];
    NSMutableArray *tObjects = [NSArray arrayWithObjects:[NSNumber numberWithInteger:mSelectedQuanity],mStorePreferencesSetting.mStoreID,[NSNumber numberWithBool:mNotificationEnabled],[NSNumber numberWithInteger:mBrandID],mStorePreferencesSetting.mID,mStorePreferencesSetting.mEntityType,mStorePreferencesSetting.mBrandName, nil];
    
    NSDictionary *tEditStorePreferencesDict = [NSDictionary dictionaryWithObjects:tObjects forKeys:tKeys];
    NSString *jsonRequest = [tEditStorePreferencesDict JSONRepresentation];
    //NSLog(@"jsonRequest for Coupon: %@", jsonRequest);
    
    [mHudPresenter presentHud];
    [[RequestHandler getInstance] postRequestwithHostURL:KURL_AddStorePreferences bodyPost:jsonRequest delegate:self requestType:kEditStorePreferencesRequest];
    
    
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
    if (pRequestType == kAddStorePreferencesRequest) {
        if (!pError) {
            NSString *tAlertMessage = [NSString new];
            StorePreferences *tStorePreferences = [[DataManager getInstance] mObjStorePreferences];
            if ([tStorePreferences.mEntityType isEqualToNumber:[NSNumber numberWithInt:1]]) {
                tAlertMessage = kBrandPrefrencesMessage;
                NSArray *tStorePreferencesArray = [[NSArray alloc] initWithArray:[[Repository sharedRepository] fetchStorePreferencesWithBrandID:tStorePreferences.mBrandID error:nil]];
                NSManagedObjectContext *tContext = [Repository sharedRepository].context;
                for (NSManagedObject * tPreferenceList in tStorePreferencesArray) {
                    [tContext deleteObject:tPreferenceList];
                }
                
                NSError *saveError = nil;
                [tContext save:&saveError];
                [[Repository sharedRepository].context insertObject:tStorePreferences];
//                NSError *error;
//                [[Repository sharedRepository].context save:&error];
                
            } else {
                tAlertMessage = kStorePrefrencesMessage;
                [[Repository sharedRepository].context insertObject:tStorePreferences];
                NSError *error;
                [[Repository sharedRepository].context save:&error];
                
            }
            
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:tAlertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];

        } else {
            
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
            
        }
    }
    else if (pRequestType == kEditStorePreferencesRequest) {
        if (!pError) {
            
            StorePreferences *tStorePreferences = [[DataManager getInstance] mObjStorePreferences];
            NSArray *tStorePreferencesArray = [[NSArray alloc] initWithArray:[[Repository sharedRepository] fetchStorePreferencesWithBrandID:tStorePreferences.mBrandID error:nil]];
            NSManagedObjectContext *tContext = [Repository sharedRepository].context;

            NSManagedObject *tDeleteTheRow = [tStorePreferencesArray objectAtIndex:0];
            [tContext deleteObject:tDeleteTheRow];
            [[Repository sharedRepository].context insertObject:tStorePreferences];
            NSError *error;
            [[Repository sharedRepository].context save:&error];

            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Changes done successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
            
        } else {
            //NSLog(@"Request Failed:%d | Code:%d | Message:%@",pRequestType, pError.mErrorCode.intValue, pError.mMessage);
            
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
            
        }
    }
    //[self performSelectorOnMainThread:@selector(refreshData) withObject:nil waitUntilDone:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView cancelButtonIndex] == buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 2) {
        self.tableView.scrollEnabled = NO;
        [self.view addSubview:self.mPickerOverlayView];
    }
}

#pragma mark -
#pragma mark PickerView DataSource
- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
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
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    mTempQuanity = row;
}

- (void) backButton:(UIBarButtonItem *)pBarButton {
    
    if (mStorePreferencesType == kAddStorePreferenes) {
        if (mNotificationSwitch.on) {
            
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Please save the preferences" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
            
            
        } else {
            [self.navigationController popViewControllerAnimated:YES ];
        }

    }
    
    else {
        [self.navigationController popViewControllerAnimated:YES ];
/*
        if ((!mNotificationSwitch.on) || (mSelectedQuanity != mTempQuanity)) {
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Please save the preferences" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];

        } else {
            [self.navigationController popViewControllerAnimated:YES ];

        }
 */

    }
     
}

- (IBAction) doneButton:(id)sender {
    self.tableView.scrollEnabled = YES;
    mSelectedQuanity = mTempQuanity+1;
    [self.mPickerOverlayView removeFromSuperview];
    [self.tableView reloadData];
    
}
- (IBAction) cancelButton:(id)sender {
    self.tableView.scrollEnabled = YES;
    [self.mPickerOverlayView removeFromSuperview];
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}





@end

