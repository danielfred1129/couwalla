//
//  CategorysViewController.m
//  Coupit
//
//  Created by Canopus5 on 6/16/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "CategorysViewController.h"
#import "CouponTableCell.h"
#import "CouponView.h"
#import "UIImageView+WebCache.h"
#import "CouponDetailViewController.h"

#define kItemWidth 103
#define kItemHeight 35

@interface CategorysViewController ()
{
    NSMutableArray * tableDataArray;
}

@end

@implementation CategorysViewController
@synthesize mID,mTableView,hideLabelForMassage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.title = [[NSUserDefaults standardUserDefaults] valueForKey:@"Rowvalue"];
    
    [mTableView setBackgroundColor:[UIColor clearColor]];
    
    //Back Button.
    UIButton *tbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tbackButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tbackButton sizeToFit];
    [tbackButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tBackBar = [[UIBarButtonItem alloc]initWithCustomView:tbackButton];
    self.navigationItem.leftBarButtonItem = tBackBar;
    
    tableDataArray =[[NSMutableArray alloc]init];
    
    [self getCouponsByCatogoryId:mID];
}


-(void) backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - call Web service

-(void)getCouponsByCatogoryId:(NSString *)mId
{
    [HUDManager showHUDWithText:kHudMassage];
    
    api = [[GREST alloc] init];
    [api setDelegate:self];
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
    NSDictionary *paramsDictionary=[NSDictionary dictionaryWithObjectsAndKeys:mId,@"category_id",
                                    userId,@"userid", nil];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:paramsDictionary options:0 error:Nil];
    NSString *paramString=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    paramString=[paramString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    [api get:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KGetCouponsBtCategoryId, paramString]] with_params:nil contentType:nil with_key:@"Categorys"];
    [api start];
}

#pragma mark - GREST Methods

- (void)request_finished:(NSString *)response for_key:(NSString *)request_key
{
    NSMutableDictionary *couponDetails = [[response JSONValue] mutableCopy];
    
    if([couponDetails count]>0 &&   ![[couponDetails  valueForKey:@"response"] isEqualToString:@"failure"])
    {
        hideLabelForMassage.hidden=YES;
        tableDataArray = [couponDetails valueForKey:@"data"];
    }
    else
    {
        hideLabelForMassage.hidden=NO;
    }

    if([tableDataArray count]<1)
    {
        hideLabelForMassage.hidden=NO;
    }
    else
    {
        hideLabelForMassage.hidden=YES;

    }
    
    [mTableView reloadData];
    [HUDManager hideHUD];
    
    
}

- (void)request_failed:(NSError *)error for_key:(NSString *)request_key
{
    [HUDManager hideHUD];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int coutForArray=[tableDataArray count];
   
    if(coutForArray==0)
    {
        return 0;
    }
    else if (coutForArray<=3)
        {
                        return 1;
        }else
        {
            int countForRow=coutForArray/3;
            if (coutForArray%3 !=0) {
                
                return countForRow+1;
            }
            else
            {
               
                return countForRow;
            }
        }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
 	static NSString *CellIdentifier1 = @"CellTest";
    
    
    CouponTableCell *cell= (CouponTableCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil) {
        cell = [[CouponTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    int margin=3;
    
    int countForRow=[tableDataArray count]/3;
    if ([tableDataArray count]%3 !=0)
    {
        countForRow= countForRow+1;
    }
    int count=3;
    if (indexPath.row==countForRow-1 && [tableDataArray count]>3 && [tableDataArray count]%3 !=0)
    {
        count=[tableDataArray count]%3;
    }
    else if ([tableDataArray count]<=3)
    {
        count=[tableDataArray count];
    }
    int i;
    for ( i = 0; i < count; i++)
    {
        CGRect frame=CGRectMake(kItemWidth * i+margin, 5, kItemWidth, kItemHeight);
        margin=margin+3;
        
        CouponView *tCouponView = [[CouponView alloc] init];
        [tCouponView.view removeFromSuperview];
        tCouponView.mTopRightView.hidden=YES;
        tCouponView.view.frame = frame;
        
        
        [tCouponView.mItemButton setImageWithURL:[[tableDataArray objectAtIndex:(indexPath.row *3)+i] valueForKey:@"coupon_thumbnail"]];
        
        [tCouponView.mItemButton setContentMode:UIViewContentModeScaleAspectFit];
        tCouponView.mItemButton.tag=(indexPath.row *3)+i;
        [tCouponView.mItemButton addTarget:self action:@selector(actionOnImage:) forControlEvents:UIControlEventTouchUpInside];
        
        if([[[tableDataArray objectAtIndex:(indexPath.row *3)+i] valueForKey:@"promo_text_short"] length])
            tCouponView.mTopRightView.hidden=NO;
        
        tCouponView.mTopRightLabel.text = [[tableDataArray objectAtIndex:(indexPath.row *3)+i] valueForKey:@"promo_text_short"];
        tCouponView.mButtomLable.text = [[tableDataArray objectAtIndex:(indexPath.row *3)+i] valueForKey:@"name"];
        
        [tCouponView.mItemButton addSubview:tCouponView.mTopRightView];
        
        [cell.contentView addSubview:tCouponView.view];
    }
    
    return cell;
}


#pragma mark - action on image
-(void)actionOnImage:(UIButton *)sender
{
    Coupon *tCoupon = [tableDataArray objectAtIndex:sender.tag];
    
    CouponDetailViewController *tController = [CouponDetailViewController new];
    tController.mCoupon                     = tCoupon;
    
    tController.mCouponName                 = [[tableDataArray objectAtIndex:sender.tag] valueForKey:@"name"];
    tController.mCouponPromoTextShort       = [[tableDataArray objectAtIndex:sender.tag] valueForKey:@"promo_text_short"];
    tController.mCouponPromoTextLong        = [[tableDataArray objectAtIndex:sender.tag] valueForKey:@"promo_text_long"];
    tController.mCouponExpireDate           = [[tableDataArray objectAtIndex:sender.tag] valueForKey:@"expiry_date"];
    tController.mCouponID                   = [[tableDataArray objectAtIndex:sender.tag] valueForKey:@"id"];
    tController.mCodeType                   = [[tableDataArray objectAtIndex:sender.tag] valueForKey:@"code_type"];
    tController.mCouponImage                = [[tableDataArray objectAtIndex:sender.tag] valueForKey:@"coupon_thumbnail"];
    tController.mBarcodeImage               = [[tableDataArray objectAtIndex:sender.tag] valueForKey:@"barcode_image"];
    tController.locatarray                  = [[tableDataArray objectAtIndex:sender.tag] valueForKey:@"store_name"];
    tController.mCouponDescription               = [[tableDataArray objectAtIndex:sender.tag] valueForKey:@"coupon_description"];
    
    [self.navigationController pushViewController:tController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
