//
//  FPNetworkManager.h
//  RideCellFindParking
//
//  Created by Dhaval on 9/26/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <CoreLocation/CoreLocation.h>
#import "ParkingSpot.h"

@protocol FPNetworkManagerDelegate <NSObject>

@end

@interface FPNetworkManager : NSObject

@property (nonatomic, readwrite, weak) id<FPNetworkManagerDelegate> networkManagerDelegate;

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration;

- (void)freeParkingSpotsUsingLatitude:(double)latitude andLongitude:(double)longitude withCompletionHandler:(void (^)(NSArray *spots, NSError *error))completionHandler;

- (BOOL)reserveFreeParkingSpot:(ParkingSpot *)spot forMinutes:(NSInteger)reserveTime;

- (void)checkReachabilityStatus;

@end
