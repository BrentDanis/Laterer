//
//  ReminderListViewController.h
//  Laterer
//
//  Created by Nimble Chapps on 03/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderListViewController : UIViewController <UIAlertViewDelegate>
{
    UILocalNotification *localNotification;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(void)reloadTableData;

@property (weak, nonatomic) IBOutlet UIView *viewDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *reminderDatePicker;
- (IBAction)reminderDatePickerValueChanged:(id)sender;
- (IBAction)btnChangeReminderTime:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reminderDatePickerTopContstant;
- (IBAction)btnCancelTapped:(id)sender;

@end
