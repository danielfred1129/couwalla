//
//  CouponPreferencesViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CouponPreferencesViewController.h"
#import "CouponCategoriesViewController.h"
#import "Category.h"
#import "Subscriber.h"
#import "AppDelegate.h"

@implementation CouponPreferencesViewController
{
    NSMutableArray *mCouponPrefencesArray;
    NSMutableArray *mCategoryArray;
    NSMutableArray *mSubcategoryArray;
    NSMutableArray *mCouponNameArray;
    NSMutableArray *mDummyArray;
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    mCouponPrefencesArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"CouponPrefences"]];

    self.navigationItem.title = @"Store Favourites";
    UIButton *tBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tBackButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tBackButton sizeToFit];
    [tBackButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tcategoryCancel = [[UIBarButtonItem alloc]initWithCustomView:tBackButton];
    self.navigationItem.leftBarButtonItem = tcategoryCancel;
    
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]]];
    mCategoryArray = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchAllCategory:nil]];
}

- (void)addMore:(id)sender
{
    CouponCategoriesViewController *tCategoriesViewController = [CouponCategoriesViewController new];
    UINavigationController *tNavigationController= [[UINavigationController alloc] initWithRootViewController:tCategoriesViewController];
    
    [self presentViewController:tNavigationController animated:YES completion:^{
        
        tCategoriesViewController.mDelegate = self;
        tCategoriesViewController.mCouponPrefrencesSelected = kFromProfileView;
        
    }];
    
}

- (void) backButton:(UIBarButtonItem *)pBarButton
{
    [self.navigationController popViewControllerAnimated:YES ];
    
}
- (void) couponViewController:(CouponCategoriesViewController *)pCouponPreferences isBack:(BOOL)pValue {
    if (mCouponPrefencesArray) {
        [mCouponPrefencesArray removeAllObjects];
    }
    mCouponPrefencesArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"CouponPrefences"]];
    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([mCouponPrefencesArray count]) {
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(addMore:)];
        [addButton setBackgroundImage:[UIImage imageNamed:@"btn22"]forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:51/255 green:179/255 blue:57/255 alpha:1];
        [addButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],  UITextAttributeTextColor,nil] forState:UIControlStateNormal];
        [self.navigationItem setRightBarButtonItem:addButton];
        
    }
    else {
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addMore:)];
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
    return [mCouponPrefencesArray count];
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
    
    mCouponNameArray = [NSMutableArray new];
    for (int i=0; i<[mCouponPrefencesArray count]; i++) {
        NSNumber *tCouponPrefences = [mCouponPrefencesArray objectAtIndex:i];
        for (int j=0; j<[mCategoryArray count];j++ ) {
            Category *tParentCategory = [mCategoryArray objectAtIndex:j];
            mSubcategoryArray = [NSMutableArray new];
            if ([tParentCategory.rChildren count]) {
                [mSubcategoryArray addObjectsFromArray:[tParentCategory.rChildren allObjects]];
            }
            [mSubcategoryArray addObject:tParentCategory];
            for (int k=0; k<[mSubcategoryArray count]; k++) {
                Category *tTotalCategoryArray = [mSubcategoryArray objectAtIndex:k];
                if([tTotalCategoryArray.mID isEqualToNumber: tCouponPrefences ]){
                    [mCouponNameArray addObject:tTotalCategoryArray.mName];
                }
            }
        }
    }
    cell.textLabel.text  = [mCouponNameArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
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

