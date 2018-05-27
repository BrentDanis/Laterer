//
//  UpdateProfileVC.m
//  laterer
//
//  Created by Nimble Chapps on 19/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "UpdateProfileVC.h"

@interface UpdateProfileVC ()

@end

@implementation UpdateProfileVC

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
