//
//  RegistrationTableViewController.m
//  Laterer
//
//  Created by Nimble Chapps on 05/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "RegistrationTableViewController.h"
#import "SIAlertView.h"
#import "UIImage+Resize.h"

#define kFirstName @"vFirstName"
#define kLastName @"vLastName"
#define kPhone @"vPhoneNumber"
#define kEmail @"vEmail"
#define kPassword @"vPassword"

@interface RegistrationTableViewController (){
    
    // User Profile Picture
    __weak IBOutlet UIButton *Btn_ImagePicker;
    
    __weak IBOutlet UITextField *txtFld_FName;
    __weak IBOutlet UITextField *txtFld_LName;
    __weak IBOutlet UITextField *txtFld_Phone;
    __weak IBOutlet UITextField *txtFld_Email;
    __weak IBOutlet UITextField *txtFld_Password;
    __weak IBOutlet UITextField *txtFld_ConfirmPassword;
    
    UIActionSheet *photoSelectorActionSheet;
    UIImagePickerController *imagePicker;
    NSMutableDictionary *dictRegistrationParams;
    UIImage *img_UserProfile;
}

@end

@implementation RegistrationTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableView.allowsSelection = NO;
    txtFld_Password.secureTextEntry = YES;
    txtFld_ConfirmPassword.secureTextEntry = YES;
    
    txtFld_Phone.keyboardType = UIKeyboardTypePhonePad;
    txtFld_Email.keyboardType = UIKeyboardTypeEmailAddress;
    
    [Btn_ImagePicker.layer setCornerRadius:Btn_ImagePicker.frame.size.width/2];
    [Btn_ImagePicker.layer setBorderColor:BUTTON_BORDER_COLOR];
    [Btn_ImagePicker.layer setBorderWidth:3];
    [Btn_ImagePicker setClipsToBounds:YES];
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    dictRegistrationParams = [[NSMutableDictionary alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- Action Sheet Delegates
// Action sheet Button click
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        imagePicker.allowsEditing = NO;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
    else if (buttonIndex == 0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            showAlertViewWithMessage(@"Device has no camera.");
            
        } else {
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:NULL];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    [chosenImage resizedImage:CGSizeMake(180, 180) interpolationQuality:kCGInterpolationDefault];
    
    Btn_ImagePicker.titleLabel.text = @"";
    [Btn_ImagePicker setImage:chosenImage forState:UIControlStateNormal];
    img_UserProfile = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark -- Button Actions
-(IBAction)imageSelectorTapped:(id)sender {
    [self.view endEditing:YES];
    
    photoSelectorActionSheet = [[UIActionSheet alloc]initWithTitle:@"Laterer" delegate:self cancelButtonTitle:@"Dismiss" destructiveButtonTitle:nil
                                                 otherButtonTitles:@"Take a photo",@"Choose from Library", nil];
    [photoSelectorActionSheet showInView:self.view];
}

-(IBAction)signUpTapped:(id)sender {
    
    if([self validateRegistrationField]) {
        
        [dictRegistrationParams setValue:txtFld_FName.text forKey:kFirstName];
        [dictRegistrationParams setValue:txtFld_LName.text forKey:kLastName];
        [dictRegistrationParams setValue:txtFld_Email.text forKey:kEmail];
        [dictRegistrationParams setValue:removeSpecialCharactersFromPhone(txtFld_Phone.text) forKey:kPhone];
        [dictRegistrationParams setValue:txtFld_Password.text forKey:kPassword];
        
        if([userDefault objectForKey:kDeviceToken]) {
            [dictRegistrationParams setObject:[userDefault objectForKey:kDeviceToken] forKey:kDeviceToken];
        } else {
            [dictRegistrationParams setObject:@"12345678" forKey:kDeviceToken];
        }
        
        UIWindow *frontWindow = [[[UIApplication sharedApplication] windows] lastObject];
        [MBProgressHUD showHUDAddedToWindow:frontWindow animated:YES];
        
        [PAWSCalls registerUserWithParam:dictRegistrationParams image:img_UserProfile completionBlock:^(id JSON, WebServiceResult result) {
            
            [MBProgressHUD hideHUDForWindow:frontWindow animated:YES];
            
            if(result == WebServiceResultSuccess && [JSON[@"status"] isEqualToString:@"0"]){
                
                showAlertViewWithMessageAndTitle(@"You have been successfully registered now please login to your account", @"Thank You");
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                showAlertViewWithMessage(JSON[@"message"]);
            }
        }];
    }
    else {
        NSLog(@"not validate");
    }
}


#pragma mark -- Text field delegate methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


// Registration Field Validation
-(BOOL) validateRegistrationField {
    
    BOOL txtFname = NO, txtLname = NO, txtPhone = NO, txtEmail = NO, txtPassword = NO, txtConfirmPassword = NO;
    NSString *errMessage = @" ";
    
    if(textFieldNotNull(txtFld_FName.text)) {
        txtFname = YES;
    } else {
        errMessage = [NSString stringWithFormat:@"%@ First Name required,",errMessage];
    }
    
    if(textFieldNotNull(txtFld_LName.text)) {
        txtLname = YES;
    } else {
        errMessage = [NSString stringWithFormat:@"%@ Last Name required,",errMessage];
    }
    
    if(textFieldNotNull(txtFld_Phone.text)) {
        txtPhone = YES;
    } else {
        errMessage = [NSString stringWithFormat:@"%@ Phone number required,",errMessage];
    }
    
    if(textFieldNotNull(txtFld_Email.text)) {
        if(validateEmailWithString(txtFld_Email.text)) {
            txtEmail = YES;
        } else {
            errMessage = [NSString stringWithFormat:@"%@ Email not valid,",errMessage];
        }
    } else {
        errMessage = [NSString stringWithFormat:@"%@ Email required,",errMessage];
    }
    
    if(textFieldNotNull(txtFld_Password.text)) {
        txtPassword = YES;
    } else {
        errMessage = [NSString stringWithFormat:@"%@ Password required,",errMessage];
    }
    
    if(textFieldNotNull(txtFld_ConfirmPassword.text)) {
        if([txtFld_Password.text isEqualToString:txtFld_ConfirmPassword.text]) {
            txtConfirmPassword = YES;
        } else {
            errMessage = [NSString stringWithFormat:@"%@ Password not matched",errMessage];
        }
    } else {
        errMessage = [NSString stringWithFormat:@"%@ Confirm Password required",errMessage];
    }
    
    if (txtFname && txtLname && txtPhone && txtEmail && txtPassword && txtConfirmPassword) {
        return  YES;
    } else {
        showAlertViewWithMessage(errMessage);
        return NO;
    }
}

@end
