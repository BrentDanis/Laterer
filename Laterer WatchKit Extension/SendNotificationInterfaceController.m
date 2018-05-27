//
//  SendNotificationInterfaceController.m
//  laterer
//
//  Created by Nimble Chapps on 15/04/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "SendNotificationInterfaceController.h"
#import "Model.h"
#import "MMWormhole.h"
// Push notification
#define kUserId @"iUserID"
#define kContactId @"iContactID"
#define kMessage @"vMessageTitle"
#define kLat @"fLat"
#define kLong @"fLong"

#define kFirstName @"vFirstName"
#define kLastName @"vLastName"

@interface SendNotificationInterfaceController ()
{
    NSDictionary *contactDetail;
}
@property (nonatomic, strong) NSDictionary *contactObject;
@property (nonatomic, strong) MMWormhole *wormhole;

@end

@implementation SendNotificationInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.laterer.watchkit" optionalDirectory:@"latererInstantCall"];
    
    self.contactObject = context;
    contactDetail = self.contactObject[@"contactDetail"];
    [self.img_Profile setImageData:[self.contactObject valueForKey:@"contactImage"]];
    [self.lbl_contactName setText:[NSString stringWithFormat:@" %@ %@", contactDetail[@"vFirstName"], contactDetail[@"vLastName"]]];

    NSLog(@"%@",self.contactObject);
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)SendPush {
    [self.wormhole passMessageObject:@{@"SendPush" : contactDetail} identifier:@"notificationIdentifier"];
}

- (IBAction)sendPushWithLocation {
    [self.wormhole passMessageObject:@{@"SendPushLocation" : contactDetail} identifier:@"notificationIdentifier"];
}

- (IBAction)scheduleLocalNotification {
    [self.wormhole passMessageObject:@{@"LocalNotification" : contactDetail} identifier:@"notificationIdentifier"];
}

@end



