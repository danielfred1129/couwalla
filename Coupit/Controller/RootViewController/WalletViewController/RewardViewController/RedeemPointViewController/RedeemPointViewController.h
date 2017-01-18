//
//  RedeemPointViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoriesViewController.h"
#import "RequestHandler.h"
#import "IconDownloadManager.h"


@interface RedeemPointViewController : UITableViewController<CategoriesViewControllerDelegate,
                                                            RequestHandlerDelegate> {

}
@property (nonatomic, retain) GiftCards *mGiftCards;


- (void) fetchGiftCardForCategoryID:(NSInteger)pCategoryID startIndex:(NSInteger)pStartIndex;

@end
