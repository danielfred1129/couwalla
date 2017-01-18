//
//  NewLocationViewController.m
//  Coupit
//
//  Created by Hashim on 23/06/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "NewLocationViewController.h"
#import "LocalyticsSession.h"
#import "AppDelegate.h"
#import "appcommon.h"
#import "jsonparse.h"
#import "countdownManager.h"

@interface NewLocationViewController ()
{
    UIButton *mMenuButton;
    UITextField *mZipCodeTextField;
    UIView *mGestureView;
    NSInteger mSelectedIndex;
    NSMutableArray *dummyArray;
    NSMutableArray *arrayFroButton;
    NSString *zipValInsideWebService;
    LocationPreference tLocationPreference;

}
@end

static int mSeletedValue;
static int isFirstPresentation;

@implementation NewLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Location";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_side_menu"]]];
    mSeletedValue = [[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreference];
    arrayFroButton=[[NSMutableArray alloc]initWithObjects:_useCurrentLocationButon,_useHomeZipLocationButton,_useOtherZipLocationCode, nil];
    isFirstPresentation=1;
    [self callWebServiceToGetData];

    mMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mMenuButton setImage:[UIImage imageNamed:@"button_menu"] forState:UIControlStateNormal];
    [mMenuButton sizeToFit];
    [mMenuButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
    
    UIBarButtonItem* menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:mMenuButton];
    self.navigationItem.leftBarButtonItem = menuBarButton;
    
    mGestureView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealToggle:)];
    [mGestureView addGestureRecognizer:recognizer];
    
    UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [mGestureView addGestureRecognizer:panRecognizer];
    
    mSelectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreference];
    
    [self initialSetUp];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[LocalyticsSession shared] tagScreen:kLocationScreen];
}

-(void)initialSetUp
{
    [self customizationForButton];

    if (mSeletedValue==0)
    {
        [self selectButtonAction:_useCurrentLocationButon];
    }
    else if(mSeletedValue==1)
    {
        NSString *tZipCode = [[NSUserDefaults standardUserDefaults] objectForKey:kZipCodeLocation];
        
        if ([tZipCode length])
        {
            _textFieldHomeZip.text = tZipCode;
            [_textFieldHomeZip setHidden:NO];
            [_labelHomeZipCode setHidden:YES];
            [_useHomeZipLocationButton setImage:[UIImage imageNamed:@"select_checked.png"] forState:UIControlStateNormal];
            tLocationPreference=kHomeLocation;
            [_useHomeZipLocationButton setTitle:@"√" forState:UIControlStateNormal];
            isFirstPresentation=0;
            
        }
        
    }else if(mSeletedValue==2)
    {
        
        NSString *tZipCode = [[NSUserDefaults standardUserDefaults] objectForKey:kZipCodeLocation];
        
        if ([tZipCode length]) {
            _textFieldOtherZip.text = tZipCode;
            [_textFieldOtherZip setHidden:NO];
            [_labelOtherZipCode setHidden:YES];
            [_useOtherZipLocationCode setImage:[UIImage imageNamed:@"select_checked.png"] forState:UIControlStateNormal];
            tLocationPreference=kZipPostalCode;
            [_useOtherZipLocationCode setTitle:@"√" forState:UIControlStateNormal];
            isFirstPresentation=0;

        }
    }
    else
    {
        [self selectButtonAction:_useCurrentLocationButon];
    }
    [[_textFieldOtherZip layer] setBorderWidth:0.5];
    [[_textFieldOtherZip layer]setBorderColor:[UIColor whiteColor].CGColor];
    [[_textFieldHomeZip layer] setBorderWidth:0.5];
    [[_textFieldHomeZip layer]setBorderColor:[UIColor whiteColor].CGColor];
  
   
    [countdownManager callWebServiceForLocationUpdate];

}

-(void)customizationForButton
{
    _useCurrentLocationButon.layer.cornerRadius = _useCurrentLocationButon.bounds.size.height/2;
    [_useCurrentLocationButon.layer setBorderWidth:0.5];
    [_useCurrentLocationButon.layer setBorderColor:[UIColor whiteColor].CGColor];
    _useCurrentLocationButon.layer.masksToBounds = YES;
    
    _useHomeZipLocationButton.layer.cornerRadius = _useCurrentLocationButon.bounds.size.height/2;
    [_useHomeZipLocationButton.layer setBorderWidth:0.5];
    [_useHomeZipLocationButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    _useHomeZipLocationButton.layer.masksToBounds = YES;
    
    _useOtherZipLocationCode.layer.cornerRadius = _useCurrentLocationButon.bounds.size.height/2;
    [_useOtherZipLocationCode.layer setBorderWidth:0.5];
    [_useOtherZipLocationCode.layer setBorderColor:[UIColor whiteColor].CGColor];
    _useOtherZipLocationCode.layer.masksToBounds = YES;
    
    
    [_useCurrentLocationButon setTitle:@" " forState:UIControlStateNormal];
    [_useHomeZipLocationButton setTitle:@" " forState:UIControlStateNormal];
    [_useOtherZipLocationCode setTitle:@" " forState:UIControlStateNormal];
}

-(IBAction)selectButtonAction:(UIButton *)sender
{
    tLocationPreference=kCurrentLocation;
    UIButton *button = (UIButton*)sender;
    if(dummyArray==nil) dummyArray=[[NSMutableArray alloc]init];
    [dummyArray removeAllObjects];
    [dummyArray addObjectsFromArray:arrayFroButton];
    
    switch (button.tag)
    {
        case 1:
            
            if ([sender.titleLabel.text isEqualToString:@" "])
            {
                
                [sender setTitle:@"√" forState:UIControlStateNormal];
                [sender setImage:[UIImage imageNamed:@"select_checked.png"] forState:UIControlStateNormal];
                
                
                [[Location getInstance] calculateCurrentLocation];
                tLocationPreference = kCurrentLocation;
                if(!isFirstPresentation)
                {
                    
                    UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Current location has been updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [tAlert show];
                    
                }
                [_textFieldOtherZip setHidden:YES];
                [_textFieldOtherZip setText:@""];
                [_labelOtherZipCode setHidden:NO];
                isFirstPresentation=0;
                
                
            }else if ([sender.titleLabel.text isEqualToString:@"√"]) {
                
                
            }
            
            break;
            
        case 2:
            if ([sender.titleLabel.text isEqualToString:@" "]) {
                
                [sender setTitle:@"√" forState:UIControlStateNormal];
                [sender setImage:[UIImage imageNamed:@"select_checked.png"] forState:UIControlStateNormal];
                [_textFieldHomeZip setHidden:NO];
                [_labelHomeZipCode setHidden:YES];
                
                [_textFieldOtherZip setHidden:YES];
                [_textFieldOtherZip setText:@""];
                [_labelOtherZipCode setHidden:NO];
                
                [self setHomeZip];
                isFirstPresentation=0;

                
            }else if ([sender.titleLabel.text isEqualToString:@"√"])
            {
                
                
            }
            
            break;
            
        case 3:
            if ([sender.titleLabel.text isEqualToString:@" "]) {
                
                [sender setTitle:@"√" forState:UIControlStateNormal];
                [sender setImage:[UIImage imageNamed:@"select_checked.png"] forState:UIControlStateNormal];
                [_textFieldOtherZip setHidden:NO];
                [_labelOtherZipCode setHidden:YES];
                
                [_textFieldHomeZip setHidden:YES];
                [_textFieldHomeZip setText:@""];
                [_labelHomeZipCode setHidden:NO];
                
                tLocationPreference = kZipPostalCode;
                isFirstPresentation=0;

                
            }else if ([sender.titleLabel.text isEqualToString:@"√"]) {
                
            }
            break;
    }

    [dummyArray removeObject:sender];
    [self settingForUnSelectedButton:dummyArray];
}

-(void)settingForUnSelectedButton:(NSMutableArray *)btnArray
{
    for (UIButton *btn in btnArray) {
        [btn setImage:[UIImage imageNamed:@"select_none.png"] forState:UIControlStateNormal];
        [btn setTitle:@" " forState:UIControlStateNormal];
    }
}

- (void) homeScreen
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate loginViewController:nil loginStatus:YES];
    
}

-(void)setHomeZip
{
    if(!isFirstPresentation)
    {
        
        if([zipValInsideWebService isEqualToString:@"0"] || [zipValInsideWebService isEqualToString:nil])
        {
            
            
        }
        else
        {
            tLocationPreference = kHomeLocation;
            [_textFieldHomeZip setText:zipValInsideWebService];
            [[NSUserDefaults standardUserDefaults]setValue:zipValInsideWebService forKeyPath:@"zipValueinSetting"];
            [[NSUserDefaults standardUserDefaults] setObject:_textFieldHomeZip.text forKey:kZipCodeLocation];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [[[UIAlertView alloc] initWithTitle:nil message:@"Home location has been updated." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
        
    }

}

#pragma -mark UITextFieldDelegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (!([textField.text length] == 5 || [textField.text length] == 9))
    {
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:kZipFieldLengthMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlert show];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kZipCodeLocation];
//        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    else if ([textField.text isEqualToString:@"00000"])
    {
        UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"ZipCode not valid." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlertView show];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kZipCodeLocation];
//        [[NSUserDefaults standardUserDefaults]synchronize];
        
        textField.text = nil;
        
    }
    else if (![self isValidNumericZip:textField.text])
    {
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"ZipCode not valid." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlert show];
    }
    else
    {
        if([textField isEqual:_textFieldHomeZip])
        {
            [[NSUserDefaults standardUserDefaults]setValue:_textFieldHomeZip.text forKeyPath:@"zipValueinSetting"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setValue:@"" forKeyPath:@"zipValueinSetting"];
        }
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:kZipCodeLocation];
        [[NSUserDefaults standardUserDefaults]synchronize];
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Zip Code has been updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlert show];
        
    }
    
    [textField resignFirstResponder];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)isValidNumericZip:(NSString *)zipCode
{
    BOOL valid;
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:zipCode];
    valid = [alphaNums isSupersetOfSet:inStringSet];
    return valid;
}

#pragma -mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSUserDefaults standardUserDefaults] setInteger:tLocationPreference forKey:kLocationPreference];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
        [countdownManager callWebServiceForLocationUpdate];
    
    [self performSelector:@selector(homeScreen) withObject:nil afterDelay:.1];

}

#pragma mark- -WebService-
-(void)callWebServiceToGetData
{
    NSString  *userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
    NSMutableDictionary *profileDic = [NSMutableDictionary dictionary];
    if(userkey != nil)  [profileDic setObject:userkey forKey:@"userid"];
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/get_myprofile_data.php?",BASE_URL];
    
    jsonparse *objJsonparse =[[jsonparse alloc]init];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityView startAnimating];
    
    NSDictionary *profileData = [objJsonparse customejsonParsing:urlString bodydata:profileDic];
    NSArray *profilearray = [profileData valueForKey:@"data"];
    
    NSDictionary * dictionary = [profilearray firstObject];
    zipValInsideWebService=[dictionary objectForKey:@"Zip"]?[dictionary objectForKey:@"Zip"]:@"";
}


@end
