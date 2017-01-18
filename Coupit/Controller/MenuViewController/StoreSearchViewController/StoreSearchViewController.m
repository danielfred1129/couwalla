//
//  StoreSearchViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "StoreSearchViewController.h"
#import "StoreListCell.h"
#import "StoreMapViewController.h"
#import "Stores.h"
#import "Brands.h"
#import "FileUtils.h"
#import "StoreGoogleMapViewController.h"
#import "CameraViewController.h"
#import "LocationDocs.h"

//#import "Store.h"
#import "StoreListViewController.h"

@implementation StoreSearchViewController
{
    UIView *mGestureView;
    UIButton *mMenuButton;
    ProgressHudPresenter *mHudPresenter;
    NSMutableArray *mStoreLocationArray;
    NSMutableArray *mSearchDataArray;
    NSInteger mStoreStartIndex, mBrandStartIndex;
    BOOL mStoreLoadMore, mBrandLoadMore;
    BOOL mIsDataLoading;

}
@synthesize mtableView, mSearchText, mSearchType, mSeletedTab;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"Search '%@'", self.mSearchText];
    [self initButtons];
    mSearchDataArray = [NSMutableArray new];
    mStoreLocationArray = [NSMutableArray new];
    mStoreStartIndex = 0;
    mBrandStartIndex = 0;

    mStoreLoadMore = mBrandLoadMore = YES;
    mIsDataLoading = NO;
    
    mHudPresenter = [[ProgressHudPresenter alloc] init];
    [self makeSearchRequestWithString:self.mSearchText];
}

- (void) makeSearchRequestWithString:(NSString *)pSearchStr
{
    if (!mStoreLoadMore) {
        return;
    }
    
    [mHudPresenter presentHud];
    
    NSArray *tIDs = [NSArray arrayWithObjects:pSearchStr, nil];
    NSMutableDictionary *tRequestDict = [NSMutableDictionary new];
    [tRequestDict setObject:tIDs forKey:@"keywords"];
    [tRequestDict setObject:[NSNumber numberWithInt:mStoreStartIndex] forKey:@"startIndex"];
    [tRequestDict setObject:[NSNumber numberWithInt:kItemsPerPage] forKey:@"itemsPerPage"];
    
    
    NSString *jsonRequest = [tRequestDict JSONRepresentation];
    //NSLog(@"-------jsonRequest:%@ ", jsonRequest);
    
    if (mSeletedTab == kStoreSearch) {
        [[RequestHandler getInstance] postRequestwithHostURL:kURL_StoreQuery bodyPost:jsonRequest delegate:self requestType:kStoreQueryRequest];

    }
    else {
        [[RequestHandler getInstance] postRequestwithHostURL:kURL_CouponBrands bodyPost:jsonRequest delegate:self requestType:kCouponBrandRequest];
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
    
    [mHudPresenter hideHud];
    if (pRequestType == kStoreQueryRequest) {
        if (!pError) {
            NSMutableArray *tItems = [[DataManager getInstance] mStoresArray];
            NSMutableArray *tLocationItems = [[DataManager getInstance] mStoresLocationArray];

            if ([tItems count] >= kItemsPerPage) {
                mStoreLoadMore = YES;
            }
            else{
                mStoreLoadMore = NO;
            }
            
            [mSearchDataArray addObjectsFromArray:tItems];
            [mStoreLocationArray addObjectsFromArray:tLocationItems];
            [self.mtableView reloadData];
            if (![mSearchDataArray count]) {
                UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"No Store found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [tAlertView show];
            }
        }
        else {
            //NSLog(@"Request Failed:%d | Code:%d | Message:%@",pRequestType, pError.mErrorCode.intValue, pError.mMessage);
            
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Search Failed" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
            
        }
    }
    else if (pRequestType == kCouponBrandRequest) {
        if (!pError) {
            
            NSMutableArray *tItems = [[DataManager getInstance] mBrandsArray];
            if ([tItems count] >= kItemsPerPage) {
                mBrandLoadMore = YES;
            }
            else{
                mBrandLoadMore = NO;
            }
            
            [mSearchDataArray addObjectsFromArray:tItems];
            [mtableView reloadData];
            if (![mSearchDataArray count]) {
                UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"No Brand found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [tAlertView show];
            }
            
        }
        else {
            //NSLog(@"Request Failed:%d | Code:%d | Message:%@",pRequestType, pError.mErrorCode.intValue, pError.mMessage);
            
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Search Failed" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
            
        }

    }

}





-(void)showGestureView {
	if (![self.view.subviews containsObject:mGestureView]) {
		[self.view addSubview:mGestureView];
	}
}

-(void)hideGestureView {
	if ([self.view.subviews containsObject:mGestureView]) {
		[mGestureView removeFromSuperview];
	}
}

-(void)menuButtonSelected {
	mMenuButton.selected = YES;
}

-(void)menuButtonUnselected {
	mMenuButton.selected = NO;
}


 

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

    return [mSearchDataArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"StoreListCelll";
    
    StoreListCell *cell = (StoreListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"StoreListCell" owner:self options:nil];
        cell = (StoreListCell *)[topLevelObjects objectAtIndex:0];
    }
    [cell.mSeperatorImageView setHidden:YES];
    // Configure the cell...
    switch (mSearchType) {
        case kStoreSearch:
        {
                if (indexPath.row < [mSearchDataArray count])
                {
                Stores *tStores = [mSearchDataArray objectAtIndex:indexPath.row];
                StoreLocations *tStoreLocations = [mStoreLocationArray objectAtIndex:indexPath.row];
                cell.mStoreTitleLabel.text = tStores.mFullName;
                cell.mActiveCouponsLabel.text = [NSString stringWithFormat:@"%d Active Coupons",[tStores.mActiveCouponCount intValue]];
                
                //CheckIn button in the cell.
                cell.mCheckInButton.tag = indexPath.row;
                [cell.mCheckInButton addTarget:self action:@selector(checkInStore:) forControlEvents:UIControlEventTouchUpInside];

                
              //  NSString *tFileName = [tStores.mThumbnailImage lastPathComponent];
                NSString *tFileName = [tStores.mThumbnailImage lastPathComponent];
                NSString *fmtFileName = makeFileName([tStores.mID stringValue], tFileName);
                
                if (isFileExists(fmtFileName)) {
                    cell.mImageView.image =  [UIImage imageWithContentsOfFile:imageFilePath(fmtFileName)];
                }
                else{
                    cell.mImageView.image = [UIImage imageNamed:@"StoresHomeDefaultImage"];
                    [[IconDownloadManager getInstance] setScreen:kStoreSearchScreen delegate:self filePath:tStores.mThumbnailImage iconID:[tStores.mID stringValue] indexPath:indexPath];
                    
                }
                
                cell.mDistanceLabel.text = [[Location getInstance] getDistanceFromCurrentLocationInMiles:tStoreLocations.mGeoCoordinate];
                [cell.mDiscountLabel setHidden:YES];
                
                //NSLog(@"-------------- Index:%d", indexPath.row);
                if (indexPath.row == [mSearchDataArray count] - 1 && !mStoreLoadMore) {
                    [cell.mSeperatorImageView setHidden:NO];
                }
                
                if (indexPath.row  == [mSearchDataArray count] - 1) {
                    if (mStoreLoadMore && !mIsDataLoading) {
                        mStoreStartIndex += kItemsPerPage;
                        [self makeSearchRequestWithString:self.mSearchText];
                    }
                }
            }
        }
            break;
            case kBrandSearch:
        {
            if (indexPath.row < [mSearchDataArray count]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                Brands *tBrand = [mSearchDataArray objectAtIndex:indexPath.row];
                cell.mStoreTitleLabel.text = tBrand.mName;
                cell.mActiveCouponsLabel.text = [NSString stringWithFormat:@"%d Active Coupons",[tBrand.mActiveCouponCount intValue]];
                
                //NSString *tFileName = [tBrand.mThumbnailImage lastPathComponent];
                
                NSString *tFileName = [tBrand.mThumbnailImage lastPathComponent];
                NSString *fmtFileName = makeFileName([tBrand.mID stringValue], tFileName);
                // //NSLog(@"tBrand ------- fmtFileName:%@", fmtFileName);
                
                if (isFileExists(fmtFileName)) {
                    cell.mImageView.image =  [UIImage imageWithContentsOfFile:imageFilePath(fmtFileName)];
                }
                else{
                    cell.mImageView.image = [UIImage imageNamed:@"BrandsHomeDefaultImage"];
                    //cell.mImageView.image = [UIImage imageNamed:@"Brand_defaultImage"];
                    
                    [[IconDownloadManager getInstance] setScreen:kBrandSearchScreen delegate:self filePath:tBrand.mThumbnailImage iconID:[tBrand.mID stringValue] indexPath:indexPath];
                }
                
                //CheckIn button in the cell.
                cell.mCheckInButton.tag = indexPath.row;
                //[cell.mCheckInButton addTarget:self action:@selector(checkInBrand:) forControlEvents:UIControlEventTouchUpInside];
                
                // cell.mStoreTitleLabel.text = @"Pizza Hut";
                // cell.mActiveCouponsLabel.text = @"20 Active Coupons";
                [cell.mCheckInButton setHidden:YES];
                [cell.mDiscountLabel setHidden:YES];
                [cell.mDistanceLabel setHidden:YES];
                
                if (indexPath.row == [mSearchDataArray count] - 1 && !mBrandLoadMore) {
                    [cell.mSeperatorImageView setHidden:NO];
                }
                
                if (indexPath.row  == [mSearchDataArray count] - 1) {
                    if (mBrandLoadMore && !mIsDataLoading) {
                        mBrandStartIndex += kItemsPerPage;
                        [self makeSearchRequestWithString:self.mSearchText];
                    }
                }
            }
          }
            break;
        default:
            break;
    }

    
    return cell;
}

-(void) checkInStore:(UIButton *)sender
{
    //NSLog(@"checkIn Store button pressed");
    Stores *tStores = [mSearchDataArray objectAtIndex:sender.tag];
    StoreLocations *tStoreLocations = [mStoreLocationArray objectAtIndex:sender.tag];
    StoreListViewController *tStoreListViewController = [[StoreListViewController alloc] initWithNibName:@"StoreListViewController" bundle:nil];
    tStoreListViewController.mStoreLocator = kstoreSelected;
    [self.navigationController pushViewController:tStoreListViewController animated:YES];
    tStoreListViewController.mStoreID = tStores.mID;
    [tStoreListViewController showCouponsForStore:tStores];
    [tStoreListViewController showLocationForStore:tStoreLocations];

    
}
/*
-(void) checkInBrand:(UIButton *)sender
{
    //NSLog(@"checkIn Brand button pressed");
    Brands *tBrand = [mSearchDataArray objectAtIndex:sender.tag];
    StoreListViewController *tStoreListViewController = [[StoreListViewController alloc] initWithNibName:@"StoreListViewController" bundle:nil];
    tStoreListViewController.mStoreLocator = kBrandSelected;

    
    [self.navigationController pushViewController:tStoreListViewController animated:YES];
    [tStoreListViewController showCouponsForBrand:tBrand];
    
}
 */


- (void) iconDownloadManager:(IconDownloadManager *)pIconDownloadManager indexPath:(NSIndexPath *)pIndexPath
{
    [self.mtableView beginUpdates];

    switch (mSearchType) {
        case kStoreSearch:
        {
            if ([mSearchDataArray count] > pIndexPath.row) {
                [self.mtableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:pIndexPath] withRowAnimation:UITableViewRowAnimationNone];

            }
        }
            break;
        case kBrandSearch:
        {
            if ([mSearchDataArray count] > pIndexPath.row) {
                [self.mtableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:pIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                
            }
        }
            break;
        default:
            break;
    }
	[self.mtableView endUpdates];
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    if (mSearchType == kBrandSearch) {
        // Navigation logic may go here. Create and push another view controller.
        //NSLog(@"checkIn Brand button pressed");
        Brands *tBrand = [mSearchDataArray objectAtIndex:indexPath.row];
        StoreListViewController *tStoreListViewController = [[StoreListViewController alloc] initWithNibName:@"StoreListViewController" bundle:nil];
        tStoreListViewController.mStoreLocator = kBrandSelected;
        [self.navigationController pushViewController:tStoreListViewController animated:YES];
        [tStoreListViewController showCouponsForBrand:tBrand];
    } else {
        
    }

}


- (void) initButtons
{
    
    //Menu Button.
    mMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mMenuButton setImage:[UIImage imageNamed:@"button_menu"] forState:UIControlStateNormal];
    
    [mMenuButton sizeToFit];
    [mMenuButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
    
    UIBarButtonItem* menuBarButton = [[UIBarButtonItem alloc]initWithCustomView:mMenuButton];
    self.navigationItem.leftBarButtonItem = menuBarButton;
    
    mGestureView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //[mGestureView setBackgroundColor:[UIColor colorWithWhite:(0/255.0) alpha:0.4]];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self.navigationController.parentViewController action:@selector(revealToggle:)];
    [mGestureView addGestureRecognizer:recognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [mGestureView addGestureRecognizer:panRecognizer];
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

