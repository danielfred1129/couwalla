//
//  LoginViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

//ViewControllers
#import "LoginViewController.h"
#import "SignUpViewController.h"

//App Delegate
#import "AppDelegate.h"

//Web-Service
#import "RequestHandler.h"

//Core Data
#import "Groups.h"
#import "Brands.h"
#import "Category.h"
#import "Subscriber.h"
#import "User.h"

//Other
#import "jsonparse.h"
#import "appcommon.h"

@interface LoginViewController ()

- (IBAction) signinButton:(id)sender;
- (IBAction) signupButton:(id)sender;
- (IBAction) forgotPassword:(id)sender;
- (IBAction) facebookButton:(id)sender;

@end

@implementation LoginViewController
{
    //TableView to show the UI for login/signup screen.
    IBOutlet UITableView *mTableView;
    
    //TextFields for getting username & password input.
    UITextField *mUserNameTextField, *mPasswordTextField;
    
    NSString *textUsername, *textPassword;
    
    //Storing signup type
    SignUpType mSignUpType;
    
    //Storing Signup user.
    User *mSignUpUser;
    
    GREST *api;
}

@synthesize mDelegate, mIsLogOut, mIsPasswordChange;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    //Initialization
    {
        mSignUpType = kNormalLogin;
        mSignUpUser = [User new];

        api = [[GREST alloc] init];
        [api setDelegate:self];
    }
    
    //navigationBar title
    {
        UIImage *image = [UIImage imageNamed: @"CouwallaLogo"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(0, 0, 110, 35);
        
        self.navigationItem.titleView = imageView;
    }
    
    //fetching previous username & passwords
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *savedUsername = [prefs stringForKey:kUsernameKey];
        NSString *savedPassword = [prefs stringForKey:kPasswordKey];
        
        //Autologin
        {
            if (savedUsername && savedPassword != nil)
            {
                [[ProgressHudPresenter sharedHUD] presentHud];
                textUsername = savedUsername;
                textPassword = savedPassword;
                [self performSelector:@selector(signdata) withObject:nil afterDelay:.5];
                [[ProgressHudPresenter sharedHUD] setTitle:@"Signing In..."];
            }
        }
    }

//    [[self navigationController] setNavigationBarHidden:NO animated:YES];
//    self.navigationItem.hidesBackButton = YES;
//    [self.navigationController.navigationBar.backItem setHidesBackButton:YES animated:YES];
}

//Getting other data after login
- (void) initCommonNetworkRequest
{
    //Getting device token
    NSString *tDeviceToken = [[DataManager getInstance] mDeviceToken];
    
    //Registering device token on server. No need to show activity view for this.
    if (tDeviceToken)
    {
        NSString *tPostBody = [NSString stringWithFormat:@"%@", tDeviceToken];
        [[RequestHandler getInstance] postRequestwithHostURL:kRegisterDeviceTokenURL bodyPost:tPostBody delegate:self requestType:kRegisterDeviceTokenRequest];
    }
    
    //Getting all categories
    if (![[Repository sharedRepository] isAllCategoriesLoaded])
    {
        //Updating progress title & requesting for categories
        [[ProgressHudPresenter sharedHUD] setTitle:@"Getting Categories..."];
        [[RequestHandler getInstance] getRequestURL:kURL_Categories delegate:self requestType:kCategoriesRequest];
    }
    else
    {
        //Updating progress title & requesting for adverts
        [[ProgressHudPresenter sharedHUD] setTitle:@"Getting Adverts..."];
        [[RequestHandler getInstance] getRequestURL:kGetAdvertsURL delegate:self requestType:kAdvertsRequest];
    }
    
    //Getting location and requesting for location update
    {
        CLLocation *tCurrentLocation = [[Location getInstance] getCurrentLocation];
        NSString *tSubscriberLocation = [kURL_SubscriberLocation stringByAppendingFormat:@"?lat=%f&lng=%f",tCurrentLocation.coordinate.latitude,tCurrentLocation.coordinate.longitude];
        
        [[RequestHandler getInstance] getRequestURL:tSubscriberLocation delegate:self requestType:kSubscriberLocationUpdate];
    }
    
    //Requesting for global settings
    [[RequestHandler getInstance] getRequestURL:kURL_GlobalSetting delegate:self requestType:kGlobalSettingRequest];
}


#pragma mark -
#pragma mark Request Handler
//It always be called on main thread. For more see RequestHandler.m Line 843-848.
- (void) requestHandler:(RequestHandler *)pRequestHandler withRequestType:(RequestType)pRequestType error:(APIError *)pError
{
    //Global setting response from 'initCommonNetworkRequest' method.
    if (pRequestType == kGlobalSettingRequest)
    {
        if (pError)
        {
//            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Server Error" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [tAlert show];
        }
    }
    //Location update response from 'initCommonNetworkRequest' method.
    else if (pRequestType == kSubscriberLocationUpdate)
    {
        if (pError)
        {
//            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Server Error" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [tAlert show];
        }
    }
    //Unused
    else if (pRequestType == kCouponGroupsRequest)
    {
        if (!pError)
        {
            if (![[Repository sharedRepository] isAllCategoriesLoaded])
            {
                [[ProgressHudPresenter sharedHUD] setTitle:@"Getting Categories..."];
                [[RequestHandler getInstance] getRequestURL:kURL_Categories delegate:self requestType:kCategoriesRequest];
            }
            else
            {
                [[ProgressHudPresenter sharedHUD] setTitle:@"Getting Adverts..."];
                [[RequestHandler getInstance] getRequestURL:kGetAdvertsURL delegate:self requestType:kAdvertsRequest];
            }
        }
        else
        {
            [[ProgressHudPresenter sharedHUD] hideHud];
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Server Error" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
        }
    }
    //Adverts response from 'initCommonNetworkRequest' method or after the Categories respose in 'requestHandler:withRequestType:error:' method.
    else if (pRequestType == kAdvertsRequest)
    {
        //Hide hud
        [[ProgressHudPresenter sharedHUD] hideHud];
        
        if (!pError)
        {
            //Push to next screen.
            [mDelegate loginViewController:self loginStatus:YES];
        }
        else
        {
//            [[[UIAlertView alloc] initWithTitle:@"Message" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }
    else if (pRequestType == kLoginRequest)
    {
        if (!pError)
        {
            //If found username & password both, then storing to user defaults.
            if ([mUserNameTextField.text length] > 0 && [mPasswordTextField.text length] > 0)
            {
                [[NSUserDefaults standardUserDefaults] setObject:mUserNameTextField.text forKey:kUsernameKey];
                [[NSUserDefaults standardUserDefaults] setObject:mPasswordTextField.text forKey:kPasswordKey];
            }
            
            //If pasword change
            if (mIsPasswordChange)
            {
                //Hide hud
                [[ProgressHudPresenter sharedHUD] hideHud];
                
                //push to next screen.
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate loginViewController:nil loginStatus:YES];
                
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            }
            
            //If logout
            if (mIsLogOut)
            {
                //Hide hud
                [[ProgressHudPresenter sharedHUD] hideHud];
                [self dismissViewControllerAnimated:YES completion:^{
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    [appDelegate makeSubscriberGetRequestByName];
                }];
                
                RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
                if (![revealController.frontViewController isKindOfClass:[UINavigationController class]] && ! [((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[CouponsViewController class]])
                {
                    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:[[CouponsViewController alloc]initWithNibName:@"CouponsViewController" bundle:nil]];
                    [revealController setFrontViewController:navigationController animated:NO];
                }
            }
            else
            {
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate makeSubscriberGetRequestByName];
                
                //Getting categories, adverts, global settings, location updates.
                [self initCommonNetworkRequest];
            }
        }
        //If error
        else
        {
            if ([pError.mErrorCode integerValue] == 4102)
            {
                //Try using facebook
                if (mSignUpType == kFacebookSignUp)
                {
                    [self getUserDataPerformLogin:NO];
                }
                //Login failed message
                else if (mSignUpType != (kFacebookSignUp))
                {
                    //Hide hud
                    [[ProgressHudPresenter sharedHUD] hideHud];
                    
                    UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Login Failure" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [tAlert show];
                }
            }
            //Login failed message
            else
            {
                //Hide hud
                [[ProgressHudPresenter sharedHUD] hideHud];
                
                UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Login Failure" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [tAlert show];
            }
        }
    }
    else if (pRequestType == kForgotPasswordRequest)
    {
        //Hide hud
        [[ProgressHudPresenter sharedHUD] hideHud];
        
        //Saving username & passwords
        if (!pError)
        {
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:kPasswordResetMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
            
            // TODO: Clear Password from NSUserDefaults
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUsernameKey];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPasswordKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        //error message
        else
        {
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Server Error" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
        }
    }
    //Categories response
    else if (pRequestType == kCategoriesRequest)
    {
        if (!pError)
        {
            //Updating hud title
            [[ProgressHudPresenter sharedHUD] setTitle:@"Getting Adverts..."];
            
            //Requesting adverts
            [[RequestHandler getInstance] getRequestURL:kGetAdvertsURL delegate:self requestType:kAdvertsRequest];
        }
        else
        {
            //Hiding hud. Showing error message.
            [[ProgressHudPresenter sharedHUD] hideHud];
            [[[UIAlertView alloc] initWithTitle:@"Message" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            NSLog(@"Request Failed:%d | Code:%d | Message:%@",pRequestType, pError.mErrorCode.intValue, pError.mMessage);
        }
    }
}

//Native SignIn
- (IBAction) signinButton:(id)sender;
{
    //Showing alert if not haivng enough info
    if ([mUserNameTextField.text length] == 0 || [mPasswordTextField.text length] == 0)
    {
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Information required is missing" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlert show];
        return;
    }

    //Updating signup type
    mSignUpType = kNormalLogin;
    
    //Resigning textFields
    [mUserNameTextField resignFirstResponder];
    [mPasswordTextField resignFirstResponder];
    
    textUsername = mUserNameTextField.text;
    textPassword = mPasswordTextField.text;
    
    [[ProgressHudPresenter sharedHUD] presentHud];
    [[ProgressHudPresenter sharedHUD] setTitle:@"Signing In..."];
    
    [self performSelector:@selector(signdata) withObject:nil afterDelay:0.1];
}

-(void)signdata
{
    NSMutableDictionary *myDic = [NSMutableDictionary dictionaryWithCapacity:7];

    [myDic setValue:[mUserNameTextField text] forKey:@"loginid"];
    [myDic setValue:[mPasswordTextField text] forKey:@"password"];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/signin.php?",BASE_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:100.0];
    NSError *error;
    [request setTimeoutInterval:100.0];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"data\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *paramsJSONDictionaryData = [NSJSONSerialization dataWithJSONObject:myDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonParamsString = [[NSString alloc] initWithData:paramsJSONDictionaryData encoding:NSUTF8StringEncoding];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",jsonParamsString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *jsonResponseDictionary = [NSJSONSerialization JSONObjectWithData:responseData
                                                                           options:kNilOptions
                                                                             error:&error];
    NSLog(@"jsonResponseDictionary=\n%@",jsonResponseDictionary);

    NSString *responseText = [jsonResponseDictionary valueForKey:@"response"];

    [[ProgressHudPresenter sharedHUD] hideHud];

    if ([responseText isEqualToString:@"Success"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        [defaults setObject:[mUserNameTextField text] forKey:kUsernameKey];
        [defaults setObject:[mPasswordTextField text] forKey:kPasswordKey];

        NSString *idstring = [[jsonResponseDictionary valueForKey:@"data"] valueForKey:@"id"];
        [defaults setObject:idstring forKey:@"logidkey"];
        //[defaults setObject:@"155" forKey:@"logidkey"];
        [defaults setObject:mUserNameTextField.text forKey:@"loginidkey"];
        [defaults synchronize];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loginViewController:nil loginStatus:YES];
    }
    else
    {
        UIAlertView *fAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Check Your Login Credentials" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [fAlert show];
        return;
    }

    [mUserNameTextField resignFirstResponder];
    [mPasswordTextField resignFirstResponder];
}

//Login for native/facebook/gmail
- (void) performLoginForUser:(NSString *)pUserName password:(NSString *)pPassword loginType:(NSString *)pLoginType deviceType:(NSString *)pDeviceType
{
    SubscriberCredentials *tSubscriberCredentials = [[SubscriberCredentials alloc]init];
    [tSubscriberCredentials setMUserName:pUserName];
    [tSubscriberCredentials setMPassword:pPassword];
    //    [tSubscriberCredentials setMDeviceType:pDeviceType];
    //    [tSubscriberCredentials setMLoginMethod:pLoginType];
    
    //Showing hud and updating title
    [[ProgressHudPresenter sharedHUD] presentHud];
    [[ProgressHudPresenter sharedHUD] setTitle:@"Signing In..."];


    NSString *urlString = [NSString stringWithFormat:@"%@/google_login.php?",BASE_URL];
    
    [[RequestHandler getInstance] postRequestwithHostURL:urlString bodyPost:[tSubscriberCredentials pToJSONString] delegate:self requestType:kLoginRequest];

//    //requesting login
//    [[RequestHandler getInstance] postRequestwithHostURL:KURL_LoginRequestQuery bodyPost:[tSubscriberCredentials pToJSONString] delegate:self requestType:kLoginRequest];
}

- (IBAction) signupButton:(id)sender
{
    //Push to signup
    SignUpViewController *tSignUpViewController = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
    [tSignUpViewController setUser:nil];
    [self.navigationController pushViewController:tSignUpViewController animated:YES];
}

//Forgot password
- (IBAction) forgotPassword:(id)sender
{
    //Showing alert to get username
    UIAlertView *tForgotPassowrdAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Enter User Name :" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    [tForgotPassowrdAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    tForgotPassowrdAlert.tag = 1;
    [tForgotPassowrdAlert show];
    return;
}

//AlertView delegate for Forgot password functionality
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        NSString *tTitle = [alertView buttonTitleAtIndex:buttonIndex];
        if([tTitle isEqualToString:@"OK"])
        {
            UITextField *tUsernameTextField = [alertView textFieldAtIndex:0];
            
            //Showing alert if missing information
            if ([tUsernameTextField.text length] == 0)
            {
                UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Information required is missing" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [tAlert show];
            }
            else
            {
                //Showing hud
                [[ProgressHudPresenter sharedHUD] presentHud];
                [[ProgressHudPresenter sharedHUD] setTitle:NSLocalizedString(@"Loading", @"Loading")];
                
                //Creating subscriber object
                SubscriberCredentials *tSubscriberCredentials = [[SubscriberCredentials alloc]init];
                tSubscriberCredentials.mUserName = tUsernameTextField.text;
                
                //Requesting forgot password
                [[RequestHandler getInstance] postRequestwithHostURL:KURL_ForgotPasswordRequestQuery bodyPost:[tSubscriberCredentials pToJSONString] delegate:self requestType:kForgotPasswordRequest];
            }
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //Switch to password textField
    if (textField == mUserNameTextField) {
        [mPasswordTextField becomeFirstResponder];
    }
    //Resign password textField
    else if (textField == mPasswordTextField) {
        [mPasswordTextField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField == mPasswordTextField) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 4) ? NO : YES;
    }
    
    return YES;
    
}

#pragma mark - GREST Methods

- (void)request_finished:(NSString *)response for_key:(NSString *)request_key
{
    if([request_key isEqualToString:@"resetPW"]) {
        
        [[ProgressHudPresenter sharedHUD] hideHud];
        
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:kPasswordResetMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlert show];
        
        // TODO: Clear Password from NSUserDefaults
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUsernameKey];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPasswordKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    
}

- (void)request_failed:(NSError *)error for_key:(NSString *)request_key {
    
    [[ProgressHudPresenter sharedHUD] hideHud];
    
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Creating cell
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    //Getting username & passwords
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *savedUsername = [prefs stringForKey:kUsernameKey];
    NSString *savedPassword = [prefs stringForKey:kPasswordKey];

    // Configure the cell...
    if (indexPath.row == 0)
    {
        //Creating Username textField
        if (mUserNameTextField == nil)
        {
            mUserNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, 300, 30)];
            mUserNameTextField.delegate = self;
            
            //If both are present only then we are setting the username
            if (savedUsername && savedPassword)
                mUserNameTextField.text = savedUsername;
            
            [mUserNameTextField setBorderStyle:UITextBorderStyleNone];
            mUserNameTextField.font = [UIFont systemFontOfSize:14.0];
            mUserNameTextField.keyboardType = UIKeyboardTypeDefault;
            mUserNameTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
            mUserNameTextField.returnKeyType = UIReturnKeyNext;
            mUserNameTextField.placeholder = @"Email";
            mUserNameTextField.textAlignment = NSTextAlignmentLeft;
            mUserNameTextField.textColor = [UIColor colorWithRed:(72/255.0) green:(72/255.0) blue:(72/255.0) alpha:1.0];
            mUserNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            mUserNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            mUserNameTextField.tag = indexPath.row;
            mUserNameTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
            [cell.contentView addSubview:mUserNameTextField];
        }
    }
    else if (indexPath.row == 1)
    {
        //Creating password textField
        if (mPasswordTextField == nil)
        {
            mPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, 300, 30)];
            
            //If both are present only then we are setting the password field
            if (savedUsername && savedPassword)
                mPasswordTextField.text = savedPassword;
            
            mPasswordTextField.delegate = self;
            mPasswordTextField.secureTextEntry = YES;
            mPasswordTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
            [mPasswordTextField setBorderStyle:UITextBorderStyleNone];
            mPasswordTextField.font = [UIFont systemFontOfSize:14.0];
            mPasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
            mPasswordTextField.returnKeyType = UIReturnKeyGo;
            mPasswordTextField.placeholder = @"Enter PIN";
            mPasswordTextField.textAlignment = NSTextAlignmentLeft;
            mPasswordTextField.textColor = [UIColor colorWithRed:(72/255.0) green:(72/255.0) blue:(72/255.0) alpha:1.0];
            mPasswordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            mPasswordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            mPasswordTextField.tag = indexPath.row;
            mPasswordTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
            
            [cell.contentView addSubview:mPasswordTextField];
            
            //[mPasswordTextField becomeFirstResponder];
        }
    }
    
    return cell;
}

- (IBAction) facebookButton:(id)sender
{
    //Check for internet connection
    if (![[RequestHandler getInstance] checkInternet])
    {
        UIAlertView *connAlert = [[UIAlertView alloc] initWithTitle:@"Internet connection appears to be offline." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [connAlert show];
        return;
    }
    
    //Updating signup type
    mSignUpType = kFacebookSignUp;
    
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
                                @"email",
                                nil];
        //Opening the connection with permission
        [FBSession openActiveSessionWithPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
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
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id<FBGraphUser> user, NSError *error) {
         if (!error)
         {
             NSMutableDictionary *fbDic = [NSMutableDictionary dictionary];
             [fbDic setObject:user.name forKey:@"name"];
             [fbDic setObject:[user objectForKey:@"email"] forKey:@"loginid"];
             [fbDic setObject:user.id forKey:@"fb_id"];
             [fbDic setObject:[user objectForKey:@"gender"] forKey:@"fbgender"];
             NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/fb_login.php?",BASE_URL];
             
             jsonparse *objJsonparse =[[jsonparse alloc]init];
             NSDictionary *reponseData = [objJsonparse customejsonParsing:urlString bodydata:fbDic];

             NSString *response =[reponseData valueForKey:@"response"];
             
             //Hiding hud
             [[ProgressHudPresenter sharedHUD] hideHud];
             
             //If success
             if ([response isEqualToString:@"Success"])
             {
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 [defaults setObject:[user objectForKey:@"email"] forKey:kUsernameKey];
                 [defaults removeObjectForKey:kPasswordKey];
                 [defaults setObject:[user objectForKey:@"email"] forKey:@"loginidkey"];
                 [defaults synchronize];

                 NSString *idstring = [[reponseData valueForKey:@"data"] valueForKey:@"id"];

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
                     jsonparse *objJsonparse =[[jsonparse alloc] init];
                     NSDictionary *reponseData = [objJsonparse customejsonParsing:urlString bodydata:fbDic];
                     
                     response =[reponseData valueForKey:@"response"];
                     idstring = [[reponseData valueForKey:@"data"] valueForKey:@"id"];
                     
                     if ([response isEqualToString:@"Success"])
                     {
                         [defaults setObject:idstring forKey:@"logidkey"];
                         //[defaults setObject:@"155" forKey:@"logidkey"];
                         [defaults synchronize];

                         AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                         [appDelegate loginViewController:nil loginStatus:YES];
                     }
                 }
             }
             else
             {
                 mSignUpUser.mPassword = user.id;
                 mSignUpUser.mUserName = user.name;
                 mSignUpUser.mEmailID = [user objectForKey:@"email"];

                 SignUpViewController *tSignUpViewController = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
                 [self.navigationController pushViewController:tSignUpViewController animated:YES];
                 [tSignUpViewController setUser:mSignUpUser];
             }
         }
         else
         {
             //Hiding HUD, showing alert.
             [[ProgressHudPresenter sharedHUD] hideHud];
             [[[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
         }
     }];
}

@end

