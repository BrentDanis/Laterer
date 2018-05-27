//
//  CDLocation.h
//  GeoMapKitDemo
//
//  Created by Nimble Chapps on 27/02/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CDLocation : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCordinate;
}

-(CDLocation *)initWithLocationManager;

-(CLLocationCoordinate2D) getCurrentLocationCordinate;

@end
