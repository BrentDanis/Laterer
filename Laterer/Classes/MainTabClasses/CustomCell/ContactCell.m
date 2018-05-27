//
//  ContactCell.m
//  Laterer
//
//  Created by Nimble Chapps on 04/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "ContactCell.h"

@implementation ContactCell

@synthesize label_contactName = _label_contactName;
@synthesize singleTapGesture = _singleTapGesture;
@synthesize doubleTapGesture = _doubleTapGesture;
@synthesize longPressGesture = _longPressGesture;
@synthesize lable_latererSent = _lable_latererSent;
@synthesize activityIndicator_laterer = _activityIndicator_laterer;
- (void)awakeFromNib {

    _lable_latererSent.hidden = YES;
    _activityIndicator_laterer.hidden = YES;
    
    // gestures
    self.singleTapGesture = [[UITapGestureRecognizer alloc] init];
    self.singleTapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:self.singleTapGesture];
    
    self.doubleTapGesture = [[UITapGestureRecognizer alloc] init];
    self.doubleTapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:self.doubleTapGesture];
    
    [self.singleTapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
    
    self.longPressGesture = [[UILongPressGestureRecognizer alloc] init];
    self.longPressGesture.minimumPressDuration = 1.0;
    [self addGestureRecognizer:self.longPressGesture];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.imgVw_ContactImage.layer setCornerRadius:self.imgVw_ContactImage.frame.size.width/2];
    [self.imgVw_ContactImage.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.imgVw_ContactImage.layer setBorderWidth:2];
    [self.imgVw_ContactImage setClipsToBounds:YES];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
