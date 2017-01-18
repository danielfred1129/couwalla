//
//  ChangePasswordViewControllerr.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "tJSON.h"
#import "RequestHandler.h"
#import "LoginViewController.h"
#import "RevealController.h"
#import "jsonparse.h"
#import "appcommon.h"

@implementation ChangePasswordViewController
{
    UITextField *mOldPasswordTextField, *mNewPasswordTextField, *mConfirmPasswordTextField;
    ProgressHudPresenter *mHudPresenter;
    NSString *userkey;
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Change PIN";
    mHudPresenter = [ProgressHudPresenter new];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]]];
    
    //Back Button
    UIButton *tBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tBackButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tBackButton sizeToFit];
    [tBackButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tBackBarButton = [[UIBarButtonItem alloc]initWithCustomView:tBackButton];
    self.navigationItem.leftBarButtonItem = tBackBarButton;

}

- (void)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        if (mOldPasswordTextField == nil) {
            
            mOldPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, 300, 30)];
            mOldPasswordTextField.delegate = self;
            mOldPasswordTextField.secureTextEntry = YES;
            // Border Style None
            [mOldPasswordTextField setBorderStyle:UITextBorderStyleNone];
            mOldPasswordTextField.font = [UIFont systemFontOfSize:14.0];
            mOldPasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
            mOldPasswordTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
            mOldPasswordTextField.returnKeyType = UIReturnKeyNext;
            mOldPasswordTextField.placeholder = @"Enter Old PIN";
            mOldPasswordTextField.textAlignment = NSTextAlignmentLeft;
            mOldPasswordTextField.textColor = [UIColor colorWithRed:(72/255.0) green:(72/255.0) blue:(72/255.0) alpha:1.0];
            mOldPasswordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            mOldPasswordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            mOldPasswordTextField.tag = indexPath.row;
            mOldPasswordTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
            
            [cell.contentView addSubview:mOldPasswordTextField];
        }
    }
    else if (indexPath.row == 1){
        if (mNewPasswordTextField == nil) {
            
            mNewPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, 300, 30)];
            mNewPasswordTextField.delegate = self;
            mNewPasswordTextField.secureTextEntry = YES;
            mNewPasswordTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
            [mNewPasswordTextField setBorderStyle:UITextBorderStyleNone];
            mNewPasswordTextField.font = [UIFont systemFontOfSize:14.0];
            mNewPasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
            mNewPasswordTextField.returnKeyType = UIReturnKeyNext;
            mNewPasswordTextField.placeholder = @"Enter New PIN";
            mNewPasswordTextField.textAlignment = NSTextAlignmentLeft;
            mNewPasswordTextField.textColor = [UIColor colorWithRed:(72/255.0) green:(72/255.0) blue:(72/255.0) alpha:1.0];
            mNewPasswordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            mNewPasswordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            mNewPasswordTextField.tag = indexPath.row;
            mNewPasswordTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
            
            [cell.contentView addSubview:mNewPasswordTextField];
            
        }
    }
    else if (indexPath.row == 2){
        if (mConfirmPasswordTextField == nil) {
            
            mConfirmPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, 300, 30)];
            //mNewPasswordTextField.text = savedPassword;
            
            mConfirmPasswordTextField.delegate = self;
            mConfirmPasswordTextField.secureTextEntry = YES;
            mConfirmPasswordTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
            [mConfirmPasswordTextField setBorderStyle:UITextBorderStyleNone];
            mConfirmPasswordTextField.font = [UIFont systemFontOfSize:14.0];
            mConfirmPasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
            mConfirmPasswordTextField.returnKeyType = UIReturnKeyGo;
            mConfirmPasswordTextField.placeholder = @"Confirm New PIN";
            mConfirmPasswordTextField.textAlignment = NSTextAlignmentLeft;
            mConfirmPasswordTextField.textColor = [UIColor colorWithRed:(72/255.0) green:(72/255.0) blue:(72/255.0) alpha:1.0];
            mConfirmPasswordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            mConfirmPasswordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            mConfirmPasswordTextField.tag = indexPath.row;
            mConfirmPasswordTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
            
            [cell.contentView addSubview:mConfirmPasswordTextField];
        }
    }
    

    
    // Configure the cell...
    
    return cell;
}

- (IBAction)changePasswordButton:(id)sender {
    
    if ([mOldPasswordTextField.text length] == 0 || [mNewPasswordTextField.text length] == 0
        || [mConfirmPasswordTextField.text length] == 0 ){
        UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:kTextFieldValidationMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tAlert show];
        return;
    }
    else if([mOldPasswordTextField.text isEqualToString:mNewPasswordTextField.text])
    {
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Old PIN can't match new PIN"] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] show];
        return;
    }
    
    else if ([mNewPasswordTextField.text length] < 4) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:KPasswordlengthmessage delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] show];
        return;
    }

    else if(![mNewPasswordTextField.text isEqualToString:mConfirmPasswordTextField.text]) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Your PINs do not match"] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] show];
        return;
    }
    userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
    
    NSArray *tKeys =    [NSArray arrayWithObjects:@"oldPassword", @"newPassword",@"userid", nil];
    NSArray *tObjects = [NSArray arrayWithObjects:mOldPasswordTextField.text, mNewPasswordTextField.text,userkey,   nil];
    
    NSMutableDictionary *tChangePasswordDict = [NSMutableDictionary dictionaryWithObjects:tObjects forKeys:tKeys];
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/change_password.php",BASE_URL];
    
    jsonparse *objJsonparse =[[jsonparse alloc]init];
    
   NSMutableDictionary *profileData = [[NSMutableDictionary alloc]init];
    
    profileData = [objJsonparse customejsonParsing:urlString bodydata:tChangePasswordDict];
    
    //NSLog(@"%@",profileData);
    
    if ([[profileData valueForKey:@"response"] isEqualToString:@"Success" ]) {
        
        UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:nil message:@"PIN Updated Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [updateAlert show];
        mConfirmPasswordTextField.text=@"";
        mOldPasswordTextField.text=@"";
        mNewPasswordTextField.text=@"";
        
    }
    else
    {
        UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:nil message:@"PIN not changed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [updateAlert show];
        mConfirmPasswordTextField.text=@"";
        mOldPasswordTextField.text=@"";
        mNewPasswordTextField.text=@"";
 
    }
    
    /*
    NSString *jsonRequest = [tChangePasswordDict JSONRepresentation];
    //NSLog(@"jsonRequest for Coupon: %@", jsonRequest);
    [mHudPresenter presentHud];
    [[RequestHandler getInstance] postRequestwithHostURL:KURL_PasswordChange bodyPost:jsonRequest delegate:self requestType:kPassWordChangeRequest];*/
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 4) ? NO : YES;

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
    if (pRequestType == kPassWordChangeRequest) {
            if (!pError) {

            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPasswordKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            LoginViewController *tLoginViewController = [LoginViewController new];
            tLoginViewController.mIsPasswordChange = YES;
            
            UINavigationController *tNavigationController= [[UINavigationController alloc] initWithRootViewController:tLoginViewController];
            [self presentViewController:tNavigationController animated:NO completion:^{
                
            }];
                /*
                RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;

                [self.navigationController popViewControllerAnimated:NO];
                CouponsViewController *tObjCouponsViewController = [CouponsViewController new];

                
                if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[CouponsViewController class]])
                {
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tObjCouponsViewController];
                    
                    [revealController setFrontViewController:navigationController animated:NO];
                }
                else{
                    [revealController revealToggle:nil];
                }
                 */
            
            } else {
                //NSLog(@"Request Failed:%d | Code:%d | Message:%@",pRequestType, pError.mErrorCode.intValue, pError.mMessage);
                
                UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:@"Password not changed" message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [tAlert show];
                
            }
    } 
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == mOldPasswordTextField) {
        [mOldPasswordTextField becomeFirstResponder];
    }
    else if (textField == mNewPasswordTextField) {
        [mNewPasswordTextField becomeFirstResponder];
    }
    else if (textField == mConfirmPasswordTextField){
        [mConfirmPasswordTextField resignFirstResponder];
    }
    
    return YES;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
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

