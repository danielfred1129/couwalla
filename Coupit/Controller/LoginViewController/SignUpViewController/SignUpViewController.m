//
//  SignUpViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SignUpViewController.h"
#import "ProfileItem.h"
#import "SubscriberCredentials.h"
#import "SubscriberProfile.h"
#import "CouponCategoriesViewController.h"
#import "WebViewController.h"
#import "IQDropDownTextField.h"
#import "NSString+Validation.h"
#define kSection0 @"Login Credential"
#define kSection1 @"Personal Details"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kLatestKivaLoansURL [NSURL URLWithString:@"http://api.kivaws.org/v1/loans/search.json?status=fundraising"]


@implementation SignUpViewController
{
    NSMutableDictionary *mItemArrayDictionary;
    UITextField *mUserNameTextField, *mPasswordTextField, *mRePasswordTextField, *mNameTextField, *mLastNameTextField, *mAgeTextField, *mZipTextField, *mEmailTextField, *mCountryTextField, *mEthnicityTextField, *mDobTextField;
    
    IQDropDownTextField *mGenderTextField;
    
    ProgressHudPresenter *mHudPresenter;
    User *mSignUser;
    NSMutableArray *mCountryNameArray;
    NSMutableArray *mCountryCodeArray;
    NSMutableArray *mEthnicityArray;
    NSMutableArray *mCouponPrefencesArray;
    
    NSString *mCouponPrefrences;
    NSString *mCountryName;
    NSString *mEthnicityValue;
    NSString *mDateOfBirthString;
    BOOL mIsDateOfBirth;
    NSUInteger mPickerValueIndex;



}
@synthesize mPickerOverlayView, mPickerView, mPickerSelected, mDatePickerView, mDatePickerOverlayView,privicyCheckeButton;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.


-(IBAction)PrivacyChanged:(id)sender
{
    
    
    if(![sender isSelected])
    {
        [privicyCheckeButton setSelected:YES];
        [privicyCheckeButton setImage:[UIImage imageNamed:@"checkbox_ticked.png"] forState:UIControlStateNormal];
       
    }
    else
    {
        [privicyCheckeButton setSelected:NO];
        [privicyCheckeButton setImage:[UIImage imageNamed:@"checkbox_not_ticked.png"] forState:UIControlStateNormal];
       
        
    }

}
-(IBAction)termsAndPolicy:(id)sender
{
    
    
    if(![sender isSelected])
    {
        [_termsandConditionsButton setSelected:YES];
        [_termsandConditionsButton setImage:[UIImage imageNamed:@"checkbox_ticked.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        [_termsandConditionsButton setSelected:NO];
        [_termsandConditionsButton setImage:[UIImage imageNamed:@"checkbox_not_ticked.png"] forState:UIControlStateNormal];
        
        
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setObject:@"checkboxNotticked" forKey:@"notTicked"];
    
    mHudPresenter = [ProgressHudPresenter new];
    mCountryNameArray = [NSMutableArray new];
    mCountryCodeArray = [NSMutableArray new];
    mEthnicityArray   = [NSMutableArray new];
    
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]]];
    
    //Back Button
    UIButton *tBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tBackButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tBackButton sizeToFit];
    [tBackButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tBackBarButton = [[UIBarButtonItem alloc]initWithCustomView:tBackButton];
    self.navigationItem.leftBarButtonItem = tBackBarButton;
    self.navigationItem.title = @"Sign Up";
    
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *plistPath = [bundlePath stringByAppendingPathComponent:@"CountryList.plist"];
    NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    mCountryNameArray = [plistData objectForKey:@"CountryName"];
    mCountryCodeArray = [plistData objectForKey:@"CountryCode"];
    mEthnicityArray     = [plistData objectForKey:@"Ethnicity"];
    
    privicyCheckeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    privicyCheckeButton.frame = CGRectMake(15,57,20,20);
    [privicyCheckeButton setBackgroundImage:[UIImage imageNamed:@"checkbox_not_ticked.png"] forState:UIControlStateNormal];
    
    [privicyCheckeButton addTarget:self action:@selector(PrivacyChanged:) forControlEvents:UIControlEventTouchUpInside];
    [privicyCheckeButton setSelected:NO];
    //[_SubmitView addSubview:privicyCheckeButton];
    
//    _termsandConditionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _termsandConditionsButton.frame = CGRectMake(10,88,22,22);
//    [_termsandConditionsButton setBackgroundImage:[UIImage imageNamed:@"checkbox_not_ticked.png"] forState:UIControlStateNormal];
//
    //  04-10
    
    [_termsandConditionsButton addTarget:self action:@selector(termsAndPolicy:) forControlEvents:UIControlEventTouchUpInside];
//    [_termsandConditionsButton setSelected:NO];

    [_SubmitView addSubview:_termsandConditionsButton];
    
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        kLatestKivaLoansURL];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
    
}

- (void) setUser:(User *)pUser
{
    if (pUser) {
        mSignUser = pUser;
        /*
        mUserNameTextField.text = [pUser objectForKey:@"email"];
        mPasswordTextField.text = pUser.id;
        mRePasswordTextField.text = pUser.id;
        
        mNameTextField.text = pUser.name;
        mEmailTextField.text = [pUser objectForKey:@"email"];
        */
        [self.tableView reloadData];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    mCouponPrefencesArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"CouponPrefences"]];
    [self.tableView reloadData];
}

- (BOOL) characterValidation:(NSString *)pTextFieldValue characterSet:(NSCharacterSet *)pCharSet {
    BOOL rIsVaild;
    NSRange location = [pTextFieldValue rangeOfCharacterFromSet:pCharSet];
    if (location.location != NSNotFound) {
        rIsVaild = false;
    } else {
        rIsVaild = true;
    }
    return rIsVaild;
}

-(IBAction)submitButton:(id)sender
{
    if ([mPasswordTextField.text length] == 0){
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:kPassWordEmptyMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlert show];
        return;
        
    } else if ( [mGenderTextField.text length] == 0 ){
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:kAgeFieldMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlert show];
        return;
        
    } else if ([mEmailTextField.text length] == 0) {
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:kEmailFieldMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlert show];
        return;
    
    } else {
        if ([mEmailTextField.text isValidEmail] == NO) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please Enter Valid Email Address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }

    [mEmailTextField resignFirstResponder];
    [mPasswordTextField resignFirstResponder];
    
    Subscriber *tSubscriber = [[Subscriber alloc] init];
    SubscriberProfile *tSubscriberProfile = [[SubscriberProfile alloc] init];

    [tSubscriber setMFirstName:@""];
    [tSubscriber setMLastName:@""];
    if ([mGenderTextField.text isEqualToString:@"Male"]) {
        [tSubscriberProfile setMSex:[NSNumber numberWithInteger:0]];
    } else {
        [tSubscriberProfile setMSex:[NSNumber numberWithInteger:1]];
    }
    [tSubscriberProfile setMEthnicity:@""];
    [tSubscriber setMZip:@""];
    [tSubscriber setMEmail:mEmailTextField.text];
    [tSubscriber setMState:@""];
    
    SubscriberCredentials *tSubscriberCredentials = [[SubscriberCredentials alloc] init];
    [tSubscriberCredentials setMUserName:mEmailTextField.text];
    [tSubscriberCredentials setMPassword:mPasswordTextField.text];
    
    [tSubscriber setMProfile:tSubscriberProfile];
    [tSubscriber setMCredentials:tSubscriberCredentials];
    
    NSMutableString *tDateOfBirth = [NSMutableString stringWithString:@""];
    [tDateOfBirth appendString: @"T00:00:00+0000"];
    [tSubscriberProfile setMDOB:tDateOfBirth];


    CouponPrefrences *tCouponPrefrences = [[CouponPrefrences alloc]init];
    [tSubscriber setMCouponPrefrences:tCouponPrefrences];
    [tSubscriber setMCouponPreferencesArray:mCouponPrefencesArray];
    
    //NSLog(@"Subscriber Sign-up Details in JSON: %@", [tSubscriber pToJSONString]);
    
    [[NSUserDefaults standardUserDefaults] setObject:[tSubscriber pToJSONString] forKey:@"subscriber"];
    
    //NSLog(@"Before API Call | Subscriber in Nsuserdefault .......%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"subscriber"]);
    
    [mHudPresenter presentHud];

//***
    
    NSMutableDictionary *myDic = [NSMutableDictionary dictionaryWithCapacity:7];
    
    [myDic setValue:@""      forKey:@"firstname"];
    [myDic setValue:[mPasswordTextField text]  forKey:@"password"];
    [myDic setValue:[mGenderTextField text]    forKey:@"gender"];
    [myDic setValue:[mEmailTextField text] forKey:@"email"];
    
  //  NSMutableDictionary *myDic = [NSMutableDictionary dictionary];
    //NSLocale *currentLocale = [NSLocale currentLocale];
    //NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    
    //[myDic setValue:countryCode forKey:@"location"];
    
    // http://api.couwallabi.com/api/signup.php?data=

    NSString *urlString = [NSString stringWithFormat:@"%@/signup.php?",BASE_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:100.0];
    NSError *error;
    [request setTimeoutInterval:100.0];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    //NSLog(@"request  %@", request);
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"data\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *paramsJSONDictionaryData = [NSJSONSerialization dataWithJSONObject:myDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonParamsString = [[NSString alloc] initWithData:paramsJSONDictionaryData encoding:NSUTF8StringEncoding];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",jsonParamsString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    //NSLog(@"body  %@", body);
    //NSLog(@"request  %@", request);
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *jsonResponseDictionary = [NSJSONSerialization JSONObjectWithData:responseData
                                                                           options:kNilOptions
                                                                             error:&error];
    
    NSString *serJSON = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"responseData  %@", serJSON);
    
    //NSLog(@"jsonResponseDictionary=%@",jsonResponseDictionary);
    
    NSMutableString *itemsArray = [[NSMutableString alloc]init];
    itemsArray =[jsonResponseDictionary valueForKey:@"response"];
    //NSLog(@"itemsArray  %@", itemsArray);
    if ([itemsArray  isEqual:@"Success"]) {
        //NSLog(@"Saving to defaults");
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:@"false" forKey:@"r"];
//        [defaults synchronize];
    }

//{"response":"Success"

    
    [[RequestHandler getInstance] postRequestwithHostURL:urlString bodyPost:nil delegate:self requestType:kCreateSubscriberPostRequest];

//data={"firstname","lastname","password","loginid","gender":"Male","dob":"5-11-1987","ethenticity"}
    
    
   
}


- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
//    NSError* error;
//    NSDictionary* json = [NSJSONSerialization
//                          JSONObjectWithData:responseData
//                          
//                          options:kNilOptions
//                          error:&error];
//    
//    NSArray* latestLoans = [json objectForKey:@"loans"];
//    
//    //NSLog(@"loans: %@", latestLoans); //3
}

- (void) requestHandler:(RequestHandler *)pRequestHandler withRequestType:(RequestType)pRequestType error:(APIError *)pError
{
    // run on main thread only
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self requestHandler:pRequestHandler withRequestType:pRequestType error:pError];
        });
        return;
    }
    
    [mHudPresenter hideHud];
    if (!pError) {
        if (pRequestType == kCreateSubscriberPostRequest) {
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUsernameKey];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPasswordKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
            if (mSignUser) {
                [[NSUserDefaults standardUserDefaults] setObject:mSignUser.mEmailID forKey:kUsernameKey];
                [[NSUserDefaults standardUserDefaults] setObject: mSignUser.mPassword forKey:kPasswordKey];

            }
            //NSLog(@"After API Call | Subscriber in Nsuserdefault .......%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"subscriber"]);
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:kSignUpSuccessfulMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
        }
    } else {
        
         UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:kSignUpFailedmessage message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlert show];
    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView cancelButtonIndex] == buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


-(void)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            return 3;
        }
            break;
        case 1:
        {
            return 9;
        }
            break;
            
        default:
        {
            return 0;
        }
            break;
    }
    
    return section;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *sectionName;
    switch (section)
    {
        case 0:
            if (mSignUser)
                sectionName = @"";
            else
                sectionName = @"";
            break;
        case 1:
        {
            sectionName = kSection1;
        }
            break;
 
            // ...
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (mSignUser) {
        switch (indexPath.section) {
            case 0:
                return 0;
                break;
            case 1:
                return 44;
                break;
            default:
                break;
        }
    }
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (mSignUser) {
        return section == 0 ? 0 : 26.0 ;
    }
    return 26.0;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (mSignUser) {
        if (section == 0) {
            return nil;
        }
    }
    
    NSString *tSectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (tSectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *tSectionTitleLabel = [[UILabel alloc] init];
    tSectionTitleLabel.frame = CGRectMake(20, 6, 300, 15);
    tSectionTitleLabel.backgroundColor = [UIColor clearColor];
    tSectionTitleLabel.textColor = [UIColor colorWithRed:(77.0/255.0) green:(77.0/255.0) blue:(77.0/255.0) alpha:1];
    tSectionTitleLabel.shadowColor = [UIColor whiteColor];
    tSectionTitleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    tSectionTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    tSectionTitleLabel.text = tSectionTitle;
    
    // Create header view and add label as a subview
    UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    [tView addSubview:tSectionTitleLabel];
    return tView;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d|section%d",indexPath.row,indexPath.section];
    //static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12.0];
    
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    
                    if (mEmailTextField == nil)
                    {
                        
                        mEmailTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, 300, 30)];
                        mEmailTextField.delegate = self;
                        mEmailTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
                        [mEmailTextField setBorderStyle:UITextBorderStyleNone];
                        mEmailTextField.font = [UIFont systemFontOfSize:14.0];
                        mEmailTextField.keyboardType = UIKeyboardTypeEmailAddress;
                        mEmailTextField.returnKeyType = UIReturnKeyNext;
                        mEmailTextField.placeholder = @"Email";
                        mEmailTextField.textAlignment = NSTextAlignmentLeft;
                        mEmailTextField.textColor = [UIColor colorWithRed:(72/255.0) green:(72/255.0) blue:(72/255.0) alpha:1.0];
                        mEmailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
                        mEmailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                        mEmailTextField.tag = indexPath.row;
                        mEmailTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
                        
                        [cell.contentView addSubview:mEmailTextField];
                    }
                    if (mSignUser) {
                        mEmailTextField.text = mSignUser.mEmailID;
                        mEmailTextField.userInteractionEnabled = NO;
                    }
                    
                } else if (indexPath.row == 1){
                    if (mPasswordTextField == nil) {
                        
                        mPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, 300, 30)];
                        mPasswordTextField.delegate = self;
                        mPasswordTextField.secureTextEntry = YES;
                        mPasswordTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
                        [mPasswordTextField setBorderStyle:UITextBorderStyleNone];
                        mPasswordTextField.font = [UIFont systemFontOfSize:14.0];
                        mPasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
                        mPasswordTextField.returnKeyType = UIReturnKeyNext;
                        mPasswordTextField.placeholder = @"PIN";
                        mPasswordTextField.textAlignment = NSTextAlignmentLeft;
                        mPasswordTextField.textColor = [UIColor colorWithRed:(72/255.0) green:(72/255.0) blue:(72/255.0) alpha:1.0];
                        mPasswordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
                        mPasswordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                        mPasswordTextField.tag = indexPath.row;
                        mPasswordTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
                        
                        [cell.contentView addSubview:mPasswordTextField];
                    }
                    if (mSignUser) {
                        mPasswordTextField.text = mSignUser.mPassword;
                        mPasswordTextField.hidden = YES;
                    }
                } else if(indexPath.row == 2)
                {
                    if (mGenderTextField == nil)
                    {
                        mGenderTextField = [[IQDropDownTextField alloc] initWithFrame:CGRectMake(10, 15, 300, 30)];
                        mGenderTextField.itemList = [[NSMutableArray alloc] initWithObjects:@"Male",@"Female", nil];
                        [mGenderTextField setBorderStyle:UITextBorderStyleNone];
                        mGenderTextField.font = [UIFont systemFontOfSize:14.0];
                        mGenderTextField.returnKeyType = UIReturnKeyNext;
                        mGenderTextField.placeholder = @"Gender";
                        mGenderTextField.textAlignment = NSTextAlignmentLeft;
                        mGenderTextField.textColor = [UIColor colorWithRed:(72/255.0) green:(72/255.0) blue:(72/255.0) alpha:1.0];
                        mGenderTextField.tag = indexPath.row;
                        mGenderTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
                        [cell.contentView addSubview:mGenderTextField];
                    }
                }
            }
        }
            break;
        case 1:
        {
            if (indexPath.section == 1) {
                if (indexPath.row == 0) {
                    if (mNameTextField == nil) {
                        
                        mNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, 300, 30)];
                        mNameTextField.delegate = self;
                        // Border Style None
                        [mNameTextField setBorderStyle:UITextBorderStyleNone];
                        mNameTextField.font = [UIFont systemFontOfSize:14.0];
                        mNameTextField.keyboardType = UIKeyboardTypeDefault;
                        mNameTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
                        mNameTextField.returnKeyType = UIReturnKeyNext;
                        mNameTextField.placeholder = @"First Name";
                        mNameTextField.textAlignment = NSTextAlignmentLeft;
                        mNameTextField.textColor = [UIColor colorWithRed:(72/255.0) green:(72/255.0) blue:(72/255.0) alpha:1.0];
                        mNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
                        mNameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
                        mNameTextField.tag = indexPath.row;
                        mNameTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
                        [cell.contentView addSubview:mNameTextField];
                    }
                    
//                    if (mSignUser) {
//                        mNameTextField.text = mSignUser.mUserName;
//                        mNameTextField.userInteractionEnabled = [mSignUser.mUserName length] ? NO : YES;
//                    }
                }
                if (indexPath.row == 1) {
                    if (mLastNameTextField == nil) {
                        
                        mLastNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, 300, 30)];
                        mLastNameTextField.delegate = self;
                        // Border Style None
                        [mLastNameTextField setBorderStyle:UITextBorderStyleNone];
                        mLastNameTextField.font = [UIFont systemFontOfSize:14.0];
                        mLastNameTextField.keyboardType = UIKeyboardTypeDefault;
                        mLastNameTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
                        mLastNameTextField.returnKeyType = UIReturnKeyNext;
                        mLastNameTextField.placeholder = @"Last Name";
                        mLastNameTextField.textAlignment = NSTextAlignmentLeft;
                        mLastNameTextField.textColor = [UIColor colorWithRed:(72/255.0) green:(72/255.0) blue:(72/255.0) alpha:1.0];
                        mLastNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
                        mLastNameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
                        mLastNameTextField.tag = indexPath.row;
                        mLastNameTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
                        [cell.contentView addSubview:mLastNameTextField];
                    }
                }
                else if (indexPath.row == 3) {
                    if (mDobTextField == nil) {
                        
                        mDobTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, 300, 30)];
                        mDobTextField.delegate = self;
                        [mDobTextField.inputView addSubview:mDatePickerOverlayView] ;
                        mDobTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
                        [mDobTextField setBorderStyle:UITextBorderStyleNone];
                        mDobTextField.font = [UIFont systemFontOfSize:14.0];
                        mDobTextField.keyboardType = UIKeyboardTypeNumberPad;
                        mDobTextField.returnKeyType = UIReturnKeyNext;
                        mDobTextField.placeholder = @"Date of Birth";
                        mDobTextField.textAlignment = NSTextAlignmentLeft;
                        mDobTextField.textColor = [UIColor colorWithRed:(72/255.0) green:(72/255.0) blue:(72/255.0) alpha:1.0];
                        mDobTextField.autocorrectionType = UITextAutocorrectionTypeNo;
                        mDobTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                        mDobTextField.tag = indexPath.row;
                        mDobTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
                        [cell.contentView addSubview:mDobTextField];
                    }
                    
                }

                
                else if (indexPath.row == 4){
                    if (mEthnicityTextField == nil) {
                        
                        mEthnicityTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, 300, 30)];
                        mEthnicityTextField.delegate = self;
                        [mEthnicityTextField.inputView addSubview:mPickerOverlayView] ;
                        mEthnicityTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
                        [mEthnicityTextField setBorderStyle:UITextBorderStyleNone];
                        mEthnicityTextField.font = [UIFont systemFontOfSize:14.0];
                        mEthnicityTextField.keyboardType = UIKeyboardTypeNumberPad;
                        mEthnicityTextField.returnKeyType = UIReturnKeyNext;
                        mEthnicityTextField.placeholder = @"Ethnicity";
                        mEthnicityTextField.textAlignment = NSTextAlignmentLeft;
                        mEthnicityTextField.textColor = [UIColor colorWithRed:(72/255.0) green:(72/255.0) blue:(72/255.0) alpha:1.0];
                        mEthnicityTextField.autocorrectionType = UITextAutocorrectionTypeNo;
                        mEthnicityTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                        mEthnicityTextField.tag = indexPath.row;
                        mEthnicityTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
                        [cell.contentView addSubview:mEthnicityTextField];
                    }
                }
                else if (indexPath.row == 5){
                    if (mCountryTextField == nil) {
                        
                        mCountryTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, 300, 30)];
                        mCountryTextField.delegate = self;
                        [mCountryTextField.inputView addSubview:mPickerOverlayView] ;
                        mCountryTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
                        [mCountryTextField setBorderStyle:UITextBorderStyleNone];
                        mCountryTextField.font = [UIFont systemFontOfSize:14.0];
                        mCountryTextField.keyboardType = UIKeyboardTypeEmailAddress;
                        mCountryTextField.returnKeyType = UIReturnKeyNext;
                        mCountryTextField.placeholder = @"State";
                        mCountryTextField.textAlignment = NSTextAlignmentLeft;
                        mCountryTextField.textColor = [UIColor colorWithRed:(72/255.0) green:(72/255.0) blue:(72/255.0) alpha:1.0];
                        mCountryTextField.autocorrectionType = UITextAutocorrectionTypeNo;
                        mCountryTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                        mCountryTextField.tag = indexPath.row;
                        mCountryTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
                        [cell.contentView addSubview:mCountryTextField];
                    }
                }



                else if (indexPath.row == 6){
                    if (mZipTextField == nil) {
                        
                        mZipTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, 300, 30)];
                        mZipTextField.delegate = self;
                        mZipTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
                        [mZipTextField setBorderStyle:UITextBorderStyleNone];
                        mZipTextField.font = [UIFont systemFontOfSize:14.0];
                        mZipTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                        mZipTextField.returnKeyType = UIReturnKeyNext;
                        mZipTextField.placeholder = @"Zip";
                        mZipTextField.textAlignment = NSTextAlignmentLeft;
                        mZipTextField.textColor = [UIColor colorWithRed:(72/255.0) green:(72/255.0) blue:(72/255.0) alpha:1.0];
                        mZipTextField.autocorrectionType = UITextAutocorrectionTypeNo;
                        mZipTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                        mZipTextField.tag = indexPath.row;
                        mZipTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
                        
                        [cell.contentView addSubview:mZipTextField];
                    }
                }
                else if (indexPath.row == 7){
                    if (mEmailTextField == nil) {
                        
                        mEmailTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, 300, 30)];
                        mEmailTextField.delegate = self;
                        mEmailTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
                        [mEmailTextField setBorderStyle:UITextBorderStyleNone];
                        mEmailTextField.font = [UIFont systemFontOfSize:14.0];
                        mEmailTextField.keyboardType = UIKeyboardTypeEmailAddress;
                        mEmailTextField.returnKeyType = UIReturnKeyNext;
                        mEmailTextField.placeholder = @"Email";
                        mEmailTextField.textAlignment = NSTextAlignmentLeft;
                        mEmailTextField.textColor = [UIColor colorWithRed:(72/255.0) green:(72/255.0) blue:(72/255.0) alpha:1.0];
                        mEmailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
                        mEmailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                        mEmailTextField.tag = indexPath.row;
                        mEmailTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
                        
                        [cell.contentView addSubview:mEmailTextField];
                    }
                    if (mSignUser) {
                        mEmailTextField.text = mSignUser.mEmailID;
                        mEmailTextField.userInteractionEnabled = NO;
                    }
                }

                else if (indexPath.row == 8) {
                    if (![mCouponPrefencesArray count]) {
                        cell.textLabel.text = @"Coupon Preferences";
                        mCouponPrefrences = cell.textLabel.text;

                    } else {
                        cell.textLabel.text = @"Completed";
                        mCouponPrefrences = cell.textLabel.text;

                    }
                }
            }
        }
            break;
                    
        default:
            break;
    }
    

    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Configure the cell...
    NSMutableArray *tObjectArray;
    
    switch (indexPath.section) {
        case 0:
        {
            tObjectArray = [mItemArrayDictionary objectForKey:kSection0];
        }
            break;
        case 1:
        {
            tObjectArray = [mItemArrayDictionary objectForKey:kSection1];
            if (indexPath.section == 1) {
                if (indexPath.row == 8) {
                    CouponCategoriesViewController *tCategoriesViewController = [CouponCategoriesViewController new];
                    UINavigationController *tNavigationController= [[UINavigationController alloc] initWithRootViewController:tCategoriesViewController];
                    
                    [self presentViewController:tNavigationController animated:YES completion:^{
                        tCategoriesViewController.mCouponPrefrencesSelected = kFromSignUpView;

                    }];

                }
            }
        }
            break;
                   
        default:
            break;
    }
    
}

#pragma mark -
#pragma mark PickerView delegate/datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
    
}
- (NSInteger )pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (mPickerSelected) {
        case kCountrySelected:
            return [mCountryNameArray count];
            break;

        case kEthnicitySelected:
            return [mEthnicityArray count];
            break;

            
        default:
            break;
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (mPickerSelected)
    {
        case kCountrySelected:
            return [mCountryNameArray objectAtIndex:row];
            break;
        case kEthnicitySelected:
            return [mEthnicityArray objectAtIndex:row];
            break;

            
        default:
            break;
    }
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    mPickerValueIndex = row;
    
    switch (mPickerSelected) {
        case kCountrySelected:
            mCountryName = [NSString stringWithFormat:@"%@",[mCountryNameArray objectAtIndex:row]];
            //mCountryTextField.text = [NSString stringWithFormat:@"%@", mCountryName];
            break;
       case kEthnicitySelected:
            mEthnicityValue = [NSString stringWithFormat:@"%@",[mEthnicityArray objectAtIndex:row]];
            //mEthnicityTextField.text = [NSString stringWithFormat:@"%@", mEthnicityValue];
            break;
            
        default:
            break;
    }
}


- (IBAction) doneButton:(id)sender {
    if (mIsDateOfBirth) {
        self.tableView.scrollEnabled = YES;
        [self.mDatePickerOverlayView removeFromSuperview];
        mIsDateOfBirth = NO;
        mDobTextField.text = mDateOfBirthString;
        [self.tableView reloadData];
        
    } else {
        switch (mPickerSelected) {
            case kCountrySelected:
                mCountryName = [NSString stringWithFormat:@"%@",[mCountryNameArray objectAtIndex:mPickerValueIndex]];
                mCountryTextField.text = [NSString stringWithFormat:@"%@", mCountryName];
                break;

            case kEthnicitySelected:
                mEthnicityValue = [NSString stringWithFormat:@"%@",[mEthnicityArray objectAtIndex:mPickerValueIndex]];
                mEthnicityTextField.text = [NSString stringWithFormat:@"%@", mEthnicityValue];
                break;
                
            default:
                break;
        }
        
        self.tableView.scrollEnabled = YES;
        [self.mPickerOverlayView removeFromSuperview];
        [self.tableView reloadData];
    }
    
}
- (IBAction) cancelButton:(id)sender {
    if (mIsDateOfBirth) {
        self.tableView.scrollEnabled = YES;
        mIsDateOfBirth = NO;
        [self.mDatePickerOverlayView removeFromSuperview];
    } else {
        self.tableView.scrollEnabled = YES;
        [self.mPickerOverlayView removeFromSuperview];
    }
    
}

- (IBAction)dateChanged:(id)sender {
    //NSDate *date = [[NSDate alloc]init];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //[df setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'+'0530"];
    [df setDateFormat:@"yyyy'-'MM'-'dd"];
   	//df.dateStyle = NSDateFormatterMediumStyle;
    ////NSLog(@"%@",[df stringFromDate:date]);
	mDateOfBirthString = [NSString stringWithFormat:@"%@",[df stringFromDate:mDatePickerView.date]];
    
}

- (IBAction)privacyPolicy:(id)sender {
    WebViewController *tWebViewController = [WebViewController new];
    UINavigationController *tNavigationController= [[UINavigationController alloc] initWithRootViewController:tWebViewController];
    [self presentViewController:tNavigationController animated:YES completion:^{
        [tWebViewController openURLString:@"https://policy-portal.truste.com/core/privacy-policy/Q2-Intel/6b45b037-c5b6-472b-b6c2-29a44b9dd9f1#landingPage"];
    }];
    
}

-(void)resignKeyboard
{
    [mUserNameTextField resignFirstResponder];
    [mPasswordTextField resignFirstResponder];
    [mRePasswordTextField resignFirstResponder];
    [mNameTextField resignFirstResponder];
    [mLastNameTextField resignFirstResponder];
    [mAgeTextField resignFirstResponder];
    [mZipTextField resignFirstResponder];
    [mEmailTextField resignFirstResponder];
    [mGenderTextField resignFirstResponder];
    [mCountryTextField resignFirstResponder];
    [mEthnicityTextField resignFirstResponder];
    [mDobTextField resignFirstResponder];
}


#pragma mark -
#pragma mark TextField delegate


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    mPickerValueIndex = 0;
    if (textField == mCountryTextField){
        mPickerSelected = kCountrySelected;
        [self resignKeyboard];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        self.tableView.scrollEnabled = NO;
        if (!IS_IPHONE_5) {
            if (mSignUser) {
                [mPickerOverlayView setFrame:CGRectMake(0, 0, 320, 450)];
            } else {
                [mPickerOverlayView setFrame:CGRectMake(0, 0, 320, 605)];
            }
        } else {
            if (mSignUser) {
                [mPickerOverlayView setFrame:CGRectMake(0, 0, 320, 520)];
            }
        }
        [self.view addSubview:self.mPickerOverlayView];
        [mPickerView selectRow:mPickerValueIndex inComponent:0 animated:NO];
        [mPickerView reloadAllComponents];
        return NO;
    }
    else if (textField == mEthnicityTextField) {
        mPickerSelected = kEthnicitySelected;
        [self resignKeyboard];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        self.tableView.scrollEnabled = NO;
        if (!IS_IPHONE_5) {
            if (mSignUser) {
                [mPickerOverlayView setFrame:CGRectMake(0, 0, 320, 450)];
            } else {
                [mPickerOverlayView setFrame:CGRectMake(0, 0, 320, 605)];
            }
        } else {
            if (mSignUser) {
                [mPickerOverlayView setFrame:CGRectMake(0, 0, 320, 520)];
            }
        }
        [self.view addSubview:self.mPickerOverlayView];
        [mPickerView selectRow:mPickerValueIndex inComponent:0 animated:NO];
        [mPickerView reloadAllComponents];
        return NO;
        
    }
    else if (textField == mDobTextField) {
        mIsDateOfBirth = YES;
        [self resignKeyboard];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        self.tableView.scrollEnabled = NO;
        if (!IS_IPHONE_5) {
            if (mSignUser) {
                [mDatePickerOverlayView setFrame:CGRectMake(0, 0, 320, 450)];
            } else {
                [mDatePickerOverlayView setFrame:CGRectMake(0, 0, 320, 605)];
            }
        } else {
            if (mSignUser) {
                [mDatePickerOverlayView setFrame:CGRectMake(0, 0, 320, 520)];
            }
        }
        
        [self.view addSubview:self.mDatePickerOverlayView];
        return NO;
        
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == mEmailTextField) {
        [mPasswordTextField becomeFirstResponder];
    } else if (textField == mPasswordTextField){
        [mGenderTextField becomeFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if((textField == mNameTextField) || (textField == mLastNameTextField)) {
        static NSCharacterSet *charSet = nil;
        if(!charSet) {
            charSet = [[NSCharacterSet characterSetWithCharactersInString:kALPHA] invertedSet];
        }
        NSRange location = [string rangeOfCharacterFromSet:charSet];
        return (location.location == NSNotFound);
        
    } else if (textField == mZipTextField) {
        static NSCharacterSet *charSet = nil;
        if(!charSet) {
            charSet = [[NSCharacterSet characterSetWithCharactersInString:kNUMERIC] invertedSet];
        }
        NSRange location = [string rangeOfCharacterFromSet:charSet];
        return (location.location == NSNotFound);
        
    } else if(textField == mPasswordTextField) {
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 4) ? NO : YES;
        
    }
    
    
    return YES;
}

@end

