//
//  FavouriteCouponsViewController.h
//  Coupit
//
//  Created by geniemac5 on 26/10/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    fPlannedList,
    fFavoriteList
}fListType;

@interface FavouriteCouponsViewController : UITableViewController

-(void)showGestureView;
-(void)hideGestureView;
-(void)menuButtonSelected;
-(void)menuButtonUnselected;
- (void) addFavourite:(id)sender;
- (void) showList:(fListType)pListType;
@end
