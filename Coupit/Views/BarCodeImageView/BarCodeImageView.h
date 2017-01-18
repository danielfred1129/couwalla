//
//  BarCodeImageView.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BarCodeImageView : BaseViewController

@property (nonatomic, retain) IBOutlet UIImageView *mImageView;
@property (nonatomic, retain) IBOutlet UIImageView *mBarCodeImageView;
@property (nonatomic, retain) IBOutlet UILabel *mCardDescriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *mCardNumberLabel;
@property (nonatomic, retain) IBOutlet UILabel *mCardTitleLabel;



@end
