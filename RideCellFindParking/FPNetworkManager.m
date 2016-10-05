//
//  FPNetworkManager.m
//  RideCellFindParking
//
//  Created by Dhaval on 9/26/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "FPNetworkManager.h"
#import "FPDeviceContext.h"
#import "FPJsonUtility.h"

NSString * const kParkingLocationBaseUrl = @"http://ridecellparking.herokuapp.com/api/v1/parkinglocations/";
NSString * const kGetParkingLocations = @"search?lat=%f&lng=%f";
NSString * const kReserveParkingSpot = @"%ld/reserve/";
const NSInteger kUserId = 1;

@interface FPNetworkManager ()

@property (nonatomic, readonly, strong) NSURLSessionConfiguration *sessionConfiguration;
@property (nonatomic, readonly, strong) AFURLSessionManager *urlSessionManager;
@property (nonatomic, readonly, strong) AFHTTPSessionManager *httpSessionManager;

@end

@implementation FPNetworkManager

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration {
    self = [super init];
    if (self) {
        _sessionConfiguration = sessionConfiguration;
        _urlSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
        _httpSessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
    }
    
    return self;
}


- (void)getFreeParkingSpotsUsingLatitude:(double)latitude andLongitude:(double)longitude withCompletionHandler:(void (^)(NSArray *spots, NSError *error))completionHandler {
    NSString *freeParkingSpotUrlString = [NSString stringWithFormat:@"%@%@", kParkingLocationBaseUrl, [NSString stringWithFormat:kGetParkingLocations, latitude, longitude]];
    NSDictionary *parameters = @{@"format": @"json"};
    [self.httpSessionManager GET:freeParkingSpotUrlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"/n/%@", responseObject);
        NSArray *parkingSpots = [FPJsonUtility freeParkingSpots:responseObject];
        completionHandler(parkingSpots, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@/n/%@", error, error.description);
        completionHandler(nil, error);
    }];
}

- (BOOL)reserveFreeParkingSpot:(ParkingSpot *)spot forMinutes:(NSInteger)reserveTime {
    NSString *reserveUrlString = [NSString stringWithFormat:@"%@%@", kParkingLocationBaseUrl, [NSString stringWithFormat:kReserveParkingSpot, spot.spotId]];
    AFJSONRequestSerializer *reqSerializer = [AFJSONRequestSerializer serializer];
    [reqSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [reqSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    AFJSONResponseSerializer *repSerializer = [AFJSONResponseSerializer serializer];
    
    self.httpSessionManager.requestSerializer = reqSerializer;
    self.httpSessionManager.responseSerializer = repSerializer;
    
    [self.httpSessionManager POST:reserveUrlString
         parameters:@{@"minutes":@(reserveTime)}
         progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSLog(@"%@", responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"%@", error.userInfo);
         }];
    return false;
}

- (void)checkReachabilityStatus {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}




@end
