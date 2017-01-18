//
//  FeedbackViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface FeedbackViewController : BaseViewController<MFMailComposeViewControllerDelegate, UINavigationControllerDelegate> {
    
    BOOL hasShown;
    
}


@property(nonatomic, retain) IBOutlet UIWebView *mWebView;

- (void) openURLString:(NSString *)pURLStr;
-(void)showGestureView;
-(void)hideGestureView;
-(void)menuButtonSelected;
-(void)menuButtonUnselected;

- (IBAction) reloadWebView:(id)sender;

@end
