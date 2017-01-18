//
//  AppDelegate.h
//  Coupit
//
//  Created by Deepak Kumar on 2/2/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RevealController.h"
#import "LoginViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "RequestHandler.h"
#import "ZXingObjC.h"
#import "PKRevealController.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate, LoginViewControllerDelegate, RequestHandlerDelegate>

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RevealController *mObjRevealController;
@property (strong, nonatomic) PKRevealController *revealControllerrr;
- (UIViewController *) getRootViewController;
-(NSArray*)getAllPhoneBookRecords;
- (void) makeSubscriberGetRequestByName;
- (void) fetchGiftCardsImages;
@end
