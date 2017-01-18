//
//  CouponCategoriesViewControllerr.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CouponCategoriesViewController.h"
#import "CouponSubCategoryViewController.h"
#import "Category.h"
#import "tJSON.h"
#import "Subscriber.h"
#import "CouponPrefrences.h"
#import "AppDelegate.h"

@implementation CouponCategoriesViewController
{
    NSMutableArray *mCategoryArray;
    NSMutableArray *mCouponPrefences;
    NSUserDefaults *userDefault;
    NSMutableArray *mLocationDocsArray;
    ProgressHudPresenter *mHudPresenter;
    BOOL mIsCategorySelected;

}

@synthesize mTableView, mCouponPrefrencesSelected, mDelegate;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    mHudPresenter = [[ProgressHudPresenter alloc] init];
    mIsCategorySelected = NO;

    self.navigationItem.title = @"Categories";
    mCouponPrefences = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"CouponPrefences"]];
    UIButton *tcancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tcancelButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tcancelButton sizeToFit];
    [tcancelButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tcategoryCancel = [[UIBarButtonItem alloc]initWithCustomView:tcancelButton];
    self.navigationItem.leftBarButtonItem = tcategoryCancel;
    mCategoryArray = [[NSMutableArray alloc] initWithArray:[[Repository sharedRepository] fetchAllCategory:nil]];
    
    //NSLog(@"getContentURL:%@", [[DataManager getInstance] getContentURL]);
    self.mTableView.allowsMultipleSelection = YES;
     mLocationDocsArray = [NSMutableArray new];
    
}

- (void) viewWillAppear:(BOOL)animated {
   // mCouponPrefrencesSelected = kFromProfileView;
    mCouponPrefences = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"CouponPrefences"]];
    [mTableView reloadData];
}
 
 

- (void) doneButton:(UIBarButtonItem *)pBarButton
{
    
    if (mCouponPrefrencesSelected == kFromProfileView) {
        if (mIsCategorySelected) {
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Do you want to save the changes" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
            [tAlert show];
            return;

        } else {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];

        }

    } else if (mCouponPrefrencesSelected == kFromSignUpView){
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];

    }


}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView cancelButtonIndex] == buttonIndex) {
        NSString *subscriberJSON = [[NSUserDefaults standardUserDefaults] objectForKey:@"subscriber"];
        NSDictionary *dictionary = [subscriberJSON JSONValue];
        Subscriber *tSubscriber = [[Subscriber alloc] init];
        [tSubscriber subscriberWithDict:dictionary];
        CouponPrefrences *tCouponPrefrences = [[CouponPrefrences alloc]init];
        [tSubscriber setMCouponPrefrences:tCouponPrefrences];
        [tSubscriber setMCouponPreferencesArray:[dictionary objectForKey:@"CouponPrefences"]];
        
        [mHudPresenter presentHud];
        NSString *tPostUrlEditProfile = [KURL_EditProfileQuery stringByAppendingFormat:@"/%@",tSubscriber.mId];
        
        [[NSUserDefaults standardUserDefaults] setObject:[tSubscriber pToJSONString] forKey:@"subscriber"];
        [[RequestHandler getInstance] postRequestwithHostURL:tPostUrlEditProfile bodyPost:[tSubscriber pToJSONString] delegate:self requestType:kEditProfileRequest];
        [self dismissView];


    } else {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate makeSubscriberGetRequestByName];
        [mHudPresenter presentHud];
        [self performSelector:@selector(dismissView) withObject:nil afterDelay:2];

    }
    
}
- (void) dismissView {
    [mHudPresenter hideHud];
    [self dismissViewControllerAnimated:YES completion:^{
        [mDelegate couponViewController:self isBack:YES];
        
        
    }];
    

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
        if (pRequestType == kEditProfileRequest) {
            //NSLog(@"After API Call | Subscriber in Nsuserdefault .......%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"subscriber"]);
            // TODO: Update password in NSUserDefaults
            
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Coupon Preferences updated" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
            return;
        }
        
        
    } else {
        //NSLog(@"Request Failed:%d | Code:%d | Message:%@",pRequestType, pError.mErrorCode.intValue, pError.mMessage);
        
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Unable to edit profile" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        
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

    Category *tCategory = [mCategoryArray objectAtIndex:indexPath.row];
    cell.textLabel.text = tCategory.mName;
    
        if ([mCouponPrefences containsObject:tCategory.mID]) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"cell_selected"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
            cell.textLabel.textColor = [UIColor whiteColor];

    }
        else {
            cell.backgroundView = nil;
            cell.textLabel.textColor = [UIColor colorWithRed:(44/255.0) green:(44/255.0) blue:(44/255.0) alpha:1.0];

        }

    if ([tCategory.rChildren count]) {
        /*
        if ([mCouponPrefences containsObject:tCategory.mID] ) {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"cell_selected"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
        }
        else {
            cell.backgroundView = nil;
        }
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
         */
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;


    }
     
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    mIsCategorySelected = YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Category *tCategory = [mCategoryArray objectAtIndex:indexPath.row];
    if ([tCategory.rChildren count]) {
        
        CouponSubCategoryViewController *tController = [[CouponSubCategoryViewController alloc] initWithNibName:@"CouponSubCategoryViewController" bundle:nil];
        [tController setTitle:tCategory.mName ID:tCategory.mID subCategories:[tCategory.rChildren allObjects]];
        tController.mDelegate = self;
        [self.navigationController pushViewController:tController animated:YES];

        /*
        if(![mCouponPrefences containsObject:tCategory.mID])
            [mCouponPrefences addObject:tCategory.mID];
        else
            [mCouponPrefences removeObject:tCategory.mID];
        [mTableView reloadData];
         */
    }
    else {
        if ([tCategory.mID isEqualToNumber:[NSNumber numberWithInt:0]]) {
            [mCouponPrefences removeAllObjects];
            [mCouponPrefences addObject:tCategory.mID];
            [mTableView reloadData];

        } else {
            [mCouponPrefences removeObject:[NSNumber numberWithInt:0]];
        if(![mCouponPrefences containsObject:tCategory.mID])
            [mCouponPrefences addObject:tCategory.mID];
        
        else
            
            [mCouponPrefences removeObject:tCategory.mID];
            [mTableView reloadData];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:mCouponPrefences forKey:@"CouponPrefences"];


}

/*
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    //---insert code here---
    Category *tCategory = [mCategoryArray objectAtIndex:indexPath.row];
    CouponSubCategoryViewController *tController = [[CouponSubCategoryViewController alloc] initWithNibName:@"CouponSubCategoryViewController" bundle:nil];
    [tController setTitle:tCategory.mName ID:tCategory.mID subCategories:[tCategory.rChildren allObjects]];
    [self.navigationController pushViewController:tController animated:YES];

}
*/
- (void) subCategoryViewController:(CouponSubCategoryViewController *)pSubCategoryViewController selectedCategoryID:(NSNumber *)pID
{
    [self dismissViewControlerForCategoryID:pID];
   // //NSLog(@"%@",pID);
    
}


- (void) dismissViewControlerForCategoryID:(NSNumber *)pID
{
    [self dismissViewControllerAnimated:YES completion:^{
        //[mDelegate categoriesViewController:self selectedCategoryID:pID];
    }];
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

