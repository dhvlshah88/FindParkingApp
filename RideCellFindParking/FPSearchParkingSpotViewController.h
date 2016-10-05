//
//  FirstViewController.h
//  RideCellFindParking
//
//  Created by Dhaval on 9/26/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Mapkit/MKAnnotation.h>
#import "FPParkingSpotCalloutView.h"
#import "FPSearchParkingSpotsViewDelegate.h"

@interface FPSearchParkingSpotViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, FPParkingSpotCalloutViewDelegate, UIGestureRecognizerDelegate, FPSearchParkingSpotsViewDelegate>

@end

