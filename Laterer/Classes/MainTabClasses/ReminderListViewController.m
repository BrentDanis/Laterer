	//
//  ReminderListViewController.m
//  Laterer
//
//  Created by Nimble Chapps on 03/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "ReminderListViewController.h"
#import "ReminderListCell.h"
#import  "Constant.h"
#import "Notifications.h"

#define kFirstName @"vFirstName"
#define kLastName @"vLastName"

@interface ReminderListViewController () {

    NSMutableArray *notificationList;
    NSInteger selectedCell;
    Notifications *notification;
}

@end

@implementation ReminderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    localNotification = [[UILocalNotification alloc] init];
    notificationList = [[NSMutableArray alloc] init];
    notification = [[Notifications alloc] init];

    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableData) name:@"notificationFired" object:nil];
    self.reminderDatePickerTopContstant.constant = self.view.frame.size.height + 500;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self reloadTableData];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self btnCancelTapped:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [notificationList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReminderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReminderCell" forIndexPath:indexPath];
    cell.lbl_ContactName.text = [NSString stringWithFormat:@"%@ %@", notificationList[indexPath.row][@"data"][@"contactDetail"][@"vFirstName"], notificationList[indexPath.row][@"data"][@"contactDetail"][@"vLastName"]];
    cell.lbl_FireDate.text  = DisplayDateFomString(notificationList[indexPath.row][@"Id"]);
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[[UIApplication sharedApplication] scheduledLocalNotifications] enumerateObjectsUsingBlock:^(UILocalNotification  *obj, NSUInteger idx, BOOL *stop) {
      
        if ([notificationList[indexPath.row] isEqualToDictionary:obj.userInfo]) {
            [[UIApplication sharedApplication] cancelLocalNotification:obj];
            *stop = YES;
            return;
        }
    }];

    [self reloadTableData];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    [self.tableView endUpdates];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedCell = indexPath.row;
    [self showDatePicker];
}

-(void)reloadTableData {
    [notificationList removeAllObjects];
    [[[UIApplication sharedApplication] scheduledLocalNotifications] enumerateObjectsUsingBlock:^(UILocalNotification  *obj, NSUInteger idx, BOOL *stop) {

        NSDate *currentDate = [NSDate date];
        if ([currentDate compare:obj.fireDate] == NSOrderedAscending) {
            [notificationList addObject:obj.userInfo];
        }
    }];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
}

- (IBAction)reminderDatePickerValueChanged:(id)sender {
    [self.reminderDatePicker setMinimumDate:[NSDate dateWithTimeIntervalSinceNow:60]];
}

- (IBAction)btnChangeReminderTime:(id)sender {
    
    NSDate *newReminderDate = [self.reminderDatePicker date];
    [[[UIApplication sharedApplication] scheduledLocalNotifications] enumerateObjectsUsingBlock:^(UILocalNotification  *obj, NSUInteger idx, BOOL *stop) {
        
        if ([notificationList[selectedCell] isEqualToDictionary:obj.userInfo]) {
            NSDictionary *dictCell = obj.userInfo[@"data"][@"contactDetail"];
            [[UIApplication sharedApplication] cancelLocalNotification:obj];
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
            
            NSString *alertMessage = [NSString stringWithFormat:@"%@ %@ %@", [userDefault objectForKey:@"reminderMessage"] , dictCell[kFirstName], dictCell[kLastName]];
            
            [notification scheduleNotificationsWith:newReminderDate AlertMsg:alertMessage andIdentification:[format stringFromDate:newReminderDate] UserInfo:[NSDictionary dictionaryWithObjectsAndKeys:dictCell, @"contactDetail", nil] withCompletionHandler:^{
               
                [self reloadTableData];
                *stop = YES;
                return;
           }];
        }
    }];

    self.reminderDatePickerTopContstant.constant = self.view.frame.size.height + 100;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setNeedsDisplay];
        [self.view layoutIfNeeded];
    }];
    
    [self reloadTableData];
}

-(void) showDatePicker {
    
    if (DEVICE_IS_IPHONE_4) {
        self.reminderDatePickerTopContstant.constant = 195;
    }
    else if (DEVICE_IS_IPHONE_5) {
        self.reminderDatePickerTopContstant.constant = 285;
    }
    else if (DEVICE_IS_IPHONE_6_PLUS) {
        self.reminderDatePickerTopContstant.constant = 450;
    }
    else {
        self.reminderDatePickerTopContstant.constant = 380;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setNeedsDisplay];
        [self.view layoutIfNeeded];
    }];
    
    [[[UIApplication sharedApplication] scheduledLocalNotifications] enumerateObjectsUsingBlock:^(UILocalNotification  *obj, NSUInteger idx, BOOL *stop) {
        if ([notificationList[selectedCell] isEqualToDictionary:obj.userInfo]) {
            NSDate *oldNotificationDate = obj.fireDate;
            [self.reminderDatePicker setMinimumDate:[NSDate dateWithTimeIntervalSinceNow:60]];
            [self.reminderDatePicker setDate:oldNotificationDate animated:YES];
            *stop = YES;
            return;
        }
    }];
}

- (IBAction)btnCancelTapped:(id)sender {
    self.reminderDatePickerTopContstant.constant = self.view.frame.size.height + 200;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setNeedsDisplay];
        [self.view layoutIfNeeded];
    }];
}
@end
