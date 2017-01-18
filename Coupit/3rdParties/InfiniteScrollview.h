//
//  SplashInfiniteScrollview.h
//  DigitalPrintShop
//
//  Created by Vinod on 3/8/14.
//  Copyright (c) 2014 CanopusInfosystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InfiniteCheckboxDelegate <NSObject>

-(void)advertiseClicked:(UIButton*)button;

@end

@interface InfiniteScrollview : UIScrollView<UIScrollViewDelegate>
{
    NSTimer *timer;
    NSTimer *pauseTimer;
}
@property(nonatomic,strong) NSArray *arrayOfImages;
@property(nonatomic,assign) NSUInteger intervalInSeconds;
@property(nonatomic,assign) NSUInteger pauseIntervalWhenUserScroll;
@property(nonatomic,assign) BOOL enableUserScrolling;
@property(unsafe_unretained) id<InfiniteCheckboxDelegate>delegateCheckbox;
-(id)initWithFrame:(CGRect)frame withArray:(NSArray*)array;
-(void)startScrolling;
-(void)stopScrolling;
-(void)pauseScrollingForDuration:(NSUInteger)duration;
@property(nonatomic,assign) BOOL enableLabelCheckmarks;
-(void)advertiseNameOnLabels:(NSArray*)arrayNames arrayDiscount:(NSArray*)arrayDiscount;
@end
