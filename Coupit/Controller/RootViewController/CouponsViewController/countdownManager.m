//
//  countdownManager.m
//  Coupit
//
//  Created by Canopus5 on 6/21/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "countdownManager.h"
#import "appcommon.h"

static countdownManager *share;


@implementation countdownManager
{
     NSTimer *timer;
}

double timerInterval = 1.0f;

@synthesize timerDictionaryForSingalCoupon;

+(countdownManager *) shareManeger
{
    if(share==nil)
        share=[[countdownManager alloc] init];
    return share;
}

-(id) init
{
    self = [super init];
    if(self)
    {
        self.timerDictionaryForSingalCoupon=[[NSMutableDictionary alloc]init];
        timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
       // [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

#pragma mark - timer
-(void)onTick:(NSTimer*)time
{
    NSDate *date = [NSDate date];
    [[Location getInstance]calculateCurrentLocation];
    CLLocation *userLocation = [[Location getInstance]getCurrentLocation];
    
    NSArray *locatIDs = [self.timerDictionaryForSingalCoupon allKeys];
    
    NSMutableArray *couponIDS=[[NSMutableArray alloc]init];
    
    for (int i=0 ; i<[locatIDs count]; i++)
    {
        NSDate * date1 = [[self.timerDictionaryForSingalCoupon valueForKey:[locatIDs objectAtIndex:i]] objectAtIndex:0];
        
        CLLocationDistance distance;
        if([[self.timerDictionaryForSingalCoupon valueForKey:[locatIDs objectAtIndex:i]] count]>1)
        {
        CLLocation * oldLocation =[[self.timerDictionaryForSingalCoupon valueForKey:[locatIDs objectAtIndex:i]] objectAtIndex:1];
        
        distance = [oldLocation distanceFromLocation:userLocation];
        }
        
//        NSLog(@"%@",date);
//        NSLog(@"%@",date1);
//       [couponIDS addObject:[locatIDs objectAtIndex:i]];

        if([date1 isEqualToDate:date])
        {
            [couponIDS addObject:[locatIDs objectAtIndex:i]];
        }
        else
        {
            float lc=(distance/1609.344);
            if(lc >5)
            {
                [couponIDS addObject:[locatIDs objectAtIndex:i]];
            }
        }
    }
    
    [self callRedeemService:couponIDS];
}

#pragma mark - call Webservice;
-(void)callRedeemService:(NSMutableArray *)couponIds
{
    for (int i=0; i<[couponIds count]; i++)
    {
        NSMutableDictionary *removeDic = [NSMutableDictionary dictionary];
        
        [removeDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"] forKey:@"userid"];
        [removeDic setObject:[couponIds objectAtIndex:i] forKey:@"couponid"];
        NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/redeem_coupon.php?",BASE_URL];
        
        jsonparse *objJsonparse =[[jsonparse alloc]init];
        
        NSMutableDictionary * reponseData = [[NSMutableDictionary alloc]init];
        
        reponseData = [objJsonparse customejsonParsing:urlString bodydata:removeDic];
        
        NSString *response = [reponseData valueForKey:@"message"];
        NSLog(@"%@",response);
        if([[reponseData valueForKey:@"response"] isEqualToString:@"failure"] && [response isEqualToString:@"Coupon already redeemed"]) 
        {
            NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/remove_from_mycoupon.php?",BASE_URL];
            
            jsonparse *objJsonparse =[[jsonparse alloc]init];
            
            reponseData = [[NSMutableDictionary alloc]init];
            
            reponseData = [objJsonparse customejsonParsing:urlString bodydata:removeDic];
        }
        [self.timerDictionaryForSingalCoupon removeObjectForKey:[couponIds objectAtIndex:i]];
    }
}


+(void)callWebServiceForLocationUpdate
{
//    if([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusDenied || [[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreference])
//    {
    int mSeletedValue = [[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreference];

    NSString  *userkey=[[NSUserDefaults standardUserDefaults] objectForKey:@"logidkey"];
    NSMutableDictionary *profileDic = [NSMutableDictionary dictionary];
    
    if (mSeletedValue==0)
    {
        //      set_user_location?data={“userid”:”155”,”latitude”:”40.542961”,”longitude”:”-74.178261”}
        [profileDic removeAllObjects];
        [[Location getInstance]calculateCurrentLocation];
        CLLocation *userLocation = [[Location getInstance]getCurrentLocation];
        double userLatitude=0,userLongitude=0;
        userLatitude=userLocation.coordinate.latitude;
        userLongitude=userLocation.coordinate.longitude;
//        if(userkey != nil && userLatitude!=0 && userLongitude!=0)
//        {
            [profileDic setObject:userkey forKey:@"userid"];
            [profileDic setObject:[NSString stringWithFormat:@"%f",userLatitude] forKey:@"latitude"];
            [profileDic setObject:[NSString stringWithFormat:@"%f",userLongitude] forKey:@"longitude"];
//        }
    }
    else if (mSeletedValue==1)
    {
        //      set_user_location?data={“userid”:”155”,”zip”:”07706”,”home”:”1”}
        [profileDic removeAllObjects];
        NSString *tZipCode = [[NSUserDefaults standardUserDefaults] objectForKey:kZipCodeLocation];
//        if(userkey != nil && [tZipCode length]>0)
//        {
            [profileDic setObject:userkey forKey:@"userid"];
            [profileDic setObject:tZipCode forKey:@"zip"];
            [profileDic setObject:@"1" forKey:@"home"];
       // }
    }
    else if (mSeletedValue==2)
    {
        //      set_user_location?data={“userid”:”155”,”zip”:”07706”}
        [profileDic removeAllObjects];
        NSString *tZipCode = [[NSUserDefaults standardUserDefaults] objectForKey:kZipCodeLocation];
//        if(userkey != nil && [tZipCode length]>0)
//        {
            [profileDic setObject:userkey forKey:@"userid"];
            [profileDic setObject:tZipCode forKey:@"zip"];
//        }
    }
    
    NSLog(@"CALL FOR %i",mSeletedValue);
    NSLog(@"%@",profileDic);
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/set_user_location?data=",BASE_URL];
    jsonparse *objJsonparse =[[jsonparse alloc]init];
    NSDictionary *profileData = [objJsonparse customejsonParsing:urlString bodydata:profileDic];
    NSLog(@"result of set_user_location?data= : %@",profileData);
    
//    }
//    else
//    {
//        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:kLocationMassageForCoupons delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [servicesDisabledAlert show];
//       
//    }

}



@end
