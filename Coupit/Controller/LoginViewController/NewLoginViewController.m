//
//  NewLoginViewController.m
//  Coupit
//
//  Created by Canopus 4 on 19/05/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "NewLoginViewController.h"
#import "RequestHandler.h"
#import "appcommon.h"
#import "jsonparse.h"
#import "AppDelegate.h"
#import "UIColor+AppTheme.h"
#import "CouwallaHelpViewController.h"
#import "NSString+Validation.h"
#import "CoupitService.h"
#import "LocalyticsSession.h"
#import "IQUIView+IQKeyboardToolbar.h"

static NSDate *dateBeforeSignUp=nil;

// fb clientId=254146351456787

@interface NewLoginViewController ()<UITextFieldDelegate>
{
    IBOutlet UIImageView *imageViewTile;
    IBOutlet UIImageView *imageViewDivider;
    IBOutlet UIButton *buttonSignInFB;
    IBOutlet UITextField *textFieldEMail;
    IBOutlet UITextField *textFieldConfirmEMail;
    
    
    IBOutlet UIButton *buttonSwitchScreen;
    IBOutlet UIButton *buttonSignInSignUp;
    IBOutlet UILabel *labelJoining;
    BOOL _isSignUp;
}

@end

@implementation NewLoginViewController
@synthesize genderTextfd;
- (BOOL)shouldAutorotate
{
    return NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];

    //Re-SetUp
    {
        //LabelJoining
        {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:labelJoining.text];
            
            NSRange rangePrivacyPolicy      = [string.string rangeOfString:@"Privacy Policy" options:NSRegularExpressionCaseInsensitive];
            NSRange rangeTermsAndConditions = [string.string rangeOfString:@"Terms and Conditions" options:NSRegularExpressionCaseInsensitive];
            
            NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:NSUnderlineStyleSingle],NSUnderlineStyleAttributeName,[UIColor appGreenColor],NSUnderlineColorAttributeName,[UIColor appGreenColor],NSForegroundColorAttributeName, nil];
            
            [string setAttributes:attribute range:rangePrivacyPolicy];
            [string setAttributes:attribute range:rangeTermsAndConditions];
            labelJoining.attributedText = string;
        }
        
        //Backgournd Tile
        {
            imageViewTile.image = [imageViewTile.image resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
        }
        
        //Navigation Bar
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_logo_couwalla"]];
            self.navigationItem.titleView = imageView;
        }
        
        //TextField
        {
            UIView *emailLeftView       = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textFieldEMail.frame.size.height, textFieldEMail.frame.size.height)];
            UIImageView *imageView1     = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_email"]];
            imageView1.contentMode = UIViewContentModeScaleAspectFit;
            imageView1.frame = CGRectInset(emailLeftView.frame, 7, 0);
            [emailLeftView addSubview:imageView1];

            UIView *confirmEmailLeftView       = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textFieldEMail.frame.size.height, textFieldEMail.frame.size.height)];
            UIImageView *imageView2     = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_email"]];
            imageView2.contentMode = UIViewContentModeScaleAspectFit;
            imageView2.frame = CGRectInset(confirmEmailLeftView.frame, 7, 0);
            [confirmEmailLeftView addSubview:imageView2];
            
            
            UIView *genderLeftView       = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textFieldEMail.frame.size.height, textFieldEMail.frame.size.height)];
            UIImageView *imageView3     = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gender_icon"]];
            imageView3.contentMode = UIViewContentModeScaleAspectFit;
            imageView3.frame = CGRectInset(confirmEmailLeftView.frame, 7, 0);
            [genderLeftView addSubview:imageView3];

            
            UIView *genderRightView       = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textFieldEMail.frame.size.height, textFieldEMail.frame.size.height)];
            genderRightView.layer.cornerRadius=5.0;
            
            
            
            
//            
//            UIImageView *imageView4     = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gender_dropdown"]];
//            imageView4.contentMode = UIViewContentModeScaleToFill;
//            imageView4.frame =CGRectMake(10, 0, textFieldEMail.frame.size.height, textFieldEMail.frame.size.height);
//            imageView4.layer.cornerRadius=5.0;
//            imageView4.center=genderRightView.center;
//            [genderRightView addSubview:imageView4];
  
            UIButton *imageBtn     = [UIButton buttonWithType:UIButtonTypeCustom];
            imageBtn.contentMode = UIViewContentModeScaleToFill;
            [imageBtn setBackgroundImage:[UIImage imageNamed:@"gender_dropdown"] forState:UIControlStateNormal];
            imageBtn.frame =CGRectMake(10, 0, textFieldEMail.frame.size.height, textFieldEMail.frame.size.height);
            [imageBtn addTarget:self action:@selector(genderFirstResponder) forControlEvents:UIControlEventTouchUpInside];
            imageBtn.layer.cornerRadius=5.0;
            imageBtn.center=genderRightView.center;
            [genderRightView addSubview:imageBtn];
            
            textFieldEMail.leftView         = emailLeftView;
            textFieldConfirmEMail.leftView  = confirmEmailLeftView;
            genderTextfd.leftView           = genderLeftView;
            genderTextfd.rightView = genderRightView;
            
             textFieldEMail.leftViewMode         = UITextFieldViewModeAlways;
            textFieldConfirmEMail.leftViewMode  = UITextFieldViewModeAlways;
            genderTextfd.leftViewMode         = UITextFieldViewModeAlways;
            genderTextfd.rightViewMode         =UITextFieldViewModeAlways;
            
            [genderTextfd setItemList:[NSArray arrayWithObjects:@"Male",@"Female",nil]];
            genderTextfd.delegate=self;
            textFieldEMail.delegate=self;
            textFieldConfirmEMail.delegate=self;
            
            [textFieldEMail setDelegate:self];
            
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AchievedFirstSuccess"])
            {
                _isSignUp = YES;
                [self setShowSignUp:NO animated:NO];
            }
            else
            {
                _isSignUp = NO;
                [self setShowSignUp:YES animated:NO];
            }
           
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"Login_Attempt"];
    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"Registration_Attempt"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[LocalyticsSession shared] tagScreen:kLoginScreen];
}

#pragma mark - Button Actions


-(void)genderFirstResponder
{
    [genderTextfd becomeFirstResponder];
}
- (IBAction)switchScreenAction:(UIButton *)sender
{
    [self setShowSignUp:!_isSignUp animated:YES];
}
- (IBAction)signUpSignInAction:(UIButton *)sender
{
    if ([textFieldEMail.text length] == 0 )
    {
        [[[UIAlertView alloc] initWithTitle:@"Message" message:@"Please enter your email ID" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    else if ([textFieldEMail.text isValidEmail] == NO)
    {
        [[[UIAlertView alloc] initWithTitle:@"Message" message:@"Email ID is not valid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
   
    else
    {
        if (_isSignUp)
        {
            if ([textFieldEMail.text isEqualToString:textFieldConfirmEMail.text] == NO)
            {
                [[[UIAlertView alloc] initWithTitle:@"Message" message:@"Email and confirm Email does not match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
            else if ([genderTextfd.text length] == 0)
            {
                [[[UIAlertView alloc] initWithTitle:@"Message" message:@"Please select gender" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
            else
            {
                // Tag Registration Start Event Localytics
                
                [self tagRegistrationStartEventInLocalytics];
                
                ///////////////////////////////////////////
                
                // To Increase Registration Attempt Count
                [self increaseRegistrationAttemptCount];
                NSDate *dateBeforeRegistration=[NSDate date];
                
                NSDictionary *userAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                               @"0000",@"password",
                                               textFieldEMail.text, @"email",
                                               textFieldConfirmEMail.text, @"loginid",
                                               genderTextfd.text,@"gender",
                                               nil];
                
                [[ProgressHudPresenter sharedHUD] presentHud];
                [[ProgressHudPresenter sharedHUD] setTitle:@"Signing up.."];
                
                [[CoupitService service] signupUser:userAttribute completionHandler:^(NSDictionary *result, NSError *error)
                {
                     if (error)
                    {
                        [[[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                        
                        // Tag Web Service Error On Localytics
                        
                        [[LocalyticsSession shared] tagEvent:kErrorSummary attributes:@{kError:[error localizedDescription]}];
                        [[ProgressHudPresenter sharedHUD] hideHud];

                        //////////////////////////////////////
                    }
                    else
                    {
                        if ([[[result objectForKey:@"response"] lowercaseString] isEqualToString:@"success"])
                        {
                        if([result count]<=2)
                        {
                            [[ProgressHudPresenter sharedHUD] hideHud];

                           UIAlertView *alrt= [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your account has been successfully created." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] ;
                            alrt.tag=123;
                            [alrt show];
                        }
                        else
                        {
                            _isSignUp=!_isSignUp;
                            [self performSelector:@selector(signUpSignInAction:) withObject:nil];
                        }
                            // Send Localytics Attributes
                            
                            NSTimeInterval interval=[[NSDate date] timeIntervalSinceDate:dateBeforeRegistration];
                            NSString *timeSpent=[NSString stringWithFormat:@"%f",interval];
                            NSString *registrationAttemptCount=[self getRegistrationAttemptCount];
                            [[LocalyticsSession shared] tagEvent:kRegistrationComplete attributes:@{ kLoadTime : timeSpent, kAttempt :  registrationAttemptCount}];
                            
                            /////////////////////////////
                        }
                        else if ([[[result objectForKey:@"response"] lowercaseString] isEqualToString:@"failure"])
                        {
                            [[[UIAlertView alloc] initWithTitle:@"Error!" message:[result objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                            [[ProgressHudPresenter sharedHUD] hideHud];
                        }
                        else
                        {
                            UIAlertView *fAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Unknown error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            [fAlert show];
                            [[ProgressHudPresenter sharedHUD] hideHud];
                        }
                    }
                }];

                //SignUp
            }
        }
        else
        {
            NSDictionary *userAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                           textFieldEMail.text,@"loginid",
                                           @"0000",@"password", nil];
            
            
            [[ProgressHudPresenter sharedHUD] presentHud];
            
            [[ProgressHudPresenter sharedHUD] setTitle:@"Signing In..."];
            
            // To Increase Login Attempt Count
            [self increaseLoginAttemptCount];
            
            NSDate *dateBeforeLogin=[NSDate date];
            
            [[CoupitService service] loginUser:userAttribute completionHandler:^(NSDictionary *result, NSError *error) {

                [[ProgressHudPresenter sharedHUD] hideHud];
                
                if (error)
                {
                    [[[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                    
                    // Tag Web Service Error On Localytics
                    
                    [[LocalyticsSession shared] tagEvent:kErrorSummary attributes:@{kError:[error localizedDescription]}];
                    
                    //////////////////////////////////////
                }
                else
                {
                    if ([[[result objectForKey:@"response"] lowercaseString] isEqualToString:@"success"])
                    {
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        
                        [defaults setObject:textFieldEMail.text forKey:kUsernameKey];
                        [defaults setObject:@"0000" forKey:kPasswordKey];
                        
                        NSString *idstring = [[result objectForKey:@"data"] objectForKey:@"id"];
                        [defaults setObject:idstring forKey:@"logidkey"];
                        //[defaults setObject:@"155" forKey:@"logidkey"];
                        [defaults setObject:textFieldEMail.text forKey:@"loginidkey"];
                        [defaults synchronize];
                        
                        // Send Localytics Attributes
                        
                        NSTimeInterval interval=[[NSDate date] timeIntervalSinceDate:dateBeforeLogin];
                        NSString *timeSpent=[NSString stringWithFormat:@"%f",interval];
                        NSString *loginAttemptCount=[self getLoginAttemptCount];
                        [[LocalyticsSession shared] tagEvent:kLoginSummary attributes:@{ kTimeSpent : timeSpent, kLoginAttempts :  loginAttemptCount}];
                        
                        /////////////////////////////
                        
                        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        [appDelegate loginViewController:nil loginStatus:YES];
                    }
                    else if ([[[result objectForKey:@"response"] lowercaseString] isEqualToString:@"failure"])
                    {
                        [[[UIAlertView alloc] initWithTitle:@"Error" message:[result objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                    }
                    else
                    {
                        UIAlertView *fAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Unknown error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [fAlert show];
                    }
                }
            }];
        }
    }
}

-(void)setShowSignUp:(BOOL)isSignUp animated:(BOOL)animated
{
    if (isSignUp != _isSignUp)
    {
        [self clearTextFromAllTextFields];
        dateBeforeSignUp=nil;
        _isSignUp = isSignUp;

        textFieldConfirmEMail.inputAccessoryView = nil;
        textFieldEMail.inputAccessoryView = nil;
        genderTextfd.inputAccessoryView = nil;

        
        NSDictionary *switchStringAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:NSUnderlineStyleSingle],NSUnderlineStyleAttributeName,[UIColor appGreenColor],NSUnderlineColorAttributeName,[UIColor appGreenColor],NSForegroundColorAttributeName, nil];
        NSDictionary *signInSignUpStringAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
        
        
        NSAttributedString *switchString;
        NSAttributedString *signInSignUpString;
        
        if (isSignUp)
        {
            switchString        = [[NSAttributedString alloc] initWithString:@"Login" attributes:switchStringAttributes];
            signInSignUpString  = [[NSAttributedString alloc] initWithString:@"Sign Up" attributes:signInSignUpStringAttributes];
            
            [UIView animateWithDuration:(animated?0.3:0.0) delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{

                CGRect frame = genderTextfd.frame;
                frame.origin.y = frame.origin.y-42;
                textFieldConfirmEMail.frame = frame;
                
                CGRect frame1 = textFieldConfirmEMail.frame;
                frame1.origin.y = frame1.origin.y-42;
                textFieldEMail.frame = frame1;
                
                [textFieldConfirmEMail setAlpha:1.0];
                [genderTextfd setAlpha:1.0];
                
            } completion:^(BOOL finished) {
                [textFieldConfirmEMail setEnabled:YES];
                [genderTextfd setEnabled:YES];
            }];

            [UIView transitionWithView:buttonSignInFB duration:(animated?0.3:0.0) options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [buttonSignInFB setImage:[UIImage imageNamed:@"button_signinFB"] forState:UIControlStateNormal];
            } completion:nil];
        }
        else
        {
            switchString        = [[NSAttributedString alloc] initWithString:@"Sign Up" attributes:switchStringAttributes];
            signInSignUpString  = [[NSAttributedString alloc] initWithString:@"Login" attributes:signInSignUpStringAttributes];
            
            [UIView animateWithDuration:(animated?0.3:0.0) delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
                textFieldConfirmEMail.frame=genderTextfd.frame;
                textFieldEMail.frame = textFieldConfirmEMail.frame;
                [textFieldConfirmEMail setAlpha:0.0];
                [genderTextfd setAlpha:0.0];
            } completion:^(BOOL finished) {
                [textFieldConfirmEMail setEnabled:NO];
                [genderTextfd setEnabled:NO];
            }];
            
            [UIView transitionWithView:buttonSignInFB duration:(animated?0.3:0.0) options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [buttonSignInFB setImage:[UIImage imageNamed:@"button_signinFB"] forState:UIControlStateNormal];
            } completion:nil];
        }
        
        [buttonSwitchScreen setAttributedTitle:switchString forState:UIControlStateNormal];
        [buttonSignInSignUp setAttributedTitle:signInSignUpString forState:UIControlStateNormal];
    }
}

#pragma mark - Facebook Handling
- (IBAction)facebookButtonAction:(UIButton *)sender
{
    [self clearTextFromAllTextFields];
    dateBeforeSignUp=[NSDate date];
    
    //Check for internet connection
    if (![[RequestHandler getInstance] checkInternet])
    {
        UIAlertView *connAlert = [[UIAlertView alloc] initWithTitle:@"Internet connection appears to be offline." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [connAlert show];
        return;
    }
    
    //If FBSession is open then performing login
    if (FBSession.activeSession.isOpen)
    {
        // login is integrated with the send button -- so if open, we send
        [self getUserDataPerformLogin:YES];
    }
    //Else session is closed then creating a session
    else
    {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_actions",
                                @"email",@"user_about_me",
                                nil];
        //Opening the connection with permission
        [FBSession openActiveSessionWithPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
        {
            // if login fails for any reason, we alert
            if (error)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Facebook connection aborted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                // if otherwise we check to see if the session is open, an alternative to
                // to the FB_ISSESSIONOPENWITHSTATE helper-macro would be to check the isOpen
                // property of the session object; the macros are useful, however, for more
                // detailed state checking for FBSession objects
            }
            else if (FB_ISSESSIONOPENWITHSTATE(status))
            {
                // send our requests if we successfully logged in
                [self getUserDataPerformLogin:YES];
            }
        }];
    }
}

- (void) getUserDataPerformLogin:(BOOL)pBool
{
    //Showing HUD
    [[ProgressHudPresenter sharedHUD] presentHud];
    [[ProgressHudPresenter sharedHUD] setTitle:@"Gathering Facebook Info"];
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id<FBGraphUser> user, NSError *error)
     {
        if (!error)
        {
            NSMutableDictionary *fbDic = [[NSMutableDictionary alloc] init];
            
            NSArray *ary = [[user objectForKey:@"first_name"] componentsSeparatedByString:@" "];
            
            [fbDic setObject:[ary firstObject] forKey:@"name"];
            [fbDic setObject:[user objectForKey:@"last_name"] forKey:@"last_name"];
            [fbDic setObject:[user objectForKey:@"email"] forKey:@"loginid"];
            [fbDic setObject:user.id forKey:@"fb_id"];
            [fbDic setObject:[user objectForKey:@"gender"] forKey:@"fbgender"];
            
            [[ProgressHudPresenter sharedHUD] setTitle:@"Signing In using Facebook..."];

            [[CoupitService service] fbLoginUser:fbDic completionHandler:^(NSDictionary *result, NSError *error)
             {
                [[ProgressHudPresenter sharedHUD] hideHud];
                
                if (error)
                {
                    [[[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                    
                    // Tag Web Service Error On Localytics
                    
                    [[LocalyticsSession shared] tagEvent:kErrorSummary attributes:@{kError:[error localizedDescription]}];
                    
                    //////////////////////////////////////
                }
                else
                {
                     if ([[[result objectForKey:@"response"] lowercaseString] isEqualToString:@"success"])
                    {
                        
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:[user objectForKey:@"email"] forKey:kUsernameKey];
                        [defaults removeObjectForKey:kPasswordKey];
                        [defaults setObject:[user objectForKey:@"first_name"] forKey:@"firstName"];
                        [defaults setObject:[user objectForKey:@"last_name"] forKey:@"lastName"];
                        [defaults setObject:[user objectForKey:@"gender"] forKey:@"fbGender"];
                        [defaults setObject:[user objectForKey:@"email"] forKey:@"loginidkey"];
                        
                        [defaults synchronize];
                        
                        NSString *idstring = [[result valueForKey:@"data"] valueForKey:@"id"];
                        
                        //If SignIn
                        if ([idstring length])
                        {
                            [defaults setObject:idstring forKey:@"logidkey"];
                            //[defaults setObject:@"155" forKey:@"logidkey"];
                            [defaults synchronize];
                            
                            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                            [appDelegate loginViewController:nil loginStatus:YES];
                        }
                        //If SignUp
                        else
                        {
                            
                            // Tag Registration Start Event Localytics
                            
                                [self tagRegistrationStartEventInLocalytics];
                            
                            ///////////////////////////////////////////
                            
                            [self increaseRegistrationAttemptCount];
                            
                            // Send Localytics Attributes
                            
                            NSTimeInterval interval=[[NSDate date] timeIntervalSinceDate:dateBeforeSignUp];
                            NSString *timeSpent=[NSString stringWithFormat:@"%f",interval];
                            NSString *registrationAttemptCount=[self getRegistrationAttemptCount];
                            [[LocalyticsSession shared] tagEvent:kRegistrationComplete attributes:@{ kLoadTime : timeSpent, kAttempt :  registrationAttemptCount}];
                            
                            /////////////////////////////
                            
                        UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Success!" message:[result objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            alt.tag=456;
                            [alt show];
                        }
                    }
                    else if ([[[result objectForKey:@"response"] lowercaseString] isEqualToString:@"failure"])
                    {
                        [[[UIAlertView alloc] initWithTitle:@"Error" message:[result objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                    }
                    else
                    {
                        UIAlertView *fAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Unknown error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [fAlert show];
                    }
                }
            }];
        }
        else
        {
            //Hiding HUD, showing alert.
            [[ProgressHudPresenter sharedHUD] hideHud];
            [[[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }];
}

#pragma mark - Privacy Policy and Terms & Conditions

- (IBAction)privacyPolicyAction:(UIButton *)sender
{
    CouwallaHelpViewController *tCouwallaHelpViewController = [[CouwallaHelpViewController alloc] initWithNibName:@"CouwallaHelpViewController" bundle:nil];
    tCouwallaHelpViewController.mCouwallaHelpType = kPrivacyPolicyHelp;
    [self.navigationController pushViewController:tCouwallaHelpViewController animated:YES];
}

- (IBAction)termsAndConditionsAction:(UIButton *)sender
{
    CouwallaHelpViewController *tCouwallaHelpViewController = [[CouwallaHelpViewController alloc] initWithNibName:@"CouwallaHelpViewController" bundle:nil];
    tCouwallaHelpViewController.mCouwallaHelpType = kTermsOFServiceHelp;
    [self.navigationController pushViewController:tCouwallaHelpViewController animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(_isSignUp && textFieldEMail.text.length==0 && textFieldConfirmEMail.text.length==0 && genderTextfd.text.length==0)
    {
        dateBeforeSignUp=[NSDate date];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    IQDropDownTextField *dropTextField = ([textField isKindOfClass:[IQDropDownTextField class]])?(IQDropDownTextField*)textField:nil;
    if (dropTextField.selectedItem == nil)
    {
        dropTextField.selectedItem = [dropTextField.itemList firstObject];
    }
    if (!_isSignUp)
    {
        [self performSelector:@selector(signUpSignInAction:) withObject:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==123)
    {
        _isSignUp=!_isSignUp;
        [self performSelector:@selector(signUpSignInAction:) withObject:nil];
    }
    if(alertView.tag==456)
    {
        [self getUserDataPerformLogin:YES];
    }
}

#pragma mark - Localytics Module Methods

-(void)increaseLoginAttemptCount
{
    NSNumber *loginAttemptCount=[[NSUserDefaults standardUserDefaults] objectForKey:@"Login_Attempt"];
    int loginCount=[loginAttemptCount intValue];
    loginCount++;
    [[NSUserDefaults standardUserDefaults] setObject:@(loginCount) forKey:@"Login_Attempt"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)getLoginAttemptCount
{
    NSNumber *loginAttemptCount=[[NSUserDefaults standardUserDefaults] objectForKey:@"Login_Attempt"];
    NSString *loginAttempt=[NSString stringWithFormat:@"%d",[loginAttemptCount intValue]];
    return loginAttempt;
}

-(void)increaseRegistrationAttemptCount
{
    NSNumber *registrationAttemptCount=[[NSUserDefaults standardUserDefaults] objectForKey:@"Registration_Attempt"];
    int registrationCount=[registrationAttemptCount intValue];
    registrationCount++;
    [[NSUserDefaults standardUserDefaults] setObject:@(registrationCount) forKey:@"Registration_Attempt"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)getRegistrationAttemptCount
{
    NSNumber *registrationAttemptCount=[[NSUserDefaults standardUserDefaults] objectForKey:@"Registration_Attempt"];
    NSString *registrationAttempt=[NSString stringWithFormat:@"%d",[registrationAttemptCount intValue]];
    return registrationAttempt;
}

-(void)clearTextFromAllTextFields
{
    [textFieldEMail setText:@""];
    [textFieldConfirmEMail setText:@""];
    [genderTextfd setText:@""];
}

-(void)tagRegistrationStartEventInLocalytics
{
    NSDateFormatter *dateFormatter=[self getDateFormatter];
    NSString *registrationStartTime=[dateFormatter stringFromDate:dateBeforeSignUp];
    [[LocalyticsSession shared] tagEvent:kRegistrationStart attributes:@{ kTime : registrationStartTime}];
}

-(NSDateFormatter *)getDateFormatter
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return dateFormatter;
}


@end
