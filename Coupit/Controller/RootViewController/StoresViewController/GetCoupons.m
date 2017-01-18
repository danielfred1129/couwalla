//
//  GetCoupons.m
//  Coupit
//
//  Created by Canopus5 on 6/16/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "GetCoupons.h"
#import "CouponsListCell.h"
#import "UIImageView+WebCache.h"
#import "CouponDetailViewController.h"

@interface GetCoupons ()

@end

@implementation GetCoupons
{
    NSMutableArray * tableDataArray;
    UILabel * mDisplayMessage;

}

@synthesize mID,mTableView,title;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.title=title;
    
    //Back Button.
    UIButton *tbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tbackButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tbackButton sizeToFit];
    [tbackButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *tBackBar = [[UIBarButtonItem alloc]initWithCustomView:tbackButton];
    self.navigationItem.leftBarButtonItem = tBackBar;
    
    tableDataArray =[[NSMutableArray alloc]init];
    
    [self getStoresNBrands:mID];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    mDisplayMessage.text=@"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Call Webservice

-(void)getStoresNBrands:(NSString *)mid
{
    [HUDManager showHUDWithText:kHudMassage];
    
    api = [[GREST alloc] init];
    [api setDelegate:self];
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
    NSDictionary *paramsDictionary=[NSDictionary dictionaryWithObjectsAndKeys:mid,@"retailer_id",userid,@"userid", nil];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:paramsDictionary options:0 error:Nil];
    NSString *paramString=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    paramString=[paramString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    [api get:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kGetStorenBrand, paramString]] with_params:nil contentType:nil with_key:@"StoresNBrand"];
    [api start];
}

#pragma mark - GREST Methods

- (void)request_finished:(NSString *)response for_key:(NSString *)request_key
{
    NSMutableDictionary *couponDetails = [[response JSONValue] mutableCopy];
    tableDataArray = [couponDetails valueForKey:@"data"];
    [mTableView reloadData];
    [HUDManager hideHUD];
}

- (void)request_failed:(NSError *)error for_key:(NSString *)request_key
{
    [HUDManager hideHUD];
}


#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    mDisplayMessage.text=@"";
    if([tableDataArray count]==0)
    {
		mDisplayMessage = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, 320, 35)];
        mDisplayMessage.font = [UIFont systemFontOfSize:14.0f];
        [mDisplayMessage setTextAlignment:NSTextAlignmentCenter];
        mDisplayMessage.textColor = [UIColor colorWithRed:(102/255.0) green:(102/255.0) blue:(102/255.0) alpha:1.0];
        mDisplayMessage.backgroundColor = [UIColor clearColor];
        mDisplayMessage.text = [NSString stringWithFormat:@"No coupons currently available for this %@. Please check back with us soon!",self.msgtitle];
        mDisplayMessage.numberOfLines=2;
        [tableView addSubview:mDisplayMessage];
    }
    else
    {
        [mDisplayMessage removeFromSuperview];
    }
    return [tableDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellTest";
    
    CouponsListCell *cell= (CouponsListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects1 = [[NSBundle mainBundle] loadNibNamed:@"CouponsListCell" owner:self options:nil];
        cell = (CouponsListCell *)[topLevelObjects1 objectAtIndex:0];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormatter dateFromString:[[tableDataArray objectAtIndex:indexPath.row] valueForKey:@"expiry_date"]];
    NSDate *endDate = [NSDate date];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:endDate
                                                          toDate:startDate
                                                         options:0];
    NSString *str;
    if (components.day<0)
    {
        str = @"Coupon Expired";
    }
    else
    {
        str = [NSString stringWithFormat:@"Expires in %ld days", (long)components.day];
    }
    
    [cell.mImageView setImageWithURL:[[tableDataArray objectAtIndex:indexPath.row] valueForKey:@"coupon_thumbnail"]];
    
    cell.mTitleLabel.text          =  [[tableDataArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.mCouponDiscountLabel.text =  [[tableDataArray objectAtIndex:indexPath.row] valueForKey:@"promo_text_short"];
    cell.mCouponDetailLabel.text   =  [[tableDataArray objectAtIndex:indexPath.row] valueForKey:@"promo_text_long"] ;
    cell.mValidDateLabel .text     =  str;

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Coupon *tCoupon = [tableDataArray objectAtIndex:indexPath.row];
    
    CouponDetailViewController *tController = [CouponDetailViewController new];
    tController.mCoupon = tCoupon;
    
    tController.mCouponName                 = [[tableDataArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    tController.mCouponPromoTextShort       = [[tableDataArray objectAtIndex:indexPath.row] valueForKey:@"promo_text_short"];
    tController.mCouponPromoTextLong        = [[tableDataArray objectAtIndex:indexPath.row] valueForKey:@"promo_text_long"];
    tController.mCouponExpireDate           = [[tableDataArray objectAtIndex:indexPath.row] valueForKey:@"expiry_date"];
    tController.mCouponID                   = [[tableDataArray objectAtIndex:indexPath.row] valueForKey:@"id"];
    tController.mCodeType                   = [[tableDataArray objectAtIndex:indexPath.row] valueForKey:@"code_type"];
    tController.mCouponImage                = [[tableDataArray objectAtIndex:indexPath.row] valueForKey:@"coupon_thumbnail"];
    tController.mBarcodeImage               = [[tableDataArray objectAtIndex:indexPath.row] valueForKey:@"barcode_image"];
    tController.mCouponDescription          = [[tableDataArray objectAtIndex:indexPath.row] valueForKey:@"coupon_description"];
    tController.locatarray              = [[tableDataArray objectAtIndex:indexPath.row] valueForKey:@"store_name"];
    
    [self.navigationController pushViewController:tController animated:YES];
}

@end
