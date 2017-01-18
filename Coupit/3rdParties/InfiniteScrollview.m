//
//  SplashInfiniteScrollview.m
//  DigitalPrintShop
//
//  Created by Vinod on 3/8/14.
//  Copyright (c) 2014 CanopusInfosystems. All rights reserved.
//

#import "InfiniteScrollview.h"
#import "UIButton+WebCache.h"

#define SELF_WIDTH  self.frame.size.width
#define SELF_HEIGHT  self.frame.size.height

@implementation InfiniteScrollview

- (id)initWithFrame:(CGRect)frame withArray:(NSArray*)array
{
    self = [self initWithFrame:frame];
    self.arrayOfImages = [[NSArray alloc] initWithArray:array];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.panGestureRecognizer addTarget:self action:@selector(panRecognized:)];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin];
        [self setPagingEnabled:YES];
        [self setBounces:NO];
        self.enableUserScrolling = NO;
        self.intervalInSeconds = 4.0;
        self.pauseIntervalWhenUserScroll = 4.0;
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        [self setDelegate:self];
    }
    return self;
}

-(void)setArrayOfImages:(NSArray *)arrayOfImages
{
    _arrayOfImages = arrayOfImages;
    
    if (_arrayOfImages.count == 0 || _arrayOfImages.count == 3)
    {
        [self setEnableUserScrolling:NO];
    }
    else
    {
        [self setEnableUserScrolling:YES];
    }
    
    
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    CGFloat x = 0.0f;
    
    CGRect frame = self.frame;
    
    for (int i=0;i<[_arrayOfImages count];i++)
    {
        
        NSURL *image=[_arrayOfImages objectAtIndex:i];
        frame.origin.x = x;
        frame.origin.y = 0;
        
        UIButton *imageButton = [[UIButton alloc] initWithFrame:frame];
        [imageButton setClipsToBounds:YES];
        [imageButton setBackgroundImageWithURL:image];
        [imageButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [imageButton setTag:i];
        [self addSubview:imageButton];
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(x, 70,120, 40)];
        [view setBackgroundColor:[UIColor blackColor]];
        view.alpha=0.5;
        
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(5,0,70,10)];
        [labelName setTextColor:[UIColor whiteColor]];
        labelName.tag=0;
        [labelName setBackgroundColor:[UIColor clearColor]];
        [labelName setText:@"Something"];
        [labelName setFont:[UIFont boldSystemFontOfSize:10.0]];
        labelName.textAlignment=NSTextAlignmentCenter;
        [view addSubview:labelName];
        
        UIButton *buyButton = [[UIButton alloc] initWithFrame:CGRectMake(5,12,70,17)];
        [buyButton setBackgroundImage:[UIImage imageNamed:@"buynow_btn"] forState:UIControlStateNormal];
        [buyButton setTag:i];
        [buyButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:buyButton];
        
        UILabel *discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(85,0,35,33)];
        [discountLabel setTextColor:[UIColor whiteColor]];
        discountLabel.tag=1;
        [discountLabel setBackgroundColor:[UIColor clearColor]];
        [discountLabel setText:@"60% OFF"];
        [discountLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        discountLabel.numberOfLines=3;
        discountLabel.textAlignment=NSTextAlignmentCenter;
        [view addSubview:discountLabel];
        
        //[self addSubview:view];
        x += 320.0;
    }
    self.contentSize = CGSizeMake(x, 0);
}

-(void)advertiseNameOnLabels:(NSArray*)arrayNames arrayDiscount:(NSArray*)arrayDiscount;
{
    int index = 0;
    int index1 = 0;
    for (UIView *view in self.subviews)
    {
        if ([view isKindOfClass:[UIView class]])
        {
            for (UIView *view1 in view.subviews)
            {
                if ([view1 isKindOfClass:[UILabel class]])
                {
                    UILabel *labelName = (UILabel*)view1;
                    if(labelName.tag==0)
                    {
                        [labelName setText:[arrayNames objectAtIndex:index]];
                        index ++;
                    }
                    if(labelName.tag==1)
                    {
                        [labelName setText:[arrayDiscount objectAtIndex:index1]];
                        index1 ++;
                    }
                }
            }
        }
    }
}
-(void)advertiseDiscountOnLabels:(NSArray*)arrayDiscount
{
    
}
-(void)imageButtonClicked:(UIButton*)button
{
    if (self.delegateCheckbox != nil && [self.delegateCheckbox respondsToSelector:@selector(advertiseClicked:)]) {
        
        [self.delegateCheckbox advertiseClicked:button];
    }
}
-(void)setEnableLabelCheckmarks:(BOOL)enableLabelCheckmarks
{
    for (UIView *imageButton in self.subviews) {
        
        if ([imageButton isKindOfClass:[UIButton class]]) {
            
            UILabel *labelCheckmark = [[UILabel alloc] initWithFrame:CGRectMake(18, 32, 30, 30)];
            [labelCheckmark setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.6]];
            [labelCheckmark setText:@" ✓"];
            [labelCheckmark setFont:[UIFont boldSystemFontOfSize:20.0]];
            //   [labelCheckmark setTextColor:[TBColorClass getCellAppDarkThemeColor]];
            [labelCheckmark setClipsToBounds:YES];
            //            [TBCommonUtility makeRoundedView:labelCheckmark withBorderColor:[TBColorClass getCellAppDarkThemeColor] andBorderWidth:1.0];
            [labelCheckmark setAlpha:0];
            [imageButton addSubview:labelCheckmark];
            
        }
    }
}

- (void)loadPageWithId:(int)index onPage:(int)page
{
    //	// load data for page
    //   // NSLog(@"loadPageWithId: %d  on page %d",index,page);
    //	switch (page) {
    //		case 0:
    //            // NSLog(@"crash: %d %d",self.arrayOfImages.count,index);
    //			pageOneImageView.image = [self.arrayOfImages objectAtIndex:index];
    //			break;
    //		case 1:
    //			pageTwoImageView.image = [self.arrayOfImages objectAtIndex:index];
    //			break;
    //		case 2:
    //			pageThreeImageView.image = [self.arrayOfImages objectAtIndex:index];
    //			break;
    //	}
}
-(void)setIntervalInSeconds:(NSUInteger)intervalInSeconds
{
    _intervalInSeconds = intervalInSeconds;
    [self startScrolling];
}

-(void)scrollContent
{
    if (self.contentOffset.x == (self.contentSize.width-self.frame.size.width))
    {
        UIButton *firstView = [self.subviews firstObject];
        
        UIButton *dummyImageView = [[UIButton alloc] initWithFrame:CGRectMake(self.contentSize.width, 0, firstView.frame.size.width, firstView.frame.size.height)];
        [dummyImageView setBackgroundImageWithURL:_arrayOfImages.firstObject];
        [self addSubview:dummyImageView];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self setContentOffset:CGPointMake(self.contentOffset.x+self.frame.size.width, self.contentOffset.y)];
        } completion:^(BOOL finished) {
            [dummyImageView removeFromSuperview];
            self.contentOffset = CGPointMake(0, self.contentOffset.y);
        }];
    }
    else
    {
        [self setContentOffset:CGPointMake(self.contentOffset.x+self.frame.size.width, self.contentOffset.y) animated:YES];
    }
}

-(void)setEnableUserScrolling:(BOOL)enableUserScrolling
{
    _enableUserScrolling = enableUserScrolling;
    [self setUserInteractionEnabled:_enableUserScrolling];
}

#pragma mark - Timer Methods
-(void)startScrolling
{
    [self stopScrolling];
    
    if (_arrayOfImages.count >1)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:self.intervalInSeconds target:self selector:@selector(scrollContent) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

-(void)pauseScrollingForDuration:(NSUInteger)duration
{
    [self stopScrolling];
    
    if (_arrayOfImages.count >1)
    {
        pauseTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(startScrolling) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:pauseTimer forMode:NSRunLoopCommonModes];
    }
}

-(void)stopScrolling
{
    if ([timer isValid])
        [timer invalidate];
    
    if ([pauseTimer isValid])
        [pauseTimer invalidate];
    
    timer = nil;
    pauseTimer = nil;
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // NSLog(@"dragged");
    
    [self pauseScrollingForDuration:self.pauseIntervalWhenUserScroll];
}

-(void)panRecognized:(UIPanGestureRecognizer*)panRecognized
{
    if (panRecognized.state == UIGestureRecognizerStateBegan)
    {
        [self stopScrolling];
    }
    else if (panRecognized.state == UIGestureRecognizerStateEnded || panRecognized.state == UIGestureRecognizerStateFailed || panRecognized.state == UIGestureRecognizerStateCancelled)
    {
        [self startScrolling];
    }
}

@end
