//
//  FavouriteViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kPlannedList,
    kFavoriteList
}ListType;

@interface FavouriteViewController : UITableViewController

-(void)showGestureView;
-(void)hideGestureView;
-(void)menuButtonSelected;
-(void)menuButtonUnselected;
- (void) addFavourite:(id)sender;
- (void) showList:(ListType)pListType;


@end
