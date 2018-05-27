//
//  InitialViewController.h
//  Laterer
//
//  Created by Nimble Chapps on 02/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InitialViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIView *loginDetailView;
@property (weak, nonatomic) IBOutlet UIButton *btn_Login;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginDetailViewYConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonBottomConstant;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelBottomConstant;

@property (weak, nonatomic) IBOutlet UITextField *text_EmailAddress;
@property (weak, nonatomic) IBOutlet UITextField *text_Password;

- (IBAction)btn_LoginTapped:(id)sender;
- (IBAction)btn_ForgotPasswordTapped:(id)sender;
- (IBAction)btn_NewRegistrationTapped:(id)sender;
@end
