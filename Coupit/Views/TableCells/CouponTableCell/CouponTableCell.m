//
//  CouponTableCell.m
//  Coupit
//
//  Created by Deepak Kumar on 17.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CouponTableCell.h"
#import "CouponView.h"
#import "FileUtils.h"
#import "RequestHandler.h"
#import "jsonparse.h"
#import "appcommon.h"

#import "CouponsViewController.h"
#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#define kItemWidth 103
#define kItemHeight 110
#define kItemMargin 10

@implementation CouponTableCell
{
    NSMutableArray *mItemArray;
    NSIndexPath *mIndexPath;
    NSMutableArray *CouponName;
    NSMutableArray *mCouponViewArray;
    NSMutableArray *itemsArray;
    NSMutableArray *mPromoTextShort;
    
}

@synthesize mScrollView, mCategoryTitleLabel, mDelegate,seeallbut,seeallimg;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) categoryTitle:(NSString *)pTitle items:(NSMutableArray *)pArray indexPath:(NSIndexPath *)pIndexPath{
    
    
    
    thumbnail=[[NSMutableArray alloc]init];
    itemsArray = [[NSMutableArray alloc]init];
    CouponName = [[NSMutableArray alloc]init];
    mPromoTextShort =[NSMutableArray new];
  
    [thumbnail removeAllObjects];
    [itemsArray removeAllObjects];
    [CouponName removeAllObjects];

    [mPromoTextShort removeAllObjects];
//    
//    itemsArray=nil;
//    CouponName=nil;
//    thumbnail=nil;
//    image=nil;
    itemsArray = pArray;
  
    CouponName=[itemsArray valueForKey:@"name"];
    thumbnail=[itemsArray valueForKey:@"coupon_thumbnail"];
    image = [itemsArray valueForKey:@"coupon_image"];
    mPromoTextShort =[itemsArray valueForKey:@"promo_text_short"];
   
    
    
    
    CouponView *tCouponView;
    if (thumbnail) {
        for (tCouponView in thumbnail) {
            
        }
        [tCouponView.view removeFromSuperview];

        [mCouponViewArray removeAllObjects];
        mCouponViewArray = nil;
    }

    mItemArray = [[NSMutableArray alloc] initWithArray:image];
    mIndexPath = pIndexPath;
    ////NSLog(@"-----mItemArray:%d", [mItemArray count]);
    ////NSLog(@"-----pmitemArray:%@", mItemArray );
    self.mCategoryTitleLabel.text = pTitle;
    [self drawThumbnailGrid];
    if ([mItemArray count]<=4) {
        seeallbut.hidden=YES;
        seeallimg.hidden=YES;
    }
    else{
        seeallbut.hidden=NO;
        seeallimg.hidden=NO;
    }
}

- (Coupon *) getCouponAtIndex:(NSInteger)pIndex
{
    
    return [mItemArray objectAtIndex:pIndex];
    
}
- (IBAction) seeAllItems:(id)sender
{
    [mDelegate couponTableCell:self selectedItemIndex:[NSIndexPath indexPathForRow:-1 inSection:mIndexPath.section]];
 
}

- (void)drawThumbnailGrid
{
    int margin=3;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger count;
    count= [mItemArray count];
    
    if(count>=11)
    {
        count=11;
    }

    mCouponViewArray = [[NSMutableArray alloc]init];
    [mCouponViewArray removeAllObjects];
    int i;
    for ( i = 0; i < count; i++)
    {
        CGRect frame=CGRectMake(kItemWidth * i+margin, 0, kItemWidth, kItemHeight);
        margin=margin+3;
        
        CouponView *tCouponView = [[CouponView alloc] initWithNibName:@"CouponView" bundle:nil];
        [tCouponView.view removeFromSuperview];
        
        tCouponView.mTopRightView.hidden=YES;
        tCouponView.view.frame = frame;
        
        [tCouponView.mItemButton setImageWithURL:[NSURL URLWithString:[thumbnail objectAtIndex:i]] placeholderImage:nil];
        
        [tCouponView.mItemButton setTag:i];
        
        [tCouponView.mItemButton addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
       
        if([[mPromoTextShort objectAtIndex:i] length])
            tCouponView.mTopRightView.hidden=NO;

        tCouponView.mTopRightLabel.text = [mPromoTextShort objectAtIndex:i]; //[NSString stringWithFormat:@"T:%d", i];
        tCouponView.mButtomLable.text = [CouponName objectAtIndex:i];
        
        
        [tCouponView.mItemButton addSubview:tCouponView.mTopRightView];
        
        [mCouponViewArray addObject:tCouponView];
        [self.mScrollView addSubview:tCouponView.view];
        //[subview release];
    }
    
    // for add one more view for see all
    
    CGRect frame=CGRectMake(kItemWidth * i+margin, 0, kItemWidth, kItemHeight);
    margin=margin+3;
    
    CouponView *tCouponView = [[CouponView alloc] initWithNibName:@"CouponView" bundle:nil];
    [tCouponView.mTopRightView removeFromSuperview];

    [tCouponView.view removeFromSuperview];
    tCouponView.view.frame = frame;
    [tCouponView.mItemButton setTag:i];
    
    [tCouponView.mItemButton addTarget:self action:@selector(seeAllItems:) forControlEvents:UIControlEventTouchUpInside];
    
    [tCouponView.mItemButton setTitle:@"See All" forState:UIControlStateNormal];
    [tCouponView.mItemButton setBackgroundColor:[UIColor clearColor]];
    [mCouponViewArray addObject:tCouponView];
    [self.mScrollView addSubview:tCouponView.view];
    
    
    
    self.mScrollView.contentSize = CGSizeMake(kItemWidth * (count+1)+margin , self.mScrollView.frame.size.height);
    
}

- (void) itemClicked:(UIButton *)pButton
{
    //NSLog(@"coupon tapped %@",pButton)  ;
    pButton.highlighted = NO;
    [mDelegate couponTableCell:self selectedItemIndex:[NSIndexPath indexPathForRow:pButton.tag inSection:mIndexPath.section]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state coupon_thumbnail
}

#pragma mark -
#pragma mark IconDownloadManager

- (void) iconDownloadManager:(IconDownloadManager *)pIconDownloadManager indexPath:(NSIndexPath *)pIndexPath
{
    Coupon *tCoupon = [thumbnail objectAtIndex:pIndexPath.row];
    CouponView *tCouponView = [thumbnail objectAtIndex:pIndexPath.row];
    NSString *tFileName = [tCoupon.mThumbnailImage lastPathComponent];
    NSString *fmtFileName = makeFileName([tCoupon.mID stringValue], tFileName);
   // //NSLog(@"Section:%d Row:%d", pIndexPath.section, pIndexPath.row);

    if (isFileExists(fmtFileName)) {
     
        [tCouponView.mItemButton setImage:[UIImage imageWithData:imageData] forState:0];
        
    }
    else
    {
        [tCouponView.mItemButton setImage:[UIImage imageNamed:@"CouponsHomeDefaultImage"] forState:0];
    }
    
    [tCouponView.mItemButton setImage:tCoupon.mIconImage forState:0];

}


@end
