//
//  RedeemPointViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RedeemPointViewController.h"
#import "RedeemPointCell.h"
#import "GiftCards.h"
#import "GiftCardDetailViewController.h"
#import "FileUtils.h"

@implementation RedeemPointViewController
{
    NSMutableArray *mGiftCardArray;
    ProgressHudPresenter *mHudPresenter;
    NSInteger mStartIndex;
    BOOL mIsLoadMore;
    NSInteger mCategoryID;
}
@synthesize mGiftCards;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Redeem Points";
    self.navigationItem.hidesBackButton = YES;

    mGiftCardArray = [NSMutableArray new];
    mHudPresenter = [ProgressHudPresenter new];
    mStartIndex = 0;
    mCategoryID = 0;
    mIsLoadMore = NO;
    
    //Back Button.
    UIButton *tbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tbackButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tbackButton sizeToFit];
    [tbackButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *tBackBar = [[UIBarButtonItem alloc]initWithCustomView:tbackButton];
    self.navigationItem.leftBarButtonItem = tBackBar;
    
    //Categories button on Bar.
    UIButton *tcategoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tcategoryButton setImage:[UIImage imageNamed:@"btn_categories"] forState:UIControlStateNormal];
    [tcategoryButton sizeToFit];
    [tcategoryButton addTarget:self action:@selector(categoryView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *tMenuBarCategory = [[UIBarButtonItem alloc]initWithCustomView:tcategoryButton];
    self.navigationItem.rightBarButtonItem = tMenuBarCategory;
    
    [self fetchGiftCardForCategoryID:mCategoryID startIndex:mStartIndex];

}

-(void)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES ];
}

// Fetch Gift Cards
- (void) fetchGiftCardForCategoryID:(NSInteger)pCategoryID startIndex:(NSInteger)pStartIndex{
    [mHudPresenter presentHud];
    NSDictionary *idDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", pCategoryID] forKey:@"id"];
    
    NSArray *tIDs = [NSArray arrayWithObjects:idDict, nil];
    NSMutableDictionary *tRequestDict = [NSMutableDictionary new];
    [tRequestDict setObject:[NSNumber numberWithInt:pStartIndex] forKey:@"startIndex"];
    [tRequestDict setObject:[NSNumber numberWithInt:kItemsPerPage] forKey:@"itemsPerPage"];

    if (pCategoryID != 0) {
        [tRequestDict setObject:tIDs forKey:@"categories"];
    }
    NSString *jsonRequest = [tRequestDict JSONRepresentation];
    [[RequestHandler getInstance] postRequestwithHostURL:kURL_PostGiftCardsQuery bodyPost:jsonRequest delegate:self requestType:kGiftCardsPostRequest];

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
    
    if (!pError) {
        if (pRequestType == kGiftCardsPostRequest) {
            [mGiftCardArray addObjectsFromArray:[[DataManager getInstance] mGiftCardsArray]];
        }
        
        mIsLoadMore = [mGiftCardArray count] % kItemsPerPage == 0 ? YES : NO;
        [self.tableView reloadData];
        
        
    }
    else{
    
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
    return [mGiftCardArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RedeemPointCell";
    
    RedeemPointCell *cell = (RedeemPointCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RedeemPointCell" owner:self options:nil];
        cell = (RedeemPointCell *)[topLevelObjects objectAtIndex:0];
    }
    [cell.mSeperatorImageView setHidden:YES];
    // Configure the cell...
    mGiftCards = [mGiftCardArray objectAtIndex:indexPath.row];
    cell.mTitleLabel.text = mGiftCards.mDisplayName;
    cell.mOfferLabel.text = mGiftCards.mLongPromoText;
    cell.mPriceOnPointLabel.text = [NSString stringWithFormat:@"%@ USD for %@ points", mGiftCards.mSavings ,mGiftCards.mPoints];
    
    NSString *tFileName = [mGiftCards.mThumbNail lastPathComponent];
    NSString *fmtFileName = makeFileName([mGiftCards.mID stringValue], tFileName);
    if (isFileExists(fmtFileName)) {
        [cell.mImageView setImage:[UIImage imageWithContentsOfFile:imageFilePath(fmtFileName)]];
    }
    else {
        cell.mImageView.image = [UIImage imageNamed:@"ReedemPointDefaultImage"];
        [[IconDownloadManager getInstance] setScreen:kRedeemPointsScreen delegate:self filePath:mGiftCards.mThumbNail iconID:[mGiftCards.mID stringValue] indexPath:indexPath];
    }
    if (indexPath.row == [mGiftCardArray count] - 1 && !mIsLoadMore) {
        [cell.mSeperatorImageView setHidden:NO];
    }

    if (indexPath.row  == [mGiftCardArray count] - 1) {
        if (mIsLoadMore) {
            mStartIndex += kItemsPerPage;
            [self fetchGiftCardForCategoryID:mCategoryID startIndex:mStartIndex];
    }
  }
    
    return cell;
}
    
- (void) iconDownloadManager:(IconDownloadManager *)pIconDownloadManager indexPath:(NSIndexPath *)pIndexPath {
    [self.tableView beginUpdates];
    if ([mGiftCardArray count] > pIndexPath.row) {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:pIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
	[self.tableView endUpdates];
    
}
    
#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    GiftCards *tGiftCard = [mGiftCardArray objectAtIndex:indexPath.row];

    GiftCardDetailViewController *detailViewController = [[GiftCardDetailViewController alloc] initWithNibName:@"GiftCardDetailViewController" bundle:nil];
    detailViewController.mGiftCard = tGiftCard;
    [self.navigationController pushViewController:detailViewController animated:YES];

}

// Categories List
-(void)categoryView:(id)sender {
    
    CategoriesViewController *tCategoriesViewController = [CategoriesViewController new];
    
    tCategoriesViewController.mDelegate = self;
    
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:tCategoriesViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

- (void) categoriesViewController:(CategoriesViewController *)pCategoriesViewController selectedCategoryID:(NSNumber *)pID {
    //NSLog(@"selectedCategoryID:%d", [pID integerValue]);
    mCategoryID = [pID integerValue];
    mStartIndex = 0;
    [mGiftCardArray removeAllObjects];
    [self fetchGiftCardForCategoryID:mCategoryID startIndex:mStartIndex];
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

