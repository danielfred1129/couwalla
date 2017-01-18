//
//  FavouriteCouponsViewController.m
//  Coupit
//
//  Created by geniemac5 on 26/10/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "FavouriteCouponsViewController.h"
#import "PlannerCell.h"
#import "Coupon.h"
#import "FileUtils.h"
#import "CouponGrouper.h"
#import "PlannerListViewController.h"

@interface FavouriteCouponsViewController ()

@end

@implementation FavouriteCouponsViewController

{
    UIView *mGestureView;
    UIButton *mMenuButton;
    
    UIButton *mFavouriteButton;
    NSMutableArray *mCouponListArray;
    CouponGrouper *mCouponGrouper;
    
    BOOL mIsFavorite;
    UILabel *mDisplayMessage;
}
-(void)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // self.navigationItem.title = @"Fav";
    mIsFavorite = NO;
    
    mCouponGrouper = [CouponGrouper new];
    // Favorite Button.
    mFavouriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mFavouriteButton setImage:[UIImage imageNamed:@"btn_favourites"] forState:UIControlStateNormal];
    [mFavouriteButton setImage:[UIImage imageNamed:@"btn_add_to_favourite"] forState:UIControlStateHighlighted];
    [mFavouriteButton setImage:[UIImage imageNamed:@"btn_add_to_favourite"] forState:UIControlStateSelected];
    
    
    [mFavouriteButton sizeToFit];
    [mFavouriteButton addTarget:self action:@selector(addFavourite:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tAddFavouriteBar = [[UIBarButtonItem alloc]initWithCustomView:mFavouriteButton];
    //self.navigationItem.rightBarButtonItem = tAddFavouriteBar;
    
    UIButton *tbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tbackButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tbackButton sizeToFit];
    [tbackButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tBackBar = [[UIBarButtonItem alloc]initWithCustomView:tbackButton];
    self.navigationItem.leftBarButtonItem = tBackBar;
    
    
       UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
    
    mGestureView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealToggle:)];
	[mGestureView addGestureRecognizer:recognizer];
	UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
	[mGestureView addGestureRecognizer:panRecognizer];
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (mCouponListArray) {
        [mCouponListArray removeAllObjects];
        mCouponListArray = nil;
    }
    if (mIsFavorite) {
        [mCouponGrouper setCoupons:[[Repository sharedRepository] fetchFavoriteCoupons:nil]];
        mCouponListArray = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchFavoriteCoupons:nil]];
        
    }

    
    [self.tableView reloadData];
    [self addFavourite:self];
    
}

- (void) showList:(fListType)pListType
{
    if (mCouponListArray) {
        [mCouponListArray removeAllObjects];
        mCouponListArray = nil;
    }
    
    switch (pListType) {

        case fFavoriteList:
        {
            mCouponListArray = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchFavoriteCoupons:nil]];
            
        }
            break;
            
        default:
            break;
    }
    
    [self.tableView reloadData];
    
}

- (void) addFavourite:(id)sender
{
    [mDisplayMessage removeFromSuperview];
    
    if (mCouponListArray) {
        [mCouponListArray removeAllObjects];
        mCouponListArray = nil;
    }
    
    mIsFavorite = !mIsFavorite;
    mFavouriteButton.selected = mIsFavorite;
    
    if (mIsFavorite) {
        [mCouponGrouper setCoupons:[[Repository sharedRepository] fetchFavoriteCoupons:nil]];
        mCouponListArray = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchFavoriteCoupons:nil]];
        self.navigationItem.title = @"Favorites";
        
    }

    
    [self.tableView reloadData];
    
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
    
    if([[mCouponGrouper getAllGroupIDs] count] == 0)
	{
        //tableView.hidden = YES;
		mDisplayMessage = [[UILabel alloc] initWithFrame:CGRectMake(55, 200, 320, 35)];
        mDisplayMessage.font = [UIFont systemFontOfSize:14.0f];
        mDisplayMessage.textColor = [UIColor colorWithRed:(102/255.0) green:(102/255.0) blue:(102/255.0) alpha:1.0];
        mDisplayMessage.backgroundColor = [UIColor clearColor];
        if (mIsFavorite) {
            mDisplayMessage.text = @"No Coupons marked favorite";
       }
            //else {
//            mDisplayMessage.text = @"No Coupons have been planned";
//            
//        }
		[tableView addSubview:mDisplayMessage];
	}
    else {
        [mDisplayMessage removeFromSuperview];
    }
    
    return [[mCouponGrouper getAllGroupIDs] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PlannerCell";
    
    PlannerCell *cell = (PlannerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"PlannerCell" owner:self options:nil];
        cell = (PlannerCell *)[topLevelObjects objectAtIndex:0];
        
    }
    [cell.mSeperatorImageView setHidden:YES];
    
    // Configure the cell...
    NSString *tGroupName = [[mCouponGrouper getAllGroupIDs] objectAtIndex:indexPath.row];
    
    //cell.mImageView.image = [UIImage imageNamed:@"t_MyCoupons"];
    
    cell.mStoreTitleLabel.text = tGroupName;
    NSInteger tCouponCount = [[mCouponGrouper getCouponListForGroupID:tGroupName] count];
    
    if (tCouponCount == 1) {
        cell.mActiveCouponsLabel.text = @"1 Downloaded Coupon";
    }
    else{
        cell.mActiveCouponsLabel.text = [NSString stringWithFormat:@"%d Downloaded Coupons", tCouponCount];
    }
    
    NSInteger tSavingAmount = [mCouponGrouper getCouponSavingForGroupID:tGroupName];
    
    if (tSavingAmount) {
        if (tSavingAmount == 1) {
            cell.mDiscountLabel.text = @"1 in Saving";
        }
        else {
            cell.mDiscountLabel.text = [NSString stringWithFormat:@"%d in Savings", tSavingAmount];
        }
    }
    else{
        //cell.mDiscountLabel.text = @"Hot deals";
        [cell.mDiscountLabel setHidden:YES];
    }
    if (indexPath.row == [[mCouponGrouper getAllGroupIDs] count]-1) {
        [cell.mSeperatorImageView setHidden:NO];
    }
    
    MyCoupons *tCoupon = [mCouponListArray objectAtIndex:indexPath.row];
    
    NSString *tFileName = [tCoupon.mThumbnailImage lastPathComponent];
    NSString *fmtFileName = makeFileName([tCoupon.mID stringValue], tFileName);
    //NSLog(@"fmtFileName :%@",tCoupon.mThumbnailImage);
    
    if (isFileExists(fmtFileName)) {
        [cell.mImageView setImage:[UIImage imageWithContentsOfFile:imageFilePath(fmtFileName)]];
    }
    else{
        cell.mImageView.image = [UIImage imageNamed:@"CouponsHomeDefaultImage"];
    }
    
    //@"Pizza Hut";
    [cell.mDistanceLabel setHidden:YES];
    [cell.mCheckInButton setHidden:YES];
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    
    PlannerListViewController *detailViewController = [[PlannerListViewController alloc] initWithNibName:@"PlannerListViewController" bundle:nil];
    NSString *tGroupName = [[mCouponGrouper getAllGroupIDs] objectAtIndex:indexPath.row];
    
    [detailViewController setPlannerCoupons:[mCouponGrouper getCouponListForGroupID:tGroupName] forGroup:tGroupName];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
