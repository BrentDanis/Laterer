//
//  LocationViewController.h
//  laterer
//
//  Created by Nimble Chapps on 14/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LocationViewController : UIViewController  <MKMapViewDelegate>

@property float latitude;
@property float longitude;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)dismissLocationController:(id)sender;

@end
