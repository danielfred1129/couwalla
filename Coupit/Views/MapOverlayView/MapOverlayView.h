//
//  MapOverlayView.h
//  Coupit
//
//  Created by Deepak Kumar on 3/21/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapOverlayView : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *mStoreName;
@property (weak, nonatomic) IBOutlet UILabel *mActiveCouponCount;
@property (weak, nonatomic) IBOutlet UILabel *mDistance;
@property (weak, nonatomic) IBOutlet UILabel *mAddress;
@property (weak, nonatomic) IBOutlet UIImageView *mThumbnail;
@property (weak, nonatomic) IBOutlet UIButton *mCheckIn;

@property (nonatomic, retain) NSString *mStoreNameLabel;
@property (nonatomic, retain) NSString *mActiveCouponCountLabel;
@property (nonatomic, retain) NSString *mDistanceLabel;
@property (nonatomic, retain) NSString *mImagePath;
@property (nonatomic, retain) NSString *mAddressLabel;



@end
