//
//  SearchViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GREST.h"
#import "tNSString+SBJSON.h"
#import "RequestHandler.h"

@interface SearchViewController : UITableViewController<GRESTDelegate>
{
    GREST *api;
    
@private  NSUInteger numberOfItemsToDisplay;
}

@property (nonatomic, retain) NSString *mSearchText;
@property SearchType mSearchType;

-(void)showGestureView;
-(void)hideGestureView;
-(void)menuButtonSelected;
-(void)menuButtonUnselected;
-(void)backButton:(id)sender;

- (void) makeSearchRequestWithString:(NSString *)pSearchStr;

@end
