//
//  WKLocationInterfaceInterfaceController.m
//  laterer
//
//  Created by Nimble Chapps on 17/04/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "WKLocationInterfaceController.h"
#import <CoreLocation/CoreLocation.h>

@interface WKLocationInterfaceController ()

@end

@implementation WKLocationInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
//    NSDictionary *data = context;
    
    CLLocationCoordinate2D locationCordinate = CLLocationCoordinate2DMake(-33.8634, 151.211);
//    CLLocationCoordinate2D locationCordinate = CLLocationCoordinate2DMake(data[@"fLat"], data[@"fLong"]);

    MKCoordinateSpan span = MKCoordinateSpanMake(0.005f, 0.005f);
    MKCoordinateRegion region = {locationCordinate, span};
    
    [self.wkMapView addAnnotation:locationCordinate withPinColor:WKInterfaceMapPinColorRed];
    [self.wkMapView setRegion:region];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



