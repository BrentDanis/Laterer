//
//  UpdatePasswordTableViewController.m
//  laterer
//
//  Created by Nimble Chapps on 19/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "UpdatePasswordTableViewController.h"

@interface UpdatePasswordTableViewController () {

    __weak IBOutlet UITextField *txtFld_OldPassword;
    __weak IBOutlet UITextField *txtFld_Password;
    __weak IBOutlet UITextField *txtFld_ConfirmPassword;
    
}
@end

@implementation UpdatePasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.allowsSelection = NO;

    txtFld_OldPassword.secureTextEntry = YES;
    txtFld_Password.secureTextEntry = YES;
    txtFld_ConfirmPassword.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)btnUpdatePasswordTapped:(id)sender {

    if ([self validatePasswordField]) {

        UIWindow *frontWindow = [[[UIApplication sharedApplication] windows] lastObject];
        [MBProgressHUD showHUDAddedToWindow:frontWindow animated:YES];
        
        [PAWSCalls changePassword:txtFld_OldPassword.text newPassword:txtFld_Password.text completionBlock:^(id JSON, WebServiceResult result) {
            
            [MBProgressHUD hideHUDForWindow:frontWindow animated:YES];
            
            if (result == WebServiceResultSuccess && [JSON[@"status"] isEqualToString:@"0"]) {
                showAlertViewWithMessage(JSON[@"message"]);
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                showAlertViewWithMessage(JSON[@"message"]);
            }
        }];
    }

}

-(BOOL) validatePasswordField {
    
    BOOL txtOldPassword = NO, txtPassword = NO, txtConfirmPassword = NO;
    NSString *errMessage = @" ";
    
    if(textFieldNotNull(txtFld_OldPassword.text)) {
        txtOldPassword = YES;
    } else {
        errMessage = [NSString stringWithFormat:@"%@ Old Password required,",errMessage];
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
    
    
    if (txtPassword && txtConfirmPassword) {
        return  YES;
    } else {
        showAlertViewWithMessage(errMessage);
        return NO;
    }
}

#pragma mark -- Text field delegate methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

@end
