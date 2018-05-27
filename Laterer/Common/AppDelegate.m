//
//  AppDelegate.m
//  Laterer
//
//  Created by Nimble Chapps on 02/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "AppDelegate.h"
#import "ReminderListViewController.h"
#import "Notifications.h"
#import "ContactListTableViewController.h"
#import "MainTabBarController.h"
#import "InitialViewController.h"
#import "CDAddressBook.h"
#import "LocationViewController.h"
#import "SIAlertView.h"

@interface AppDelegate ()
{
    Notifications *localNotifications;
    CDAddressBook *myAddressBook;
    
    NSMutableArray *sortedContactList;
    UIStoryboard *storyboard;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    localNotifications = [[Notifications alloc] init];
    
    // User defaults for Message and Time offset
    if (![userDefault integerForKey:@"reminderHours"]) {
        [userDefault setInteger:0 forKey:@"reminderHours"];
    }
    if (![userDefault integerForKey:@"reminderMinutes"]) {
        [userDefault setInteger:30 forKey:@"reminderMinutes"];
    }
    if (![userDefault stringForKey:@"reminderMessage"]) {
        [userDefault setValue:@"Contact " forKey:@"reminderMessage"];
    }
    [userDefault synchronize];
    
    // status bar color
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    float osVersion = [[UIDevice currentDevice].systemVersion floatValue];
    NSLog(@"OS version - %f", osVersion);
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        NSLog(@"Requesting permission for push notifications..."); // iOS 8
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: UIUserNotificationTypeAlert | UIUserNotificationTypeBadge |
                                                UIUserNotificationTypeSound categories:nil];
        [UIApplication.sharedApplication registerUserNotificationSettings:settings];
    }
    else {
        NSLog(@"Registering device for push notifications..."); // iOS 7 and earlier
        [UIApplication.sharedApplication registerForRemoteNotificationTypes: UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
    
    // user phone contact list
    if ([Model getLatereUserId]) {
        [self uploadPhoneContacts];
    }
  
    // setting first view controller
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
//    if ([userDefault objectForKey:kLatererUserID] && [userDefault objectForKey:kLatererUserDetail]) {
    if ([Model getLatereUserId]) {
        
        MainTabBarController *mainTabbarController = [storyboard instantiateViewControllerWithIdentifier:@"MainTabbar"];
        self.navController = [[UINavigationController alloc] initWithRootViewController:mainTabbarController];
        self.window.rootViewController = self.navController;
        [self.window makeKeyAndVisible];
    }
    else {
        
        InitialViewController *initialVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        self.navController = [[UINavigationController alloc] initWithRootViewController:initialVC];
        self.window.rootViewController = self.navController;
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    [self saveContext];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)settings
{
    NSLog(@"Registering device for push notifications..."); // iOS 8
    [application registerForRemoteNotifications];
}


// Remote Notification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);
    NSString* newToken = [[[NSString stringWithFormat:@"%@",deviceToken]
                           stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@",newToken);
    
    newToken.length ? [userDefault setObject:newToken forKey:kDeviceToken] :[userDefault setObject:@"12345678" forKey:kDeviceToken] ;
    [userDefault synchronize];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Did Fail to Register for Remote Notifications");
    [userDefault setObject:@"12345678" forKey:kDeviceToken];
    [userDefault synchronize];
    NSLog(@"%@, %@", error, error.localizedDescription);
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)notification completionHandler:(void(^)())completionHandler
{
    NSLog(@"Received push notification: %@, identifier: %@", notification, identifier); // iOS 8
    completionHandler();
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    /*
     
     {
         "aps" : {
                     "alert" : "Chetan Sent you laterer.",
                     "badge" : 9,
                     "sound" : "bingbong.aiff"
                 },
         "data" :{
                    "fLat" : "%20"
                    "fLong": "%20"
                 }
     }
     
     */
    
    
    NSLog(@"Alert: %@", userInfo);
    NSString *message = [userInfo valueForKeyPath:@"aps.alert"];
    NSLog(@"msg - %@",message);
    
    float fLat = -1, fLong = -1;
    if (! [ userInfo[@"data"][@"fLat"] isEqualToString:@"%20" ]) {
        fLat = [userInfo[@"data"][@"fLat"] floatValue];
    }
    
    if (! [ userInfo[@"data"][@"fLong"] isEqualToString:@"%20" ]) {
        fLong = [userInfo[@"data"][@"fLong"] floatValue];
    }
    
    
    if (fLat != -1 && fLong != -1) {
        
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:__APP_NAME__ andMessage:message];
        
        [alertView addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                              }];
        
        [alertView addButtonWithTitle:@"See Location" type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  
                                  LocationViewController *locationVC = [storyboard instantiateViewControllerWithIdentifier:@"LocationVC"];
                                  locationVC.latitude = fLat;
                                  locationVC.longitude = fLong;
                                  [self.navController presentViewController:locationVC animated:YES completion:nil];
                              }];
        
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        [alertView show];
        
    } else {
        
        showAlertViewWithMessage(message);
    }
}

// Local notification
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"" andMessage:notification.alertBody];
    
    [alertView addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              
                              [[UIApplication sharedApplication] cancelLocalNotification:notification];
                              [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationFired" object:nil];
                          }];
    
    [alertView addButtonWithTitle:@"Laterer" type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              
                              NSDateFormatter *format = [[NSDateFormatter alloc] init];
                              [format setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
                              NSDate *oldNotificationDate = [NSDate date];
                              NSTimeInterval secondsForReminder = 30 * 60;
                              NSDate *dateTimeForReminder = [oldNotificationDate dateByAddingTimeInterval:secondsForReminder];
                              NSString *key = [format stringFromDate:dateTimeForReminder];
                              
                              [localNotifications scheduleNotificationsWith:dateTimeForReminder AlertMsg:notification.alertBody andIdentification:key
                                                                   UserInfo:notification.userInfo[@"data"]];
                              
                              [[UIApplication sharedApplication] cancelLocalNotification:notification];
                              [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationFired" object:nil];
                              
                          }];
    
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}


-(void) uploadPhoneContacts {
    
    // upload user contacts for laterer
    
    myAddressBook = [[CDAddressBook alloc]init];
    sortedContactList = [myAddressBook getSortedContactList];
    
    NSLog(@"contact uploading");
    NSMutableArray *contactsToUpload = [[NSMutableArray alloc] init];
    [sortedContactList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSArray *phones;
        NSArray *emails;
        if (obj[@"phones"] != [NSNull null]) { phones = obj[@"phones"]; } else { phones = nil; }
        if (obj[@"emails"] != [NSNull null]) { emails = obj[@"emails"]; } else { emails = nil; }
        int maxCount = (int) (phones.count > emails.count) ? (int) phones.count : (int) emails.count;
        
        for (int i = 0; i < maxCount; i++) {
            NSString *phone;
            NSString *email;
            if (phones.count > i) { phone = phones[i]; } else { phone = @""; }
            if (emails.count > i) { email = emails[i]; } else { email = @""; }
            
            // Email - Phone pair
            NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys: email, @"vEmail",
                                      removeSpecialCharactersFromPhone(phone), @"vPhoneNumber", nil];
            [contactsToUpload addObject:tempDict];
        }
    }];
    
    // All Contacts with user id
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:contactsToUpload options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dictAllContactList = [[NSMutableDictionary alloc] init];
    [dictAllContactList setObject:jsonString forKey:@"data"];
    [dictAllContactList setObject:[Model getLatereUserId] forKey:@"iUserID"];
        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [PAWSCalls uploadPhoneContactsWithParam:dictAllContactList completionBlock:^(id JSON, WebServiceResult result) {
            
            if (result == WebServiceResultSuccess && [JSON[@"status"] isEqualToString:@"0"]) {
                NSLog(@"%@", JSON[@"message"]);
            } else {
                NSLog(@"%@", JSON[@"message"]);
            }
        }];
    });
}

@end
