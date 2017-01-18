//
//  MenuViewController.m
//  iTestPro
//
//  Created by Deepak Kumar on 2/3/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MenuViewController.h"

#import "MenuTableCell.h"

#import "ProfileViewController.h"
#import "RevealController.h"
#import "WWalletViewController.h"
#import "NewStoresViewController.h"
#import "FavouriteViewController.h"
#import "MyCouponViewController.h"
#import "LocationViewController.h"
#import "StoreMapViewController.h"
#import "RewardViewController.h"
#import "CouponListViewController.h"
#import "SearchViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Subscriber.h"
#import "StoreSearchViewController.h"
#import "WalletViewController.h"
#import "FeedbackViewController.h"
#import "QRViewController.h"
#import "GiftcardsViewController.h"
#import "NewWalletViewController.h"
#import "GTScrollNavigationBar.h"
#import "ProgressHudPresenter.h"
#import "appcommon.h"
#import "jsonparse.h"
#import "CouwallaHelpViewController.h"
#import "NewLocationViewController.h"

static int shouldHide;
static int isFirstPresentation;
static int mSeletedValue;


@implementation MenuViewController
{
    NSInteger mSelectedIndex;
    NSInteger mStartIndex, mItemsPerPage;
    ProgressHudPresenter *mHudPresenter;
    UIView *mOverlayView;
    SearchType mSearchType;
    UIWindow *currentWindow;
    NSMutableArray *dummyArray;
    NSMutableArray *arrayFroButton;
    NSString *zipValInsideWebService;
    UITextField *myTextField;
}

@synthesize mTableView;
@synthesize mSearchBar;
@synthesize mObjCouponsViewController;

#pragma mark -
#pragma mark View lifecycle

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self callWebServiceToGetData];
    
    mSeletedValue = [[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreference];
    arrayFroButton=[[NSMutableArray alloc]initWithObjects:_useCurrentLocationButon,_useHomeZipLocationButton,_useOtherZipLocationCode, nil];
    shouldHide=0;
    //    [self.mSearchBar setCloseButtonFont:[UIFont fontWithName:@"American Typewriter" size:14] textColor:[UIColor grayColor]];
    //    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    mSelectedIndex = 0;
    mSearchType = kCouponSearch;
    
    if (IS_IPHONE_5) {
        self.mTableView.frame = CGRectMake(0, 55, 320, 525);
    }
    else {
        self.mTableView.frame = CGRectMake(0, 55, 320, 436);
    }
    
    mHudPresenter = [ProgressHudPresenter new];
    
    [self.mTableView setSeparatorColor:[UIColor colorWithRed:(33.0/255) green:(33.0/255) blue:(33.0/255) alpha:1.0]];
    
    //    self.mSearchBar.backgroundColor = [UIColor colorWithRed:(100/255.0) green:(255/255.0) blue:(100/255.0) alpha:1.0];
    [self.mTableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_side_menu"]]];
    
    mOverlayView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    mOverlayView.userInteractionEnabled = YES;
    [mOverlayView setBackgroundColor:[UIColor colorWithWhite:(0/255.0) alpha:0.7]];
    
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchBarCancelButtonClicked:)];
	[mOverlayView addGestureRecognizer:recognizer];
    
    //    [self.mSearchBar `.titleLabel setTextColor:[UIColor blackColor]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self prefersStatusBarHidden];
}

-(void)showOverlayView
{
	if (![self.mTableView.subviews containsObject:mOverlayView])
    {
		[self.mTableView addSubview:mOverlayView];
	}
}

-(void)hideOverlayView
{
	if ([self.mTableView.subviews containsObject:mOverlayView])
    {
		[mOverlayView removeFromSuperview];
	}
}

- (void) viewDidLayoutSubviews
{
    
    CGRect viewBounds = self.view.bounds;
    NSString *version = [[UIDevice currentDevice] systemVersion];
    if ([version isEqualToString:@"7.0"]) {
        //CGFloat topBarOffset = self.topLayoutGuide.length;
        //viewBounds.origin.y = topBarOffset * -1;
        self.view.bounds = viewBounds;
    }else{
        //           CGFloat topBarOffset = self.topLayoutGuide.length;
        //           viewBounds.origin.y = topBarOffset * -1;
        self.view.bounds = viewBounds;
    }
}

//- (void)setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation
//{
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//
//}

- (void) notificationDictionary:(NSDictionary *)pDict
{
    NSString *tNotificationType = [pDict objectForKey:@"type"];
    //NSLog(@"tNotificationType:%@", tNotificationType);
    
    if ([tNotificationType isEqualToString:kAdvertisement]) {
        [self tableView:mTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] notification:pDict];
    }
    else if ([tNotificationType isEqualToString:kGiftcardNotification]) {
        [self tableView:mTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] notification:pDict];
    }
    else if ([tNotificationType isEqualToString:kRewardPointsUpdate]) {
        RewardViewController *tObjRewardViewController = [[RewardViewController alloc]initWithNibName:@"RewardViewController" bundle:nil];
        [tObjRewardViewController notificationDictionary:pDict];
    }
    else if ([tNotificationType isEqualToString:kStoreCouponNotification]) {
        [self tableView:mTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:0] notification:pDict];
    }
    
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor blackColor]];
    //NSLog(@"searchBarShouldBeginEditing");
    RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    [revealController hideFrontView];
    [self showOverlayView];
    [self.mSearchBar setFrame:CGRectMake(0, 0, 320, 62)];
    [self.mSearchBar setShowsCancelButton:YES animated:NO];
    [searchBar setShowsScopeBar:YES];
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    //NSLog(@"searchBarShouldEndEditing");
    
    RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    [revealController showFrontViewCompletely:NO];
    
    
    [self.mSearchBar resignFirstResponder];
    [self hideOverlayView];
    
    [self.mSearchBar setFrame:CGRectMake(0, 0, 260, 48)];
    [self.mSearchBar setShowsCancelButton:NO animated:NO];
    [searchBar setShowsScopeBar:NO];
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    //NSLog(@"searchBarCancelButtonClicked");
    
    RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    [revealController showFrontViewCompletely:NO];
    
    [self.mSearchBar resignFirstResponder];
    [self hideOverlayView];
    
    [self.mSearchBar setFrame:CGRectMake(0, 0, 260, 44)];
    [self.mSearchBar setShowsCancelButton:NO animated:YES];
    [self.mSearchBar setShowsScopeBar:NO];
    self.mSearchBar.text = nil;
    
    
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    mSearchType = selectedScope;
    //NSLog(@"selectedScope--------->%d",selectedScope);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    //NSLog(@"searchBarSearchButtonClicked");
    
    [self.mSearchBar resignFirstResponder];
    
    if ([searchBar.text length] == 0) {
        return;
    }
    if (mSearchType == kCouponSearch)
    {
        SearchViewController *tSearchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
        tSearchViewController.mSearchText = searchBar.text;
        tSearchViewController.mSearchType = kCouponSearch;
        
        RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tSearchViewController];
        
        [revealController setFrontViewController:navigationController animated:NO];
        searchBar.text = @"";
        mSelectedIndex = -1;
        [self.mTableView reloadData];
        
        
    }
    
    else if (mSearchType == kStoreSearch)
    {
        StoreSearchViewController *tStoreSearchViewController = [[StoreSearchViewController alloc] initWithNibName:@"StoreSearchViewController" bundle:nil];
        tStoreSearchViewController.mSearchText = searchBar.text;
        tStoreSearchViewController.mSearchType = mSearchType;
        tStoreSearchViewController.mSeletedTab = kStoreSearch;
        
        
        RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tStoreSearchViewController];
        
        [revealController setFrontViewController:navigationController animated:NO];
        searchBar.text = @"";
        mSelectedIndex = -1;
        [self.mTableView reloadData];
        
    }
    else if (mSearchType == kBrandSearch) {
        StoreSearchViewController *tStoreSearchViewController = [[StoreSearchViewController alloc] initWithNibName:@"StoreSearchViewController" bundle:nil];
        tStoreSearchViewController.mSearchText = searchBar.text;
        tStoreSearchViewController.mSearchType = mSearchType;
        tStoreSearchViewController.mSeletedTab = kBrandSearch;
        
        RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tStoreSearchViewController];
        
        [revealController setFrontViewController:navigationController animated:NO];
        searchBar.text = @"";
        mSelectedIndex = -1;
        [self.mTableView reloadData];
        
        
    }
    else if (mSearchType == kLoyaltyCardSearch) {
        WalletViewController *tWalletViewController = [[WalletViewController alloc] initWithNibName:@"WalletViewController" bundle:nil];
        tWalletViewController.mSearchText = searchBar.text;
        tWalletViewController.mIsSearched = YES;
        RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tWalletViewController];
        
        [revealController setFrontViewController:navigationController animated:NO];
        searchBar.text = @"";
        mSelectedIndex = -1;
        [self.mTableView reloadData];
        
        
    }
    
    
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 7;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    else if( indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 )
    {
        cell.mImageView.frame = CGRectMake(8, 0, 40, 40);
    }
    
    switch (indexPath.row)
    {
        case 0:
        {
            cell.mTitleLabel.text = @"Coupons";
            cell.mImageView.image = [UIImage imageNamed:@"sm_coupon3"];
        }
            break;
            
        case 1:
        {
            cell.mTitleLabel.text = @"My Coupons";
            cell.mImageView.image = [UIImage imageNamed:@"sm_coupon"];
        }
            break;
            
        case 2:
        {
            cell.mTitleLabel.text = @"Wallet";
            cell.mImageView.image = [UIImage imageNamed:@"sm_wallet"];
        }
            break;
        case 3:
        {
            cell.mTitleLabel.text = @"Stores & Brands";
            //cell.mTitleLabel.font = [UIFont fontWithName:@"System Bold" size:10.0f];
            cell.mImageView.image = [UIImage imageNamed:@"sm_store"];
        }
            break;
        case 4:
        {
            cell.mTitleLabel.text = @"Location";
            cell.mImageView.image = [UIImage imageNamed:@"sm_location"];
        }
            break;
        case 5:
        {
            cell.mImageView.image = [UIImage imageNamed:@"sm_survey"];
            cell.mTitleLabel.text = @"Feedback";
        }
            break;
        case 6:
        {
            
            cell.mImageView.image = [UIImage imageNamed:@"sm_profile"];
            cell.mTitleLabel.text = @"My Profile";
        }
            break;
            
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


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView didSelectRowAtIndexPath:indexPath notification:nil];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath notification:(NSDictionary *)pNotificaiton
{
    // Navigation logic may go here. Create and push another view controller.
    //NSLog(@"pNotificaiton:%@", pNotificaiton);
    
    BOOL tIsMarked = YES;
    RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    
    [self.mSearchBar resignFirstResponder];
    
    switch (indexPath.row)
    {
        case 0:
        {
            if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[CouponsViewController class]])
            {
                //                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mObjCouponsViewController];
                //                mObjCouponsViewController.mResetCouponCategory = kFromMenuScreen;
                //                [revealController setFrontViewController:navigationController animated:NO];
                
                UINavigationController *navigationController = [[UINavigationController alloc] initWithNavigationBarClass:[GTScrollNavigationBar class] toolbarClass:nil];
                [navigationController setViewControllers:[NSArray arrayWithObjects:mObjCouponsViewController, nil]];
                [revealController setFrontViewController:navigationController animated:NO];
                
                if (pNotificaiton)
                {
                    [mObjCouponsViewController notificationDictionary:pNotificaiton];
                    [revealController revealToggle:nil];
                }
            } else {
                [revealController revealToggle:nil];
            }
        }
            break;
            
        case 1:
        {
            if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[MyCouponViewController class]])
            {
                //                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[MyCouponViewController alloc] initWithNibName:@"MyCouponViewController" bundle:nil]];
                //                [revealController setFrontViewController:navigationController animated:NO];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithNavigationBarClass:[GTScrollNavigationBar class] toolbarClass:nil];
                [navigationController setViewControllers:[NSArray arrayWithObjects:[[MyCouponViewController alloc] initWithNibName:@"MyCouponViewController" bundle:nil], nil]];
                [revealController setFrontViewController:navigationController animated:NO];
                
            } else {
                [revealController revealToggle:nil];
                
            }
        }
            break;
        case 2:
        {
            
            /* if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ! [((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[GiftcardsViewController class]])
             {
             GiftcardsViewController *tObjWalletViewController = [[GiftcardsViewController alloc]initWithNibName:@"WWalletViewController" bundle:nil];
             
             UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:tObjWalletViewController];
             [revealController setFrontViewController:navigationController animated:NO];
             
             if (pNotificaiton) {
             [tObjWalletViewController notificationDictionary:pNotificaiton];
             [revealController revealToggle:nil];
             }
             
             } else {
             [revealController revealToggle:nil];
             }
             }
             break;*/
            
            if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ! [((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[NewWalletViewController class]])
            {
                
                /*
                 RewardViewController *tObjRewardViewController = [[RewardViewController alloc]initWithNibName:@"RewardViewController" bundle:nil];
                 UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:tObjRewardViewController];
                 [revealController setFrontViewController:navigationController animated:NO];
                 */
                
                NewWalletViewController *walletViewer = [[NewWalletViewController alloc] initWithNibName:@"NewWalletViewController" bundle:[NSBundle mainBundle]];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:walletViewer];
                [revealController setFrontViewController:navigationController animated:NO];
                
            } else {
                [revealController revealToggle:nil];
            }
            
        }
            break;
        case 3:
        {
            if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ! [((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[NewStoresViewController class]])
            {
                NewStoresViewController *tNewStoresViewController = [[NewStoresViewController alloc]initWithNibName:@"NewStoresViewController" bundle:nil];
                //tNewStoresViewController.mSeletedTab = kNearmMeTab;
                
                
                UINavigationController *navigationController = [[UINavigationController alloc] initWithNavigationBarClass:[GTScrollNavigationBar class] toolbarClass:nil];
                [navigationController setViewControllers:[NSArray arrayWithObjects:tNewStoresViewController, nil]];
                [revealController setFrontViewController:navigationController animated:NO];
                
                if (pNotificaiton)
                {
                    //                    tNewStoresViewController.mSeletedTab = kStoreWithNotification;
                    //                    [tNewStoresViewController notificationDictionary:pNotificaiton];
                    //                    [revealController revealToggle:nil];
                }
                
            } else {
                [revealController revealToggle:nil];
            }
            
        }
            break;
        case 4:
        {
                        if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ! [((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[LocationViewController class]])
                        {
                            UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:[[NewLocationViewController alloc]initWithNibName:@"NewLocationViewController" bundle:nil]];
                            [revealController setFrontViewController:navigationController animated:NO];
                        } else {
                            [revealController revealToggle:nil];
                        }
//            isFirstPresentation=1;
//            
//            [self initialSetUp];
//            
//            [self locationCellOperation];
            
            
            
            
        }
            break;
            
        case 5:
        {
           if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[CouwallaHelpViewController class]])
           {
               UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[CouwallaHelpViewController alloc] initWithNibName:@"CouwallaHelpViewController" bundle:nil]];
               [revealController setFrontViewController:navigationController animated:NO];
           }
           else
           {
               [revealController revealToggle:nil];
           }
            
        }
            break;
        case 6:
        {
            
            
            
            if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[ProfileViewController class]])
            {
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil]];
                [revealController setFrontViewController:navigationController animated:NO];
            } else {
                [revealController revealToggle:nil];
                
            }
            
        }
            break;
            
        
    }
    
    if (tIsMarked)
    {
        mSelectedIndex = indexPath.row;
    }
    
    [self.mTableView reloadData];
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
    
    if (pRequestType == kLogoutRequest)
    {
        if (!pError) {
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPasswordKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            LoginViewController *tLoginViewController = [LoginViewController new];
            tLoginViewController.mIsLogOut = YES;
            
            UINavigationController *tNavigationController= [[UINavigationController alloc] initWithRootViewController:tLoginViewController];
            [self presentViewController:tNavigationController animated:NO completion:^{
                
            }];
            
            RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
            
            if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[CouponsViewController class]])
            {
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mObjCouponsViewController];
                
                [revealController setFrontViewController:navigationController animated:NO];
            }
            else{
                [revealController revealToggle:nil];
            }
            
            mSelectedIndex = 1;
            [self.mTableView reloadData];
            
            //[revealController revealToggle:nil];
            
            
        } else {
            //NSLog(@"Request Failed:%d | Code:%d | Message:%@",pRequestType, pError.mErrorCode.intValue, pError.mMessage);
            
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Unable to Logout" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
            
            //[tAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
            
        }
        
    }
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


#pragma mark- -MenuOpration
-(void)initialSetUp
{
    [self customizationForButton];
    
    
    if (mSeletedValue==0) {
        
        [self selectButtonAction:_useCurrentLocationButon];
        
    }else if(mSeletedValue==1)
    {
        //        if([zipValInsideWebService isEqualToString:@"0"] || [zipValInsideWebService isEqualToString:nil])
        //        {
        //            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //            myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
        //            [myAlertView addSubview:myTextField];
        //            myAlertView.tag=11;
        //            [myAlertView show];
        //        }
        
        [self selectButtonAction:_useHomeZipLocationButton];
        
    }else if(mSeletedValue==2)
    {
        
        NSString *tZipCode = [[NSUserDefaults standardUserDefaults] objectForKey:kZipCodeLocation];
        
        if ([tZipCode length]) {
            _textFieldOtherZip.text = tZipCode;
            [_textFieldOtherZip setHidden:NO];
            [_labelOtherZipCode setHidden:YES];
            [_useOtherZipLocationCode setImage:[UIImage imageNamed:@"select_checked.png"] forState:UIControlStateNormal];
            [_useOtherZipLocationCode setTitle:@"√" forState:UIControlStateNormal];
            isFirstPresentation=0;
        }
    }
    else
    {
        [self selectButtonAction:_useCurrentLocationButon];
    }
    [[_textFieldOtherZip layer] setBorderWidth:0.5];
    [[_textFieldOtherZip layer]setBorderColor:[UIColor whiteColor].CGColor];
    
}

-(void)customizationForButton
{
    _useCurrentLocationButon.layer.cornerRadius = _useCurrentLocationButon.bounds.size.height/2;
    [_useCurrentLocationButon.layer setBorderWidth:0.5];
    [_useCurrentLocationButon.layer setBorderColor:[UIColor whiteColor].CGColor];
    _useCurrentLocationButon.layer.masksToBounds = YES;
    
    _useHomeZipLocationButton.layer.cornerRadius = _useCurrentLocationButon.bounds.size.height/2;
    [_useHomeZipLocationButton.layer setBorderWidth:0.5];
    [_useHomeZipLocationButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    _useHomeZipLocationButton.layer.masksToBounds = YES;
    
    _useOtherZipLocationCode.layer.cornerRadius = _useCurrentLocationButon.bounds.size.height/2;
    [_useOtherZipLocationCode.layer setBorderWidth:0.5];
    [_useOtherZipLocationCode.layer setBorderColor:[UIColor whiteColor].CGColor];
    _useOtherZipLocationCode.layer.masksToBounds = YES;
    
    
    [_useCurrentLocationButon setTitle:@" " forState:UIControlStateNormal];
    [_useHomeZipLocationButton setTitle:@" " forState:UIControlStateNormal];
    [_useOtherZipLocationCode setTitle:@" " forState:UIControlStateNormal];
}
-(void)locationCellOperation
{
    currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:_bgViewForLocation];
    
    if(!shouldHide)
    {
        self.title=@"Setting";
        //            [mSettingButton setImage:[UIImage imageNamed:@"button_save.png"] forState:UIControlStateNormal];
        [currentWindow bringSubviewToFront:self.bgViewForLocation];
        self.bgViewForLocation.hidden=NO;
        CATransition *Sidetransition=[CATransition animation];
        Sidetransition.duration=0.5;
        Sidetransition.type=kCATransitionMoveIn;
        Sidetransition.subtype=kCATransitionFromBottom;
        [_bgViewForLocation.layer addAnimation:Sidetransition forKey:nil];
    }else
    {
        if([self.title isEqualToString:@"Setting"])
        {
            // perform Action For Save
        }
        
        self.title=@" ";
        //            [mSettingButton setImage:[UIImage imageNamed:@"button_setting.png"] forState:UIControlStateNormal];
        
        CATransition *Sidetransition=[CATransition animation];
        Sidetransition.duration=0.5;
        Sidetransition.type=kCATransitionPush;
        Sidetransition.subtype=kCATransitionFromTop;
        [_bgViewForLocation.layer addAnimation:Sidetransition forKey:nil];
        //        [self.view sendSubviewToBack:self.bgViewForSettingOption];
        self.bgViewForLocation.hidden=YES;
        
    }
    
    
    shouldHide=!shouldHide;
    
    
}
- (IBAction)backButtonActionForOverlay:(id)sender {
    
    self.title=@" ";
    shouldHide=0;
    //            [mSettingButton setImage:[UIImage imageNamed:@"button_setting.png"] forState:UIControlStateNormal];
    
    CATransition *Sidetransition=[CATransition animation];
    Sidetransition.duration=0.5;
    Sidetransition.type=kCATransitionPush;
    Sidetransition.subtype=kCATransitionFromTop;
    [_bgViewForLocation.layer addAnimation:Sidetransition forKey:nil];
    //        [self.view sendSubviewToBack:self.bgViewForSettingOption];
    self.bgViewForLocation.hidden=YES;
    
}


-(IBAction)selectButtonAction:(UIButton *)sender
{
    LocationPreference tLocationPreference;
    tLocationPreference=kCurrentLocation;
    UIButton *button = (UIButton*)sender;
    if(dummyArray==nil) dummyArray=[[NSMutableArray alloc]init];
    [dummyArray removeAllObjects];
    [dummyArray addObjectsFromArray:arrayFroButton];
    
    switch (button.tag) {
            
            
        case 1:
            
            if ([sender.titleLabel.text isEqualToString:@" "]) {
                
                [sender setTitle:@"√" forState:UIControlStateNormal];
                [sender setImage:[UIImage imageNamed:@"select_checked.png"] forState:UIControlStateNormal];
                
                
                [[Location getInstance] calculateCurrentLocation];
                tLocationPreference = kCurrentLocation;
                if(!isFirstPresentation)
                {
                    
                    UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Current location has been updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [tAlert show];
                    
                }
                isFirstPresentation=0;
                
                
                
            }else if ([sender.titleLabel.text isEqualToString:@"√"]) {
                
                //                [sender setTitle:@" " forState:UIControlStateNormal];
                //                [sender setImage:nil forState:UIControlStateNormal];
            }
            
            break;
            
        case 2:
            if ([sender.titleLabel.text isEqualToString:@" "]) {
                
                [sender setTitle:@"√" forState:UIControlStateNormal];
                [sender setImage:[UIImage imageNamed:@"select_checked.png"] forState:UIControlStateNormal];
                
                
                tLocationPreference = kHomeLocation;
                [self showAlertView];
                
                isFirstPresentation=0;
                
                
                
            }else if ([sender.titleLabel.text isEqualToString:@"√"])
            {
                
                //                [sender setTitle:@" " forState:UIControlStateNormal];
                //                [sender setImage:nil forState:UIControlStateNormal];
            }
            break;
            
        case 3:
            if ([sender.titleLabel.text isEqualToString:@" "]) {
                
                [sender setTitle:@"√" forState:UIControlStateNormal];
                [sender setImage:[UIImage imageNamed:@"select_checked.png"] forState:UIControlStateNormal];
                [_textFieldOtherZip setHidden:NO];
                [_labelOtherZipCode setHidden:YES];
                tLocationPreference = kZipPostalCode;
                isFirstPresentation=0;
                
            }else if ([sender.titleLabel.text isEqualToString:@"√"]) {
                //                [_textFieldOtherZip setHidden:YES];
                //                [_labelOtherZipCode setHidden:NO];
                
                //                [sender setTitle:@" " forState:UIControlStateNormal];
                //                [sender setImage:nil forState:UIControlStateNormal];
            }
            break;
    }
    
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:tLocationPreference forKey:kLocationPreference];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [dummyArray removeObject:sender];
    [self settingForUnSelectedButton:dummyArray];
}

-(void)settingForUnSelectedButton:(NSMutableArray *)btnArray
{
    for (UIButton *btn in btnArray) {
        [btn setImage:[UIImage imageNamed:@"select_none.png"] forState:UIControlStateNormal];
        [btn setTitle:@" " forState:UIControlStateNormal];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView cancelButtonIndex] == buttonIndex && alertView.tag!=11) {
        [self performSelector:@selector(homeScreen) withObject:nil afterDelay:.1];
        
    }else if(alertView.tag==11)
    {
        [[NSUserDefaults standardUserDefaults]setValue:myTextField.text forKeyPath:@"zipValueinSetting"];
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Home location has been updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        if(myTextField.text.length<1)
        {
            [self showAlertView];
        }else
            
        {
            
            [tAlert show];
        }
        
        
    }
    
}

- (void) homeScreen {
    [_bgViewForLocation removeFromSuperview];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate loginViewController:nil loginStatus:YES];
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    static NSCharacterSet *charSet = nil;
    if(!charSet) {
        charSet = [[NSCharacterSet characterSetWithCharactersInString:kNUMERIC] invertedSet];
    }
    NSRange location = [string rangeOfCharacterFromSet:charSet];
    return (location.location == NSNotFound);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if ([textField.text length] < 5) {
        UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:kZipFieldLengthMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlertView show];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kZipCodeLocation];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        _textFieldOtherZip.text = nil;
        
    } else if ([textField.text length ] > 5){
        UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:kZipFieldLengthMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlertView show];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kZipCodeLocation];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        _textFieldOtherZip.text = nil;
        
    }else if ([textField.text isEqualToString:@"00000"]){
        UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"ZipCode not valid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlertView show];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kZipCodeLocation];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        _textFieldOtherZip.text = nil;
        
    }
    else if ([textField.text length] == 5){
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:kZipCodeLocation];
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Zip Code has been updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlert show];
        
        
    }
    
    [textField resignFirstResponder];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text length] < 5) {
        UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:kZipFieldLengthMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlertView show];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kZipCodeLocation];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        _textFieldOtherZip.text = nil;
        
    } else if ([textField.text length ] > 5){
        UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:kZipFieldLengthMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlertView show];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kZipCodeLocation];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        _textFieldOtherZip.text = nil;
        
    }else if ([textField.text isEqualToString:@"00000"]){
        UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"ZipCode not valid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlertView show];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kZipCodeLocation];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        _textFieldOtherZip.text = nil;
        
    }
    else if ([textField.text length] == 5){
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:kZipCodeLocation];
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Zip Code has been updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlert show];
        
        
    }
    
    [textField resignFirstResponder];
    return YES;
}


#pragma mark- -WebService-
-(void)callWebServiceToGetData
{
    NSString  *userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
    NSMutableDictionary *profileDic = [NSMutableDictionary dictionary];
    if(userkey != nil)  [profileDic setObject:userkey forKey:@"userid"];
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/get_myprofile_data.php?",BASE_URL];
    
    jsonparse *objJsonparse =[[jsonparse alloc]init];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityView startAnimating];
    
    NSDictionary *profileData = [objJsonparse customejsonParsing:urlString bodydata:profileDic];
    NSArray *profilearray = [profileData valueForKey:@"data"];
    
    NSDictionary * dictionary = [profilearray firstObject];
    zipValInsideWebService=[dictionary objectForKey:@"Zip"]?[dictionary objectForKey:@"Zip"]:@"";
}


-(void)showAlertView
{
    if(!isFirstPresentation)
    {
        
        if([zipValInsideWebService isEqualToString:@"0"] || [zipValInsideWebService isEqualToString:nil])
        {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            myAlertView.tag=11;
            
            myAlertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
            myTextField = [myAlertView textFieldAtIndex:0];
            myTextField.placeholder=@"Postal/Zip";
//            myTextField.delegate=self;
            myAlertView.delegate=self;

            [myAlertView show];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Home location has been updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            [[NSUserDefaults standardUserDefaults]setValue:zipValInsideWebService forKeyPath:@"zipValueinSetting"];
        }
     
    }
}
-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if(alertView.tag ==11)
    {
        if([[alertView textFieldAtIndex:0].text length] > 5)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return YES;
}



@end

