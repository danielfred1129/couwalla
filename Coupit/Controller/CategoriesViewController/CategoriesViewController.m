//
//  CategoriesViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CategoriesViewController.h"
#import "Category.h"

#import "RNFullScreenScroll.h"
#import "UIViewController+RNFullScreenScroll.h"
#import "UITabBarController+hidable.h"
#import "CouponsViewController.h"
#import "CategorysViewController.h"
#import "UIColor+AppTheme.h"
#import "Reachability.h"
#import "countdownManager.h"


static int hide;

@implementation CategoriesViewController
{
    NSMutableArray *mCategoryArray;
    UIButton *mMenuButton;
    ProgressHudPresenter *mHudPresenter;
    UIView *mGestureView;
    
    UIView *hideView;
    UISearchBar *searchBar;
    NSMutableArray *searchDummyArray;
    UITableView *searchDummyTable;
    UILabel *noResult;
    
}

@synthesize mTableView, mDelegate, mSelectedCategoryID;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView =[self getNevigationBarView:@"Categories"];
    [self.navigationController.navigationBar setTranslucent:NO];
    [HUDManager showHUDWithText:kHudMassage];
    hide=0;
    mHudPresenter =[[ProgressHudPresenter alloc]init];
    
    //Nevigationbar
    {
        //LeftItem
        mMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [mMenuButton setImage:[UIImage imageNamed:@"button_menu"] forState:UIControlStateNormal];
        [mMenuButton sizeToFit];
//        [mMenuButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [mMenuButton addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:mMenuButton];
        self.navigationItem.leftBarButtonItem = menuBarButton;
        
//        //RightItem
//        UIButton *tSearchButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        tSearchButton.frame = CGRectMake(0, 0, 38, 30);
//        [tSearchButton setImage:[UIImage imageNamed:@"button_search.png"] forState:UIControlStateNormal];
//        [tSearchButton addTarget:self action:@selector(searchView:) forControlEvents:UIControlEventTouchUpInside];
//        
//        
//        UIBarButtonItem *menuBarCategory = [[UIBarButtonItem alloc]initWithCustomView:tSearchButton];
//        self.navigationItem.rightBarButtonItem = menuBarCategory;
    }
    

    [self reload];
    //Gesture
    {
        
        mGestureView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UIViewController *vc=self.navigationController.parentViewController;
        
         UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:vc action:@selector(revealToggle:)];
        //[mGestureView addGestureRecognizer:recognizer];
        
        
        UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:vc action:@selector(revealGesture:)];
        [self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
        
        UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:vc action:@selector(revealGesture:)];
        [mGestureView addGestureRecognizer:panRecognizer];
    }
    
    // Refresh View
    {
        refreshControl = [[UIRefreshControl alloc] init];
        refreshControl.tintColor = [UIColor appGreenColor];
        [refreshControl addTarget:self action:@selector(pulledToRefresh) forControlEvents:UIControlEventValueChanged];
        self.refreshControl = refreshControl;
        [self.mTableView addSubview:refreshControl];

        //[self.mTableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_reward"]]];
    }

}

-(void)popAction
{
    
    [countdownManager shareManeger].opensidemenu=YES;
    [self.navigationController popViewControllerAnimated:NO];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mTableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     [self.refreshControl endRefreshing];
}

-(void)showGestureView
{
	if (![self.view.subviews containsObject:mGestureView])
    {
		[self.view addSubview:mGestureView];
	}
}

-(void)hideGestureView
{
	if ([self.view.subviews containsObject:mGestureView])
    {
		[mGestureView removeFromSuperview];
	}
}

-(void)menuButtonSelected
{
    
	mMenuButton.selected = YES;
    if(hide)
    {
        [self searchView:nil];
    }
}

-(void)menuButtonUnselected
{
    
	mMenuButton.selected = NO;
}

- (void) notificationDictionary:(NSDictionary *)pDict
{
}

-(void)addSearching
{
    searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0,0,320,40)];
    [searchBar setBackgroundColor:[UIColor whiteColor]];
    [searchBar setPlaceholder:@"Search"];
    searchBar.hidden=YES;
    [searchBar setDelegate:self];
    
    searchDummyTable=[[UITableView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(searchBar.frame),320, CGRectGetMaxY(self.mTableView.frame))];
    [searchDummyTable setDataSource:self];
    [searchDummyTable setDelegate:self];
    searchDummyTable.hidden=YES;
    
    noResult=[[UILabel alloc]initWithFrame:CGRectMake(120, 100,320,100)];
    
    hideView =[[UIView alloc]initWithFrame:self.view.frame];
    [hideView setBackgroundColor:[UIColor blackColor]];
    [hideView setAlpha:0.5];
    hideView.hidden=YES;
    
    UITapGestureRecognizer *tapRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchView:)];
    [tapRecognizer1 setNumberOfTapsRequired:1];
    hideView.userInteractionEnabled = YES;
    [hideView addGestureRecognizer:tapRecognizer1];
    
    
    [self.view addSubview:hideView];
    [self.view addSubview:searchBar];
    [self.view addSubview:searchDummyTable];
    
}

- (void) doneButton:(UIBarButtonItem *)pBarButton
{
    
    for (UIViewController *vc in self.navigationController.viewControllers)
    {
        if([vc isKindOfClass:[CouponsViewController class]])
        {
            [UIView  beginAnimations:nil context:NULL];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.75];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
            [UIView commitAnimations];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelay:0.375];
            [self.navigationController popToViewController:vc animated:YES];
            [UIView commitAnimations]; 
            
        }
    }
}

- (void)pulledToRefresh
{
    [self reload];
}
-(void)reload
{

    if(![[Reachability reachabilityForInternetConnection] currentReachabilityStatus]==NotReachable )
    {
    api = [[GREST alloc] init];
    [api setDelegate:self];
    [api get:[NSURL URLWithString:[NSString stringWithFormat:@"%@",kURL_Categories]] with_params:nil contentType:nil with_key:@"getCategories"];
    [api start];
    }
    else
    {
        [HUDManager hideHUD];
        [self.refreshControl endRefreshing];
        
        [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"The internet connection appears to be offline." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
  
//    NSMutableDictionary *profileDic = [NSMutableDictionary dictionary];
//    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@",kURL_Categories];
//    jsonparse *objJsonparse =[[jsonparse alloc]init];
//    
//    mCategoryArray = (NSMutableArray*)[objJsonparse customejsonParsing:urlString bodydata:profileDic];
//    
//   // NSLog(@"%@",[profileData objectAtIndex:0]);
//
//    
//    
//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
//    [mCategoryArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
//    
//    //    for (Category *tCategory in mCategoryArray)
//    //    {
//    //        if ([tCategory.mID intValue] == mSelectedCategoryID)
//    //        {
//    //            [[NSUserDefaults standardUserDefaults] setObject:tCategory.mName forKey:@"Rowvalue"];
//    //        }
//    //    }
//    
//    [mCategoryArray insertObject:@"All" atIndex:0];
//    
//    searchDummyArray=[[NSMutableArray alloc]init];
//    
//    [self.mTableView reloadData];
}
#pragma mark - GREST Methods

- (void)request_finished:(NSString *)response for_key:(NSString *)request_key
{
    NSMutableDictionary *couponDetails = [[response JSONValue] mutableCopy];
    mCategoryArray=(NSMutableArray *)couponDetails;
    [mCategoryArray sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2)
     {
         NSString *store1 = [[mCategoryArray  objectAtIndex:0]valueForKey:@"name"];
         NSString *store2 = [[mCategoryArray  objectAtIndex:0]valueForKey:@"name"];
         
         return [store1 compare:store2];
     }];
    [HUDManager hideHUD];
    [mCategoryArray insertObject:@"All" atIndex:0];
    searchDummyArray=[[NSMutableArray alloc]init];
    
    
    
    
    [self.mTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

    //[self.mTableView reloadData];
    [self.refreshControl endRefreshing];

    
}

- (void)request_failed:(NSError *)error for_key:(NSString *)request_key
{
    [HUDManager hideHUD];
    [self.refreshControl endRefreshing];

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
    //    if([mCategoryArray count])
    //        return [mCategoryArray count]+1;
    if(tableView==searchDummyTable)
        return [searchDummyArray count];
    return [mCategoryArray count];
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //set the cell selected image.
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_selected"]];
        
        //set the font and color type.
        UIFont *tFont = [ UIFont fontWithName: @"HelveticaNeue-Bold" size: 17.0 ];
        cell.textLabel.font = tFont;
        cell.textLabel.textColor = [UIColor colorWithRed:(44/255.0) green:(44/255.0) blue:(44/255.0) alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
   
    //for all action
    if(indexPath.row==0 && tableView!=searchDummyTable)
    {
        cell.textLabel.text=@"All";
    }
    else
    {
        cell.textLabel.text = [[mCategoryArray objectAtIndex:indexPath.row]valueForKey:@"name"];
    }
    
    // for background
    if ([cell.textLabel.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"Rowvalue"]] )
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"cell_selected"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        cell.backgroundView = nil;
        cell.textLabel.textColor = [UIColor colorWithRed:(44/255.0) green:(44/255.0) blue:(44/255.0) alpha:1.0];
    }
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
////    [HUDManager showHUDWithText:kHudMassage];
////    // Navigation logic may go here. Create and push another view controller.
////    [tableView deselectRowAtIndexPath:indexPath animated:YES];
////    
//    Category *tCategory;
////    if(tableView==searchDummyTable)
////        tCategory = [searchDummyArray objectAtIndex:indexPath.row];
////    else
//        tCategory = [mCategoryArray objectAtIndex:indexPath.row];
////    
////    if(indexPath.row!=0 || tableView==searchDummyTable)
////    {
////        if ([tCategory.rChildren count])
////        {
////            SubCategoryViewController *tController = [[SubCategoryViewController alloc] initWithNibName:@"SubCategoryViewController" bundle:nil];
////            [tController setTitle:tCategory.mName ID:tCategory.mID subCategories:[tCategory.rChildren allObjects]];
////            tController.mDelegate = self;
////            [self.navigationController pushViewController:tController animated:YES];
////            
////        }
////        else
////        {
////            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
////            [defaults setObject:tCategory.mName forKey:@"Rowvalue"];
////            [self dismissViewControlerForCategoryID:tCategory.mID];
////        }
////    }
////    else
////    {
////        [[NSUserDefaults standardUserDefaults] setObject:@"Category" forKey:@"Rowvalue"];
////        [self dismissViewControlerForCategoryID:@""];
////    }
//    
    
    if(indexPath.row==0)
    {
        [self dismissViewControlerForCategoryID:@""];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:[[mCategoryArray objectAtIndex:indexPath.row]valueForKey:@"name"] forKey:@"Rowvalue"];
        CategorysViewController * cvc= [[CategorysViewController alloc]init];
        cvc.mID=[[mCategoryArray objectAtIndex:indexPath.row]valueForKey:@"id"];
        [self.navigationController pushViewController:cvc animated:YES];
    }
}

/*
 - (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
 //---insert code here---
 Category *tCategory = [mCategoryArray objectAtIndex:indexPath.row];
 SubCategoryViewController *tController = [[SubCategoryViewController alloc] initWithNibName:@"SubCategoryViewController" bundle:nil];
 [tController setTitle:tCategory.mName ID:tCategory.mID subCategories:[tCategory.rChildren allObjects]];
 tController.mDelegate = self;
 [self.navigationController pushViewController:tController animated:YES];
 
 }
 */

- (void) subCategoryViewController:(SubCategoryViewController *)pSubCategoryViewController selectedCategoryID:(NSNumber *)pID
{
    //NSLog(@"%@",pID);  dfssf
    [[NSUserDefaults standardUserDefaults] setObject:pID forKey:@"CouponPrefencesID"];
    [self dismissViewControlerForCategoryID:pID];
}

- (void) dismissViewControlerForCategoryID:(NSNumber *)pID
{
    
    //    [self dismissViewControllerAnimated:YES completion:^{
    //        [mDelegate categoriesViewController:self selectedCategoryID:pID];
    //    }];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [mDelegate categoriesViewController:self selectedCategoryID:pID];
    });
    [self doneButton:nil];
    [HUDManager hideHUD];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

-(UIView *)getNevigationBarView:(NSString *)title
{
    
    UIButton *tcategoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tcategoryButton.frame = CGRectMake(0, 0,250,45 );
    [tcategoryButton setBackgroundColor:[UIColor clearColor]];
    
    tcategoryButton.titleLabel.font=[UIFont boldSystemFontOfSize:20.0];
    [tcategoryButton setTitle:title forState:UIControlStateNormal];
    [tcategoryButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
    tcategoryButton.titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [tcategoryButton setImage:[UIImage imageNamed:@"uparrow_icon.png"] forState:UIControlStateNormal];
    tcategoryButton.imageEdgeInsets=UIEdgeInsetsMake(0, 170, 0, 0);
    tcategoryButton.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0,60);
    
    return tcategoryButton;
}

#pragma mark-search

-(void) searchView:(id)sender
{
    if(!hide)
    {
        hideView.hidden=NO;
        searchBar.hidden=NO;
        searchBar.transform = CGAffineTransformMakeTranslation(0, -44);
        [UIView animateWithDuration:0.3 animations:^{
            searchBar.transform = CGAffineTransformIdentity;
        }];
        [searchBar becomeFirstResponder];
        hide=!hide;
    }
    else
    {
        hideView.hidden=YES;
        searchBar.hidden=YES;
        searchDummyTable.hidden=YES;
        [self.mTableView reloadData];
        searchBar.transform = CGAffineTransformMakeTranslation(0, 0);
        [UIView animateWithDuration:0.3 animations:^{
            searchBar.alpha = 0.0;
        }];
        searchBar.alpha = 1.0;
        [searchBar resignFirstResponder];
        hide=!hide;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    [self handleSearch:searchBar1];
}
- (void)handleSearch:(UISearchBar *)searchBar1
{
    [searchBar1 resignFirstResponder]; // if you want the keyboard to go away
}


- (BOOL)searchBar:(UISearchBar *)searchBar1 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    searchDummyTable.hidden=NO;
    NSString *finalString = [searchBar1.text stringByReplacingCharactersInRange:range withString:text];
    if(finalString.length)
        [self updateTableAfterSearch:finalString];
    else
        searchDummyTable.hidden=YES;
    
    return YES;
}

-(void)updateTableAfterSearch:(NSString *)productName
{
    
    [searchDummyArray removeAllObjects];
    noResult.hidden=YES;
    int count=0;
    for (Category *product in mCategoryArray)
    {
        if(count==0)
        {
        }
        else{
            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
            NSRange productNameRange = NSMakeRange(0, product.mName.length);
            NSRange foundRange = [product.mName rangeOfString:productName options:searchOptions range:productNameRange];
            if (foundRange.length > 0)
            {
                [searchDummyArray addObject:product];
            }
        }
        count++;
    }
    if(!searchDummyArray.count)
    {
        noResult.hidden=NO;
        noResult.text=@"No Result";
        noResult.textColor=[UIColor grayColor];
        noResult.font=[UIFont boldSystemFontOfSize:20.0];
        [searchDummyTable addSubview:noResult];
    }
    [searchDummyTable reloadData];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
}
@end

