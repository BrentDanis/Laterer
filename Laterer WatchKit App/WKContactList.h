//
//  WKContactList.h
//  laterer
//
//  Created by Nimble Chapps on 13/04/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface WKContactList : NSObject
@property (weak, nonatomic) IBOutlet WKInterfaceImage *img_ContactImage;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *lbl_ContactName;
@end
