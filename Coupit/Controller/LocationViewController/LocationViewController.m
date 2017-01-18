//
//  LocationViewController.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "LocationViewController.h"
#import "AppDelegate.h"
#import "LocalyticsSession.h"

@implementation LocationViewController
{
    UIView *mGestureView;
    UIButton *mMenuButton;
    
    UITextField *mZipCodeTextField;
    NSInteger mSelectedIndex;
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Location";
    mSelectedIndex = -1;
    
    //[self.tableView setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BG_CouponCell"]]];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]]];

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
    //NSLog(@"------->.:%d",mSelectedIndex);

    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[LocalyticsSession shared] tagScreen:kLocationScreen];
}

// kZipCodeLocation
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
    [mZipCodeTextField resignFirstResponder];
}

-(void)menuButtonUnselected {
	mMenuButton.selected = NO;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       // cell.textLabel.text = [NSString stringWithFormat:@"cell:%d",indexPath.row];

    }

    cell.accessoryType = UITableViewCellAccessoryNone;

    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"Use current location";
            
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"Use Home location";
        }
            break;

        case 2:
        {
            
            if (mSelectedIndex == indexPath.row) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                cell.textLabel.text = @"";

                if (mZipCodeTextField == nil) {
                    mZipCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, 260, 40)];
                    mZipCodeTextField.delegate = self;

                    // Border Style None
                    [mZipCodeTextField setBorderStyle:UITextBorderStyleNone];
                    mZipCodeTextField.font = [UIFont systemFontOfSize:17.0];
                    mZipCodeTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                    mZipCodeTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
                    
                    mZipCodeTextField.returnKeyType = UIReturnKeyDone;
                    mZipCodeTextField.placeholder = @"Enter Postal/Zip code";
                    mZipCodeTextField.textAlignment = NSTextAlignmentLeft;
                    mZipCodeTextField.textColor = [UIColor colorWithRed:(72/255.0) green:(72/255.0) blue:(72/255.0) alpha:1.0];
                    mZipCodeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
                    mZipCodeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    mZipCodeTextField.tag = indexPath.row;
                    mZipCodeTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
                    
                    [cell.contentView addSubview:mZipCodeTextField];
                    
                    [mZipCodeTextField becomeFirstResponder];

                }
                
                NSString *tZipCode = [[NSUserDefaults standardUserDefaults] objectForKey:kZipCodeLocation];

                if ([tZipCode length]) {
                    mZipCodeTextField.text = tZipCode;
                }
                
                if (mZipCodeTextField) {
                    [mZipCodeTextField becomeFirstResponder];
                }
                
            }
            else{
                cell.textLabel.text = @"Postal/Zip code";
                if (mZipCodeTextField) {
                    [mZipCodeTextField removeFromSuperview];
                
                }
                
                mZipCodeTextField = nil;
            }
            
        }
            break;
            
        default:
            break;
    }
    
    if (mSelectedIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;

    }
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    LocationPreference tLocationPreference;
    switch (indexPath.row) {
        case kCurrentLocation: {
            [[Location getInstance] calculateCurrentLocation];
            tLocationPreference = kCurrentLocation;
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Current location has been updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];

        }
            break;
        case kHomeLocation: {
            tLocationPreference = kHomeLocation;
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Home location has been updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];

        }
            break;
        case kZipPostalCode: {
            tLocationPreference = kZipPostalCode;

        }
            break;

        default:
            tLocationPreference = kCurrentLocation;
            break;
    }
    
    mSelectedIndex = tLocationPreference;
    //NSLog(@"------->.:%d",mSelectedIndex);

    [[NSUserDefaults standardUserDefaults] setInteger:tLocationPreference forKey:kLocationPreference];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [tableView reloadData];

    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView cancelButtonIndex] == buttonIndex) {
        [self performSelector:@selector(homeScreen) withObject:nil afterDelay:.1];
        
    } 
    
}

- (void) homeScreen {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate loginViewController:nil loginStatus:YES];

}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    static NSCharacterSet *charSet = nil;
    if(!charSet) {
        charSet = [[NSCharacterSet characterSetWithCharactersInString:kNUMERIC] invertedSet];
    }
    NSRange location = [string rangeOfCharacterFromSet:charSet];
    return (location.location == NSNotFound);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text length] < 5) {
        UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:kZipFieldLengthMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlertView show];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kZipCodeLocation];
        [[NSUserDefaults standardUserDefaults]synchronize];

        mZipCodeTextField.text = nil;
        
    } else if ([textField.text length ] > 5){
        UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:kZipFieldLengthMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlertView show];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kZipCodeLocation];
        [[NSUserDefaults standardUserDefaults]synchronize];

        mZipCodeTextField.text = nil;
        
    }else if ([textField.text isEqualToString:@"00000"]){
        UIAlertView *tAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"ZipCode not valid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlertView show];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kZipCodeLocation];
        [[NSUserDefaults standardUserDefaults]synchronize];

        mZipCodeTextField.text = nil;
        
    }
    else if ([textField.text length] == 5){
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:kZipCodeLocation];
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Zip Code has been updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlert show];
        

    }
    
    [textField resignFirstResponder];
    return YES;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}





@end

