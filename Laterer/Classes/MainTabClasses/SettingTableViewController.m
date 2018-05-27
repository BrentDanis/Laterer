//
//  SettingTableViewController.m
//  laterer
//
//  Created by Nimble Chapps on 14/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "SettingTableViewController.h"
#import "InitialViewController.h"
#import "AppDelegate.h"

@interface SettingTableViewController ()
{
    NSMutableArray *hoursArray;
    NSMutableArray *minsArray;

    NSInteger hours;
    NSInteger minutes;
    
    UIActionSheet *logoutActionSheet;
}
@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hours = 0;
    minutes = 0;
    
    hoursArray = [[NSMutableArray alloc] init];
    minsArray = [[NSMutableArray alloc] init];
    NSString *strVal = [[NSString alloc] init];
    
    for(int i=0; i<60; i++) {
        strVal = [NSString stringWithFormat:@"%d", i];
        if (i < 24) {
            [hoursArray addObject:strVal];
        }
        [minsArray addObject:strVal];
    }

    
    if (DEVICE_IS_IPHONE_5 || DEVICE_IS_IPHONE_4) {
        UILabel *hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.commonPicker.frame.size.height / 2 - 15, 75, 30)];
        hourLabel.text = @"Hours";
        [hourLabel setTextColor:[UIColor whiteColor]];
        [self.commonPicker addSubview:hourLabel];
        
        UILabel *minsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.commonPicker.frame.size.width / 2.8, self.commonPicker.frame.size.height / 2 - 15, 75, 30)];
        minsLabel.text = @"Minutes";
        [minsLabel setTextColor:[UIColor whiteColor]];
        [self.commonPicker addSubview:minsLabel];
    }
    else if (DEVICE_IS_IPHONE_6 || DEVICE_IS_IPHONE_6_PLUS) {
        UILabel *hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.commonPicker.frame.size.height / 2 - 15, 75, 30)];
        hourLabel.text = @"Hours";
        [hourLabel setTextColor:[UIColor whiteColor]];
        [self.commonPicker addSubview:hourLabel];
        
        UILabel *minsLabel = [[UILabel alloc] initWithFrame:CGRectMake( (self.commonPicker.frame.size.width / 2) - 5, self.commonPicker.frame.size.height / 2 - 15, 75, 30)];
        minsLabel.text = @"Minutes";
        [minsLabel setTextColor:[UIColor whiteColor]];
        [self.commonPicker addSubview:minsLabel];
    }
    
    
    
    if ([userDefault stringForKey:@"reminderMessage"]) {
        self.txtFld_Message.text =  [userDefault stringForKey:@"reminderMessage"];
    }
    
    self.tableView.allowsSelection = NO;
    [[self navigationController] setNavigationBarHidden:YES animated:NO];

}

- (void)viewDidAppear:(BOOL)animated{
    
    hours = [userDefault integerForKey:@"reminderHours"];
    minutes = [userDefault integerForKey:@"reminderMinutes"];
    
    [self.commonPicker selectRow:hours inComponent:0 animated:YES];
    [self.commonPicker reloadComponent:0];
    
    [self.commonPicker selectRow:minutes inComponent:1 animated:YES];
    [self.commonPicker reloadComponent:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//Method to define how many columns/dials to show
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}


// Method to define the numberOfRows in a component using the array.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component
{
    if (component==0) {
        return [hoursArray count];
    } else {
        return [minsArray count];
    }
}


// Method to show the title of row for a component.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            return [hoursArray objectAtIndex:row];
            break;
        case 1:
            return [minsArray objectAtIndex:row];
            break;
    }
    return nil;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    
    if (component == 0) {
        title = [NSString stringWithFormat:@"%@", hoursArray[row]];
    } else {
        title = [NSString stringWithFormat:@"%@", minsArray[row]];
    }
    
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    hours = [pickerView selectedRowInComponent:0];
    minutes = [pickerView selectedRowInComponent:1];
    
    if (hours == 0 && minutes == 0) {
        showAlertViewWithMessageAndTitle(@"Hours or Minutes must be greater then 0", @"Invalid Time");
    }
    else {
        
        // user defaults
        if ([userDefault integerForKey:@"reminderHours"]) {
            [userDefault removeObjectForKey:@"reminderHours"];
        }
        if ([userDefault integerForKey:@"reminderMinutes"]) {
            [userDefault removeObjectForKey:@"reminderMinutes"];
        }
        
        [userDefault setInteger:hours forKey:@"reminderHours"];
        [userDefault setInteger:minutes forKey:@"reminderMinutes"];
        [userDefault synchronize];
    }
}

- (IBAction)txtFld_ReminderMessageEditingChanged:(id)sender {
    
    if (textFieldNotNull(self.txtFld_Message.text)) {
        if ([userDefault stringForKey:@"reminderMessage"]) {
            [userDefault removeObjectForKey:@"reminderMessage"];
        }
        [userDefault setValue:self.txtFld_Message.text forKey:@"reminderMessage"];
        [userDefault synchronize ];
    } else {
        showAlertViewWithMessage(@"Please Enter Message.");
    }
}


// Logout
- (IBAction)btnLogoutTapped:(id)sender {
    
    logoutActionSheet = [[UIActionSheet alloc]initWithTitle:@"Are you sure?" delegate:self cancelButtonTitle:@"Dismiss" destructiveButtonTitle:nil otherButtonTitles:@"Yes",@"No", nil];
    [logoutActionSheet showInView:self.view];
}

// Share
- (IBAction)btnShareTapped:(id)sender {
    
    NSString *text = @"Busy? Send me a Laterer";
    NSURL *url = [NSURL URLWithString:@"http://www.laterer.com/"];
    UIImage *image = [UIImage imageNamed:@"ShareImage"];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[text, url, image] applicationActivities:nil];
    
    controller.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo,
                                         UIActivityTypeAirDrop];
    
    [self presentViewController:controller animated:YES completion:nil];
}

// Contact Us
- (IBAction)btnContactUs:(id)sender {
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        [mailController setSubject:@""];
        [mailController setMessageBody:@"" isHTML:NO];
        [mailController setToRecipients:@[@"LatererApp@gmail.com"]];
        
        [self presentViewController:mailController animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
}

// Rate Us
- (IBAction)btnRateUs:(id)sender {
    
    UIApplication *ourApplication = [UIApplication sharedApplication];
    NSString* launchUrlString = @"itms-apps://itunes.apple.com/app/idAPP_ID";
    NSURL *launchUrl = [NSURL URLWithString:launchUrlString];
    
    if ([ourApplication canOpenURL:launchUrl]) {
        [ourApplication openURL:launchUrl];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark -- Action Sheet Delegates --

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
                
        UIWindow *frontWindow = [[[UIApplication sharedApplication] windows] lastObject];
        [MBProgressHUD showHUDAddedToWindow:frontWindow animated:YES];
        
        [PAWSCalls logoutUserWithUserId:[Model getLatereUserId] completionBlock:^(id JSON, WebServiceResult result) {
            
            [MBProgressHUD hideHUDForWindow:frontWindow animated:YES];
            
            if (result == WebServiceResultSuccess) {
                
                NSLog(@"%@",JSON);
                
                // Clear User defaults
//                if ([userDefault objectForKey:kLatererUserID]) {
//                    [userDefault removeObjectForKey:kLatererUserID];
//                }
//                if ([userDefault objectForKey:kLatererUserDetail]) {
//                    [userDefault removeObjectForKey:kLatererUserDetail];
//                }
                [Model removeLatererUserIdAndDetail];
                
                [userDefault setInteger:0 forKey:@"reminderHours"];
                [userDefault setInteger:30 forKey:@"reminderMinutes"];
                [userDefault setValue:@"Contact " forKey:@"reminderMessage"];

                
                // Remove local notifications
                [[[UIApplication sharedApplication] scheduledLocalNotifications] enumerateObjectsUsingBlock:^(UILocalNotification  *obj, NSUInteger idx, BOOL *stop) {
                    [[UIApplication sharedApplication] cancelLocalNotification:obj];
                }];
                
                // changing navigation controller and redirecting to login view controller
                AppDelegate* myDelegate = (((AppDelegate*) [UIApplication sharedApplication].delegate));
                InitialViewController *initialVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
                myDelegate.navController = [[UINavigationController alloc] initWithRootViewController:initialVC];
                myDelegate.window.rootViewController = myDelegate.navController;
                [myDelegate.window makeKeyAndVisible];
            }
        }];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
