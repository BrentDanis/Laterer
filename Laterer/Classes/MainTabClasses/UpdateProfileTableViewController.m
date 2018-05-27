//
//  UpdateProfileTableViewController.m
//  laterer
//
//  Created by Nimble Chapps on 19/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "UpdateProfileTableViewController.h"
#import "JPLazyImageDownloader.h"
#import "UIButton+AFNetworking.h"
#import "UIImage+Resize.h"

#define kUserId @"iUserID"
#define kFirstName @"vFirstName"
#define kLastName @"vLastName"
#define kPhone @"vPhoneNumber"
#define kEmail @"vEmail"
#define kImage @"vImage"

@interface UpdateProfileTableViewController () {
    
    __weak IBOutlet UIButton *Btn_ImagePicker;
    
    __weak IBOutlet UITextField *txtFld_FName;
    __weak IBOutlet UITextField *txtFld_LName;
    __weak IBOutlet UITextField *txtFld_Phone;
    __weak IBOutlet UITextField *txtFld_Email;
    
    UIActionSheet *photoSelectorActionSheet;
    UIImagePickerController *imagePicker;
    NSMutableDictionary *dictUserParams;
    UIImage *img_UserProfile;
    
    __block NSMutableDictionary *userDetail;
    
    JPLazyImageDownloader *imgDownloader;
}
@end

@implementation UpdateProfileTableViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    imgDownloader =[[JPLazyImageDownloader alloc]init];
    self.tableView.allowsSelection = NO;
    txtFld_Phone.enabled = NO;
    txtFld_Email.enabled = NO;
    
    [Btn_ImagePicker.layer setCornerRadius:Btn_ImagePicker.frame.size.width/2];
    [Btn_ImagePicker.layer setBorderColor:BUTTON_BORDER_COLOR];
    [Btn_ImagePicker.layer setBorderWidth:3];
    [Btn_ImagePicker setClipsToBounds:YES];
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    userDetail = [[NSMutableDictionary alloc] init];
    dictUserParams = [[NSMutableDictionary alloc] init];
    userDetail = [[Model getLatererUserDetail] mutableCopy];
    
    txtFld_FName.text = userDetail[kFirstName];
    txtFld_LName.text = userDetail[kLastName];
    txtFld_Phone.text = userDetail[kPhone];
    txtFld_Email.text = userDetail[kEmail];
    NSString *imagePath = userDetail[kImage];
    
    if (imagePath.length) {
        [Btn_ImagePicker setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:imagePath]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- Action Sheet Delegates

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        imagePicker.allowsEditing = NO;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
    else if(buttonIndex == 0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Laterer" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [myAlertView show];
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
    
    photoSelectorActionSheet = [[UIActionSheet alloc]initWithTitle:@"Laterer" delegate:self cancelButtonTitle:@"Dismiss" destructiveButtonTitle:nil otherButtonTitles:@"Take a photo",@"Choose from Library", nil];
    [photoSelectorActionSheet showInView:self.view];
}

-(IBAction)signUpTapped:(id)sender {
    
    if([self validateProfileField]) {
        
        NSLog(@"Profile Update Successfully.");
        [dictUserParams setValue:[Model getLatereUserId] forKey:kUserId];
        [dictUserParams setValue:txtFld_FName.text forKey:kFirstName];
        [dictUserParams setValue:txtFld_LName.text forKey:kLastName];
        
        UIWindow *frontWindow = [[[UIApplication sharedApplication] windows] lastObject];
        [MBProgressHUD showHUDAddedToWindow:frontWindow animated:YES];
        
        [PAWSCalls updateUserProfileWithParam:dictUserParams image:img_UserProfile completionBlock:^(id JSON, WebServiceResult result) {
            
            [MBProgressHUD hideHUDForWindow:frontWindow animated:YES];
            
            if(result == WebServiceResultSuccess && [JSON[@"status"] isEqualToString:@"0"]){
                
//                if([userDefault objectForKey:kLatererUserDetail]) {
//                    [userDefault removeObjectForKey:kLatererUserDetail];
//                }
                [Model removeLatererUserDetail];
                [Model setLatererUserDetail:JSON[@"data"]];
//                [userDefault setObject:JSON[@"data"] forKey:kLatererUserDetail];
//                [userDefault synchronize];
                
                showAlertViewWithMessage(JSON[@"message"]);
                
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


-(BOOL) validateProfileField {
    
    BOOL txtFname = NO, txtLname = NO, txtPhone = NO;
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
    
    if (txtFname && txtLname && txtPhone) {
        return  YES;
    } else {
        showAlertViewWithMessage(errMessage);
        return NO;
    }
}

@end
