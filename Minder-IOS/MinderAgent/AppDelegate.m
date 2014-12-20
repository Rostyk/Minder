//
//  AppDelegate.m
//  MinderAgent
//
//  Created by Garnik Ghazaryan on 5/21/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import "AppDelegate.h"

#import <HockeySDK/HockeySDK.h>
#import "LocationManager.h"
#import "Utils.h"
#import "DataCommunicator.h"
#import "SecureUDID.h"

#import "FTLocationManager.h"

@implementation AppDelegate {
    LocationManager *locManager;
    NSUserDefaults *userDefs;
    UILocalNotification *localNotif;
    DataCommunicator *dataCommunicator;
    FTLocationManager *locationManager;
    UIBackgroundTaskIdentifier background_task;
    BOOL isNotified;
    
    BOOL isConnected;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
//    NSLog(@"Device Token : %@", deviceToken);
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello" message:[NSString stringWithFormat:@"Your device token is:%@",deviceToken] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
    [userDefs setObject:[NSString stringWithFormat:@"%@",deviceToken] forKey:@"deviceToken"];
    [userDefs synchronize];

}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Error push :%@",error);
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
//    
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else{
        [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"User ingo: %@",userInfo);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [self.locationTracker updateLocationToServer];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self validateModes];
    
    userDefs = [NSUserDefaults standardUserDefaults];
    
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else{
        [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }


    
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        application.applicationIconBadgeNumber = 0;
    }
    // Override point for customization after application launch.
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"41870f95b5781bb32247427b1764c4b3"];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator
     authenticateInstallation];


    
    NSString *deviceID = [userDefs objectForKey:@"deviceID"];
    dataCommunicator = [[DataCommunicator alloc] initWithURL:[NSString stringWithFormat:@"http://minderweb.com/device/%@",deviceID]];
    
    
    return YES;
}

-(void) validateModes {
    UIAlertView * alert;
    
    //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The functions of this app are limited because the Background App Refresh is disable."
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    } else{
        
        self.locationTracker = [[LocationTracker alloc]init];
        [self.locationTracker startLocationTracking];
        
        //Send the best location to server every 60 seconds
        //You may adjust the time interval depends on the need of your app.
        NSTimeInterval time = 60.0;
        self.locationUpdateTimer =
        [NSTimer scheduledTimerWithTimeInterval:time
                                         target:self
                                       selector:@selector(updateLocation)
                                       userInfo:nil
                                        repeats:YES];
    }

}

-(void)updateLocation {
    NSLog(@"updateLocation");
    
    [self.locationTracker updateLocationToServer];
}



-(void)locationDidFailToUpdateWithError:(NSError *)error {

}
- (void)applicationWillResignActive:(UIApplication *)application
{

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
//    [locManager updateLocation];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self.locationTracker updateLocationToServer];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    isConnected = [[userDefs  objectForKey:@"connected"] boolValue];
    if (isConnected) {
        localNotif = [[UILocalNotification alloc] init];
        localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.1];
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        localNotif.alertBody = @"Minder is disabled - open Minder to keep app working";
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    }
    
    
    NSLog(@"Terminated");
}

- (NSDictionary*) createJSON {
    
    NSString *deviceModel = [Utils deviceModelName];
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    NSString *UUID = [Utils getUUIDString];
    float latitude =  locationManager.location.coordinate.latitude;
    float longitude = locationManager.location.coordinate.longitude;
    
    NSDictionary *dict = @{ @"device_name" : deviceModel,
                            @"os_version" : osVersion,
                            @"udid" : UUID,
                            @"device_type" : @"iOS",
                            @"last_location" : [NSString stringWithFormat:@"%f, %f",latitude, longitude]
                            };
    
    return dict;
    
}



@end
