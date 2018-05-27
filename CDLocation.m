//
//  CDLocation.m
//  GeoMapKitDemo
//
//  Created by Nimble Chapps on 27/02/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "CDLocation.h"

@implementation CDLocation

-(CDLocation *)initWithLocationManager {
    
    self = [super init];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=kCLDistanceFilterNone;
    locationManager.distanceFilter = 500;
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
    
//    [locationManager startMonitoringSignificantLocationChanges];
    
    return self;
}


-(CLLocationCoordinate2D) getCurrentLocationCordinate {

    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        NSLog(@"Location service is enabled");
    }
    else {
        NSLog(@"Location service is Disabled");
    }
    
    return currentCordinate;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
//        [userDefault setFloat:currentLocation.coordinate.latitude forKey:kLatererUserLatitude];
//        [userDefault setFloat:currentLocation.coordinate.longitude forKey:kLatererUserLongitude];
        
        [Model setLatLong:currentLocation.coordinate.latitude andLong:currentLocation.coordinate.longitude];
        
        currentCordinate = currentLocation.coordinate;
    }
    
    // Stop Location Manager
//    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"location didFailWithError: %@", error);
}

@end
