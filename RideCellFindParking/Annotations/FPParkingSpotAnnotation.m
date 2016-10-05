//
//  ParkingSpotAnnotation.m
//  RideCellFindParking
//
//  Created by Dhaval on 9/27/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "FPParkingSpotAnnotation.h"

@implementation FPParkingSpotAnnotation

@synthesize coordinate = _coordinate;

- (instancetype)initWithParkingSpot:(ParkingSpot *)spot {
    self = [super init];
    if (self) {
        _spot = spot;
        _coordinate = self.spot.coordinate;
    }
    return self;
}

- (NSString *)title {
    return self.spot.spotName;
}

- (NSString *)subtitle {
    return self.spot.spotAddress;
}

@end
