//
//  CouwallaHelpViewController.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>


typedef enum {
    kFAQHelp,
    kTermsOFServiceHelp,
    kPrivacyPolicyHelp,
    kSurvey
}CouwallaHelp;



@interface CouwallaHelpViewController : BaseViewController <MFMailComposeViewControllerDelegate>

@property(nonatomic, retain) IBOutlet UIWebView *mWebView;
@property CouwallaHelp mCouwallaHelpType;

- (void) showGestureView;
- (void) hideGestureView;
- (void) menuButtonSelected;
- (void) menuButtonUnselected;


- (void) openURLString:(NSString *)pURLStr;
- (IBAction) reloadWebView:(id)sender;

@end
