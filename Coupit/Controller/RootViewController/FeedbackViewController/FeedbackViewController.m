//
//  FeedbackViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "FeedbackViewController.h"


@implementation FeedbackViewController {
    UIView *mGestureView;
	UIButton *mMenuButton;

}
@synthesize mWebView;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Feedback";
    mMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mMenuButton setImage:[UIImage imageNamed:@"button_menu"] forState:UIControlStateNormal];
    [mMenuButton sizeToFit];
	[mMenuButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
    
    UIBarButtonItem* menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:mMenuButton];
    self.navigationItem.leftBarButtonItem = menuBarButton;
    
    mGestureView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //[mGestureView setBackgroundColor:[UIColor colorWithWhite:(0/255.0) alpha:0.4]];
    
    // [[UIScreen mainScreen] bounds].size.height
	UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealToggle:)];
	[mGestureView addGestureRecognizer:recognizer];
    
	UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
	[mGestureView addGestureRecognizer:panRecognizer];
    [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];


}

- (void)viewDidAppear:(BOOL)animated {
    
    if(!hasShown) {
        
        if([MFMailComposeViewController canSendMail]) {
            
            MFMailComposeViewController *emailSender = [[MFMailComposeViewController alloc] init];
            [emailSender setSubject:@"Couwalla Feedback"];
            [emailSender setToRecipients:@[@"adam@q2intel.com"]];
            [emailSender setDelegate:self];
            [emailSender setMailComposeDelegate:self];
            [self presentViewController:emailSender animated:YES completion:nil];
            
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Couwalla"
                                  message:@"Your device doesn't support emails. To send us feedback, email adam@q2intel.com"
                                  delegate:self cancelButtonTitle:@"Close"
                                  otherButtonTitles:nil];
            [alert show];
            
        }
        
    }
    
}

#pragma mark - MFMailComposerViewController Events

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    hasShown = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if(result == MFMailComposeResultSent) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Couwalla"
                              message:@"Your feedback is greatly appreciated. Thanks!"
                              delegate:self cancelButtonTitle:@"Close"
                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (IBAction) reloadWebView:(id)sender
{
    [self.mWebView reload];
}

- (void) openURLString:(NSString *)pURLStr
{
    //NSLog(@"openURLString:%@", pURLStr);
    
    [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pURLStr]]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)showGestureView {
	if (![self.view.subviews containsObject:mGestureView]) {
		[self.view addSubview:mGestureView];
	}
}

-(void)hideGestureView {
	if ([self.view.subviews containsObject:mGestureView]) {
		[mGestureView removeFromSuperview];
	}
}

-(void)menuButtonSelected {
	mMenuButton.selected = YES;
}

-(void)menuButtonUnselected {
	mMenuButton.selected = NO;
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}





@end
