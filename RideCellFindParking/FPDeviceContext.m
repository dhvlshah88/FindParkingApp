//
//  DeviceContext.m
//  RideCellFindParking
//
//  Created by Dhaval on 9/26/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "FPDeviceContext.h"

static NSString * const kDeviceContextHasSeenLocationPermission = @"kDeviceContextHasSeenLocationPermission";

@interface FPDeviceContext ()

@end

@implementation FPDeviceContext

#pragma mark Static methods

+ (FPDeviceContext *)instance {
    static dispatch_once_t pred;
    static FPDeviceContext *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        // Initialize location manager
        [self initializeLocationServices];
        _geocoder = [[CLGeocoder alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    
}

#pragma mark Private Methods

- (void)initializeLocationServices {
    if (!self.locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    
    if ([self isLocationServiceEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        } else {
            [self.locationManager startUpdatingLocation];
        }
    }
}

- (void)startUpdatingLocation {
    [self.locationManager startUpdatingLocation];
}

#pragma mark Public Methods

- (void)locationCoordinatesFromAddressString:(NSString *)addressString completionHandler:(void (^)(CLLocationCoordinate2D currentCoordinate)) completionHandler {
    __block CLLocationCoordinate2D locationCoordinate;
    [self.geocoder geocodeAddressString:addressString completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            switch (error.code) {
                case kCLErrorGeocodeFoundNoResult:
                    NSLog(@"Address not found");
                    break;
                    
                default:
                    break;
            }
            completionHandler(kCLLocationCoordinate2DInvalid);
        } else {
            locationCoordinate = ((CLPlacemark *)[placemarks firstObject]).location.coordinate;
            completionHandler(locationCoordinate);
        }
    }];
}

//- (NSString *)reverseGeocodeLocation:(CLLocation *)location {
//    NSString *name = [self locationNameReverseGecodeLocation:location];
//    NSString *addressOnly = [self addressReserveGecodeLocation:location];
//    return [NSString stringWithFormat:@"%@\n%@", name, addressOnly];
//}

//- (NSString *)locationNameReverseGecodeLocation:(CLLocation *)location {
//    __block CLPlacemark *placemark;
//    __block NSString *locationName;
//    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        if (!error && [placemarks count] > 0) {
//            placemark = [placemarks lastObject];
//            locationName = [NSString stringWithFormat:@"%@, %@, %@ %@",
//                           placemark.name,
//                           placemark.locality, placemark.administrativeArea,
//                           placemark.postalCode];
//            ;
//        } else {
//            NSLog(@"%@", error.debugDescription);
//        }
//    }];
//    
//    return locationName;
//}

- (void)addressReserveGecodeLocation:(CLLocation *)location completionHandler:(void (^)(NSString *address))completionHandler {
    __block CLPlacemark *placemark;
    __block NSString *address;

        [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (!error && [placemarks count] > 0) {
                placemark = [placemarks lastObject];
                address = [NSString stringWithFormat:@"%@, %@, %@ %@",
                           placemark.name,
                           placemark.locality, placemark.administrativeArea,
                           placemark.postalCode];
                completionHandler(address);
            } else {
                NSLog(@"%@", error.debugDescription);
                completionHandler(nil);
            }
        }];
}

#pragma mark Location Permission

- (BOOL)hasSeenLocationPermission {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kDeviceContextHasSeenLocationPermission] boolValue];
}

- (void)setHasSeenLocationPermission {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(true) forKey:kDeviceContextHasSeenLocationPermission];
    [defaults synchronize];
}

- (BOOL)isLocationServiceEnabled {
    return [CLLocationManager locationServicesEnabled];
}

@end
