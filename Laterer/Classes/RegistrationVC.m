//
//  RegistrationVC.m
//  Laterer
//
//  Created by Nimble Chapps on 09/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "RegistrationVC.h"

@interface RegistrationVC ()

@end

@implementation RegistrationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
