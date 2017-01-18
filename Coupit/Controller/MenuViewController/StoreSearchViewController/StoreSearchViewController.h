//
//  StoreSearchViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestHandler.h"
#import "IconDownloadManager.h"
#import <CoreLocation/CoreLocation.h>
#import "StoreLocations.h"

typedef enum {
    kStoreSearchTab,
    kBrandsSearchTab,
    
}SeletedSearchTab;

@interface StoreSearchViewController : BaseViewController<RequestHandlerDelegate, IconDownloadManagerDelegate>


@property(nonatomic, retain) IBOutlet UITableView *mtableView;
@property (nonatomic, retain) NSString *mSearchText;
@property SearchType mSearchType;
@property SeletedSearchTab mSeletedTab;

- (void) initButtons;

-(void)showGestureView;
-(void)hideGestureView;
-(void)menuButtonSelected;
-(void)menuButtonUnselected;

- (void) makeSearchRequestWithString:(NSString *)pSearchStr;


//- (StoreLocations *) getStoreLocationByID:(NSInteger)pID;

@end
