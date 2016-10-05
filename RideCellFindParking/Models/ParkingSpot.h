//
//  ParkingLocation.h
//  RideCellFindParking
//
//  Created by Dhaval on 9/26/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParkingSpotLimit.h"
#import <CoreLocation/CoreLocation.h>

@interface ParkingSpot : NSObject

@property (nonatomic, readwrite) NSInteger spotId;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite, copy) NSString *spotName;
@property (nonatomic, readwrite, copy) NSString *spotAddress;
@property (nonatomic, readwrite) double costPerMinute;
@property (nonatomic, readwrite) ParkingSpotLimit *parkingSpotLimit;
@property (nonatomic, readwrite, getter=isReserved) BOOL reserved;
@property (nonatomic, readwrite) NSDate *reservedUntil;

@end
