//
//  SettingTableViewController.h
//  laterer
//
//  Created by Nimble Chapps on 14/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface SettingTableViewController : UITableViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtFld_Message;
@property(weak,nonatomic) IBOutlet UIPickerView *commonPicker;

- (IBAction)txtFld_ReminderMessageEditingChanged:(id)sender;
- (IBAction)btnLogoutTapped:(id)sender;

- (IBAction)btnShareTapped:(id)sender;
- (IBAction)btnContactUs:(id)sender;
- (IBAction)btnRateUs:(id)sender;

@end
