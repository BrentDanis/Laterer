//
//  NotificationController.h
//  Laterer WatchKit Extension
//
//  Created by Nimble Chapps on 13/04/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface NotificationController : WKUserNotificationInterfaceController

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *alertLabel;

@end
