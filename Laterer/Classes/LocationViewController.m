//
//  LocationViewController.m
//  laterer
//
//  Created by Nimble Chapps on 14/03/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.showsUserLocation = YES;

    CLLocationCoordinate2D centerCoordinate = {self.latitude, self.longitude};
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1f, 0.0f);
    MKCoordinateRegion region = {centerCoordinate, span};
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:centerCoordinate];
//    [annotation setTitle:@"User Location"];
//    annotation.subtitle = @"This is my sweet home.";
    [self.mapView setRegion:region];
    [self.mapView addAnnotation:annotation];
    
    // Zoom
    MKMapRect zoomRect = MKMapRectNull;
    MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
    MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
    if (MKMapRectIsNull(zoomRect)) {
        zoomRect = pointRect;
    } else {
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [self.mapView setVisibleMapRect:zoomRect animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissLocationController:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
