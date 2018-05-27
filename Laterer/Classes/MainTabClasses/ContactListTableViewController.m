//
//  ContactListTableViewController.m
//  Laterer
//
//  Created by Nimble Chapps on 02/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "ContactListTableViewController.h"
#import "JPLazyImageDownloader.h"
#import "AppDelegate.h"
#import "ContactCell.h"
#import "CDLocation.h"
#import "Notifications.h"

#import "ContactManager.h"
#import "MMWormhole.h"

#define kFirstName @"vFirstName"
#define kLastName @"vLastName"
#define kImage @"vImage"
#define kPhone @"vPhoneNumber"
#define kEmail @"vEmail"
#define kContactId @"iContactID"
#define kBlock @"block"

// Push notification
#define kUserId @"iUserID"
#define kContactId @"iContactID"
#define kMessage @"vMessageTitle"
#define kLat @"fLat"
#define kLong @"fLong"

@interface ContactListTableViewController () {
    
    NSMutableArray *latererContacts;
    NSMutableArray *latererUnblockedContacts;
    
    JPLazyImageDownloader *imgDownloader;
    Notifications *notification;
    CDLocation *location;
    ContactCell *contactCell;
    
    BOOL isNeedsToUploadContacts;
}

@property (nonatomic, strong) MMWormhole *wormhole;

@end

@implementation ContactListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isNeedsToUploadContacts = YES;
    
    latererContacts = [[NSMutableArray alloc] init];
    latererUnblockedContacts = [[NSMutableArray alloc] init];
    
    location = [[CDLocation alloc] initWithLocationManager];
    notification = [[Notifications alloc] init];
    imgDownloader =[[JPLazyImageDownloader alloc]init];
    
    // Fetch All the contacts
    [self fetchAndListContacts];
    
    // Refresh control - Tableview pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchAndListContacts) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self watchKitInstantUpdateCall];
}

-(void)watchKitInstantUpdateCall {
    
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:__APP_GROUP__
                                                         optionalDirectory:@"latererInstantCall"];
    
    [self.wormhole listenForMessageWithIdentifier:@"notificationIdentifier" listener:^(id messageObject) {
        
        if ([messageObject valueForKey:@"SendPush"]) {
            [self sendPushFromWatchKit:[messageObject valueForKey:@"SendPush"] withSendLocation:NO];
        }
        else if ([messageObject valueForKey:@"SendPushLocation"]) {
            [self sendPushFromWatchKit:[messageObject valueForKey:@"SendPushLocation"] withSendLocation:YES];
        }
        else if ([messageObject valueForKey:@"LocalNotification"]) {
            [self scheduleLocalNotification:[messageObject valueForKey:@"LocalNotification"]];
        }
        else if ([messageObject valueForKey:@"ReScheduleLocalNotification"]) {
            [self reScheduleLocalNotification:[messageObject valueForKey:@"ReScheduleLocalNotification"]];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Fetch contacts from Server and Reload data table
- (void) fetchAndListContacts {
    
    UIWindow *frontWindow = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD showHUDAddedToWindow:frontWindow animated:YES];
    
    if (isNeedsToUploadContacts) {
        AppDelegate *appDelegate = ((AppDelegate *) [[UIApplication sharedApplication] delegate]);
        [appDelegate uploadPhoneContacts];
    }
    [PAWSCalls fetchAllContactsWithCompletionBlock:[Model getLatereUserId] completionBlock:^(id JSON, WebServiceResult result) {
        
        [MBProgressHUD hideHUDForWindow:frontWindow animated:YES];
        [self.refreshControl endRefreshing];
        
        if (result == WebServiceResultSuccess && [JSON[@"status"] isEqualToString:@"0"]) {
            isNeedsToUploadContacts = YES;
            latererContacts = JSON[@"data"];
            [latererUnblockedContacts removeAllObjects];
            
            // Contacts From Core Data
            NSArray *dbContacts = [ContactManager fetchAllContacts];
            
            [latererContacts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                NSDictionary *tempContact = [latererContacts objectAtIndex:idx];
                if ([tempContact[@"block"] isEqualToString:@"NO"]) {
                    [latererUnblockedContacts addObject:tempContact];
                    [self updateContactInDB:dbContacts contactToUpdate:tempContact];
                }
            }];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
                [self.wormhole passMessageObject:@{@"newContacts" : @"yes"} identifier:@"contctUpdated"];
            }];
            
        } else {
            showAlertViewWithMessage(@"No Contacts");
        }
    }];
}

-(void)updateContactInDB:(NSArray*)dbContacts contactToUpdate:(NSDictionary*)tempContact {
    BOOL isContactExistInDB = NO;
    for (int i = 0; i < [dbContacts count]; i++) {
        
        if ([tempContact[kContactId] isEqualToString:[dbContacts[i][@"id"] stringValue]]) {
            isContactExistInDB = YES;
            if (![tempContact isEqualToDictionary:dbContacts[i][@"contactDetail"]]) {
                NSLog(@"Going to update contact");
                [ContactManager updateContactDetail:tempContact];
            }
            return;
        }
    }
    if (!isContactExistInDB) {
        NSLog(@"Goint to save contact");
        [ContactManager saveContact:tempContact];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [latererUnblockedContacts count];
}

// cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"ContactCell";
    
    ContactCell *cell = (ContactCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSDictionary *dictCell = [latererUnblockedContacts objectAtIndex:indexPath.row];
    
    [cell.singleTapGesture addTarget:self action:@selector(cellSingleTapped:)];
    [cell.doubleTapGesture addTarget:self action:@selector(cellDoubleTapped:)];
    [cell.longPressGesture addTarget:self action:@selector(cellLongPress:)];
    
    // labeling
    cell.label_contactName.text = [NSString stringWithFormat:@"%@ %@", [dictCell valueForKey:kFirstName], [dictCell valueForKey:kLastName]];
    
    [imgDownloader downloadImageFromUrl:[dictCell valueForKey:kImage] forIndexPath:indexPath
                        completionBlock:^(UIImage *image, NSIndexPath *path) {
                            if(path) {
                                ContactCell *contCell = (ContactCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                                [contCell.imgVw_ContactImage setImage:image];
                            } else {
                                [cell.imgVw_ContactImage setImage:image];
                            }
                            NSNumber *numId = @([dictCell[kContactId] intValue]);
                            [ContactManager updateContactForImage:UIImageJPEGRepresentation(image, 0.9) contactId:numId];
                        }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

// Block User
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *blockUser = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                       {
                                           isNeedsToUploadContacts = NO;
                                           
                                           UIWindow *frontWindow = [[[UIApplication sharedApplication] windows] lastObject];
                                           [MBProgressHUD showHUDAddedToWindow:frontWindow animated:YES];
                                           
                                           NSDictionary *contactDetail = [latererUnblockedContacts objectAtIndex:indexPath.row];
                                           [PAWSCalls blockUserWithUserId:[Model getLatereUserId] contactId:contactDetail[@"iContactID"] completionBlock:^(id JSON, WebServiceResult result) {
                                               
                                               [MBProgressHUD hideHUDForWindow:frontWindow animated:YES];
                                               
                                               if (result == WebServiceResultSuccess && [JSON[@"status"] isEqualToString:@"0"]) {
                                                   [self fetchAndListContacts];
                                               } else {
                                                   NSLog(@"%@", JSON[@"message"]);
                                                   [self.tableView beginUpdates];
                                                   [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationRight];
                                                   [self.tableView endUpdates];
                                               }
                                           }];
                                       }];
    
    blockUser.backgroundColor = [UIColor colorWithRed:204.0f/255.0f green:220.0f/255.0f blue:113.0f/255.0f alpha:1.0];
    return @[blockUser];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Add new contact in phonebook
- (IBAction)btnAddNewContact:(id)sender {
    
    ABNewPersonViewController *picker =[ABNewPersonViewController new];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:picker];
    picker.newPersonViewDelegate = self;
    [self presentViewController:nc animated:YES completion:nil];
    
}

// Open new contact add controller
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person{
    if (person) {
        [self fetchAndListContacts];
    }
    [newPersonView dismissViewControllerAnimated:YES completion:nil];
}

// Time Calculation
-(NSDictionary *)timeCalculation {
    
    NSDate *currentTime = [NSDate date];
    NSInteger reminderHour = [userDefault integerForKey:@"reminderHours"];
    NSInteger reminderMinute = [userDefault integerForKey:@"reminderMinutes"];
    NSTimeInterval secondsForReminder = (reminderHour * 60 * 60) + (reminderMinute * 60);
    NSDate *dateTimeForReminder = [currentTime dateByAddingTimeInterval:secondsForReminder];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [format stringFromDate:dateTimeForReminder], @"key",
            dateTimeForReminder, @"dateTimeForReminder"
            , nil];
}

#pragma mark - Gesture recognizer methods

// single tap

/*
 
 Single Tap on a particular contact would send a push notification with TEXT “Laterer” (and voice if the sound is turned on their phone). The recipient would receive a push notification and would see the TEXT of Laterer and a message would pop up saying “Mr XYZ sent you Laterer”
 
 as well as set a reminder on the senders phone with predefined message and time.
 
 */
-(void)cellSingleTapped:(UITapGestureRecognizer *)singleTapGestureRecognizer {
    
    
    ContactCell *cell = (ContactCell *) [singleTapGestureRecognizer view];
    cell.activityIndicator_laterer.hidden = NO;
    [cell.activityIndicator_laterer startAnimating];
    cell.label_contactName.hidden = YES;
    cell.imgVw_ContactImage.hidden = YES;
    self.view.userInteractionEnabled = NO;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *dictCell = [latererUnblockedContacts objectAtIndex:indexPath.row];
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:dictCell, @"contactDetail", nil];
    
    // schedule push notification
    NSDictionary *dictUserDetail = [Model getLatererUserDetail];
    NSDictionary *dictPayload = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [Model getLatereUserId], kUserId,
                                 dictCell[@"iContactID"], kContactId,
                                 [NSString stringWithFormat:@"%@ %@ sent you a Laterer.", dictUserDetail[kFirstName], dictUserDetail[kLastName]], kMessage,
                                 @"%20", kLat,
                                 @"%20", kLong, nil];
    
    [PAWSCalls sendPushNotificationWithCompletionBlock:dictPayload completionBlock:^(id JSON, WebServiceResult result) {
        
        if (result == WebServiceResultSuccess && [JSON[@"status"] isEqualToString:@"0"]) {
            
            cell.lable_latererSent.alpha = 0;
            [cell.activityIndicator_laterer stopAnimating];
            cell.activityIndicator_laterer.hidden = YES;
            cell.lable_latererSent.hidden = NO;
            
            [UIView animateWithDuration:0.5 animations:^{
                cell.lable_latererSent.alpha = 1;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    cell.lable_latererSent.alpha = 0.9;
                    cell.lable_latererSent.hidden = YES;
                    cell.label_contactName.hidden = NO;
                    cell.imgVw_ContactImage.hidden = NO;
                    self.view.userInteractionEnabled = YES;
                });
            } completion:^(BOOL finished) {
            }];
            
        } else {
            cell.activityIndicator_laterer.hidden = YES;
            [cell.activityIndicator_laterer stopAnimating];
            cell.label_contactName.hidden = NO;
            cell.imgVw_ContactImage.hidden = NO;
            self.view.userInteractionEnabled = YES;
            NSLog(@"Opps, Problem while sending push");
        }
    }];
    
    
    // schedule local notification
    NSDictionary *keyAndDateTime = [self timeCalculation];
    NSString *alertMessage = [NSString stringWithFormat:@"%@ %@ %@", [userDefault objectForKey:@"reminderMessage"] , dictCell[kFirstName], dictCell[kLastName]];
    [notification scheduleNotificationsWith:keyAndDateTime[@"dateTimeForReminder"] AlertMsg:alertMessage andIdentification:keyAndDateTime[@"key"] UserInfo:infoDict];
    NSLog(@"new reminder set - single tap");
    
}

// double tap
/*
 Send push notification to contact for reminder with sender location
 Send notification to sender for reminder of specific contact
 
 Double tap on a particular contact would send a push notification of a TEXT (and voice if the users has the sound turned on) that says Laterer and includes with the notification sending users GPS location (optional setting to enable GPS or not) as well as set a reminder on the senders phone with predefined message and time from current time.
 
 */

-(void)cellDoubleTapped:(UITapGestureRecognizer *)doubleTapGestureRecognizer {
    
    ContactCell *cell = (ContactCell *) [doubleTapGestureRecognizer view];
    cell.activityIndicator_laterer.hidden = NO;
    [cell.activityIndicator_laterer startAnimating];
    cell.label_contactName.hidden = YES;
    cell.imgVw_ContactImage.hidden = YES;
    self.view.userInteractionEnabled = NO;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *dictCell = [latererUnblockedContacts objectAtIndex:indexPath.row];
    
    // schedule push notification
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:dictCell, @"contactDetail", nil];
    NSDictionary *dictUserDetail = [Model getLatererUserDetail];
    NSDictionary *dictPayload = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [Model getLatereUserId], kUserId,
                                 dictCell[@"iContactID"], kContactId,
                                 [NSString stringWithFormat:@"%@ %@ sent you a Laterer.", dictUserDetail[kFirstName], dictUserDetail[kLastName]], kMessage,
                                 [NSString stringWithFormat:@"%f", [Model getLatitude]], kLat,
                                 [NSString stringWithFormat:@"%f", [Model getLongitude]], kLong, nil];
    
    [PAWSCalls sendPushNotificationWithCompletionBlock:dictPayload completionBlock:^(id JSON, WebServiceResult result) {
        
        if (result == WebServiceResultSuccess && [JSON[@"status"] isEqualToString:@"0"]) {
            
            NSLog(@"json - %@", JSON);
            
            cell.lable_latererSent.alpha = 0;
            [cell.activityIndicator_laterer stopAnimating];
            cell.activityIndicator_laterer.hidden = YES;
            cell.lable_latererSent.hidden = NO;
            
            [UIView animateWithDuration:0.5 animations:^{
                cell.lable_latererSent.alpha = 1;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    cell.lable_latererSent.alpha = 0.9;
                    cell.lable_latererSent.hidden = YES;
                    cell.label_contactName.hidden = NO;
                    cell.imgVw_ContactImage.hidden = NO;
                    self.view.userInteractionEnabled = YES;
                });
            } completion:^(BOOL finished) {
            }];
            
            
        } else {
            cell.activityIndicator_laterer.hidden = YES;
            [cell.activityIndicator_laterer stopAnimating];
            cell.label_contactName.hidden = NO;
            cell.imgVw_ContactImage.hidden = NO;
            self.view.userInteractionEnabled = YES;
            NSLog(@"Opps, Problem while sending push");
        }
    }];
    
    // schedule local notification
    NSDictionary *keyAndDateTime = [self timeCalculation];
    NSString *alertMessage = [NSString stringWithFormat:@"%@ %@ %@", [userDefault objectForKey:@"reminderMessage"], dictCell[kFirstName], dictCell[kLastName]];
    [notification scheduleNotificationsWith:keyAndDateTime[@"dateTimeForReminder"] AlertMsg:alertMessage andIdentification:keyAndDateTime[@"key"] UserInfo:infoDict];
    NSLog(@"new reminder set - double tap");
    
}

// long press

/*
 Send notification to senders for reminder of specific contact
 
 Hold and press down on a particular contact and send a reminder only to yourself at a set amount of time later to contact that user.
 
 */
-(void)cellLongPress:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    
    if (longPressGestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    ContactCell *cell = (ContactCell *) [longPressGestureRecognizer view];
    cell.activityIndicator_laterer.hidden = NO;
    [cell.activityIndicator_laterer startAnimating];
    cell.label_contactName.hidden = YES;
    cell.imgVw_ContactImage.hidden = YES;
    self.view.userInteractionEnabled = NO;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *dictCell = [latererUnblockedContacts objectAtIndex:indexPath.row];
    NSDictionary *keyAndDateTime = [self timeCalculation];
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:dictCell, @"contactDetail", nil];
    
    // schedule local notification
    NSString *alertMessage = [NSString stringWithFormat:@"%@ %@ %@" , [userDefault objectForKey:@"reminderMessage"], dictCell[kFirstName], dictCell[kLastName]];
    [notification scheduleNotificationsWith:keyAndDateTime[@"dateTimeForReminder"] AlertMsg:alertMessage andIdentification:keyAndDateTime[@"key"] UserInfo:infoDict];
    
    cell.lable_latererSent.alpha = 0;
    cell.lable_latererSent.text = @"Reminder Set";
    [cell.activityIndicator_laterer stopAnimating];
    cell.activityIndicator_laterer.hidden = YES;
    cell.lable_latererSent.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        cell.lable_latererSent.alpha = 1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            cell.lable_latererSent.alpha = 0.9;
            cell.lable_latererSent.hidden = YES;
            cell.label_contactName.hidden = NO;
            cell.imgVw_ContactImage.hidden = NO;
            cell.lable_latererSent.text = @"Laterer Sent";
            self.view.userInteractionEnabled = YES;
        });
    } completion:^(BOOL finished) {
    }];
    
    NSLog(@"new reminder set - long press");
}

-(void)sendPushFromWatchKit:(NSDictionary *)contactDetail withSendLocation:(BOOL)sendLocation{
    
    NSDictionary *dictUserDetail = [Model getLatererUserDetail];
    NSDictionary *dictPayload;
    if (sendLocation) {
        dictPayload = [NSDictionary dictionaryWithObjectsAndKeys:
                       [Model getLatereUserId], kUserId,
                       contactDetail[@"iContactID"], kContactId,
                       [NSString stringWithFormat:@"%@ %@ sent you a Laterer.", dictUserDetail[kFirstName], dictUserDetail[kLastName]], kMessage,
                       [NSString stringWithFormat:@"%f", [Model getLatitude]], kLat,
                       [NSString stringWithFormat:@"%f", [Model getLongitude]], kLong, nil];
    } else {
        dictPayload = [NSDictionary dictionaryWithObjectsAndKeys:
                       [Model getLatereUserId], kUserId,
                       contactDetail[@"iContactID"], kContactId,
                       [NSString stringWithFormat:@"%@ %@ sent you a Laterer.", dictUserDetail[kFirstName], dictUserDetail[kLastName]], kMessage,
                       @"%20", kLat,
                       @"%20", kLong, nil];
    }
    
    [PAWSCalls sendPushNotificationWithCompletionBlock:dictPayload completionBlock:^(id JSON, WebServiceResult result) {
        
        if (result == WebServiceResultSuccess && [JSON[@"status"] isEqualToString:@"0"]) {
            NSLog(@"json - %@", JSON);
        }
    }];
    [self scheduleLocalNotification:contactDetail];
}

-(void)scheduleLocalNotification:(NSDictionary *)dictContactDetail {
    
    // schedule local notification
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:dictContactDetail, @"contactDetail", nil];
    NSDictionary *keyAndDateTime = [self timeCalculation];
    NSString *alertMessage = [NSString stringWithFormat:@"%@ %@ %@", [userDefault objectForKey:@"reminderMessage"], dictContactDetail[kFirstName], dictContactDetail[kLastName]];
    
    [notification scheduleNotificationsWith:keyAndDateTime[@"dateTimeForReminder"] AlertMsg:alertMessage andIdentification:keyAndDateTime[@"key"] UserInfo:infoDict withCompletionHandler:^{
        [self performSelector:@selector(reloadReminderTable) withObject:nil afterDelay:1.0];
    }];
}

-(void)reScheduleLocalNotification:(NSDictionary *)dictContactDetail {
    
    // re schedule local notification
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSDate *oldNotificationDate = [NSDate date];
    NSTimeInterval secondsForReminder = 30 * 60;
    NSDate *dateTimeForReminder = [oldNotificationDate dateByAddingTimeInterval:secondsForReminder];
    NSString *key = [format stringFromDate:dateTimeForReminder];
    
    [notification scheduleNotificationsWith:dateTimeForReminder AlertMsg:dictContactDetail[@"alertBody"] andIdentification:key UserInfo:dictContactDetail[@"data"] withCompletionHandler:^{
        [self performSelector:@selector(reloadReminderTable) withObject:nil afterDelay:1.0];
    }];
}

-(void) reloadReminderTable {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationFired" object:nil];
}

@end
