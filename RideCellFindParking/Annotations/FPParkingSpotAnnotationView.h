//
//  ParkingSpotAnnotationView.h
//  RideCellFindParking
//
//  Created by Dhaval on 9/27/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "FPParkingSpotAnnotation.h"
#import "FPParkingSpotCalloutView.h"

@interface FPParkingSpotAnnotationView : MKAnnotationView

@property (nonatomic, readwrite, strong) FPParkingSpotCalloutView *calloutView;

- (instancetype)initWithAnnotation:(FPParkingSpotAnnotation *)spotAnnotation reuseIdentifier:(NSString *)reuseIdentifier;

@end
