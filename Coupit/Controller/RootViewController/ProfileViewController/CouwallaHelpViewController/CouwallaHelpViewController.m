//
//  CouwallaHelpViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CouwallaHelpViewController.h"


@implementation CouwallaHelpViewController
{
    UIView *mGestureView;
	UIButton *mMenuButton;

}
@synthesize mWebView, mCouwallaHelpType;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Back Button
    
    if(mCouwallaHelpType !=kSurvey)
    {
    UIButton *tBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tBackButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tBackButton sizeToFit];
    [tBackButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tBackBarButton = [[UIBarButtonItem alloc]initWithCustomView:tBackButton];
    self.navigationItem.leftBarButtonItem = tBackBarButton;
    }
    else
    {
    
    UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
    
    mGestureView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //[mGestureView setBackgroundColor:[UIColor colorWithWhite:(0/255.0) alpha:0.4]];
    
    mMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mMenuButton setImage:[UIImage imageNamed:@"button_menu"] forState:UIControlStateNormal];
    [mMenuButton sizeToFit];
	[mMenuButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc]initWithCustomView:mMenuButton];
    self.navigationItem.leftBarButtonItem = menuBarButton;
    
    // [[UIScreen mainScreen] bounds].size.height
	UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealToggle:)];
	[mGestureView addGestureRecognizer:recognizer];
    
	UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
	[mGestureView addGestureRecognizer:panRecognizer];

    }
    
    
    switch (mCouwallaHelpType)
    {
        case 0:
            self.navigationItem.title = @"FAQ";
            [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.couwallabi.com/faq"]]];
            break;
        case 1:
            self.navigationItem.title = @"Terms and Conditions";
            [mWebView loadHTMLString:[self getTearmAndcondition] baseURL:nil];
            
            
            //[mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://policy-portal.truste.com/core/privacy-policy/Q2-Intel/6b45b037-c5b6-472b-b6c2-29a44b9dd9f1#landingPage"]]];
            //[mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.couwallabi.com/api/privacy_policy/privacy_policy.html"]]];
            
            break;
        case 2:
            self.navigationItem.title = @"Privacy Policy";
            [mWebView loadHTMLString:[self getPrivacyPolicy] baseURL:nil];
            
            
            // [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.couwallabi.com/api/privacy_policy/privacy_policy.html"]]];
            
            break;
        case 3:
            self.navigationItem.title = @"Feedback";
            [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.couwallabi.com/survey"]]];
            break;
            
        default:
            break;
            
            
    }
}

- (void)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSLog(@"%@",request.URL.absoluteString);
        
        if([request.URL.absoluteString isEqualToString:@"http://support@cowalla.com/"])
        {
            [self openMailComposer];
            return NO;
        }
        
  
        
        else if([request.URL.absoluteString isEqualToString:[NSString stringWithFormat:@"%@/privacy_policy/privacy_policy.html",BASE_URL]])
        {
             [mWebView loadHTMLString:[self getPrivacyPolicy] baseURL:nil];
        }
    }
    return YES;
}

-(void)openMailComposer
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"Couwalla"];
        //[controller setMessageBody:tShareCouponMessage isHTML:YES];
        
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    }
    else
    {
        UIAlertView* errorMessage = [[UIAlertView alloc] initWithTitle:@"No local email configure. Kindly setup your email in mail app." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [errorMessage show];
        
    }
}
-(void)showGestureView
{
	if (![self.view.subviews containsObject:mGestureView])
    {
		[self.view addSubview:mGestureView];
	}
}

-(void)hideGestureView
{
	if ([self.view.subviews containsObject:mGestureView])
    {
		[mGestureView removeFromSuperview];
	}
}

-(void)menuButtonSelected
{
    mMenuButton.selected = YES;
    self.mCouwallaHelpType =kSurvey;
}

-(void)menuButtonUnselected
{
	mMenuButton.selected = NO;
    self.mCouwallaHelpType =kSurvey;
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

-(NSString *)getTearmAndcondition
{
    
    NSString * str= @"<html><style>p.couwalla{font-family:\"Helvetica\";}</style><body><b><p class=\"couwalla\"><font color=\"BLACK\">ACCEPTANCE OF TERMS AND CONDITIONS</p></b></b><p>Through this website and its mobile applications and microsites, Couwalla LLC., Inc. provides access to software and services (collectively, the \"Service\") that allow Customers (defined below) to provide and use information for market research purposes. The Service may also include other information and interactivity, such as information and advertising from Clients, and the ability to post comments and participate in discussions. In these Terms of Service, \"Customer\", \"user\" or \"you\" means any person</p><p>using the Service, whether by browsing Couwalla LLC, Inc. websites or mobile apps or participating in any other activities available through the Services. These Terms of Service (the \"Terms of Service\" or \"Agreement\") sets forth the terms and conditions that apply to the use of this website on which Couwalla LLC, Inc. provides the Service to Customers.READ THIS AGREEMENT CAREFULLY. BY USING THIS WEBSITE (OTHER THAN TO READ THIS AGREEMENT FOR THE FIRST TIME), BY INDICATING ACCEPTANCE OF THIS AGREEMENT, ENGAGE IN A COUWALLA LLC., INC. OPERATED REWARDS PROGRAM, OR OTHERWISE USING THE SERVICES, OR BY DOWNLOADING THE COUWALLA LLC., INC. APPLICATION, YOU ARE ENTERING INTO THIS AGREEMENT WITH COUWALLA LLC., INC. AND AGREE TO COMPLY WITH ALL OF THE TERMS OF SERVICE HEREOF. THIS IS A LEGALLY BINDING AGREEMENT.</p></b><p> If you do not agree to these terms and conditions, you may not use the Service or this website, or download or use “Couwalla” LLC., Inc. applications. Void where prohibited.</p><p class=\"couwalla\">1. Registration.</p><p>In order to use the Service, you must create an account and register with us (\"Account\"). If you register as a Customer or otherwise use the Service, you represent and warrant to Couwalla LLC., Inc. that:</p><p>(i) you are of legal age to form a binding contract;</p><p>(ii) you will provide Couwalla LLC., Inc. with accurate, current and complete registration information;</p><p>(iii) your registration and your use of the Service is not prohibited by law;</p><p>(iv) all such registrations use an actual email address owned and operated by you. Couwalla LLC., Inc. reserves the right to suspend or terminate your registration, or your access to the Service.</p><p>Terms of Service</p><p>Effective Date: May 21st, 2014 You are responsible for your own registration and all use of the Service under it. You shall not share your passcode nor use the Service through using the registration of any third party. Your registration, and this Agreement, is personal to you, and is not transferable by you to any third party without the prior written consent of Couwalla LLC., Inc. You further represent that you will create and/or use only one Account, and are thereby entitled to the benefits of only one Couwalla LLC., Inc. membership when using the Service or Reward Program(s). Any creation of additional Account(s) shall be considered a violation of this Agreement. Any such violations may result in fees and penalties as deemed appropriate by Couwalla LLC., Inc. to rectify such resulting fraudulent use, including immediate termination of your Couwalla LLC., Inc. account(s). By registering for Couwalla LLC., Inc., you hereby agree to all fees and penalties that may be applied to your Account in the event Couwalla LLC., Inc. deems your use of the Service as a violation of this Agreement, or in any way against the intended purpose or interest of the Service or any Rewards Program(s). In the event such violations cannot be rectified by fees and penalties (as determined by Couwalla LLC., Inc.), or in the event you attempt to register additional Account(s) once your Account has been terminated, Couwalla LLC., Inc. shallbe entitled to collect treble damages associated with each violation. </p><p class=\"couwalla\">2. Minors.</p><p>Use of Couwalla LLC., Inc. Services is limited to users who are at least 18 years old, although if you are 13 or more, but not yet 18, you may use this website if your parent or legal guardian agrees to this Agreement on your behalf. Use of the Service is not directed to users under the age of 13. If you are under the age of 13, you are not permitted to use this website,register as a Customer or send personal information to Couwalla LLC., Inc.</p><p class=\"couwalla\>3. Proprietary Materials and Ownership.</p><p>The Service and the Couwalla LLC., Inc. website and online application are the property of Couwalla LLC., Inc. Without limitation of the foregoing, all the text, images, sound, music, marks, logos, compilations (meaning the collection, arrangement and assembly of information) and other content on this website other than User Content as defined below (collectively, the \"Site Content\"), and all software embodied in the Couwalla LLC., Inc. website or mobile application or otherwise used by Couwalla LLC., Inc. to deliver the Service (\"Software\"), is proprietary to us or to third parties (which shall be presented upon request) and are protected by copyright and other intellectual property laws. Except as otherwise expressly permitted by this Agreement, any use, exploitation, copying, making derivative works, transmitting, posting, linking, deep linking, redistribution, sale, decompilation, modification, reverse engineering,translation or disassembly of the Software or Site Content is prohibited. You may be subject to criminal or civil penalties for violation of this paragraph.The marks “Couwalla”  and their respective logos are registered or unregistered trademarks of Couwalla LLC., Inc., and they may not be used in connection with any service or products other than those provided by Couwalla LLC., Inc., in any manner that is likely to cause confusion among customers, or in any manner that disparages or discredits Couwalla LLC., Inc. The Service also features the trademarks, service marks, and logos of Clients and other third parties, and each owner retains all rights in such marks. Any use of such marks, or any others displayed on the Service, will inure solely to the benefit of their respective owners.</p><p class=\"couwalla\">4. License to Use the Service.</p><p>Subject to your payment of any applicable fees, Couwalla LLC., Inc. authorizes you to access, view and use the Site Content and Software (collectively, the \"Couwalla LLC., Inc. Property\") solely to the extent necessary for you to use the Service. You may not remove any copyright, trademark or other proprietary notices that have been placed on the Couwalla LLC., Inc. Property. Except as expressly permitted by this Agreement, any modification, reproduction, redistribution, republication, uploading, posting, transmitting, distributing or otherwise exploiting in any way the Couwalla LLC., Inc. Property, or any portion of the Couwalla LLC., Inc. Property, is strictly prohibited without the prior written permission of Couwalla LLC., Inc. You agree, and represent and warrant, that your use of the Service and the Couwalla LLC., Inc. Property, or any portion thereof, will be consistent with the foregoing license, covenants and restrictions and will neither infringe nor violate the rights of any other party or breach any contract or legal duty to any other parties. In addition, you agree that you will comply with all applicable laws, regulations and ordinances relating to the Service, the Couwalla LLC., Inc.Property or your use of them, and that in using the Service you will not engage in any conduct that restricts or inhibits any other person from using or enjoying the Service. You are responsible for obtaining and maintaining the computer, smartphone and other equipment you use to access the Service, and for paying for such equipment and any telecommunications charges. We are not liable for any loss or damage you suffer arising from damage to equipment used in connection with use of the Service.</p><p class=\"couwalla\">5. Terms of the Service</p><p>5.1 - A reward account will be opened for you automatically on registration within the Couwalla  app. Your reward account status can be checked on-line at any time fromwithin the Couwalla app.</p><p>5.2 - Individuals may only open one Couwalla account. Attempts by a single person to open multiple accounts may result in suspension of all their accounts and awards.</p><p>5.3 - You may not earn coins or other Awards in Couwalla without set up of a Cowalla account.</p><p>5.4 - Award redemptions must be made within the Couwalla app or third party designee app. You may be asked to confirm and enter some information about yourself and your household in order to redeem Awards.</p><p>5.5 – Couwalla points/ coins, status and other Awards will be rewarded as described within the app.</p><p>5.6 - If you have any questions related to your Awards, Account or the Couwalla  app, you may use the feedback feature within the app to contact us.</p><p>5.7 - Couwalla and its parent company, Couwalla LLC. Inc., reserve the right to change the Rewards Program and Award redemption options and will notify you of changes from within the Couwalla app with at least a 2-day notice.</p><p>5.8 - All redemption requests will be processed within 14-days of their submission.</p><p>5.9 - Couwalla LLC. Inc. reserves the right to decide who may use the Couwalla app.</p><p>5.10 - Couwalla LLC. Inc. may freeze or eliminate your Couwalla Account after six consecutive months of inactivity. This will be at Couwalla LLC. Inc.'s discretion.</p><p>5.11 - Couwalla LLC. Inc. may freeze or eliminate your Couwalla  Account if fraudulent activity is suspected and/or if activity registered is not as a result  of using app, or that have been modified in any way.</p><p class=\"couwalla\">6. Sweepstakes, Contests & Promotions.</p><p>Any sweepstakes, contests or other promotions (collectively, \"Promotions\") that may be offered via the Service may be governed by a separate set of rules that may have eligibility requirements, such as certain age or geographic area restrictions, terms and conditions governing the Promotions, use of Submissions, and disclosures about how your personal information may be used. It is your responsibility to read these rules to determine whether or not you want to and are eligible to participate, register and/or enter, and to determine the applicable terms and conditions of the Promotion. By participating in a Promotion, you will be subject to those official rules, and you agree to comply with and abide by such rules and the decisions of the Rewards Program Sponsor(s) identified therein.</p><p class=\"couwalla\">7. Third Party Websites/Mobile sites.</p><p>The Couwalla LLC., Inc. website may contain links to third-party websites. The linked sites are not under our control, and we are not responsible for the contents of any linked site. We provide these links as a convenience only, and a link does not imply endorsement of, sponsorship of, or affiliation with the linked site by Couwalla LLC., Inc. You should make whatever investigation you feel necessary or appropriate before proceeding with any transaction with any of these third parties.</p><p class=\"couwalla\">8. Ideas Submitted to Couwalla LLC., Inc.</p><p>Couwalla LLC., Inc. is pleased to hear from you and welcomes your comments about the Service. If you submit ideas or suggestions for the Service (\"Service Comments\"), the Service Comments will be deemed, and will remain, the sole property of Couwalla LLC., Inc. None of the Service Comments will be subject to any obligation of confidence on the part of Couwalla LLC., Inc., and Couwalla LLC., Inc. will not be liable for any use or disclosure of any Service Comments. Without limiting the foregoing, Couwalla LLC., Inc. will be entitled to unrestricted use and other exploitation of the Service Comments for any purpose whatsoever, commercial or otherwise, by any means, by any media, without compensation to the provider, author, creator or inventor of the Service Comments.</p><p  class=\"couwalla\">9. Warranty Exclusions and Limitations of Liability.</p><p>Couwalla LLC., Inc. does not warrant that the Service or Couwalla LLC., Inc. Property will operate error free or without downtime. Couwalla LLC., Inc. may pause or interrupt the Service at any time, and users should expect periodic downtime for updates to the Service.Because we do not control the security of the Internet, or other networks you use to access the microsite, Couwalla LLC., Inc. is not responsible for the security of information that you choose to communicate with Couwalla LLC., Inc. and the microsite while it is being transmitted. Additionally, Couwalla LLC., Inc. is not responsible for any data lost during transmission. Customer's sole and exclusive remedy, and Couwalla LLC., Inc.'s sole and exclusive liability, for any breach of this Agreement or for any other cause of action shall be (at Couwalla LLC., Inc.'s option) to remedy the                                                                                                                                                                                                                           failure or to give a credit to the Customer the amount owed as an Award under a Rewards Program. (Individual Customer contracts with Couwalla LLC., Inc. may include remedy terms which supersede those listed above.) COUWALLA LLC., INC. EXPRESSLY DISCLAIMS ANY AND ALL                                                                                                                                                                                                                                                                    WARRANTIES, WHETHER EXPRESS OR IMPLIED, INCLUDING: (i) ALL WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, NONINFRINGEMENT, AND ANY AND ALL WARRANTIES ARISING FROM COURSE OF DEALING AND USAGE OF                                                                                                                                                                                                                                                                TRADE; (ii) THAT THE SERVICES, INCENTIVES AND COUWALLA LLC., INC. PROPERTY WILL MEET YOUR REQUIREMENTS, WILL ALWAYS BE AVAILABLE, ACCESSIBLE, UNINTERRUPTED, TIMELY, SECURE OR OPERATE WITHOUT ERROR, (iii) AS TO THE RESULTS THAT MAY BE OBTAINED FROM THE OPERATION, USE OR OTHER EXPLOITATION OF THE SERVICES OR COUWALLA LLC., INC. PROPERTY, AND (iv) AS TO THE ACCURACY OR RELIABILITY OF ANY                                                                                                                                                                                                                                                                    INFORMATION OBTAINED FROM THE SERVICES OR THE COUWALLA LLC., INC. PROPERTY.                                                                                                                                                                                                                                                                    No advice or information, whether oral or written, obtained by you from Couwalla LLC., Inc. or through the Service will create any warranty not expressly stated herein.                                                                                                                                                                                                                                                                    UNDER NO CIRCUMSTANCES WILL YOU BE ENTITLED TO RECOVER FROM COUWALLA LLC., INC. ANY INCIDENTAL, CONSEQUENTIAL, INDIRECT, PUNITIVE OR SPECIAL DAMAGES (INCLUDING DAMAGES FOR LOSS OF BUSINESS, LOSS OF PROFITS OR LOSS OF USE), WHETHER BASED ON CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE ARISING FROM OR RELATING TO THE SERVICES OR COUWALLA LLC., INC. PROPERTY, EVEN IF COUWALLA LLC., INC. HAS BEEN INFORMED OR SHOULD HAVE KNOWN OF THE POSSIBILITY OF SUCH DAMAGES. COUWALLA LLC., INC.'S MAXIMUM LIABILITY TO YOU FOR ANY DAMAGES OR LIABILITY ARISING IN CONNECTION WITH THE SERVICE, WHETHER                                                                                                                                                                                                                                                                    ARISING IN CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, SHALL BE A CREDIT OF THE AMOUNT OWED. SOME JURISDICTIONS DO NOT ALLOW THE LIMITATION OR EXCLUSION OF WARRANTIES OR OF LIABILITY FOR CERTAIN TYPES OF DAMAGES, SO SOME OF THE ABOVE LIMITATIONS OR EXCLUSIONS MAY NOT APPLY TO YOU.</p><p class=\"couwalla\">10. Digital Millennium Copyright Act.</p><p>Company complies with the provisions of the Digital Millennium Copyright Act applicable to internet service providers (17 U.S.C. §512, as amended). If you have any complaints or objections to material posted on the Services, you may contact our Designated Agent at the following address:</p><p><a href=\"http://support@couwalla.com/\">support@couwalla.com</a></p><p>Any notice alleging that materials hosted by or distributed through the Services infringe intellectual property rights must include the following information:</p><p>1. an electronic or physical signature of the person authorized to act on behalf of the owner of the copyright or other right being infringed;</p><p>2. a description of the copyrighted work or other intellectual property that you claim has been infringed;</p><p>3. a description of the material that you claim is infringing and where it is located on the Services;</p><p>4. your address, telephone number, and email address;</p><p>5. a statement by you that you have a good faith belief that the use of the materials on the Services of which you are complaining is not authorized by the copyright owner, its agent, or the law; and</p><p>6. a statement by you that the above information in your notice is accurate and that, under penalty of perjury, you are the copyright or intellectual property owner or authorized to act on the copyright or intellectual property owner's behalf.</p><p class=\"couwalla\">Counter Notices</p><p>If material that you have posted to the Services has been removed or disabled, you may file a counter notice pursuant to 17 U.S.C. §512 (g). To be effective, the counter notice must be a written communication sent to the designated agent address listed above that includes the following:</p><p>1. a physical or electronic signature of the subscriber;</p><p>2. identification of the material that has been removed or to which access has been disabled and the location at which the material appeared before it was removed or access to it was disabled;</p><p>3. a statement under penalty of perjury that you have a good faith belief that the material was removed or disabled as a result of mistake or misidentification of the material to be removed or disabled; and</p><p>4. your name, address, and telephone number, and a statement that you consent to the jurisdiction of Federal District Court for the judicial district in which the address is located or, if your address is outside of the United States, for any judicial district in which Company may be found, and that you will accept service of process from the person who provided notification under subsection 17 U.S.C. §512 (c)(1)(C) or an agent of such person.</p><p class=\"couwalla\">11. Link to the Privacy Policy.</p><p>Couwalla LLC., Inc. is concerned about user privacy and operates the Service under the PRIVACY POLICY published at <a href=\"http://www.couwalla.com/privacy.html\">http://www.couwalla.com/privacy.html</a> . We urge you to read this policy now and, because the policy is updated from time to time, later at your convenience.</p><p class=\"couwalla\">12. Arbitration.</p><p>This Agreement represents the entire agreement of the parties as to its subject matter, and supersedes all prior written and oral representations and discussions between the parties. If a matter arises that cannot be resolved between you and Couwalla LLC., Inc. with reasonable effort, you agree that all such disagreements or disputes that in any way involves the Program or this Agreement shall be resolved exclusively by final and binding administration by the American Arbitration Association (\"AAA\"), and will be conducted before a single arbiter pursuant to the applicable Rules and Procedures established by the AAA. You agree that the arbitration shall be held in Florida, or at any other location that is mutually agreed upon by You and Couwalla LLC., Inc. You agree that the arbiter will apply the laws of the State of Florida consistent with the Federal Arbitration Act, and will honor and agree to all applicable statutes of limitation. You agree that, unless prohibited by law, there shall be no authority for any claims to be arbitrated on a class or representative basis, and arbitration will only decide a dispute between You and Couwalla LLC., Inc. If any part of this Arbitration clause is later deemed invalid as a matter of law, then the remaining portions of this section shall remain in effect, with the exception of the class language referenced herein, in such case this entire section shall be deemed invalid.</p><p class=\"couwalla\">13. Suspension; Modifications and Termination.</p><p>Couwalla LLC., Inc. reserves the right to suspend your password and/or access to the Service at any time if it believes you are in breach of this Agreement. Couwalla LLC., Inc. reserves the right to terminate or modify this Agreement, terminate the Service or modify any features or aspects of the Service, or modify its policies at any time, with or without notice to you.</p><p>Any such termination will not affect any Incentives you have earned prior to termination. If you earn an Incentive or use the Service, you shall be bound by the version of the Agreement in effect at the time of your purchase. If we make changes that materially affect your use of the Program or Services, we will post a notice of the change on the Couwalla LLC., Inc. website. You are under an obligation to review the current version of this Agreement and other published Couwalla LLC., Inc. policies before using the Service. Sections 2, 3, 5, 7-12, 14 and 15, any accrued rights and remedies hereunder, and any other provisions that by their nature require survival in order to be effective, shall survive the termination or expiration of this Agreement.</p><p class=\"couwalla\">14. Force Majeure</p><p>In no event shall Couwalla LLC., Inc. be liable for any failure to comply with this Agreement to the extent that such failure arises from factors outside Couwalla LLC., Inc.'s reasonable control.</p> <p class=\"couwalla\">15. Third Party Beneficiaries</p><p>The provisions of this Agreement are entered into for the benefit of Couwalla LLC., Inc. and its third party licensors and each of them shall have the right to enforce such provisions of this Agreement directly against you to protect their interests. Except as stated in the preceding sentence, there shall be no third party beneficiaries to this Agreement.</p><p class=\"couwalla\">16. Miscellaneous Provisions.</p><p>No delay or omission by Couwalla LLC., Inc. in exercising any of its rights occurring upon any noncompliance or default by you with respect to any of the terms and conditions of this Agreement will impair any such right or be construed to be a waiver thereof, and a waiver by Couwalla LLC., Inc. of any of the covenants, conditions or agreements to be performed by you will not be construed to be a waiver of any succeeding breach thereof or of any other covenant, condition or agreement hereof contained. As used in this Agreement, \"including\" means \"including but not limited to\" and the term \"partner\" is used solely to denote another entity with whom Couwalla LLC., Inc. has a sponsorship or similar contractual arrangement. If any provision of this Agreement is found by a court of competent jurisdiction to be invalid or unenforceable, then this Agreement will remain in full force and effect and will be reformed to be valid and enforceable while reflecting the intent of the parties to the greatest extent permitted by law. Except as otherwise expressly provided herein, this Agreement sets forth the entire agreement between you and Couwalla LLC., Inc. regarding its subject matter, and supersedes all prior promises, agreements or representations, whether written or oral, regarding such subject matter. You shall not assign or transfer this Agreement or any right or obligation hereunder to any third party. This Agreement may be executed electronically, and your electronic assent or use of the Service shall constitute execution of this Agreement. You agree that the electronic text of this Agreement constitutes in writing and your assent to the terms and conditions hereof constitutes a \"signing\" for all purposes. If any provision of this Agreement is held invalid by a court of competent jurisdiction, such invalidity shall not affect the enforceability of any other provisions contained in this Agreement, and the remaining portions of this Agreement shall continue in full force and effect. You agree to act in a way that complies with the letter and spirit of this Agreement and the terms of any Loyalty Program, and you understand that failure to do so can result in your immediate deletion of your Couwalla LLC., Inc. account.</p><p class=\"couwalla\">17. Choice of Law.</p><p>Any disputes arising out of or related to this Agreement and/or the Program shall be governed by the laws of the State of Florida, without regard to its choice of law rules and without regard to conflicts of laws principles except that the Arbitration provision in Section 11 shall be governed by the Federal Arbitration Act.© 2014 Couwalla LLC., Inc.</p></font></b></body></html>";
    
    
    return str;
}

-(NSString *)getPrivacyPolicy
{
    NSString * str= @"<html><style>p.couwalla{font-family:\"Helvetica\";}</style><body><font color=\"BLACK\"><p class=\"couwalla\"><b>Privacy Policy</b></p></font><font color=\"BLACK\">Last Updated: May 21, 2014 Your privacy is very important to Couwalla, LLC., LLC.. (“Couwalla, LLC.). We respect your privacy rights and are committed to protecting your privacy and to use your personal information for the uses that you will have approved only. Couwalla, LLC., analyzes your usage patterns when interacting and utilizing the Couwalla platform. Cowalla LLC., and related brands measure your usage and loyalty to a brand, product or retailer. This privacy policy (“Policy”) explains how your information is collected, used and disclosed by Couwalla, LLC. This Policy is subject to all the terms and conditions for the use of the Services provided in the Terms of Use. Please see our Terms of Use at <a href=\"http://www.couwalla.com/\">COUWALLA.com</a></p><a href=\"http://api.couwallabi.com/api/privacy_policy/location_services.html\">Location Service</a></br><a href=\"http://api.couwallabi.com/api/privacy_policy/collection_use.html\">Collection & Service</a></br><a href=\"http://api.couwallabi.com/api/privacy_policy/sharing_your_info.html\">Sharing Your Information</a>   </br>   <a href=\"http://api.couwallabi.com/api/privacy_policy/tracking_ads.html\">Tracking Your Information</a>   </br>   <a href=\"http://api.couwallabi.com/api/privacy_policy/security.html\">Security</a>   </br>   <a href=\"http://api.couwallabi.com/api/privacy_policy/other_info.html\">Other Information</a>   </br>   <a href=\"http://api.couwallabi.com/api/privacy_policy/contact.html\">Contact</a><p>Questions? Concerns? Suggestions?</br> Please contact us at <a href=\"http://support@cowalla.com\">support@cowalla.com</a></p></font></body></html>";
//    
//    <font color=\"BLACK\"><p class=\"couwalla\">Collected Information</p><p>Information will be collected by Couwalla, LLC., on www.Cowalla.com (the \"Site\"), on our Facebook application (www.facebook.com/Couwalla) and through our mobile application and affiliated partnerships and services where Couwalla, LLC. is active (collectively, such services, including any new features and applications, and the Site, the \"Service(s)\"). When you use the Services, you consent to our collection, use, disclosure of your information as described in this Policy. The information we collect is needed in order to help provide valuable information to our clients so together we can offer the best opportunities for which the platform was created.The information Couwalla, LLC. gathers falls into either of the 2 following categories:</p><p>1. Personally identifiable information, which includes personal information you supply when you register, order, complete a survey, enter a contest, provide your email address or provide your friends’ email addresses such as, but not limited to, your name, your age your pictures, your email address, your telephone number, your mailing address and your employer; and anything you opt to provide us upon sign up or any additional requests we may have.</p><p>2. Non-personally identifiable information collected through technology, which includes the IP address of the computer you are using, your domain name, your browser, your operating system, the navigation path that brought you to our Site, aggregate information on what pages your access or visit and tracking information collected as you navigate the Web or away from our mobile application.</p></font><font color=\"BLACK\"><p class=\"couwalla\"><b>Cookies</b></p><p>Our Site may use ”cookies”. Cookies record user-specific information on what pages you access or visit, alert you to new areas that we think might be of interest to you when you return to our Site, record past activity at a site in order to provide better service when you return to our Site, help ensure you are not repeatedly sent the same banner ads, customize web page content based on your browser type or other information that the you send. You can disable cookies by disabling this feature in your browser. However, if you refuse cookies, you may not be able to use the services or receive our offers. Cookies allow you to take full advantage of the best features of the services. We recommend that you allow them.</p><p>Questions? Concerns? Suggestions?</br> Please contact us at <a href=\"http://support@cowalla.com/\">support@cowalla.com</a></p></font><font color=\"BLACK\"><p class=\"couwalla\"><b>Sharing Your Information</b></p></font><font color=\"BLACK\"><p class=\"couwalla\"><b>Use of Information</b></p><p>Couwalla, LLC., respects your privacy settings and does not analyze private accounts unless given explicit permission to do so. Couwalla, LLC.,  works actively to ensure the strictest of compliance with all privacy policies, laws and regulations. Couwalla, LLC., only uses your information to help understand your patterns of purchase and usage of any and all products services or retail establishments to provide significant benefits back to you. Some or all of the information we collect is already publicly available (such as your name, pictures, posts and likes on public Facebook pages, as well as your public posts or images). If you are uncomfortable with your information being publicly available, Couwalla LLC. recommends you set your various social media accounts to private. Couwalla LLc., only measures private information when explicitly given access from you. Couwalla LLC.,  will never publicly share or display your private updates. Cowalla LLC., by acceptance and usage of our platform is granted the complete rights to compile your data and display the results in any form we see fit without violating your privacy rights. You can control the information that is displayed on your profile or choose to opt-out at any time. If you wish to opt-out completely, please do so through the Facebook page tab. Couwalla, LLC.,  will not give, share, rent or sell any personally identifiable information to any third party without your explicit permission. We will only share your public personally identifiable information (such as those publicly disclosed on Facebook) to third party partners (“Partners”) for the purpose of showing your interaction and loyalty/ favorable position for the Couwalla platform.Partners do not get access to your private information. You acknowledge and agree that we may preserve personally identifiable information and may also disclose personally identifiable information if required to do so by law or in the good faith believe that such preservation or disclosure is reasonably necessary to comply with legal process, applicable laws or government requests.</p><p class=\"couwalla\"><b>Authentication Process</b></p><p>We never collect passwords. The authentication process is based on existing accounts with different social media services such as Facebook. Also, you can choose which social networks Couwalla, LLC.,  can access.</p></font><font color=\"BLACK\"><p class=\"couwalla\"><b>Tracking & Ads</b></p></font><font color=\"BLACK\"><p class=\"couwalla\">Third Party Advertising</p><p>The Site- mobile application the Couwalla platform may contain third party advertising and/or link to other websites. You may also use the services through our Facebook application (www.facebook.com/Cowalla). We are not responsible for the privacy practices, terms of use and/or content of such other third party websites or advertisements. We recommend that you carefully read the policies relating to the protection of personal information found on these websites in order to determine in an informed manner to what extent you want or not to use these websites and or products. You also agree to hold us completely harmless should any issue occur as a result of usage of said companies products.</p><p class=\"couwalla\"><b>Storage</b></p><p>If you reside outside of the United States of America, you agree that your information will be transferred to the United States of America, then processed and stored in in the storage unit desired and utilized by Couwalla LLC.. At your request or upon your opting-out, we will close your account and delete your personally identifiable information. Despite the closure of your account, we reserve the right to keep, for an indefinite period of time within the time limits specified in the stae of Florida or federal laws, personally identifiable information to comply with the law, prevent fraud, resolve a claim or some other related problem,cooperate in an investigation, enforce the Terms of Use and any other act permitted by law. At the end of this period, the data files will be destroyed or deleted from our systems.</p><p>Questions? Concerns? Suggestions? Please contact us at <a href=\"http://support@cowalla.com/\">support@cowalla.com</a></p></font><font color=\"BLACK\"><p class=\"couwalla\"><b> Security</b></p></font><font color=\"BLACK\"><p class=\"couwalla\"><b>Security of Information</b></p><p>All personally identifiable information you provide to us are stored on our secure servers with restricted access. In deciding to voluntarily provide us your personally identifiable information, you consent to the transfer and storage of your personal data on our servers. Although stored in a secure environment, please be advised that no information security methodology is entirely secure. You should take reasonable steps to protect yourself against unauthorized access to your information and personally identifiable information. GIVEN THE PUBLIC NATURE OF THE INTERNET NETWORK MOBILE CONNECTIONS, AND ANY AND SOCIAL PLATFORMS, USER ACKNOWLEDGES AND AGREES THAT THE SECURITY OF COMMUNICATIONS CANNOT BE GUARANTEED. THEREFORE, COOUWALLA LLC., CANNOT GUARANTEE NOR SHALL BEAR ANY LIABILITY FOR ANY BREACH OF CONFIDENTIALITY, HACKING, VIRUSES, LOSS OR ALTERATION OF INFORMATION TRANSMITTED OR HOSTED ON COUWALLA’S SYSTEMS.</p><p>Questions? Concerns? Suggestions? Please contact us at <a href=\"http://support@cowalla.com/\">support@cowalla.com</a></p>
//    
//    
//    
//    
    
    
    
    
    
    //<font color=\"RED\"></font>
    //<font color=\"BLACK\"></font>
    //    <p></p>
    //    <p class=\"couwalla\"></p>
    
    // <p>Questions? Concerns? Suggestions? Please contact us at <a href="http://support@cowalla.com/">support@cowalla.com</a></p>
    return str;
}
#pragma mark - mailComposeController delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        UIAlertView* errorMessage = [[UIAlertView alloc] initWithTitle:@"Mail sent successfully" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        ;
        [errorMessage show];
    }
    else if (result == MFMailComposeResultFailed) {
        UIAlertView* errorMessage = [[UIAlertView alloc] initWithTitle:@"Mail sending fail" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        ;
        [errorMessage show];
        
    }
    
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
