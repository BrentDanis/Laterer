//
//  InterfaceController.m
//  Laterer WatchKit Extension
//
//  Created by Nimble Chapps on 13/04/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "InterfaceController.h"
#import "WKContactList.h"
#import "ContactManager.h"
#import <CoreData/CoreData.h>
#import "MMWormhole.h"

@interface InterfaceController()
{
    NSArray *contactList;
}

@property (nonatomic, strong) MMWormhole *wormhole;

@end


@implementation InterfaceController

-(instancetype)init {
    self = [super init];
    return self;
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    NSLog(@"awake");
    
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.laterer.watchkit" optionalDirectory:@"latererInstantCall"];
    
    [self.wormhole listenForMessageWithIdentifier:@"contctUpdated" listener:^(id messageObject) {
        NSString *string = [messageObject valueForKey:@"newContacts"];
        NSLog(@"listening.....");
        if (string != nil) {
            contactList = [ContactManager fetchAllContacts];
            [self configureTableWithData];
        }
    }];
    
}

- (void)willActivate {
    [super willActivate];
    NSLog(@"Will activate");
    contactList = [ContactManager fetchAllContacts];
    [self configureTableWithData];
}

- (void)didDeactivate {
    [super didDeactivate];
}

- (void)configureTableWithData {
    if ([contactList count] <= 0) {
        NSLog(@"No Contacts");
        return;
    }
    
    [self.tableContactList setNumberOfRows:[contactList count] withRowType:@"WKContactList"];
    
    for (int i = 0; i < [contactList count]; i++) {
        WKContactList *theRow = [self.tableContactList rowControllerAtIndex:i];

        NSDictionary *contactObject = [contactList objectAtIndex:i];
        NSDictionary *contactDetail = contactObject[@"contactDetail"];
        if ([contactObject valueForKey:@"contactImage"] != nil) {
            [theRow.img_ContactImage setImageData:[contactObject valueForKey:@"contactImage"]];
        }
        [theRow.lbl_ContactName setText:[NSString stringWithFormat:@" %@ %@", contactDetail[@"vFirstName"], contactDetail[@"vLastName"]]];
    }
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
    NSLog(@"cell taped");
    [self pushControllerWithName:@"SendNotificationIC" context:[contactList objectAtIndex:rowIndex]];
}

-(void)handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)localNotification {
    NSLog(@"local notification itnerface controller");
    
    if ([identifier isEqualToString:@"notificationLatererTapped"]) {
    
        NSMutableDictionary *rescheduleNotification = [[NSMutableDictionary alloc] init];
        [rescheduleNotification setObject:localNotification.alertBody forKey:@"alertBody"];
        [rescheduleNotification setObject:localNotification.userInfo[@"data"] forKey:@"data"];
        
        [self.wormhole passMessageObject:@{@"ReScheduleLocalNotification" : rescheduleNotification} identifier:@"notificationIdentifier"];
    }
}

-(void)handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)remoteNotification {
    NSLog(@"remote notificaiton itnerface controller");
    
    if ([identifier isEqualToString:@"firstButtonAction"]) {
        
        [self pushControllerWithName:@"LocationInterfaceController" context:remoteNotification[@"data"]];
    }
    
}

@end



