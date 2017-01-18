//
//  ProfileViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileItem.h"
#import "Subscriber.h"
#import "SubscriberCredentials.h"
#import "SubscriberProfile.h"
#import "tJSON.h"
#import "StorePreferencesViewController.h"
#import "CouponPreferencesViewController.h"
#import "ChangePasswordViewController.h"
#import "CouwallaHelpViewController.h"
#import "jsonparse.h"
#import "appcommon.h"
#import "IQKeyboardManager.h"
#import "AppDelegate.h"
#import "NSString+Validation.h"
#import "EditProfileCell.h"
#import "EditProfileListCell.h"
#import "EditProfileValueCell.h"
#import "LocalyticsSession.h"
#import "UIColor+AppTheme.h"

#define kSection0 @"LOGIN CREDENTIAL" // Login Credential"
#define kSection1 @"PERSONAL DETAILS" //Personal Details"
#define kSection2 @"Preferences"
#define kSection3 @"COUWALLA HELP"//Couwalla help"
@implementation ProfileViewController
{
    UIView      *mGestureView;
    
    UIButton *menuButton;
    
	UIBarButtonItem *saveBarButton;
	UIBarButtonItem *menuBarButton;
    
    NSMutableDictionary     *mItemArrayDictionary;
    ProgressHudPresenter    *mHudPresenter;
    
    NSDictionary    *mPlistData;
    NSString    *userkey;
    
    int didSelectRowTag;
    NSMutableDictionary  *dataForUpdate;
    int flagForUpdate;
}

static NSDateFormatter *profileDateFormatter = nil;

+(void)initialize
{
    [super initialize];
    profileDateFormatter = [[NSDateFormatter alloc] init];
    [profileDateFormatter setDateFormat:@"yyyy'-'MM'-'dd"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    didSelectRowTag=0;
    
    flagForUpdate=0;
    
    //Initialization
    {
        //Plist
        {
            NSString *mPlistPath  = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"CountryList.plist"];
            mPlistData  = [NSDictionary dictionaryWithContentsOfFile:mPlistPath];
        }
        
        mHudPresenter = [ProgressHudPresenter new];
        mItemArrayDictionary = [NSMutableDictionary new];
    }
    
    //Settings
    {
        
        //TableView
        {
            [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]]];
            
            //Registering class for reuseIdentifier
            {
                [self.tableView registerClass:[EditProfileCell class] forCellReuseIdentifier:NSStringFromClass([EditProfileCell class])];
                [self.tableView registerClass:[EditProfileListCell class] forCellReuseIdentifier:NSStringFromClass([EditProfileListCell class])];
                [self.tableView registerClass:[EditProfileValueCell class] forCellReuseIdentifier:NSStringFromClass([EditProfileValueCell class])];
            }
        }

        //NavigationBar
        {
            self.navigationItem.title = @"Profile";
            
            //LeftItem
            menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [menuButton setImage:[UIImage imageNamed:@"button_menu"] forState:UIControlStateNormal];
            [menuButton sizeToFit];
            [menuButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
            menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
            self.navigationItem.leftBarButtonItem = menuBarButton;
            
//            //RightItem
//            UIButton* mSaveButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [mSaveButton setImage:[UIImage imageNamed:@"btn_save"] forState:UIControlStateNormal];
//            [mSaveButton sizeToFit];
//            [mSaveButton addTarget:self action:@selector(initialBeforeSave:) forControlEvents:UIControlEventTouchUpInside];
//            saveBarButton = [[UIBarButtonItem alloc]initWithCustomView:mSaveButton];
//            self.navigationItem.rightBarButtonItem = saveBarButton;
        }
        
        //Gesture
        {
            UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
            [self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
            
            mGestureView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealToggle:)];
            [mGestureView addGestureRecognizer:recognizer];
            
            UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
            [mGestureView addGestureRecognizer:panRecognizer];
        }
    }
    
    //Web-Service
    {
        NSMutableArray *tLoginCredential = [[NSMutableArray alloc] init];
        
        //Section0
        {
            NSString* loginID =[[NSUserDefaults standardUserDefaults] objectForKey:@"loginidkey"];
            [tLoginCredential addObject:[[ProfileItem alloc] initWithTitle:@"Login ID" value:loginID serverKey:@""]];
            //[tLoginCredential addObject:[[ProfileItem alloc] initWithTitle:@"Change PIN" value:@"" serverKey:@""]];
            [mItemArrayDictionary setObject:tLoginCredential forKey:kSection0];
        }
        
        //Section1
        {
            [mItemArrayDictionary setObject:[NSArray new] forKey:kSection1];
        }
        
        //Section2
        {
            NSMutableArray *tPrefences = [NSMutableArray new];
            [tPrefences addObject:[[ProfileItem alloc] initWithTitle:@"Retailers & Manufacturers" value:@"" serverKey:@""]];
            [tPrefences addObject:[[ProfileItem alloc] initWithTitle:@"Store Favorites" value:@"" serverKey:@""]];
            [mItemArrayDictionary setObject:tPrefences forKey:kSection2];
        }
        
        //Section3
        {
            NSMutableArray *tCouwallaHelp = [NSMutableArray new];
            [tCouwallaHelp addObject:[[ProfileItem alloc] initWithTitle:@"FAQ" value:@"" serverKey:@""]];
            [tCouwallaHelp addObject:[[ProfileItem alloc] initWithTitle:@"Terms and Conditions" value:@"" serverKey:@""]];
            [tCouwallaHelp addObject:[[ProfileItem alloc] initWithTitle:@"Privacy Policy" value:@"" serverKey:@""]];
            [mItemArrayDictionary setObject:tCouwallaHelp forKey:kSection3];
        }
        
        userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
        NSMutableDictionary *profileDic = [NSMutableDictionary dictionary];
        if(userkey != nil)  [profileDic setObject:userkey forKey:@"userid"];
        
        NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/get_myprofile_data.php?",BASE_URL];
        
        jsonparse *objJsonparse =[[jsonparse alloc]init];
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [activityView startAnimating];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:activityView];
        self.navigationItem.rightBarButtonItem = barButton;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSDictionary *profileData = [objJsonparse customejsonParsing:urlString bodydata:profileDic];
            
            NSArray *profilearray = [profileData valueForKey:@"data"];
            
            NSDictionary *dictionary = [profilearray firstObject];
            
            
            
            //Section1
            {
                NSString *firstName =![[dictionary objectForKey:@"First Name"] isEqualToString:@""]?[dictionary objectForKey:@"First Name"]:[[NSUserDefaults standardUserDefaults] objectForKey:@"firstName"];
                
                NSString *lastName  = ![[dictionary objectForKey:@"Last Name"] isEqualToString:@""]?[dictionary objectForKey:@"Last Name"]:[[NSUserDefaults standardUserDefaults] objectForKey:@"lastName"];
                
                NSString *DOB       = [dictionary objectForKey:@"DOB"]?[dictionary objectForKey:@"DOB"]:@"";
                NSString *email     = [dictionary objectForKey:@"Email"]?[dictionary objectForKey:@"Email"]:@"";
                NSString *ethnicity = [dictionary objectForKey:@"Ethnicity"]?[dictionary objectForKey:@"Ethnicity"]:@"";
                NSString *havePets  = [dictionary objectForKey:@"Have Pets"]?[dictionary objectForKey:@"Have Pets"]:@"";
                NSString *sex       = [dictionary objectForKey:@"Sex"]?[dictionary objectForKey:@"Sex"]:@"";
                if([sex isEqualToString:@""] || [sex isEqual:[NSNull null]])
                {
                    sex =[[NSUserDefaults standardUserDefaults]objectForKey:@"fbGender"];
                }
                
                
                NSString *state     = [dictionary objectForKey:@"State"]?[dictionary objectForKey:@"State"]:@"";
                NSString *zip       = [dictionary objectForKey:@"Zip"]?[dictionary objectForKey:@"Zip"]:@"";
                NSString *maritalStatus = [dictionary objectForKey:@"Marital Status"]?[dictionary objectForKey:@"Marital Status"]:@"";
                NSString *noOfChildren  = [dictionary objectForKey:@"No. of Children"]?[dictionary objectForKey:@"No. of Children"]:@"";
                
                //Saving '5+' on server, but getting '5' from the server response.
                if ([noOfChildren isEqualToString:@"5"])
                {
                    noOfChildren = @"5+";
                }
                
                NSString *yearlyIncome  = [dictionary objectForKey:@"Yearly Income"]?[dictionary objectForKey:@"Yearly Income"]:@"";
                
                NSString *education  = [dictionary objectForKey:@"Education"]?[dictionary objectForKey:@"Education"]:@"";
                NSString *smoke  = [dictionary objectForKey:@"Smoker"]?[dictionary objectForKey:@"Smoker"]:@"";
                NSString *ownBoat  = [dictionary objectForKey:@"Boat Owner"]?[dictionary objectForKey:@"Boat Owner"]:@"";
                NSString *takeCruises  = [dictionary objectForKey:@"Cruises"]?[dictionary objectForKey:@"Cruises"]:@"";
                
                
                //dataForUpdate
                {
                    
                    if(firstName == nil || [firstName isEqual:[NSNull null]])
                        firstName=@"";
                    if(lastName == nil || [lastName isEqual:[NSNull null]])
                        lastName=@"";
                    if(DOB == nil || [DOB isEqual:[NSNull null]])
                        DOB=@"";
                    if(sex == nil || [sex isEqual:[NSNull null]])
                        sex=@"";
                    if(ethnicity == nil || [ethnicity isEqual:[NSNull null]])
                        ethnicity=@"";
                    if(maritalStatus == nil || [maritalStatus isEqual:[NSNull null]])
                        maritalStatus=@"";
                    if(email == nil || [email isEqual:[NSNull null]])
                        email=@"";
                    if(state == nil || [state isEqual:[NSNull null]])
                        state=@"";
                    if(zip == nil || [zip isEqual:[NSNull null]])
                        zip=@"";
                    if(noOfChildren == nil || [noOfChildren isEqual:[NSNull null]])
                        noOfChildren=@"";
                    if(havePets == nil || [havePets isEqual:[NSNull null]])
                        havePets=@"";
                    if(yearlyIncome == nil || [yearlyIncome isEqual:[NSNull null]])
                        yearlyIncome=@"";
                    if(education == nil || [education isEqual:[NSNull null]])
                        education=@"";
                    if(smoke == nil || [smoke isEqual:[NSNull null]])
                        smoke=@"";
                    if(ownBoat == nil || [ownBoat isEqual:[NSNull null]])
                        ownBoat=@"";
                    if(takeCruises == nil || [takeCruises isEqual:[NSNull null]])
                        takeCruises=@"";
                    
    
                    dataForUpdate=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                   firstName,@"First Name",
                                   lastName,@"Last Name",
                                   DOB,@"DOB",
                                   sex,@"Sex",
                                   ethnicity,@"Ethnicity",
                                   maritalStatus,@"Marital Status",
                                   email,@"Email",
                                   state,@"State",
                                   zip,@"Zip",
                                   noOfChildren,@"No. of Children",
                                   havePets,@"Have Pets",
                                   yearlyIncome,@"Yearly Income",
                                   education,@"Education",
                                   smoke,@"Smoker",
                                   ownBoat,@"Boat Owner",
                                   takeCruises,@"Cruises",
                                   nil];
                    NSLog(@"%@",dataForUpdate);
                
                }
               NSMutableArray *tPersonalDetails = [NSMutableArray new];
                
                [tPersonalDetails addObject:[[ProfileItem alloc] initWithTitle:@"First Name" value:firstName serverKey:@"First Name"]];
                [tPersonalDetails addObject:[[ProfileItem alloc] initWithTitle:@"Last Name" value:lastName serverKey:@"Last Name"]];
                [tPersonalDetails addObject:[[ProfileItem alloc] initWithTitle:@"Date of Birth" value:DOB serverKey:@"DOB"]];
                [tPersonalDetails addObject:[[ProfileItem alloc] initWithTitle:@"Gender" value:sex serverKey:@"Sex"]];
                [tPersonalDetails addObject:[[ProfileItem alloc] initWithTitle:@"Ethnicity" value:ethnicity serverKey:@"Ethnicity"]];
                [tPersonalDetails addObject:[[ProfileItem alloc] initWithTitle:@"Marital Status" value:maritalStatus serverKey:@"Marital Status"]];
                [tPersonalDetails addObject:[[ProfileItem alloc] initWithTitle:@"Email" value:email serverKey:@"Email"]];
                [tPersonalDetails addObject:[[ProfileItem alloc] initWithTitle:@"State" value:state serverKey:@"State"]];
                [tPersonalDetails addObject:[[ProfileItem alloc] initWithTitle:@"Zip Code" value:zip serverKey:@"Zip"]];
                [tPersonalDetails addObject:[[ProfileItem alloc] initWithTitle:@"Children Under 18" value:noOfChildren serverKey:@"No. of Children"]];
                [tPersonalDetails addObject:[[ProfileItem alloc] initWithTitle:@"Pets" value:havePets serverKey:@"Have Pets"]];
                [tPersonalDetails addObject:[[ProfileItem alloc] initWithTitle:@"Family Income" value:yearlyIncome serverKey:@"Yearly Income"]];
                [tPersonalDetails addObject:[[ProfileItem alloc] initWithTitle:@"Education" value:education serverKey:@"education"]];
                [tPersonalDetails addObject:[[ProfileItem alloc] initWithTitle:@"Smoke (Cigarettes/Cigars)" value:smoke serverKey:@"smoker"]];
                [tPersonalDetails addObject:[[ProfileItem alloc] initWithTitle:@"Own Boat" value:ownBoat serverKey:@"boat_owner"]];
                [tPersonalDetails addObject:[[ProfileItem alloc] initWithTitle:@"Take Cruises" value:takeCruises serverKey:@"cruises"]];
                
                [mItemArrayDictionary setObject:tPersonalDetails forKey:kSection1];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [activityView stopAnimating];
                [self.navigationItem setRightBarButtonItem:saveBarButton animated:YES];
                
                [self.tableView beginUpdates];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 4)] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
                
            });
        });
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[LocalyticsSession shared] tagScreen:kMyProfile];
}
-(void)viewWillDisappear:(BOOL)animated
{
    //    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isDisappearcall"];
    [super viewWillDisappear:animated];
}

-(void)initialBeforeSave:(id)sender
{
    [self saveProfileAction:sender];
}
- (void) saveProfileAction:(id)sender
{
    
    if(!flagForUpdate)
        return;
    
    
    [self.view endEditing:YES];
    //     [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isDisappearcall"];
    NSMutableArray *tObjectArray = [mItemArrayDictionary objectForKey:kSection1];
    
    if([tObjectArray count]>0)
    {
        
    //ProfileItem *firstNameProfileItem       = [tObjectArray objectAtIndex:0];
    //ProfileItem *lastNameProfileItem        = [tObjectArray objectAtIndex:1];
    ProfileItem *DOBProfileItem             = [tObjectArray objectAtIndex:2];
    //ProfileItem *sexProfileItem             = [tObjectArray objectAtIndex:3];
    //ProfileItem *ethnicityProfileItem       = [tObjectArray objectAtIndex:4];
    //ProfileItem *maritalStatusProfileItem   = [tObjectArray objectAtIndex:5];
    ProfileItem *emailProfileItem           = [tObjectArray objectAtIndex:6];
    //ProfileItem *stateProfileItem           = [tObjectArray objectAtIndex:7];
    ProfileItem *zipProfileItem             = [tObjectArray objectAtIndex:8];
    //ProfileItem *noOfChildrenProfileItem    = [tObjectArray objectAtIndex:9];
    //ProfileItem *havePetsProfileItem        = [tObjectArray objectAtIndex:10];
    //ProfileItem *yearlyIncomeProfileItem    = [tObjectArray objectAtIndex:11];
    
    //DOB
    if ([DOBProfileItem.mValue length] == 0)
    {
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Birth date should not be empty" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [tAlert show];
    }
    else if( [[self ageFromBirthDate:[profileDateFormatter dateFromString:DOBProfileItem.mValue]] integerValue
              ]<18)
    {
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"You must be 18 to complete this profile. Your profile birthdate has been reset." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [tAlert show];
    }

    //email
    else if ([emailProfileItem.mValue length] == 0)
    {
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:kEmailFieldMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [tAlert show];
    }
    else if ([emailProfileItem.mValue isValidEmail] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:kEmailValidationMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
        [alert show];
    }
    
    else if (!([zipProfileItem.mValue length] == 5 || [zipProfileItem.mValue length] == 9 || [zipProfileItem.mValue length] == 0))
    {
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:kZipFieldLengthMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [tAlert show];
    }
    else
    {
        userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
        
        if(userkey != nil)
        {
            UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [activityView startAnimating];
            UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:activityView];
            self.navigationItem.rightBarButtonItem = barButton;
            [self.tableView setUserInteractionEnabled:NO];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSArray *arrayItems = [mItemArrayDictionary objectForKey:kSection1];
                
                NSMutableDictionary *updatedDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:userkey,@"userid", nil];
                
                for (ProfileItem *item in arrayItems)
                {
                    if([item mValue]!=nil)
                    {
                        [updatedDict setObject:[item mValue] forKey:[item mServerKey]];
                    }
                    if([[item mServerKey] isEqualToString:@"Sex"] && ![[item mValue] isEqualToString:@""])
                    {
                        [[LocalyticsSession shared] setCustomDimension:0 value:[item mValue]];
                    }
                    
                    else if([[item mServerKey] isEqualToString:@"DOB"] && ![[item mValue] isEqualToString:@"2001-01-01"])
                    {
                        NSDate *birthDate=[profileDateFormatter dateFromString:[item mValue]];
                        [[LocalyticsSession shared] setCustomDimension:1 value:[self ageFromBirthDate:birthDate]];
                    }
                    
                    else if([[item mServerKey] isEqualToString:@"Ethnicity"] && ![[item mValue] isEqualToString:@""])
                    {
                        [[LocalyticsSession shared] setCustomDimension:2 value:[item mValue]];
                    }
                    
                    else if([[item mServerKey] isEqualToString:@"State"] && ![[item mValue] isEqualToString:@""])
                    {
                        [[LocalyticsSession shared] setCustomDimension:3 value:[item mValue]];
                    }
                }
                
                NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/update_profile.php?",BASE_URL];
                
                jsonparse *objJsonparse =[[jsonparse alloc]init];
                
                NSLog(@"%@",updatedDict);
                dataForUpdate=[updatedDict mutableCopy];
                
                NSDictionary *updateptofile = [objJsonparse customejsonParsing:urlString bodydata:updatedDict];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [activityView stopAnimating];
                    self.navigationItem.rightBarButtonItem = saveBarButton;
                    [self.tableView setUserInteractionEnabled:YES];
                    flagForUpdate=0;
                    
                    if ([[updateptofile valueForKey:@"response"] isEqualToString:@"success"])
                    {
                        UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Profile Updated Successfully" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                        
                        
//                        BOOL val=[[NSUserDefaults standardUserDefaults] boolForKey:@"isDisappearcall"];
                        
                            [updateAlert show];
//                        switch (didSelectRowTag)
//                        {
//                            case 1:
//                            {
//                                CouwallaHelpViewController *tCouwallaHelpViewController = [[CouwallaHelpViewController alloc] initWithNibName:@"CouwallaHelpViewController" bundle:nil];
//                                tCouwallaHelpViewController.mCouwallaHelpType = kFAQHelp;
//                                [self.navigationController pushViewController:tCouwallaHelpViewController animated:YES];
//                            }
//                                break;
//                            case 2:
//                            {
//                                CouwallaHelpViewController *tCouwallaHelpViewController = [[CouwallaHelpViewController alloc] initWithNibName:@"CouwallaHelpViewController" bundle:nil];
//                                tCouwallaHelpViewController.mCouwallaHelpType = kTermsOFServiceHelp;
//                                [self.navigationController pushViewController:tCouwallaHelpViewController animated:YES];
//                            }
//                                break;
//                            case 3:
//                            {
//                                CouwallaHelpViewController *tCouwallaHelpViewController = [[CouwallaHelpViewController alloc] initWithNibName:@"CouwallaHelpViewController" bundle:nil];
//                                tCouwallaHelpViewController.mCouwallaHelpType = kPrivacyPolicyHelp;
//                                [self.navigationController pushViewController:tCouwallaHelpViewController animated:YES];
//                            }
//                                break;
//                        }
//                        didSelectRowTag=0;
                    }
                    else
                    {
                        UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:[updateptofile objectForKey:@"message"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                        [updateAlert show];
                    }
                });
            });
        }
    }
    }
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
    
    if (!pError)
    {
        if (pRequestType == kEditProfileRequest) {
            //NSLog(@"After API Call | Subscriber in Nsuserdefault .......%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"subscriber"]);
            // TODO: Update password in NSUserDefaults
            
            NSString *subscriberJSON = [[NSUserDefaults standardUserDefaults] objectForKey:@"subscriber"];
            NSDictionary *dictionary = [subscriberJSON JSONValue];
            Subscriber *tSubscriber = [[Subscriber alloc] init];
            [tSubscriber subscriberWithDict:dictionary];
            [tSubscriber setMCredentials:tSubscriber.mCredentials];
            //NSLog(@"..................:%@",tSubscriber.mCredentials.mPassword);
            
            [[NSUserDefaults standardUserDefaults] setObject:tSubscriber.mCredentials.mPassword forKey:kPasswordKey];
//            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:kProfileUpdatedMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [tAlert show];
            return;
        }
    }
    else
    {
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Unable to edit profile" message:pError.mMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
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
    didSelectRowTag=0;
    [self saveProfileAction:nil];
}

-(void)menuButtonUnselected {
	menuButton.selected = NO;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [mItemArrayDictionary count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0: return kSection0;   break;
        case 1: return kSection1;   break;
        case 2: return kSection3;   break;
            //case 3: return kSection3;   break;
        default:    return @"";     break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0: return [[mItemArrayDictionary objectForKey:kSection0] count];   break;
        case 1: return [[mItemArrayDictionary objectForKey:kSection1] count];   break;
        case 2: return [[mItemArrayDictionary objectForKey:kSection3] count];   break;
            // case 3: return [[mItemArrayDictionary objectForKey:kSection3] count];   break;
        default:    return 0;   break;
    }
}

/*Request_url:http://prodlb-905810012.us-east-1.elb.amazonaws.com/couwalla/api/v1/subscriber/100000138
 2013-11-10 18:25:02.620 Couwalla[4495:907] pBodyPost:{"lastName":"miller","id":100000138,"profile":{"householdIncome":"","dob":"1999-06-30T00:00:00+0000","children":"","familyMembers":0,"maritalStatus":"","pets":0,"sex":0,"ethinicity":"Hispanic/Latino"},"firstName":"john","zip":"33431","email":"rupeshpalsingh.genie@gmail.com","credentials":{"username":"john","password":"123456"},"state":"Florida","couponPreferences":[0]}
 ]
 After API Call | Subscriber in Nsuserdefault .......{"lastName":"miller","id":100000138,"profile":{"householdIncome":"","dob":"1999-06-30T00:00:00+0000","children":"","familyMembers":0,"maritalStatus":"","pets":0,"sex":0,"ethinicity":"Hispanic/Latino"},"firstName":"john","zip":"33431","email":"rupeshpalsingh.genie@gmail.com","credentials":{"username":"john","password":"123456"},"state":"Florida","couponPreferences":[0]}
 */

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *tObjectArray;
    
    switch (indexPath.section)
    {
        case 0: tObjectArray = [mItemArrayDictionary objectForKey:kSection0];   break;
        case 1: tObjectArray = [mItemArrayDictionary objectForKey:kSection1];   break;
        case 2: tObjectArray = [mItemArrayDictionary objectForKey:kSection3];   break;
            // case 3: tObjectArray = [mItemArrayDictionary objectForKey:kSection3];   break;
        default:    break;
    }
    
    ProfileItem *tProfileItem = [tObjectArray objectAtIndex:indexPath.row];
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    EditProfileValueCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EditProfileValueCell class])];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.profileItem = tProfileItem;
                    cell.textLabel.text = tProfileItem.mTitle;
                    cell.detailTextLabel.text = tProfileItem.mValue;
                    return cell;
                }
                    break;
                case 1:
                {
                    EditProfileValueCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EditProfileValueCell class])];
                    cell.profileItem = tProfileItem;
                    cell.textLabel.text = tProfileItem.mTitle;
                    cell.detailTextLabel.text = tProfileItem.mValue;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    return cell;
                }
                    break;
                default: return nil;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:
                case 1:
                {
                    EditProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EditProfileCell class])];
                    cell.inputField.delegate = self;
                    cell.inputField.tag = (indexPath.section * 100) + indexPath.row;
                    cell.inputField.placeholder=@"Select";
                    cell.profileItem = tProfileItem;
                    cell.textLabel.text = tProfileItem.mTitle;
                    cell.inputField.text = tProfileItem.mValue;
                    return cell;
                }
                    break;
                case 2:
                {
                    EditProfileListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EditProfileListCell class])];
                    cell.inputField.delegate = self;
                    cell.inputField.tag = (indexPath.section * 100) + indexPath.row;
                    cell.inputField.dropDownMode = IQDropDownModeDatePicker;
                    cell.inputField.dropDownDateFormatter = profileDateFormatter;
                    [cell.inputField setDatePickerMaximumDate:[NSDate date]];
                    cell.profileItem = tProfileItem;
                    cell.textLabel.text = tProfileItem.mTitle;
                    
                    
//                   NSLog(@"%@",tProfileItem.mValue);
//                   NSDate *date = [profileDateFormatter dateFromString:tProfileItem.mValue];
//                    if (date == nil)
//                    {
//                        tProfileItem.mValue = [profileDateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:0]];
//                    }
                    
                    cell.inputField.selectedItem = tProfileItem.mValue;
                    
                    return cell;
                }
                    break;
                case 3:
                {
                    EditProfileListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EditProfileListCell class])];
                    cell.inputField.delegate = self;
                    cell.inputField.tag = (indexPath.section * 100) + indexPath.row;
                    cell.inputField.dropDownMode = IQDropDownModeTextPicker;
                    cell.inputField.itemList = [[NSArray alloc] initWithObjects:@"Select",@"Male",@"Female", nil];
                    cell.profileItem = tProfileItem;
                    cell.textLabel.text = tProfileItem.mTitle;
                    cell.inputField.selectedItem = tProfileItem.mValue;
                    return cell;
                }
                    break;
                case 4:
                {
                    EditProfileListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EditProfileListCell class])];
                    cell.inputField.delegate = self;
                    cell.inputField.tag = (indexPath.section * 100) + indexPath.row;
                    cell.inputField.dropDownMode = IQDropDownModeTextPicker;
                    cell.inputField.itemList = [mPlistData objectForKey:@"Ethnicity"];
                    cell.profileItem = tProfileItem;
                    cell.textLabel.text = tProfileItem.mTitle;
                    cell.inputField.selectedItem = tProfileItem.mValue;
                    return cell;
                }
                    break;
                case 5:
                {
                    EditProfileListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EditProfileListCell class])];
                    cell.inputField.delegate = self;
                    cell.inputField.tag = (indexPath.section * 100) + indexPath.row;
                    cell.inputField.dropDownMode = IQDropDownModeTextPicker;
                    cell.inputField.itemList = [mPlistData objectForKey:@"MaritalStatus"];
                    cell.profileItem = tProfileItem;
                    cell.textLabel.text = tProfileItem.mTitle;
                    cell.inputField.selectedItem = tProfileItem.mValue;
                    return cell;
                }
                    break;
                case 6:
                {
                    EditProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EditProfileCell class])];
                    cell.inputField.delegate = self;
                    cell.inputField.tag = (indexPath.section * 100) + indexPath.row;
                    cell.inputField.keyboardType = UIKeyboardTypeEmailAddress;
                    cell.profileItem = tProfileItem;
                    cell.textLabel.text = tProfileItem.mTitle;
                    cell.inputField.text = tProfileItem.mValue;
                    return cell;
                }
                    break;
                case 7:
                {
                    EditProfileListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EditProfileListCell class])];
                    cell.inputField.delegate = self;
                    cell.inputField.tag = (indexPath.section * 100) + indexPath.row;
                    cell.inputField.dropDownMode = IQDropDownModeTextPicker;
                    cell.inputField.itemList = [mPlistData objectForKey:@"CountryName"];
                    cell.profileItem = tProfileItem;
                    cell.textLabel.text = tProfileItem.mTitle;
                    cell.inputField.selectedItem = tProfileItem.mValue;
                    return cell;
                }
                    break;
                case 8:
                {
                    EditProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EditProfileCell class])];
                    cell.inputField.delegate = self;
                    cell.inputField.tag = (indexPath.section * 100) + indexPath.row;
                    cell.inputField.keyboardType = UIKeyboardTypeNumberPad;
                    cell.profileItem = tProfileItem;
                    cell.textLabel.text = tProfileItem.mTitle;
                    //                    cell.inputField.text = tProfileItem.mValue;
                    [cell.inputField setPlaceholder:@"Select"];
                    NSString *str=[[NSUserDefaults standardUserDefaults] valueForKeyPath:@"zipValueinSetting"];
                    
                    if(str.length)
                    {
                        cell.inputField.text=str;
                        tProfileItem.mValue=str;
                    }else
                    {
                        if(![tProfileItem.mValue isEqualToString:@"0"])
                           cell.inputField.text = tProfileItem.mValue;
                   }
                   return cell;
                }
                    break;
                case 9:
                {
                    EditProfileListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EditProfileListCell class])];
                    cell.inputField.delegate = self;
                    cell.inputField.tag = (indexPath.section * 100) + indexPath.row;
                    cell.inputField.dropDownMode = IQDropDownModeTextPicker;
                    cell.inputField.itemList = [mPlistData objectForKey:@"No of Children"];
                    cell.profileItem = tProfileItem;
                    cell.textLabel.text = tProfileItem.mTitle;
                    cell.inputField.selectedItem = tProfileItem.mValue;
                    return cell;
                }
                    break;
                case 10:
                {
                    EditProfileListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EditProfileListCell class])];
                    cell.inputField.delegate = self;
                    cell.inputField.tag = (indexPath.section * 100) + indexPath.row;
                    cell.inputField.dropDownMode = IQDropDownModeTextPicker;
                    cell.inputField.itemList = [mPlistData objectForKey:@"Pets"];
                    cell.profileItem = tProfileItem;
                    cell.textLabel.text = tProfileItem.mTitle;
                    cell.inputField.selectedItem = tProfileItem.mValue;
                    return cell;
                }
                    break;
                case 11:
                {
                    EditProfileListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EditProfileListCell class])];
                    cell.inputField.delegate = self;
                    cell.inputField.tag = (indexPath.section * 100) + indexPath.row;
                    cell.inputField.dropDownMode = IQDropDownModeTextPicker;
                    cell.inputField.itemList = [mPlistData objectForKey:@"FamilyIncome"];
                    cell.profileItem = tProfileItem;
                    cell.textLabel.text = tProfileItem.mTitle;
                    cell.inputField.selectedItem = tProfileItem.mValue;
                    return cell;
                }
                case 12:
                {
                    EditProfileListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EditProfileListCell class])];
                    cell.inputField.delegate = self;
                    cell.inputField.tag = (indexPath.section * 100) + indexPath.row;
                    cell.inputField.dropDownMode = IQDropDownModeTextPicker;
                    cell.inputField.itemList = [mPlistData objectForKey:@"Education"];
                    cell.profileItem = tProfileItem;
                    cell.textLabel.text = tProfileItem.mTitle;
                    cell.inputField.selectedItem = tProfileItem.mValue;
                    return cell;
                }
                case 13:
                {
                    EditProfileListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EditProfileListCell class])];
                    cell.inputField.delegate = self;
                    cell.inputField.tag = (indexPath.section * 100) + indexPath.row;
                    cell.inputField.dropDownMode = IQDropDownModeTextPicker;
                    cell.inputField.itemList = [[NSArray alloc] initWithObjects:@"Select",@"Yes",@"No", nil];
                    cell.profileItem = tProfileItem;
                    cell.textLabel.text = tProfileItem.mTitle;
                    cell.inputField.selectedItem = tProfileItem.mValue;
                    return cell;
                }
                case 14:
                {
                    EditProfileListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EditProfileListCell class])];
                    cell.inputField.delegate = self;
                    cell.inputField.tag = (indexPath.section * 100) + indexPath.row;
                    cell.inputField.itemList = [[NSArray alloc] initWithObjects:@"Select",@"Yes",@"No", nil];
                    cell.profileItem = tProfileItem;
                    cell.inputField.dropDownMode = IQDropDownModeTextPicker;
                    cell.textLabel.text = tProfileItem.mTitle;
                    cell.inputField.selectedItem = tProfileItem.mValue;
                    return cell;
                }
                case 15:
                {
                    
                    EditProfileListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EditProfileListCell class])];
                    cell.inputField.delegate = self;
                    cell.inputField.tag = (indexPath.section * 100) + indexPath.row;
                    cell.inputField.itemList = [mPlistData objectForKey:@"Take Cruises"];
                    cell.inputField.dropDownMode = IQDropDownModeTextPicker;
                    cell.profileItem = tProfileItem;
                    cell.textLabel.text = tProfileItem.mTitle;
                    cell.inputField.selectedItem = tProfileItem.mValue;
                    return cell;
                }
                    
                    break;
                default:    return nil; break;
            }
            
        }
            break;
        case 2:
        case 3:
        {
            EditProfileValueCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EditProfileValueCell class])];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.profileItem = tProfileItem;
            cell.textLabel.text = tProfileItem.mTitle;
            cell.detailTextLabel.text = tProfileItem.mValue;
            return cell;
        }
            break;
            
        default:    return nil; break;
    }
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 1:
                {
                    ChangePasswordViewController *tChangePasswordViewController = [[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil];
                    [self.navigationController pushViewController:tChangePasswordViewController animated:YES];
                }
                    break;
            }
        }
            break;
        case 2:
        {
            if(!flagForUpdate)
            {
                switch (indexPath.row)
                {
                    case 0:
                    {
                        CouwallaHelpViewController *tCouwallaHelpViewController = [[CouwallaHelpViewController alloc] initWithNibName:@"CouwallaHelpViewController" bundle:nil];
                        tCouwallaHelpViewController.mCouwallaHelpType = kFAQHelp;
                        [self.navigationController pushViewController:tCouwallaHelpViewController animated:YES];
                    }
                        break;
                    case 1:
                    {
                        CouwallaHelpViewController *tCouwallaHelpViewController = [[CouwallaHelpViewController alloc] initWithNibName:@"CouwallaHelpViewController" bundle:nil];
                        tCouwallaHelpViewController.mCouwallaHelpType = kTermsOFServiceHelp;
                        [self.navigationController pushViewController:tCouwallaHelpViewController animated:YES];
                    }
                        break;
                    case 2:
                    {
                        CouwallaHelpViewController *tCouwallaHelpViewController = [[CouwallaHelpViewController alloc] initWithNibName:@"CouwallaHelpViewController" bundle:nil];
                        tCouwallaHelpViewController.mCouwallaHelpType = kPrivacyPolicyHelp;
                        [self.navigationController pushViewController:tCouwallaHelpViewController animated:YES];
                    }
                        break;
                }

            }
            else
            {
                [self saveProfileAction:nil];
                didSelectRowTag = indexPath.row+1;
            }
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //tableFooterView
    {
        
        UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,60)];
        [tableFooterView setBackgroundColor:[UIColor clearColor]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setBackgroundImage:[[UIImage imageNamed:@"logout_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(85, 0, 160, 60)];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[button setTitle:@"Logout" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [tableFooterView addSubview:button];
        if(section==2)
            return  tableFooterView;
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 2)     return 50;
    else                return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *tSectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (tSectionTitle == nil)
    {
        return nil;
    }
    UILabel *tSectionTitleLabel = [[UILabel alloc] init];
    if(section == 0)
    {
        tSectionTitleLabel.frame = CGRectMake(15, 6, 300, 20);
    }
    else
    {
        tSectionTitleLabel.frame = CGRectMake(15, 0, 300, 20);
        
    }
    tSectionTitleLabel.backgroundColor = [UIColor clearColor];
    tSectionTitleLabel.textColor = [UIColor appGreenColor];
    tSectionTitleLabel.shadowColor = [UIColor whiteColor];
    tSectionTitleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    tSectionTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    tSectionTitleLabel.text = tSectionTitle;
    
    UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    [tView addSubview:tSectionTitleLabel];
    return tView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)     return 30;
    else                return 25;
}


- (BOOL) characterValidation:(NSString *)pTextFieldValue characterSet:(NSCharacterSet *)pCharSet
{
    BOOL rIsVaild;
    NSRange location = [pTextFieldValue rangeOfCharacterFromSet:pCharSet];
    if (location.location != NSNotFound) {
        rIsVaild = false;
    } else {
        rIsVaild = true;
    }
    return rIsVaild;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    IQDropDownTextField *dropTextField = ([textField isKindOfClass:[IQDropDownTextField class]])?(IQDropDownTextField*)textField:nil;
    
    NSMutableArray *tObjectArray = [mItemArrayDictionary objectForKey:kSection1];
    
    NSString *textFieldText=textField.text;
    
    flagForUpdate=0;
 
    switch (textField.tag)
    {
        case 100:
        {
            if(![[dataForUpdate valueForKey:@"First Name"]isEqualToString:textFieldText])
                flagForUpdate=1;
            
            ProfileItem *tProfileItem = [tObjectArray objectAtIndex:0];
            tProfileItem.mValue = textField.text;
        }
            break;
        case 101:
        {
            if(![[dataForUpdate valueForKey:@"Last Name"]isEqualToString:textFieldText])
                flagForUpdate=1;
            
            ProfileItem *tProfileItem = [tObjectArray objectAtIndex:1];
            tProfileItem.mValue = textField.text;
        }
            break;
        case 102:
        {
            if(![[dataForUpdate valueForKey:@"DOB"]isEqualToString:textFieldText])
            flagForUpdate=1;
            
            NSLog(@"%@",dropTextField.selectedItem);
            if (dropTextField.selectedItem == nil)
                dropTextField.selectedItem = [dropTextField.dropDownDateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:0]];
            ProfileItem *tProfileItem = [tObjectArray objectAtIndex:2];
            if ([dropTextField.selectedItem isEqualToString:@"Select"])
            {
                textField.text = @"";
                tProfileItem.mValue = [dataForUpdate valueForKey:@"DOB"];
            }
            else
            {
                tProfileItem.mValue = textField.text;
            }
        }
            break;
        case 103:
        {
            if(![[dataForUpdate valueForKey:@"Sex"]isEqualToString:textFieldText])
            flagForUpdate=1;
            
            if (dropTextField.selectedItem == nil)
                dropTextField.selectedItem = [dropTextField.itemList firstObject];
            
            ProfileItem *tProfileItem = [tObjectArray objectAtIndex:3];
            if ([dropTextField.selectedItem isEqualToString:@"Select"])
            {
                textField.text = @"";
                tProfileItem.mValue = [dataForUpdate valueForKey:@"Sex"];
            }
            else
            {
                tProfileItem.mValue = textField.text;
            }
        }
            break;
        case 104:
        {
            if(![[dataForUpdate valueForKey:@"Ethnicity"]isEqualToString:textFieldText])
                flagForUpdate=1;
            
            if (dropTextField.selectedItem == nil)
                dropTextField.selectedItem = [dropTextField.itemList firstObject];
            
            ProfileItem *tProfileItem = [tObjectArray objectAtIndex:4];
            if ([dropTextField.selectedItem isEqualToString:@"Select"])
            {
                textField.text = @"";
                tProfileItem.mValue = [dataForUpdate valueForKey:@"Ethnicity"];
            }
            else
            {
                tProfileItem.mValue = textField.text;
            }
        }
            break;
        case 105:
        {
            if(![[dataForUpdate valueForKey:@"Marital Status"]isEqualToString:textFieldText])
                flagForUpdate=1;
            
            if (dropTextField.selectedItem == nil)
                dropTextField.selectedItem = [dropTextField.itemList firstObject];
            
            ProfileItem *tProfileItem = [tObjectArray objectAtIndex:5];
            if ([dropTextField.selectedItem isEqualToString:@"Select"])
            {
                textField.text = @"";
                tProfileItem.mValue = [dataForUpdate valueForKey:@"Marital Status"];
            }
            else
            {
                tProfileItem.mValue = textField.text;
            }
        }
            break;
        case 106:
        {
            if(![[dataForUpdate valueForKey:@"Email"]isEqualToString:textFieldText])
                flagForUpdate=1;
            
            ProfileItem *tProfileItem = [tObjectArray objectAtIndex:6];
            tProfileItem.mValue = textField.text;
        }
            break;
        case 107:
        {
            if(![[dataForUpdate valueForKey:@"State"]isEqualToString:textFieldText])
                flagForUpdate=1;
            
            if (dropTextField.selectedItem == nil)
                dropTextField.selectedItem = [dropTextField.itemList firstObject];
            
            ProfileItem *tProfileItem = [tObjectArray objectAtIndex:7];
            if ([dropTextField.selectedItem isEqualToString:@"Select"])
            {
                textField.text = @"";
                tProfileItem.mValue = [dataForUpdate valueForKey:@"State"];
            }
            else
            {
                tProfileItem.mValue = textField.text;
            }
        }
            break;
        case 108:
        {
            if(![[dataForUpdate valueForKey:@"Zip"]isEqualToString:textFieldText])
                flagForUpdate=1;
            
            ProfileItem *tProfileItem = [tObjectArray objectAtIndex:8];
            tProfileItem.mValue = textField.text;
            NSLog(@"%@",tProfileItem);
        }
            break;
        case 109:
        {
            if(![[dataForUpdate valueForKey:@"No. of Children"]isEqualToString:textFieldText])
                flagForUpdate=1;
            
            if (dropTextField.selectedItem == nil)
                dropTextField.selectedItem = [dropTextField.itemList firstObject];
            
            ProfileItem *tProfileItem = [tObjectArray objectAtIndex:9];
            if ([dropTextField.selectedItem isEqualToString:@"Select"])
            {
                textField.text = @"";
                tProfileItem.mValue = [dataForUpdate valueForKey:@"No. of Children"];
            }
            else
            {
                tProfileItem.mValue = textField.text;
            }
        }
            break;
        case 110:
        {
            if(![[dataForUpdate valueForKey:@"Have Pets"]isEqualToString:textFieldText])
                flagForUpdate=1;
            
            if (dropTextField.selectedItem == nil)
                dropTextField.selectedItem = [dropTextField.itemList firstObject];
            
            ProfileItem *tProfileItem = [tObjectArray objectAtIndex:10];
            if ([dropTextField.selectedItem isEqualToString:@"Select"])
            {
                textField.text = @"";
                tProfileItem.mValue = [dataForUpdate valueForKey:@"Have Pets"];
            }
            else
            {
                tProfileItem.mValue = textField.text;
            }
        }
            break;
        case 111:
        {
            if(![[dataForUpdate valueForKey:@"Yearly Income"]isEqualToString:textFieldText])
                flagForUpdate=1;
            
            if (dropTextField.selectedItem == nil)
                dropTextField.selectedItem = [dropTextField.itemList firstObject];
            
            ProfileItem *tProfileItem = [tObjectArray objectAtIndex:11];
            if ([dropTextField.selectedItem isEqualToString:@"Select"])
            {
                textField.text = @"";
                tProfileItem.mValue = [dataForUpdate valueForKey:@"Yearly Income"];
            }
            else
            {
                tProfileItem.mValue = textField.text;
            }
        }
            break;
        case 112:
        {
            if(![[dataForUpdate valueForKey:@"Education"]isEqualToString:textFieldText])
                flagForUpdate=1;
            
            if (dropTextField.selectedItem == nil)
                dropTextField.selectedItem = [dropTextField.itemList firstObject];
            
            ProfileItem *tProfileItem = [tObjectArray objectAtIndex:12];
            if ([dropTextField.selectedItem isEqualToString:@"Select"])
            {
                textField.text = @"";
                tProfileItem.mValue = [dataForUpdate valueForKey:@"Education"];
            }
            else
            {
                tProfileItem.mValue = textField.text;
            }
        }
            break;
        case 113:
        {
            if(![[dataForUpdate valueForKey:@"Smoker"]isEqualToString:textFieldText])
                flagForUpdate=1;
            
            if (dropTextField.selectedItem == nil)
                dropTextField.selectedItem = [dropTextField.itemList firstObject];
            
            ProfileItem *tProfileItem = [tObjectArray objectAtIndex:13];
            if ([dropTextField.selectedItem isEqualToString:@"Select"])
            {
                textField.text = @"";
                tProfileItem.mValue = [dataForUpdate valueForKey:@"Smoker"];
            }
            else
            {
                tProfileItem.mValue = textField.text;
            }
        }
            break;
        case 114:
        {
           
            if(![[dataForUpdate valueForKey:@"Boat Owner"]isEqualToString:textFieldText])
                flagForUpdate=1;
            
            if (dropTextField.selectedItem == nil)
                dropTextField.selectedItem = [dropTextField.itemList firstObject];
            
            ProfileItem *tProfileItem = [tObjectArray objectAtIndex:14];
            if ([dropTextField.selectedItem isEqualToString:@"Select"])
            {
                textField.text = @"";
                tProfileItem.mValue = [dataForUpdate valueForKey:@"Boat Owner"];
            }
            else
            {
                tProfileItem.mValue = textField.text;
            }
        }
            break;
        case 115:
        {
            if(![[dataForUpdate valueForKey:@"Cruises"]isEqualToString:textFieldText])
                flagForUpdate=1;
            
            if (dropTextField.selectedItem == nil)
                dropTextField.selectedItem = [dropTextField.itemList firstObject];
            
            ProfileItem *tProfileItem = [tObjectArray objectAtIndex:15];
            
            if ([dropTextField.selectedItem isEqualToString:@"Select"])
            {
                textField.text = @"";
                tProfileItem.mValue = [dataForUpdate valueForKey:@"Cruises"];
            }
            else
            {
                tProfileItem.mValue = textField.text;
            }
        }
            break;
            
        default:
            break;
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 108)
    {
        NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        return (([str length] <= 9) || [textField.text length]>[str length]);
    }
    else
    {
        return YES;
    }
}

-(void)logoutAction:(UIButton*)button
{
    //tIsMarked = NO;
    UIActionSheet *tActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Logout" otherButtonTitles:nil];
    tActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [tActionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //Logout Facebook
        if(flagForUpdate)
        [self saveProfileAction:nil];
        [FBSession.activeSession closeAndClearTokenInformation];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kUsernameKey];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kPasswordKey];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"firstName"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"lastName"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Rowvalue"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loginViewController:nil loginStatus:NO];
    }
}
#pragma mark - Localytics Helper Methods

-(NSString *)ageFromBirthDate:(NSDate *)birthDate
{
    NSDate *currentDate=[NSDate date];
    NSDateComponents *dateComponents=[[NSCalendar currentCalendar] components:NSYearCalendarUnit
                                                                     fromDate:birthDate
                                                                       toDate:currentDate
                                                                      options:0];
    NSInteger age=[dateComponents year];
    return [NSString stringWithFormat:@"%d",age];
}

#pragma mark - alertviewdeleget
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        switch (didSelectRowTag)
        {
            case 1:
            {
                CouwallaHelpViewController *tCouwallaHelpViewController = [[CouwallaHelpViewController alloc] initWithNibName:@"CouwallaHelpViewController" bundle:nil];
                tCouwallaHelpViewController.mCouwallaHelpType = kFAQHelp;
                [self.navigationController pushViewController:tCouwallaHelpViewController animated:YES];
            }
                break;
            case 2:
            {
                CouwallaHelpViewController *tCouwallaHelpViewController = [[CouwallaHelpViewController alloc] initWithNibName:@"CouwallaHelpViewController" bundle:nil];
                tCouwallaHelpViewController.mCouwallaHelpType = kTermsOFServiceHelp;
                [self.navigationController pushViewController:tCouwallaHelpViewController animated:YES];
            }
                break;
            case 3:
            {
                CouwallaHelpViewController *tCouwallaHelpViewController = [[CouwallaHelpViewController alloc] initWithNibName:@"CouwallaHelpViewController" bundle:nil];
                tCouwallaHelpViewController.mCouwallaHelpType = kPrivacyPolicyHelp;
                [self.navigationController pushViewController:tCouwallaHelpViewController animated:YES];
            }
                break;
        }
        if(didSelectRowTag==0)
            menuButton.selected = YES;
    }
}


@end
