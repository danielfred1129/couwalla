//
//  RightMenuViewController.m
//  Coupit
//
//  Created by Genie Technology on 04/10/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "RightMenuViewController.h"
#import "MenuTableCell.h"
#import "RevealController.h"

@interface RightMenuViewController ()

@end

@implementation RightMenuViewController
{
    NSInteger mSelectedIndex;
    
    NSInteger mStartIndex, mItemsPerPage;
    ProgressHudPresenter *mHudPresenter;
    UIView *mOverlayView;
    SearchType mSearchType;
}
@synthesize rightMenuTableView,mObjCouponsViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)prefersStatusBarHidden{
    return NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    mSelectedIndex =  1;
    if (IS_IPHONE_5) {
        self.rightMenuTableView.frame = CGRectMake(0, 44, 320, 525);
    }
    else {
        self.rightMenuTableView.frame = CGRectMake(0, 44, 320, 436);
    }
    [self.rightMenuTableView setSeparatorColor:[UIColor colorWithRed:(33.0/255) green:(33.0/255) blue:(33.0/255) alpha:1.0]];
    
    
    [self.rightMenuTableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_side_menu"]]];
    
    mOverlayView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    mOverlayView.userInteractionEnabled = YES;
    [mOverlayView setBackgroundColor:[UIColor colorWithWhite:(0/255.0) alpha:0.7]];
    
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchBarCancelButtonClicked:)];
	[mOverlayView addGestureRecognizer:recognizer];
    
}
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 6;
}

-(void)showOverlayView {
	if (![self.rightMenuTableView.subviews containsObject:mOverlayView]) {
		[self.rightMenuTableView addSubview:mOverlayView];
	}
}

-(void)hideOverlayView {
	if ([self.rightMenuTableView.subviews containsObject:mOverlayView]) {
		[mOverlayView removeFromSuperview];
	}
}

- (void) viewDidLayoutSubviews
{
    if (IS_IPHONE_5) {
        CGRect viewBounds = self.view.bounds;
        //CGFloat topBarOffset = self.topLayoutGuide.length;
        //viewBounds.origin.y = topBarOffset * -1;
        self.view.bounds = viewBounds;    }
    else {
        CGRect viewBounds = self.view.bounds;
        //        CGFloat topBarOffset = self.topLayoutGuide.length;
        //        viewBounds.origin.y = topBarOffset * -1;
        self.view.bounds = viewBounds;    }
    
}

- (void) notificationDictionary:(NSDictionary *)pDict
{
    NSString *tNotificationType = [pDict objectForKey:@"type1"];
    //NSLog(@"tNotificationType:%@", tNotificationType);
    
    if ([tNotificationType isEqualToString:kAdvertisement]) {
        [self tableView:rightMenuTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] notification:pDict];
    }
    else if ([tNotificationType isEqualToString:kGiftcardNotification]) {
        [self tableView:rightMenuTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] notification:pDict];
    }
    else if ([tNotificationType isEqualToString:kRewardPointsUpdate]) {
        //        RewardViewController *tObjRewardViewController = [[RewardViewController alloc]initWithNibName:@"RewardViewController" bundle:nil];
        //        [tObjRewardViewController notificationDictionary:pDict];
    }
    else if ([tNotificationType isEqualToString:kStoreCouponNotification]) {
        [self tableView:rightMenuTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:0] notification:pDict];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MenuTableCell";
    MenuTableCell *cell = (MenuTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MenuTableCell" owner:self options:nil];
		cell =  (MenuTableCell *)[topLevelObjects objectAtIndex:0];
	}
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_selected"]];
    
    cell.mSelectedImageView.image = nil;
    cell.mTitleLabel.textColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1.0];
    
    if (indexPath.row == 3 )
    {
        cell.mImageView.frame = CGRectMake(5, 0, 40, 40);
    }
    else if( indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 ){
        cell.mImageView.frame = CGRectMake(8, 0, 40, 40);
    }
    
    switch (indexPath.row) {
            
        case 0:
        {
            cell.mTitleLabel.text = @"Near Me";
            cell.mImageView.image = [UIImage imageNamed:@"sm_coupon"];
            
        }
            break;
            
        case 1:
        {
            cell.mTitleLabel.text = @"Retailers";
            cell.mImageView.image = [UIImage imageNamed:@"sm_coupon3"];
        }
            break;
            
        case 2:
        {
            cell.mTitleLabel.text = @"Manufacturer";
            cell.mImageView.image = [UIImage imageNamed:@"sm_wallet"];
        }
            break;
        case 3:
        {
            cell.mTitleLabel.text = @"Store Favorites";
            cell.mImageView.image = [UIImage imageNamed:@"sm_reward"];
        }
            break;
        case 4:
        {
            cell.mTitleLabel.text = @"Store Map";
            cell.mImageView.image = [UIImage imageNamed:@"sm_store"];
            
        }
        default:
            break;
    }
    
    // Make cell selected.
    if (indexPath.row == mSelectedIndex) {
        //NSLog(@"mSelectedIndex>>>>");
        cell.mSelectedImageView.image = [UIImage imageNamed:@"side_menu_selected_cell"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self tableView:tableView didSelectRowAtIndexPath:indexPath notification:nil];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath notification:(NSDictionary *)pNotificaiton{
    // Navigation logic may go here. Create and push another view controller.
    //NSLog(@"pNotificaiton:%@", pNotificaiton);
    
    BOOL tIsMarked = YES;
    RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    
    
    
    switch (indexPath.row) {
            
        case 0:
        {
            if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[NewStoresViewController class]])
            {
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[NewStoresViewController alloc] initWithNibName:@"StoresViewController" bundle:nil]];
                [revealController setFrontViewController:navigationController animated:NO];
            } else {
                [revealController revealToggle:nil];
                
            }
        }
            break;
            
            
        case 1:
        {
            if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[NewStoresViewController class]])
            {
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mObjCouponsViewController];
                //                mObjCouponsViewController.mResetCouponCategory = kFromMenuScreen;
                [revealController setFrontViewController:navigationController animated:NO];
                
                if (pNotificaiton)
                {
                    //[mObjCouponsViewController notificationDictionary:pNotificaiton];
                    [revealController revealToggle:nil];
                }
            } else {
                [revealController revealToggle:nil];
            }
        }
            break;
            
            
            //        case 2:
            //        {
            //            if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ! [((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[WalletViewController class]])
            //            {
            //                WalletViewController *tObjWalletViewController = [[WalletViewController alloc]initWithNibName:@"WalletViewController" bundle:nil];
            //
            //                UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:tObjWalletViewController];
            //                [revealController setFrontViewController:navigationController animated:NO];
            //
            //                if (pNotificaiton) {
            //                    [tObjWalletViewController notificationDictionary:pNotificaiton];
            //                    [revealController revealToggle:nil];
            //                }
            //
            //            } else {
            //                [revealController revealToggle:nil];
            //            }
            //        }
            //            break;
            //
            //        case 3:
            //        {
            //            if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ! [((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[RewardViewController class]])
            //            {
            //                RewardViewController *tObjRewardViewController = [[RewardViewController alloc]initWithNibName:@"RewardViewController" bundle:nil];
            //                UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:tObjRewardViewController];
            //
            //                [revealController setFrontViewController:navigationController animated:NO];
            //
            //            } else {
            //                [revealController revealToggle:nil];
            //            }
            //
            //        }
            //            break;
            //
            //        case 4:
            //        {
            //            if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ! [((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[StoresViewController class]])
            //            {
            //                StoresViewController *tStoresViewController = [[StoresViewController alloc]initWithNibName:@"StoresViewController" bundle:nil];
            //                tStoresViewController.mSeletedTab = kNearmMeTab;
            //
            //
            //                UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:tStoresViewController];
            //                [revealController setFrontViewController:navigationController animated:NO];
            //                if (pNotificaiton) {
            //                    tStoresViewController.mSeletedTab = kStoreWithNotification;
            //                    [tStoresViewController notificationDictionary:pNotificaiton];
            //                    [revealController revealToggle:nil];
            //                }
            //
            //            } else {
            //                [revealController revealToggle:nil];
            //            }
            //
            //        }
            //            break;
            //
            //        case 5:
            //        {
            //            if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ! [((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[LocationViewController class]])
            //            {
            //                UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:[[LocationViewController alloc]initWithNibName:@"LocationViewController" bundle:nil]];
            //                [revealController setFrontViewController:navigationController animated:NO];
            //            } else {
            //                [revealController revealToggle:nil];
            //            }
            //        }
            //            break;
            
            
        default:
            break;
    }
    
    if (tIsMarked) {
        mSelectedIndex = indexPath.row;
    }
    
    [self.rightMenuTableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
