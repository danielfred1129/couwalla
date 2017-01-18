//
//  CategoriesViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SubCategoryViewController.h"
#import "Category.h"
#import "MyCouponViewController.h"


#import "RNFullScreenScroll.h"
#import "UIViewController+RNFullScreenScroll.h"
#import "UITabBarController+hidable.h"

@implementation SubCategoryViewController
{
    NSMutableArray *mCategoryArray;
}

@synthesize mTableView, mDelegate;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *tBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tBackButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tBackButton sizeToFit];
    [tBackButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tBackButtonItem = [[UIBarButtonItem alloc]initWithCustomView:tBackButton];
    self.navigationItem.leftBarButtonItem = tBackButtonItem;
    //mCategoryArray = [[NSMutableArray alloc]init];
    
/*
    UIBarButtonItem *tShareButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButton:)];
    self.navigationItem.rightBarButtonItem = tShareButton;
    
*/
//     self.fullScreenScroll = [[RNFullScreenScroll alloc] initWithViewController:self scrollView:self.mTableView];
    
}

- (void) setTitle:(NSString *)pTitle ID:(NSNumber *)pID subCategories:(NSMutableArray *)pArray;
{
    self.navigationItem.title = pTitle;
    mCategoryArray = [[NSMutableArray alloc]init];
   // mCategoryArray = [[NSMutableArray alloc] initWithArray:pArray];
    

     mCategoryArray= [pArray mutableCopy];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"mName" ascending:YES];
    [mCategoryArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];

    NSMutableArray *finalArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[mCategoryArray count]; i++)
    {
        NSLog(@"%@", [[mCategoryArray objectAtIndex:i]valueForKey:@"mName"]);
        if ([[[mCategoryArray objectAtIndex:i]valueForKey:@"mName"] hasPrefix:@"All "]) {
            
            [finalArray insertObject:[mCategoryArray objectAtIndex:i] atIndex:0];
            
        }else{
            
            [finalArray addObject:[mCategoryArray objectAtIndex:i]];
            
        }
    }
    
  
    mCategoryArray = [finalArray mutableCopy];
    
    [self.mTableView reloadData];
}

- (void) backButton:(UIBarButtonItem *)pBarButton
{
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [mCategoryArray count];
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //set the cell selected image.
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_selected"]];
        
        //set the font and color type.
        UIFont *tFont = [ UIFont fontWithName: @"HelveticaNeue-Bold" size: 17.0 ];
        cell.textLabel.font = tFont;
        cell.textLabel.textColor = [UIColor colorWithRed:(44/255.0) green:(44/255.0) blue:(44/255.0) alpha:1.0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;

    }
    
    // Configure the cell...

    Category *tSubCategory = [mCategoryArray objectAtIndex:indexPath.row];
    cell.textLabel.text = tSubCategory.mName;
    
    if ([cell.textLabel.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"Rowvalue"]] )
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"cell_selected"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    else {
        cell.backgroundView = nil;
        cell.textLabel.textColor = [UIColor colorWithRed:(44/255.0) green:(44/255.0) blue:(44/255.0) alpha:1.0];
    }
    
    if ([tSubCategory.rChildren count]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Category *tSubCategory = [mCategoryArray objectAtIndex:indexPath.row];

    if ([tSubCategory.rChildren count])
    {
        SubCategoryViewController *tController = [[SubCategoryViewController alloc] initWithNibName:@"SubCategoryViewController" bundle:nil];
        [tController setTitle:tSubCategory.mName ID:tSubCategory.mID subCategories:[tSubCategory.rChildren allObjects]];
        [self.navigationController pushViewController:tController animated:YES];
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:tSubCategory.mName forKey:@"Rowvalue"];
        
        NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
        [defaults1 setObject:tSubCategory.mID forKey:@"CatValue"];
        
        [mDelegate subCategoryViewController:self selectedCategoryID:tSubCategory.mID];
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





@end

