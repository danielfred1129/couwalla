//
//  AppDelegate.m
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"
#import "RightMenuViewController.h"
#import "CouponsViewController.h"
#import "Location.h"
#import "Card.h"
#import "FileUtils.h"
#import "GiftCards.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LocalyticsSession.h"
#import "IQkeyboardManager.h"

#import "NewLoginViewController.h"
#import "GTScrollNavigationBar.h"
#import "PWBaseNavigationController.h"
#import <AppiaSDK/AIAppia.h>

#import "SplashViewController.h"


//Canopus Facebook Test ID:-    315208965298488

//Original Bundle ID:-          com.couwalla.iphone
//Facebook App ID:-             826894197338612
//Facebook Development ID:-     837410252953673

@implementation AppDelegate
{
    MenuViewController *mMenuViewController;
    RightMenuViewController *rightMenuViewController;
}

@synthesize mObjRevealController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

-(void)applyAppearanceProxy
{
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor],[UIFont boldSystemFontOfSize:20]: NSFontAttributeName}];

    // Create image for navigation background - portrait
    UIImage *NavigationPortraitBackground = [UIImage imageNamed:@"header_BG"];
    
    // Set the background image all UINavigationBars
    [[UINavigationBar appearance] setBackgroundImage:NavigationPortraitBackground forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:1 forBarMetrics:UIBarMetricsDefault];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self applyAppearanceProxy];
   
//    [[IQKeyboardManager sharedManager] setEnable:NO];
    
//    [TestFlight takeOff:@"b0e2e5b0-2c8b-4227-be4a-cd3911884dad"];
 //   [TestFlight takeOff:@"1e6aa4b2-f813-4453-abcd-b0c3e00769ec"];
    
     
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[NSUserDefaults standardUserDefaults] setObject:@"US" forKey:kCountryCode];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    [GMSServices provideAPIKey:kGoogleMapAPIKey];
    [[Location getInstance] calculateCurrentLocation];
    [FBProfilePictureView class];
    [self saveCategoryList];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSMutableString* checkRememberSkip=[[NSMutableString alloc]init];
    checkRememberSkip=[[NSUserDefaults standardUserDefaults] objectForKey:@"rememberSkip"];
    
//    [self loginViewController:nil loginStatus:([[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"] != nil)];
    
    
    
    
    SplashViewController *controller=[[SplashViewController alloc] init];
    
    PWBaseNavigationController *navigationController = [[PWBaseNavigationController alloc] initWithNavigationBarClass:[GTScrollNavigationBar class] toolbarClass:nil];
    
    [navigationController setViewControllers:[NSArray arrayWithObjects:controller, nil]];
    
    [UIView transitionFromView:self.window.rootViewController.view toView:navigationController.view duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
        self.window.rootViewController = navigationController;
    }];
        
    [self.window makeKeyAndVisible];
       [[LocalyticsSession shared] startSession:kLocalyticsAPIKey];
    
    [self tagLaunchSource:launchOptions];

    //appia
    AIAppia *appia = [AIAppia sharedInstance];
    appia.siteId = AppiaiD;
    return YES;
}
- (void)tagLaunchSource:(NSDictionary *)launchOptions
{
    NSDictionary *launchMapping = @{
                                    UIApplicationLaunchOptionsURLKey : @"Protocol Handler",
                                    UIApplicationLaunchOptionsSourceApplicationKey : @"Another App",
                                    UIApplicationLaunchOptionsLocalNotificationKey : @"Local Notification",
                                    UIApplicationLaunchOptionsRemoteNotificationKey : @"Push Notification",
                                    UIApplicationLaunchOptionsAnnotationKey: @"Annotation Key",
                                    UIApplicationLaunchOptionsLocationKey : @"Location Event",
                                    UIApplicationLaunchOptionsNewsstandDownloadsKey : @"Newsstand"
                                    };
    NSString *launchMechanism = @"Direct";
    
    if (launchOptions)
    {
        for(NSString *launchKey in launchOptions)
        {
            if (launchMapping[launchKey])
            {
                // Record the friendly name of the launchKey
                launchMechanism = launchMapping[launchKey];
            }
            else
            {
                // Just record the key name for new source types which may be added by Apple
                launchMechanism = launchKey;
            }
            
            break;
        }
    }
    
    [[LocalyticsSession shared] tagEvent:kAppLaunch attributes:@{ kSourceOfLaunch : launchMechanism }];
}

- (void) loginViewController:(LoginViewController *)pController loginStatus:(BOOL)pBool
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (pBool)
    {
        [defaults setBool:YES forKey:@"AchievedFirstSuccess"];
        [defaults synchronize];
        
        CouponsViewController *frontViewController = [[CouponsViewController alloc] init];
        mMenuViewController = [[MenuViewController alloc] init];
        mMenuViewController.mObjCouponsViewController = frontViewController;
        
        RevealController *revealController = [[RevealController alloc] initWithFrontViewController:frontViewController rearViewController:mMenuViewController];
        self.mObjRevealController = revealController;

        [UIView transitionFromView:self.window.rootViewController.view toView:self.mObjRevealController.view duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
            self.window.rootViewController = self.mObjRevealController;
        }];
    }
    else
    {
        [defaults removeObjectForKey:@"logidkey"];
        [defaults synchronize];
        
//        LoginViewController *controller=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:Nil];

//        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        
        NewLoginViewController *controller=[[NewLoginViewController alloc] init];

        PWBaseNavigationController *navigationController = [[PWBaseNavigationController alloc] initWithNavigationBarClass:[GTScrollNavigationBar class] toolbarClass:nil];
    
        [navigationController setViewControllers:[NSArray arrayWithObjects:controller, nil]];
        
        [UIView transitionFromView:self.window.rootViewController.view toView:navigationController.view duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
            self.window.rootViewController = navigationController;
        }];
    }
}

- (UIViewController *) getRootViewController
{
    return self.mObjRevealController.frontViewController;
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
	NSString *tDeviceToken = [deviceToken description];
	tDeviceToken = [tDeviceToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    tDeviceToken = [tDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
	//NSLog(@"My token is: %@", tDeviceToken);
    if (tDeviceToken) {
        [DataManager getInstance].mDeviceToken = tDeviceToken;
    }
    NSString *tPostBody = [NSString stringWithFormat:@"[\"%@\"]", tDeviceToken];
    //NSLog(@"My token is: %@", tPostBody);
    
    [[RequestHandler getInstance] postRequestwithHostURL:kDeviceTokenRequestURL bodyPost:tPostBody delegate:self requestType:kSendDeviceTokenRequest];
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    
    //NSLog(@"Failed to get token, error: %@", error);
}

// Get APNS
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;
{
    //NSLog(@"Notification:%@",userInfo);
    [mMenuViewController notificationDictionary:userInfo];
    [rightMenuViewController notificationDictionary:userInfo];
    
}

// FBSample logic
// If we have a valid session at the time of openURL call, we handle Facebook transitions
// by passing the url argument to handleOpenURL; see the "Just Login" sample application for
// a more detailed discussion of handleOpenURL
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
{
    // attempt to extract a token from the url
    return [[FBSession activeSession] handleOpenURL:url];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // FBSample logic
    // if the app is going away, we close the session object
    [FBSession.activeSession close];
    [[LocalyticsSession shared] close];
    [[LocalyticsSession shared] upload];
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //NSLog(@"Inside handleOpenURL");
    return [[FBSession activeSession] handleOpenURL:url];
    //    if([[LocalyticsSession shared] handleOpenURL:url])
    //        return YES;
    //
    //    //
    //    // Any custom URL logic goes here
    //    //
    //
    //    return NO;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [[LocalyticsSession shared] close];
    [[LocalyticsSession shared] upload];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[LocalyticsSession shared] close];
    [[LocalyticsSession shared] upload];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [[LocalyticsSession shared] resume];
    [[LocalyticsSession shared] upload];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[LocalyticsSession shared] resume];
    [[LocalyticsSession shared] upload];
    
}

//- (void)setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation
//{
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//
//}
/*
 - (void) fetchGiftCardsImages
 {
 for (GiftCards *tGiftCard in [[Repository sharedRepository] fetchAllGiftCards:nil]) {
 
 
 // Front Image
 NSString *tmpFileName = [tGiftCard.mFrontImage lastPathComponent];
 NSString *ftFileName = makeFileName([tGiftCard.mID stringValue], tmpFileName);
 
 
 if (isFileExists(ftFileName)) {
 //[cell.mImageView setImage:[UIImage imageWithContentsOfFile:imageFilePath(fmtFileName)]];
 }
 else{
 [[IconDownloadManager getInstance] setScreen:kGiftCardScreen delegate:self filePath:tGiftCard.mFrontImage iconID:[tGiftCard.mID stringValue] indexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
 
 NSError* error = nil;
 NSString *tFilePath = [[NSString alloc] initWithString:documentsFilePath(kImagePathDownload)];
 NSString *tUniqueFileName = [self pImageFolderName];
 NSString *tSavedImagePath = [tFilePath stringByAppendingPathComponent:[tUniqueFileName stringByAppendingPathExtension:@"jpeg"]];
 
 
 UIImage *tBarCodeImage;
 ZXBarcodeFormat *tFormat = kBarcodeFormatCode128;
 int width = 87;
 int height = 312;
 
 if (tFormat != NULL) {
 ZXMultiFormatWriter* writer = [ZXMultiFormatWriter writer];
 ZXBitMatrix* result = [writer encode:@"123456789"
 format:tFormat
 width:width
 height:height
 error:&error];
 if (result) {
 CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
 tBarCodeImage = [UIImage imageWithCGImage:image scale:NO orientation:UIImageOrientationLeft];
 }else {
 NSString* errorMessage = [error localizedDescription];
 //NSLog(@"Error Message :%@", errorMessage);
 }
 
 NSData *imgData = UIImageJPEGRepresentation(tBarCodeImage, 0.5);
 [imgData writeToFile:tSavedImagePath atomically:NO];
 
 
 Card *tCard = [NSEntityDescription
 insertNewObjectForEntityForName:@"Card"
 inManagedObjectContext:[Repository sharedRepository].context];
 
 tCard.mIsFliped = [NSNumber numberWithBool:NO];
 tCard.mID = [tGiftCard.mID stringValue];
 //NSLog(@"------------cardImageFilePath:%@", imageFilePath(ftFileName));
 
 tCard.mFrontImage = imageFilePath(ftFileName);
 //tCard.mBackImage = imageFilePath(fmtFileName);
 tCard.mCardType = [NSNumber numberWithInt:1];
 tCard.mIsCameraImage = [NSNumber numberWithBool:NO];
 tCard.mCardNumber = tGiftCard.mBarCode;
 tCard.mCardSavings = tGiftCard.mSavings;
 tCard.mBarCodeImage = tSavedImagePath;
 tCard.mHaveBarcodeImage = [NSNumber numberWithBool:YES];
 
 NSError *error;
 [[Repository sharedRepository].context insertObject:tCard];
 [[Repository sharedRepository].context save:&error];
 }
 
 }
 }
 }*/
- (NSString *)pImageFolderName
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    // [dateString stringByAppendingFormat:@"%d",arc4random()%1000];
    return dateString;
}

- (void) saveCategoryList
{
    if (![[Repository sharedRepository] isAllCategoriesLoaded])
    {
        [[RequestHandler getInstance] getRequestURL:kURL_Categories delegate:self requestType:kCategoriesRequest];
    }
    
} 

- (void) iconDownloadManager:(IconDownloadManager *)pIconDownloadManager indexPath:(NSIndexPath *)pIndexPath
{
    
}

- (void) makeSubscriberGetRequestByName
{
    NSString *tUserName = [[NSUserDefaults standardUserDefaults] objectForKey:kUsernameKey];
    //NSLog(@"tUserName- ---*%@*",tUserName);
    

    [[RequestHandler getInstance] getRequestURL:kGetSubscriberByNameURL(tUserName) delegate:self requestType:kSubscriberByNameRequest];
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
    
    if (pRequestType == kSubscriberByNameRequest) {
        if (!pError) {
            
            
        } else {
            UIAlertView *tAlert = [[UIAlertView alloc] initWithTitle:nil message:pError.mMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [tAlert show];
            
        }
    }
    else if (pRequestType == kCategoriesRequest)
    {
        if (!pError) {
            
        } else {
            //NSLog(@"Request Failed:%d | Code:%d | Message:%@",pRequestType, pError.mErrorCode.intValue, pError.mMessage);
        }
    }
    
    
}

- (NSManagedObjectContext *) managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _managedObjectContext;
}

//2
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

//3
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"PhoneBook.sqlite"]];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil URL:storeUrl options:nil error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    
    return _persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

-(NSArray*)getAllPhoneBookRecords
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Card"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Returning Fetched Records
    return fetchedRecords;
}

- (void) fetchGiftCardsImages{}
@end
