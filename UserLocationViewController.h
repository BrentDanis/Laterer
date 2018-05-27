//
//  UserLocationViewController.h
//  GeoMapKitDemo
//
//  Created by Nimble Chapps on 27/02/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface UserLocationViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property float latitude;
@property float longitude;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *switchMapType;
- (IBAction)switchMapTypeValueChanged:(id)sender;
- (IBAction)btn_zoomTapped:(id)sender;
@end
