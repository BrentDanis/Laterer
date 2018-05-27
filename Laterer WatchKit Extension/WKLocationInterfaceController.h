//
//  WKLocationInterfaceInterfaceController.h
//  laterer
//
//  Created by Nimble Chapps on 17/04/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface WKLocationInterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceMap *wkMapView;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@end
