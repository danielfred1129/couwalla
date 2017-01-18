//
//  StoreFavoritesViewController.h
//  Coupit
//
//  Created by geniemac5 on 12/12/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GREST.h"

@interface StoreFavoritesViewController : BaseViewController <GRESTDelegate> {
    
    GREST *api;
    
    IBOutlet UITableView *favoritetable;
    
}

@end
