//
//  FPJsonUtility.m
//  RideCellFindParking
//
//  Created by Dhaval on 9/26/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "FPJsonUtility.h"
#import "ParkingSpot.h"
#import "FPDeviceContext.h"

@implementation FPJsonUtility

+ (NSArray *)freeParkingSpots:(id)jsonData {
    NSMutableArray *freeParkingSpots = [NSMutableArray new];
    if (jsonData) {
        for (NSDictionary *spotJSON in jsonData) {
            ParkingSpot *spot = [[ParkingSpot alloc] init];
            spot.spotId = ((NSNumber *)spotJSON[@"id"]).integerValue;
            spot.coordinate = CLLocationCoordinate2DMake(((NSString *)spotJSON[@"lat"]).doubleValue, ((NSString *)spotJSON[@"lng"]).doubleValue);
            spot.spotName = spotJSON[@"name"];
            spot.costPerMinute = ((NSString *)spotJSON[@"cost_per_minute"]).doubleValue;
            spot.parkingSpotLimit = [[ParkingSpotLimit alloc] initWithReserveTimeMin:((NSNumber *)spotJSON[@"min_reserve_time_mins"]).unsignedIntegerValue andMax:((NSNumber *)spotJSON[@"max_reserve_time_mins"]).unsignedIntegerValue];
            spot.reserved = ((NSNumber *)spotJSON[@"is_reserved"]).boolValue;
            [freeParkingSpots addObject:spot];
        }
    }
    
    return freeParkingSpots;
}

@end
