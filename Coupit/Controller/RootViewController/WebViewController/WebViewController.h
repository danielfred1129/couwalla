//
//  WebViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : BaseViewController <UIWebViewDelegate> {
 
    IBOutlet UIWebView *mWebView;
    NSURL *urlToLoad;
    
}

- (void) openURLString:(NSString *)pURLStr;
- (IBAction) dismissWebView:(id)sender;
- (IBAction) reloadWebView:(id)sender;

@property(nonatomic, retain) NSURL *urlToLoad;

@end