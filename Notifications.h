//
//  Notifications.h
//  ToDoList
//
//  Created by Rajiv Patil on 14/11/11.
//  Copyright 2011 Capgemini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Notifications : NSObject

-(void)scheduleNotificationsWith:(NSDate *)fireDate
                        AlertMsg:(NSString *)alertBody
               andIdentification:(NSString *)Id
                        UserInfo:(NSDictionary *)userInfo;
//                   repeatInterval:(NSCalendarUnit )calenderUnit



-(void)scheduleNotificationsWith:(NSDate *)fireDate
                        AlertMsg:(NSString *)alertBody
               andIdentification:(NSString *)Id
                        UserInfo:(NSDictionary *)userInfo
           withCompletionHandler:(void(^)(void))completionHandler;



-(void)scheduleNotificationsWith:(NSDate *)fireDate AlertMsg:(NSString *)alertBody title:(NSString *)title soundName:(NSString *)soundName andIdentification:(NSString *)Id withImageName:(NSString *)imgName repeatInterval:(NSCalendarUnit )calenderUnit;

-(void)cancelNotificationforId:(NSString *)Id;

-(void)scheduleNotificationsToReapeatContinuousWith:(NSDate *)fireDate AlertMsg:(NSString *)alertBody title:(NSString *)title soundName:(NSString *)soundName andIdentification:(NSString *)Id withImageName:(NSString *)imgName;
-(void)cancelNotificationRepeatedContinuesforId:(NSString *)Id;


@end
