//
//  FavouriteViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "FavouriteViewController.h"
#import "PlannerCell.h"
#import "Coupon.h"
#import "FileUtils.h"
#import "CouponGrouper.h"
#import "PlannerListViewController.h"
#import "jsonparse.h"
#import "appcommon.h"

@implementation FavouriteViewController
{
    UIView *mGestureView;
    UIButton *mMenuButton;
    
    UIButton *mFavouriteButton;
    NSMutableArray *mCouponListArray;
    CouponGrouper *mCouponGrouper;
    
    BOOL mIsFavorite;
    UILabel *mDisplayMessage;
    NSString *userkey;
    NSMutableDictionary *planerreponseData;
    NSMutableArray *planerlistarray,*namesarray,*descarray,*imgarray;
}

-(void)backButton:(id)sender
{
   [self.navigationController popViewControllerAnimated:YES];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //[self requestHandler:pRequestHandler withRequestType:pRequestType error:pError];
//    });
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Planner";
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
    
    
//    mMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [mMenuButton setImage:[UIImage imageNamed:@"button_menu"] forState:UIControlStateNormal];
//    [mMenuButton sizeToFit];
//    [mMenuButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* menuBarButton = [[UIBarButtonItem alloc]initWithCustomView:mMenuButton];
//    self.navigationItem.leftBarButtonItem = menuBarButton;
    
    UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
    
    mGestureView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealToggle:)];
	[mGestureView addGestureRecognizer:recognizer];
	UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
	[mGestureView addGestureRecognizer:panRecognizer];
    
    userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
    NSMutableDictionary *planerDic = [NSMutableDictionary dictionary];
    [planerDic setObject:userkey forKey:@"userid"];
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/get_plannerslist.php?",BASE_URL];
    
    jsonparse *objJsonparse =[[jsonparse alloc]init];
    
    planerreponseData = [[NSMutableDictionary alloc]init];
    
    planerreponseData = [objJsonparse customejsonParsing:urlString bodydata:planerDic];
    
    ////NSLog(@"%@",planerreponseData);
    planerlistarray = [[NSMutableArray alloc]init];
    planerlistarray = [planerreponseData valueForKey:@"data"];
   // //NSLog(@"%@",planerlistarray);
    namesarray = [planerlistarray valueForKey:@"name"];
    descarray = [planerlistarray valueForKey:@"coupon_description"];
    imgarray = [planerlistarray valueForKey:@"coupon_thumbnail"];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    /*
    if (mCouponListArray) {
        [mCouponListArray removeAllObjects];
        mCouponListArray = nil;
    }
    if (mIsFavorite) {
        [mCouponGrouper setCoupons:[[Repository sharedRepository] fetchFavoriteCoupons:nil]];
        mCouponListArray = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchFavoriteCoupons:nil]];

    }
    else {
        [mCouponGrouper setCoupons:[[Repository sharedRepository] fetchPlannedCoupons:nil]];
        mCouponListArray = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchPlannedCoupons:nil]];
        
    }
     */[self viewDidLoad];
    [self.tableView reloadData];

}

- (void) showList:(ListType)pListType
{
    if (mCouponListArray) {
        [mCouponListArray removeAllObjects];
        mCouponListArray = nil;
    }
    
    switch (pListType) {
        case kPlannedList:
        {
            mCouponListArray = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchPlannedCoupons:nil]];

        }
            break;
        case kFavoriteList:
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
        self.navigationItem.title = @"Favorite";

    }
    else {
        self.navigationItem.title = @"Planner";
        [mCouponGrouper setCoupons:[[Repository sharedRepository] fetchPlannedCoupons:nil]];
        mCouponListArray = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchPlannedCoupons:nil]];

    }
    
    [self.tableView reloadData];

    //[self showList:kFavoriteList];
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
    
    //if([[mCouponGrouper getAllGroupIDs] count] == 0)
    if([planerlistarray count] == 0)
	{
        //tableView.hidden = YES;
		mDisplayMessage = [[UILabel alloc] initWithFrame:CGRectMake(55, 200, 320, 35)];
        mDisplayMessage.font = [UIFont systemFontOfSize:14.0f];
        mDisplayMessage.textColor = [UIColor colorWithRed:(102/255.0) green:(102/255.0) blue:(102/255.0) alpha:1.0];
        mDisplayMessage.backgroundColor = [UIColor clearColor];
        if (mIsFavorite) {
            mDisplayMessage.text = @"No Coupons marked favorite";
        } else {
            mDisplayMessage.text = @"No Coupons have been planned";

        }
		[tableView addSubview:mDisplayMessage];
	}
    else {
        [mDisplayMessage removeFromSuperview];
    }
    
    return [planerlistarray count];
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
    NSString *tGroupName = [planerlistarray objectAtIndex:indexPath.row];

    //cell.mImageView.image = [UIImage imageNamed:@"t_MyCoupons"];[tCoupon valueForKey:@"customer_name"];

    
    cell.mStoreTitleLabel.text = [tGroupName valueForKey:@"customer_name"];
    cell.mDiscountLabel.text = [tGroupName valueForKey:@"name"];
    NSString *stringUrl = [NSString stringWithFormat:@"%@",[tGroupName valueForKey:@"coupon_thumbnail"]];
    NSURL *url=[[NSURL alloc]initWithString:stringUrl];
    NSData *imageData= [[NSData alloc]initWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc]initWithData:imageData];
    cell.mImageView.image =image;
//    NSInteger tCouponCount = [[mCouponGrouper getCouponListForGroupID:tGroupName] count];
//
//    if (tCouponCount == 1) {
//        cell.mActiveCouponsLabel.text = @"1 Downloaded Coupon";
//    }
//    else{
//        cell.mActiveCouponsLabel.text = [NSString stringWithFormat:@"%d Downloaded Coupons", tCouponCount];
//    }
//    
//    NSInteger tSavingAmount = [mCouponGrouper getCouponSavingForGroupID:tGroupName];
//    
//    if (tSavingAmount) {
//        if (tSavingAmount == 1) {
//            cell.mDiscountLabel.text = @"";
//        }
//else {
//        //cell.mDiscountLabel.text = [NSString stringWithFormat:@"%d in Savings", tSavingAmount];
//    cell.mDiscountLabel.text = @"";
//        }
//    }
//else{
//        cell.mDiscountLabel.text = @"Hot deals";
//        [cell.mDiscountLabel setHidden:YES];
//    }
//    if (indexPath.row == [[mCouponGrouper getAllGroupIDs] count]-1) {
//        [cell.mSeperatorImageView setHidden:NO];
//    }
//    
//    MyCoupons *tCoupon = [mCouponListArray objectAtIndex:indexPath.row];
//
//    NSString *tFileName = [tCoupon.mThumbnailImage lastPathComponent];
//    NSString *fmtFileName = makeFileName([tCoupon.mID stringValue], tFileName);
//    //NSLog(@"fmtFileName :%@",tCoupon.mThumbnailImage);
//    
//    if (isFileExists(fmtFileName)) {
//        [cell.mImageView setImage:[UIImage imageWithContentsOfFile:imageFilePath(fmtFileName)]];
//    }
//    else{
//        cell.mImageView.image = [UIImage imageNamed:@"CouponsHomeDefaultImage"];
//    }
//
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
    
//    NSString *tGroupName = [[mCouponGrouper getAllGroupIDs] objectAtIndex:indexPath.row];
//
//    [detailViewController setPlannerCoupons:[mCouponGrouper getCouponListForGroupID:tGroupName] forGroup:tGroupName];
   detailViewController.mDownloadedCouponList = [planerlistarray objectAtIndex:indexPath.row];
    
    //[detailViewController setPlannerCoupons:[mCouponGrouper getCouponListForGroupID:tGroupName] forGroup:tGroupName];
    detailViewController.name =  [namesarray objectAtIndex:indexPath.row];
    detailViewController.descrp = [descarray objectAtIndex:indexPath.row];
    detailViewController.tumbimg = [imgarray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
   
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

