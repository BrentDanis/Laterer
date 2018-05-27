//
//  SendNotificationInterfaceController.h
//  laterer
//
//  Created by Nimble Chapps on 15/04/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface SendNotificationInterfaceController : WKInterfaceController

@property (weak, nonatomic) IBOutlet WKInterfaceImage *img_Profile;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *lbl_contactName;

- (IBAction)SendPush;
- (IBAction)sendPushWithLocation;
- (IBAction)scheduleLocalNotification;

@end
