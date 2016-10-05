//
//  FPParkingSpotCalloutView.h
//  RideCellFindParking
//
//  Created by Dhaval on 9/27/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "FPParkingSpotAnnotation.h"

@protocol FPParkingSpotCalloutViewDelegate <NSObject>

- (void)parkingSpotCalloutViewDidPressPayAndReserveSpot:(FPParkingSpotAnnotation *)spot;
- (void)parkingSpotCalloutViewDidPressMoreAboutSpot:(FPParkingSpotAnnotation *)spot;

@end

@interface FPParkingSpotCalloutView : UIView

@property (nonatomic, strong, readonly) FPParkingSpotAnnotation *spotAnnotation;
@property (nonatomic, weak, readwrite) id<FPParkingSpotCalloutViewDelegate> calloutDelegate;

- (instancetype)initWithSpotAnnotation:(FPParkingSpotAnnotation *)spotAnnotation andUserLocation:(CLLocation *)userLocation;

- (void)addToAnnotationView:(MKAnnotationView *)annotationView;

@end
