//
//  ParkingSpotLimit.m
//  RideCellFindParking
//
//  Created by Dhaval on 9/26/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "ParkingSpotLimit.h"

@implementation ParkingSpotLimit

- (instancetype)initWithReserveTimeMin:(NSUInteger)minReserveTime andMax:(NSUInteger)maxReserveTime {
    self = [super init];
    if (self) {
        _minReserveTime = minReserveTime;
        _maxReserveTime = maxReserveTime;
    }
    return self;
}

@end
