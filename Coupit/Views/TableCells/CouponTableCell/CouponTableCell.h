//
//  CouponTableCell.h
//  Coupit
//
//  Created by Deepak Kumar on 17.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloadManager.h"
#import "Coupon.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@class CouponTableCell;

@protocol CouponTableCellDelegate
// Sent when the user selects a row in the recent searches list.
- (void) couponTableCell:(CouponTableCell *)pTableCell selectedItemIndex:(NSIndexPath *)pIndexPath;
@end

@interface CouponTableCell : UITableViewCell
//<IconDownloadManagerDelegate>
{
    NSMutableArray* thumbnail, *image;
    NSData *imageData;
}

@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *mCategoryTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *seeallbut;
@property (weak, nonatomic) IBOutlet UIImageView *seeallimg;

@property (nonatomic, retain) id <CouponTableCellDelegate> mDelegate;

- (void) categoryTitle:(NSString *)pTitle items:(NSMutableArray *)pArray indexPath:(NSIndexPath *)pIndexPath;
- (void) categoryTitle2:(NSString *)pTitle items:(NSArray *)pArray indexPath:(NSIndexPath *)pIndexPath;
- (Coupon *) getCouponAtIndex:(NSInteger)pIndex;

- (IBAction) seeAllItems:(id)sender;
- (void) drawThumbnailGrid;
-(void)filterbycategory;
@end
