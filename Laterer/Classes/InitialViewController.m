//
//  InitialViewController.m
//  Laterer
//
//  Created by Nimble Chapps on 02/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "InitialViewController.h"
#import "ContactListTableViewController.h"
#import "ForgotPasswordViewController.h"
#import "RegistrationTableViewController.h"
#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "Model.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.text_EmailAddress.keyboardType = UIKeyboardTypeEmailAddress;
    self.text_Password.secureTextEntry = YES;
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"SegueMainView"]) {
        ContactListTableViewController *contactListVC __attribute__((unused)) = segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:@"SegueForgotPassword"]) {
        ForgotPasswordViewController *forgotPasswordVC __attribute__((unused)) = segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:@"SegueRegistration"]) {
        RegistrationTableViewController *newRegistrationVC __attribute__((unused)) = segue.destinationViewController;
    }
}

- (IBAction)btn_LoginTapped:(id)sender {
   
    if (textFieldNotNull(self.text_EmailAddress.text) && textFieldNotNull(self.text_Password.text) && validateEmailWithString(self.text_EmailAddress.text))
    {
        
        UIWindow *frontWindow = [[[UIApplication sharedApplication] windows] lastObject];
        [MBProgressHUD showHUDAddedToWindow:frontWindow animated:YES];
        
        [PAWSCalls loginUserWithUsername:self.text_EmailAddress.text password:self.text_Password.text completionBlock:^(id JSON, WebServiceResult result) {
            
            [MBProgressHUD hideHUDForWindow:frontWindow animated:YES];
            if (result == WebServiceResultSuccess && [JSON[@"status"] isEqualToString:@"0"]) {

//                if ([userDefault objectForKey:kLatererUserID]) {
//                    [userDefault removeObjectForKey:kLatererUserID];
//                }
//                [userDefault setObject:JSON[@"data"][@"iUserID"] forKey:kLatererUserID];
//                
//                if ([userDefault objectForKey:kLatererUserDetail]) {
//                    [userDefault removeObjectForKey:kLatererUserDetail];
//                }
//                [userDefault setObject:JSON[@"data"] forKey:kLatererUserDetail];
                
                
                [Model removeLatererUserIdAndDetail];
                [Model setLatererUserId:JSON[@"data"][@"iUserID"]];
                [Model setLatererUserDetail:JSON[@"data"]];
                
                
                // Contact Upload Call
                AppDelegate* myDelegate = (((AppDelegate*) [UIApplication sharedApplication].delegate));
                [myDelegate uploadPhoneContacts];

                MainTabBarController *mainTabbarController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabbar"];
                myDelegate.navController = [[UINavigationController alloc] initWithRootViewController:mainTabbarController];
                myDelegate.window.rootViewController = myDelegate.navController;
                [myDelegate.window makeKeyAndVisible];
                
                
            } else {
                showAlertViewWithMessage(JSON[@"message"]);
            }
        }];
    }
    else {
        showAlertViewWithMessage(@"Username and Password is in invalid format");
    }
}

- (IBAction)btn_ForgotPasswordTapped:(id)sender {

}

- (IBAction)btn_NewRegistrationTapped:(id)sender {

   // [self performSegueWithIdentifier:@"SegueRegistration" sender:self];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (DEVICE_IS_IPHONE_4) {
        if (self.loginDetailViewYConstant.constant != -10) {
            self.loginDetailViewYConstant.constant = -10;
        }
        
        self.labelBottomConstant.constant = 15;
        self.loginButtonBottomConstant.constant = 255;
        self.btnForgotPassword.hidden = YES;
    }
    else if (DEVICE_IS_IPHONE_5) {
        
        if (self.loginDetailViewYConstant.constant != 5) {
            self.loginDetailViewYConstant.constant = 5;
        }
        self.loginButtonBottomConstant.constant = self.loginDetailViewYConstant.constant + self.loginDetailView.frame.size.height + 140;
    }
    else {
        
        if (self.loginDetailViewYConstant.constant != 5) {
            self.loginDetailViewYConstant.constant = 5;
        }
        self.loginButtonBottomConstant.constant = self.loginDetailViewYConstant.constant + self.loginDetailView.frame.size.height + 200;
    }
    
    // Allows you to perform layout before the drawing cycle happens.
    //-layoutIfNeeded forces layout early
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setNeedsDisplay];
        [self.view layoutIfNeeded];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.btnForgotPassword.hidden = NO;
    self.loginDetailViewYConstant.constant = 57;
    self.loginButtonBottomConstant.constant = 67;
    self.labelBottomConstant.constant = 8;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setNeedsDisplay];
        [self.view layoutIfNeeded];
    }];
}




@end
