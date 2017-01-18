//
//  StorePreferencesViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "StorePreferencesViewController.h"
#import "StoreSettingViewController.h"
#import "StorePreferences.h"

@implementation StorePreferencesViewController
{
    NSMutableArray *mDbStorePreferenceArray;
    ProgressHudPresenter *mHudPresenter;
    NSInteger mIndexRow;
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Store Preferences";
    mHudPresenter = [ProgressHudPresenter new];
    
    UIButton *tBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tBackButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tBackButton sizeToFit];
    [tBackButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tcategoryCancel = [[UIBarButtonItem alloc]initWithCustomView:tBackButton];
    self.navigationItem.leftBarButtonItem = tcategoryCancel;
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]]];
    //mDbStorePreferenceArray = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchAllStoresPreference:nil]];
    ////NSLog(@"mDbStorePreferenceArray :%d",[mDbStorePreferenceArray count]);
    /*
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(EditTable:)];
    [addButton setBackgroundImage:[UIImage imageNamed:@"btn"]forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:51/255 green:179/255 blue:57/255 alpha:1];
    [self.navigationItem setRightBarButtonItem:addButton];
     */

}


- (IBAction) EditTable:(id)sender{
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [self.tableView setEditing:NO animated:NO];
        [self.tableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Delete"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [self.tableView setEditing:YES animated:YES];
        [self.tableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}

- (void) backButton:(UIBarButtonItem *)pBarButton
{
    [self.navigationController popViewControllerAnimated:YES ];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshView];
    
}

- (void) refreshView {
    if ([mDbStorePreferenceArray count]) {
        [mDbStorePreferenceArray removeAllObjects];
    }
    mDbStorePreferenceArray = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchAllStoresPreference:nil]];
    
    if ([mDbStorePreferenceArray count]) {
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(EditTable:)];
        [addButton setBackgroundImage:[UIImage imageNamed:@"btn22"]forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:51/255 green:179/255 blue:57/255 alpha:1];
        [addButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],  UITextAttributeTextColor,nil] forState:UIControlStateNormal];
        [self.navigationItem setRightBarButtonItem:addButton];
        
    }

}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [mDbStorePreferenceArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UIFont *tFont = [ UIFont fontWithName: @"HelveticaNeue-Bold" size: 17.0 ];
    cell.textLabel.font = tFont;
    cell.textLabel.textColor = [UIColor colorWithRed:(44/255.0) green:(44/255.0) blue:(44/255.0) alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    StorePreferences *tStorePreferences = [mDbStorePreferenceArray objectAtIndex:indexPath.row];
    if ([tStorePreferences.mEntityType isEqualToNumber:[NSNumber numberWithInt:1]]) {
        cell.textLabel.text = tStorePreferences.mBrandName;
    } else {
        cell.textLabel.text = tStorePreferences.mStoreName;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        StorePreferences *tStorePreferences = [mDbStorePreferenceArray objectAtIndex:indexPath.row];
        mIndexRow = indexPath.row;
        if ([tStorePreferences.mEntityType isEqualToNumber:[NSNumber numberWithInt:2]]) {
            NSString *tDeleteStorePreference = [KURL_DeleteStorePreferences stringByAppendingFormat:@"?store-id=%@",tStorePreferences.mStoreID];
            [[NSUserDefaults standardUserDefaults] setObject:tStorePreferences.mStoreID forKey:@"deleteStorePreference"];
            
            [[RequestHandler getInstance] getRequestURL:tDeleteStorePreference delegate:self requestType:kDeleteStorePreferenceRequest];

        } else {
            NSString *tDeleteStorePreference = [KURL_DeleteStorePreferences stringByAppendingFormat:@"?brand-id=%@",tStorePreferences.mBrandID];
            [[NSUserDefaults standardUserDefaults] setObject:tStorePreferences.mBrandID forKey:@"deleteStorePreference"];
            
            [[RequestHandler getInstance] getRequestURL:tDeleteStorePreference delegate:self requestType:kDeleteStorePreferenceRequest];
        }
        
        [mHudPresenter presentHud];
    } 
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
    //[mHudPresenter hideHud];
    if (pRequestType == kDeleteStorePreferenceRequest) {
        if (!pError) {
            NSArray *tStorePreferencesArray = [NSArray new];
            StorePreferences *tStorePreferences = [mDbStorePreferenceArray objectAtIndex:mIndexRow];
            if ([tStorePreferences.mEntityType isEqualToNumber:[NSNumber numberWithInt:2]]) {
                tStorePreferencesArray = [[Repository sharedRepository] fetchStorePreferencesWithStoreID:[[NSUserDefaults standardUserDefaults] objectForKey:@"deleteStorePreference"] error:nil];
            } else {
                tStorePreferencesArray = [[NSArray alloc] initWithArray:[[Repository sharedRepository] fetchStorePreferencesWithBrandID:[[NSUserDefaults standardUserDefaults] objectForKey:@"deleteStorePreference"] error:nil]];
            }
            NSManagedObjectContext *tContext = [Repository sharedRepository].context;
            
            NSManagedObject *tDeleteTheRow = [tStorePreferencesArray objectAtIndex:0];
            [tContext deleteObject:tDeleteTheRow];

            NSError *error = nil;
            [[Repository sharedRepository].context save:&error];
            [mDbStorePreferenceArray removeObjectAtIndex:mIndexRow];
            [self.tableView reloadData];
            [mHudPresenter hideHud];
            [self refreshView];
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Store Preferences deleted successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];

        } else {
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
            
        }
    }
}

- (StorePreferences *) getBrandById:(NSInteger)pID {
    if (mDbStorePreferenceArray) {
        [mDbStorePreferenceArray removeAllObjects];
    }
    mDbStorePreferenceArray = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchAllStoresPreference:nil]];
    
    for (StorePreferences *tStorePreferences in mDbStorePreferenceArray) {
        if ([tStorePreferences.mEntityType isEqualToNumber:[NSNumber numberWithInt:2]]) {
            if (pID == [tStorePreferences.mStoreID integerValue]) {
                return tStorePreferences;
            }
            
        } else if ([tStorePreferences.mEntityType isEqualToNumber:[NSNumber numberWithInt:1]]) {
            if (pID == [tStorePreferences.mBrandID integerValue]) {
                return tStorePreferences;
            }
            
        }
    }
    return nil;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    StorePreferences *tStorePreferences = [mDbStorePreferenceArray objectAtIndex:indexPath.row];
        StoreSettingViewController *tStoreSettingViewController = [[StoreSettingViewController alloc] initWithNibName:@"StoreSettingViewController" bundle:nil];
    tStoreSettingViewController.mStorePreferencesType = kEditStorePreferences;

    if ([tStorePreferences.mEntityType isEqualToNumber:[NSNumber numberWithInt:2]]) {
        tStoreSettingViewController.mStorePreferencesSetting = [self getBrandById:[tStorePreferences.mStoreID integerValue]];
    } else {
        tStoreSettingViewController.mStorePreferencesSetting = [self getBrandById:[tStorePreferences.mBrandID integerValue]];
    }
    [self.navigationController pushViewController:tStoreSettingViewController animated:YES];
    
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

