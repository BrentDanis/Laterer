//
//  Notifications.m
//  ToDoList
//
//  Created by Rajiv Patil on 14/11/11.
//  Copyright 2011 Capgemini. All rights reserved.
//

#import "Notifications.h"

@implementation Notifications

// repeatInterval:(NSCalendarUnit )calenderUnit
-(void)scheduleNotificationsWith:(NSDate *)fireDate AlertMsg:(NSString *)alertBody andIdentification:(NSString *)Id UserInfo:(NSDictionary *)userInfo {
    
    // set user info
    NSMutableDictionary *dictUserInfo = [[NSMutableDictionary alloc]init];
    [dictUserInfo setValue:Id forKey:@"Id"];
    [dictUserInfo setValue:userInfo forKey:@"data"];
    
    UILocalNotification *notification = [[UILocalNotification alloc]init] ;
    notification.userInfo = dictUserInfo;
    notification.fireDate = fireDate;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.alertBody = alertBody;
    notification.soundName = @"Test.caf";
    notification.hasAction = YES;
    notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    notification.category = @"latererNotification";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}


-(void)scheduleNotificationsWith:(NSDate *)fireDate
                        AlertMsg:(NSString *)alertBody
               andIdentification:(NSString *)Id
                        UserInfo:(NSDictionary *)userInfo
           withCompletionHandler:(void (^)(void))completionHandler {

    // set user info
    NSMutableDictionary *dictUserInfo = [[NSMutableDictionary alloc]init];
    [dictUserInfo setValue:Id forKey:@"Id"];
    [dictUserInfo setValue:userInfo forKey:@"data"];
    
    UILocalNotification *notification = [[UILocalNotification alloc]init] ;
    notification.userInfo = dictUserInfo;
    notification.fireDate = fireDate;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.alertBody = alertBody;
    notification.soundName = @"Test.caf";
    notification.hasAction = YES;
    notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    notification.category = @"latererNotification";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    completionHandler();
}


-(void)scheduleNotificationsWith:(NSDate *)fireDate AlertMsg:(NSString *)alertBody title:(NSString *)title soundName:(NSString *)soundName andIdentification:(NSString *)Id withImageName:(NSString *)imgName repeatInterval:(NSCalendarUnit )calenderUnit{
    
    UILocalNotification *notificationToCancel=nil;
    
    for(UILocalNotification *aNotif in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if([[aNotif.userInfo objectForKey:@"Id"] isEqualToString:Id]) {
            notificationToCancel=aNotif;
            break;
        }
    }
    
    if(notificationToCancel)[[UIApplication sharedApplication] cancelLocalNotification:notificationToCancel];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
    [userInfo setValue:Id forKey:@"Id"];
    [userInfo setValue:imgName forKey:@"selectedImage"];
    [userInfo setValue:title forKey:@"title"];

    UILocalNotification *notification = [[UILocalNotification alloc]init] ;
    notification.repeatInterval = calenderUnit;
    notification.userInfo = userInfo;
    notification.fireDate = fireDate;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.alertBody = alertBody;
//    notification.soundName =@"Zen1.mp3";
    notification.soundName =soundName;
    notification.alertAction = @"alert alarm";
    notification.hasAction = YES;
    notification.applicationIconBadgeNumber = 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}



-(void)cancelNotificationforId:(NSString *)Id
{
    
    UILocalNotification *notificationToCancel=nil;
    
    for(UILocalNotification *aNotif in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if([[aNotif.userInfo objectForKey:@"Id"] isEqualToString:Id]) {
            notificationToCancel=aNotif;
            break;
        }
    }
    if(notificationToCancel)[[UIApplication sharedApplication] cancelLocalNotification:notificationToCancel];
    
}


-(void)scheduleNotificationsToReapeatContinuousWith:(NSDate *)fireDate AlertMsg:(NSString *)alertBody title:(NSString *)title soundName:(NSString *)soundName andIdentification:(NSString *)Id withImageName:(NSString *)imgName
{
    if ([Id rangeOfString:@"#"].location == NSNotFound) {
        [self scheduleNotificationsWith:fireDate AlertMsg:alertBody title:title soundName:soundName andIdentification:Id withImageName:imgName repeatInterval:NSCalendarUnitMinute];
        [self scheduleNotificationsWith:[NSDate dateWithTimeInterval:30 sinceDate:fireDate] AlertMsg:alertBody title:title soundName:soundName andIdentification:[NSString stringWithFormat:@"%@#",Id] withImageName:imgName repeatInterval:NSCalendarUnitMinute];

    }
    else
    {
        [self scheduleNotificationsWith:fireDate AlertMsg:alertBody title:title soundName:soundName andIdentification:Id withImageName:imgName repeatInterval:NSCalendarUnitMinute];
        [self scheduleNotificationsWith:[NSDate dateWithTimeInterval:30 sinceDate:fireDate] AlertMsg:alertBody title:title soundName:soundName andIdentification:[Id stringByReplacingOccurrencesOfString:@"#" withString:@""] withImageName:imgName repeatInterval:NSCalendarUnitMinute];
    }

    
//     NSLog(@"schedule notification.m:%@",   [[UIApplication sharedApplication] scheduledLocalNotifications]);
}

-(void)cancelNotificationRepeatedContinuesforId:(NSString *)Id
{
    if ([Id rangeOfString:@"#"].location == NSNotFound) {
        [self cancelNotificationforId:Id];
        [self cancelNotificationforId:[NSString stringWithFormat:@"%@#",Id]];
    }
    else
    {
        [self cancelNotificationforId:Id];
        [self cancelNotificationforId:[Id stringByReplacingOccurrencesOfString:@"#" withString:@""]];
    }
 
    
//     NSLog(@"cancel notification.m:%@",   [[UIApplication sharedApplication] scheduledLocalNotifications]);
}

@end
