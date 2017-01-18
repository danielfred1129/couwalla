//
//  WebViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"


@implementation WebViewController
@synthesize urlToLoad;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
   // self.navigationItem.title = @"Terms & Conditions";
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"%@", urlToLoad);
    [mWebView loadRequest:[NSURLRequest requestWithURL:urlToLoad cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0]];

    
}

- (IBAction) dismissWebView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction) reloadWebView:(id)sender
{
    [mWebView reload];
}

- (void) openURLString:(NSString *)pURLStr
{
    //NSLog(@"openURLString:%@", pURLStr);
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
