//
//  ParkingSpotAnnotation.h
//  RideCellFindParking
//
//  Created by Dhaval on 9/27/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "ParkingSpot.h"

@interface FPParkingSpotAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly, strong) ParkingSpot *spot;

- (instancetype)initWithParkingSpot:(ParkingSpot *)spot;

@end
