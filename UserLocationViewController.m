//
//  UserLocationViewController.m
//  GeoMapKitDemo
//
//  Created by Nimble Chapps on 27/02/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "UserLocationViewController.h"

@interface UserLocationViewController () {

    NSArray *first;
    NSArray *second;
    NSArray *third;
}
@end

@implementation UserLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.showsUserLocation = YES;
    NSLog(@"Map View lat %f -- long %f",self.latitude, self.longitude);
    
    if ((self.latitude == 0 && self.longitude == 0)) {
        self.latitude = 37.332333;
        self.longitude = -122.031219;
    }
    
    CLLocationCoordinate2D centerCoordinate = {self.latitude, self.longitude};
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1f, 0.1f);
    MKCoordinateRegion region = {centerCoordinate, span};
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:centerCoordinate];
    [annotation setTitle:@"I am Here"];
    annotation.subtitle = @"This is my sweet home.";
    
//    [self.mapView setRegion:region];
//    [self.mapView addAnnotation:annotation];
 
    
//    [self addAllPins];

}

- (void)viewDidAppear:(BOOL)animated {

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
//    _mapView.centerCoordinate = userLocation.location.coordinate;
}

// Add anotaiton to map view
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id <MKAnnotation> mp = [annotationView annotation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance
    ([mp coordinate], 2000, 2000);
    [mv setRegion:region animated:YES];
    [mv selectAnnotation:mp animated:YES];
}


- (IBAction)switchMapTypeValueChanged:(id)sender {
    
    if ([sender isOn]) {
        self.mapView.mapType = MKMapTypeSatellite;
    }
    else {
        self.mapView.mapType = MKMapTypeStandard;
    }
}

- (IBAction)btn_zoomTapped:(id)sender {
    MKUserLocation *userLocation = _mapView.userLocation;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (
                                        userLocation.location.coordinate, 20000, 20000);
    [_mapView setRegion:region animated:NO];
}


// Multiple annotations
-(void)addAllPins
{
    NSArray *name=[[NSArray alloc]initWithObjects:
                   @"VelaCherry",
                   @"Perungudi",
                   @"Tharamani", nil];
    
    NSMutableArray *arrCoordinateStr = [[NSMutableArray alloc] initWithCapacity:name.count];
    
    [arrCoordinateStr addObject:@"12.970760345459, 80.2190093994141"];
    [arrCoordinateStr addObject:@"12.9752297537231, 80.2313079833984"];
    [arrCoordinateStr addObject:@"12.9788103103638, 80.2412414550781"];
    
    for(int i = 0; i < name.count; i++)
    {
        [self addPinWithTitle:name[i] AndCoordinate:arrCoordinateStr[i]];
    }
    
    first = [NSArray arrayWithObjects: [NSNumber numberWithDouble:12.970760345459], [NSNumber numberWithDouble:80.2190093994141], nil];
    second = [NSArray arrayWithObjects: [NSNumber numberWithDouble:12.9752297537231], [NSNumber numberWithDouble:80.2313079833984], nil];
    third = [NSArray arrayWithObjects: [NSNumber numberWithDouble:12.9788103103638], [NSNumber numberWithDouble:80.2412414550781], nil];

    [self drawLines:first destination:second];
}

-(void)addPinWithTitle:(NSString *)title AndCoordinate:(NSString *)strCoordinate
{
    MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
    
    // clear out any white space
    strCoordinate = [strCoordinate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // convert string into actual latitude and longitude values
    NSArray *components = [strCoordinate componentsSeparatedByString:@","];
    
    double latitude = [components[0] doubleValue];
    double longitude = [components[1] doubleValue];
    
    // setup the map pin with all data and add to map view
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    mapPin.title = title;
    mapPin.coordinate = coordinate;
    
    [self.mapView addAnnotation:mapPin];
    
}



-(void) drawLines:(NSArray *)sourcePoint destination:(NSArray *)destinationPoint {
    
   
    
    MKPlacemark *source = [[MKPlacemark   alloc]initWithCoordinate:CLLocationCoordinate2DMake([sourcePoint[0] doubleValue], [sourcePoint[1] doubleValue])
                                                 addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
    [srcMapItem setName:@""];
    
    MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake([destinationPoint[0] doubleValue], [destinationPoint[1] doubleValue])
                                                    addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    [distMapItem setName:@""];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    [request setSource:srcMapItem];
    [request setDestination:distMapItem];
    [request setTransportType:MKDirectionsTransportTypeWalking];
    
    MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
    
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        NSLog(@"response = %@",response);
        NSArray *arrRoutes = [response routes];
        [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            MKRoute *rout = obj;
            
            MKPolyline *line = [rout polyline];
            [self.mapView addOverlay:line];
            NSLog(@"Rout Name : %@",rout.name);
            NSLog(@"Total Distance (in Meters) :%f",rout.distance);
            
            NSArray *steps = [rout steps];
            
            NSLog(@"Total Steps : %lu",(unsigned long)[steps count]);
            
            [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSLog(@"Rout Instruction : %@",[obj instructions]);
                NSLog(@"Rout Distance : %f",[obj distance]);
            }];
        }];
    }];
}






@end
