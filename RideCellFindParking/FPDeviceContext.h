//
//  DeviceContext.h
//  RideCellFindParking
//
//  Created by Dhaval on 9/26/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FPDeviceContext : NSObject

@property (nonatomic, readonly, strong) CLLocationManager *locationManager;
@property (nonatomic, readonly, strong) CLGeocoder *geocoder;

// Static constructor

+ (FPDeviceContext *)instance;

- (void)locationCoordinatesFromAddressString:(NSString *)addressString completionHandler:(void (^)(CLLocationCoordinate2D currentCoordinate)) completionHandler;

//- (NSString *)reverseGeocodeLocation:(CLLocation *)location;

//- (NSString *)locationNameReverseGecodeLocation:(CLLocation *)location;

- (void)addressReserveGecodeLocation:(CLLocation *)location completionHandler:(void (^)(NSString *address))completionHandler;

// Location premissions

- (BOOL)hasSeenLocationPermission;

- (void)setHasSeenLocationPermission;

- (BOOL)isLocationServiceEnabled;

@end
