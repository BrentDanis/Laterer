//
//  MainTabBarController.m
//  Laterer
//
//  Created by Nimble Chapps on 03/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.hidesBackButton = YES;
//    self.navigationController.hidesBarsOnTap = YES;

    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:66.0/255.0 green:145.0/255.0 blue:159.0/255.0 alpha:1.0]];
    
//    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
