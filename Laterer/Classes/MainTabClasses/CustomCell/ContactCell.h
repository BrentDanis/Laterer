//
//  ContactCell.h
//  Laterer
//
//  Created by Nimble Chapps on 04/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label_contactName;
@property(nonatomic,strong) IBOutlet UIImageView *imgVw_ContactImage;

@property (strong, nonatomic) UITapGestureRecognizer *singleTapGesture;
@property (strong, nonatomic) UITapGestureRecognizer *doubleTapGesture;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGesture;

@property (strong, nonatomic) IBOutlet UILabel *lable_latererSent;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator_laterer;

@end
