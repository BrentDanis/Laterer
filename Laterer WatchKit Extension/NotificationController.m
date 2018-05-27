//
//  NotificationController.m
//  Laterer WatchKit Extension
//
//  Created by Nimble Chapps on 13/04/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "NotificationController.h"


@interface NotificationController()

@end


@implementation NotificationController

- (instancetype)init {
    self = [super init];
    if (self){
        // Initialize variables here.
        // Configure interface objects here.
        
    }
    return self;
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


- (void)didReceiveLocalNotification:(UILocalNotification *)localNotification withCompletion:(void (^)(WKUserNotificationInterfaceType))completionHandler {
    
    NSLog(@"local notification received");
    
    
    
    
    
    completionHandler(WKUserNotificationInterfaceTypeCustom);
}



- (void)didReceiveRemoteNotification:(NSDictionary *)remoteNotification withCompletion:(void (^)(WKUserNotificationInterfaceType))completionHandler {
    
    
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

    NSLog(@"payload - %@",remoteNotification);
//    NSLog(@"data - %@",remoteNotification[@"aps"][@"data"]);
    
    [self.alertLabel setText:remoteNotification[@"aps"][@"alert"]];
    
    NSLog(@"remote notification received");

    completionHandler(WKUserNotificationInterfaceTypeCustom);
}

@end



