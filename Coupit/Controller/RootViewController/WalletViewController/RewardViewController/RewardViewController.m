//
//  RewardViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RewardViewController.h"
#import "RedeemPointViewController.h"
#import "RewardCard.h"
#import "FileUtils.h"
#import "Subscriber.h"
#import "AppDelegate.h"
#import "MyCouponsCell.h"
#import "jsonparse.h"
#import "appcommon.h"
#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "LocalyticsSession.h"

#define kAlertViewOne 1
#define kAlertViewTwo 2

@implementation RewardViewController
{
    UIView *mGestureView;
    UIButton *mMenuButton;
    RewardCard *mRewardCard;
    NSMutableDictionary *gidtdataData;
    NSMutableArray *mGiftCouponList;
    NSInteger mSelectedRedeemIndex,mDeleteButtonIndex;
}

@synthesize mTableView, mCardImageView, mRewardCardLabel, mValidFromLabel, mValidTillLabel, mNameLabel;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Gift Cards";
    
    mMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mMenuButton setImage:[UIImage imageNamed:@"button_menu"] forState:UIControlStateNormal];
    [mMenuButton sizeToFit];
    [mMenuButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
    
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc]initWithCustomView:mMenuButton];
    self.navigationItem.leftBarButtonItem = menuBarButton;
    
    mGestureView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealToggle:)];
	[mGestureView addGestureRecognizer:recognizer];
	UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
	[mGestureView addGestureRecognizer:panRecognizer];
    [self getgiftcards];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[LocalyticsSession shared] tagScreen:kRewardsScreen];
}
-(void)getgiftcards
{
    NSString *userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
    NSMutableDictionary *couponDic = [NSMutableDictionary dictionary];
    [couponDic setObject:userkey forKey:@"user_id"];
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/get_gift_cards.php?",BASE_URL];
    
    jsonparse *objJsonparse =[[jsonparse alloc]init];
    
    gidtdataData = [[NSMutableDictionary alloc]init];
    
    gidtdataData = [objJsonparse customejsonParsing:urlString bodydata:couponDic];
    
    
    MyCoupons *mycoupons =[MyCoupons alloc];
    [mycoupons couponsWithDict:[[gidtdataData objectForKey:@"data"] objectAtIndex:0]];
    //    //[couponsWithDict:reponseData];
    //NSLog(@"%@",gidtdataData);
    mGiftCouponList = [gidtdataData valueForKey:@"data"];

}

- (void) notificationDictionary:(NSDictionary *)pDict {
   
    UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Your reward points have been changed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [tAlert show];
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
    return [mGiftCouponList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCouponsCell *cell;
    
    static NSString *CellIdentifier = @"MyCouponsCell";
    cell = (MyCouponsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MyCouponsCell" owner:self options:nil];
        cell = (MyCouponsCell *)[topLevelObjects objectAtIndex:0];
    }
    [cell.mSeperatorImageView setHidden:YES];
    [cell.mCouponCodeLabel setHidden:YES];
    cell.mRedeemSelectButton.hidden=YES;
    MyCoupons *tCoupon = [mGiftCouponList objectAtIndex:indexPath.row];
    cell.mFavouriteButton.hidden=YES;
    
    cell.mPlannerButton.hidden=YES;
  
    cell.mDeleteButton.hidden=YES;
   
    
    cell.mButtonsView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background" ]];
    cell.mButtonsView.alpha = 1;
    cell.mRedeemButton.tag = indexPath.row;
    [cell.mRedeemButton addTarget:self action:@selector(redeemButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.mTitleLabel.text = [tCoupon valueForKey:@"card_name"];
    cell.mCouponDetailLabel.text = [tCoupon valueForKey:@"description"];
    
    
   cell.mValidDateLabel.text = [NSString stringWithFormat:@"Reward Points :  %@",[tCoupon valueForKey:@"reward_points"] ];

        [cell.mCouponImageView setImageWithURL:[NSURL URLWithString: [[mGiftCouponList objectAtIndex:indexPath.row]objectForKey:@"image_url"]]];

    
       return cell;
}


- (void)redeemButtonSelected:(UIButton *)sender
{
    mSelectedRedeemIndex = sender.tag;
    UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you wish to redeem now?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    tAlertView.tag = kAlertViewOne;
    [tAlertView show];
}

- (void) deleteButtonSelected:(UIButton *)sender
{
    mDeleteButtonIndex = sender.tag;
    UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:@"Delete Card ?" message:kDeleteCouponMessage delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    tAlertView.tag = kAlertViewTwo;
    [tAlertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (alertView.tag==1) {
            if(buttonIndex == 0){
                 NSString *removeid =[[mGiftCouponList objectAtIndex:mSelectedRedeemIndex] valueForKey:@"id"];
                //NSLog(@"%@",removeid);
                
                NSString *userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
                NSMutableDictionary *couponDic = [NSMutableDictionary dictionary];
                [couponDic setObject:userkey forKey:@"user_id"];
                [couponDic setObject:removeid forKey:@"giftcard_id"];
                NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/redeem_gift_card.php?",BASE_URL];
                
                jsonparse *objJsonparse =[[jsonparse alloc]init];
                
                gidtdataData = [[NSMutableDictionary alloc]init];
                
                gidtdataData = [objJsonparse customejsonParsing:urlString bodydata:couponDic];
               
                NSString *resstr = [gidtdataData valueForKey:@"message"];
                NSString *respstr =[gidtdataData valueForKey:@"response"];
                
                UIAlertView *redalrt = [[UIAlertView alloc]initWithTitle:respstr message:resstr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
                [redalrt show];
                
            }
            else{
                
            }
            
            
        }
    if (alertView.tag==2) {
        if(buttonIndex == 0){
            
            NSString *removeid =[[mGiftCouponList objectAtIndex:mDeleteButtonIndex] valueForKey:@"id"];
            //NSLog(@"%@",removeid);
            
        }
        else{
            
        }
    }
    [self getgiftcards];
    [mTableView reloadData];
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}





@end
