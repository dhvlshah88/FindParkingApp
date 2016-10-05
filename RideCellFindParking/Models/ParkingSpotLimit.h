//
//  ParkingSpotLimit.h
//  RideCellFindParking
//
//  Created by Dhaval on 9/26/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParkingSpotLimit : NSObject

@property (nonatomic, readonly) NSUInteger minReserveTime;
@property (nonatomic, readonly) NSUInteger maxReserveTime;

- (instancetype)initWithReserveTimeMin:(NSUInteger)minReserveTime andMax:(NSUInteger)maxReserveTime;

@end
