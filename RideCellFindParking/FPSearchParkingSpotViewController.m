//
//  FirstViewController.m
//  RideCellFindParking
//
//  Created by Dhaval on 9/26/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "FPSearchParkingSpotViewController.h"
#import "FPDeviceContext.h"
#import "FPNetworkManager.h"
#import "ParkingSpot.h"
#import "FPParkingSpotAnnotation.h"
#import "FPParkingSpotAnnotationView.h"
#import "FPSearchParkingSpotsView.h"

NSString * const kParkingSpotAnnotationViewReuseIdentifier = @"kParkingSpotAnnotationViewReuseIdentifier";

@interface FPSearchParkingSpotViewController ()

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) MKMapCamera *mapCamera;
@property (nonatomic, strong) UIButton *currentLocationButton;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) NSInteger numberOfAnnotations;
@property (nonatomic, strong) UIAlertController *locationServicesOffAlertController;
@property (nonatomic, strong) FPNetworkManager *networkManager;
@property (nonatomic, strong) NSArray *parkingSpots;
@property (nonatomic, strong) NSMutableArray *parkingSpotAnnotations;
@property (nonatomic, strong) FPParkingSpotCalloutView *selectedCalloutView;
@property (nonatomic, strong) FPSearchParkingSpotsView *searchView;
@property (nonatomic, strong) MASConstraint *searchViewBottomConstraint;
@property (nonatomic) NSInteger reservedTime;
@property (nonatomic, strong) ParkingSpot *selectedParkingSpot;

@end

@implementation FPSearchParkingSpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationItemLabel];
    
    FPDeviceContext *context = [FPDeviceContext instance];
    if (context.locationManager) {
        _locationManager = context.locationManager;
        self.locationManager.delegate = self;
    }
    
    _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = true;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.zoomEnabled = true;
    self.mapView.scrollEnabled = true;
    
    _mapCamera = [MKMapCamera cameraLookingAtCenterCoordinate:self.locationManager.location.coordinate fromDistance:650 pitch:0 heading:90.0];
    self.mapView.camera = self.mapCamera;
    
    [self setMapCenterUsingCoordinate:self.locationManager.location.coordinate];
    [self.view addSubview:self.mapView];
    [self.mapView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    _searchView = [[FPSearchParkingSpotsView alloc] init];
    [self.mapView addSubview:self.searchView];
    self.searchView.searchDelegate = self;
    [self.searchView makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(44);
        make.height.greaterThanOrEqualTo(@(300));
    }];
    self.searchView.userInteractionEnabled = true;
    [self.mapView bringSubviewToFront:self.searchView];
    
    _currentLocationButton = [[UIButton alloc] init];
    self.currentLocationButton.backgroundColor = [UIColor blueColor];
    self.currentLocationButton.layer.cornerRadius = 8.0;
    [self.mapView addSubview:self.currentLocationButton];
    [self.currentLocationButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-20);
        make.bottom.equalTo(self.view).with.offset(-70);
        make.width.equalTo(@(30));
        make.height.equalTo(@(30));
    }];
    [self.mapView bringSubviewToFront:self.currentLocationButton];
    [self.currentLocationButton addTarget:self action:@selector(showUserCurrentLocation) forControlEvents:UIControlEventTouchUpInside];
    
    _parkingSpotAnnotations = [NSMutableArray new];
    _networkManager = [[FPNetworkManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [self populateParkingSpotsAroundUserCoordinate];
    
    UITapGestureRecognizer *tapGestureRecogizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnView:)];
    tapGestureRecogizer.delegate = self;
    tapGestureRecogizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecogizer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager startUpdatingLocation];
        [self setMapCenterUsingCoordinate:self.locationManager.location.coordinate];
    } else if (status == kCLAuthorizationStatusDenied) {
        [self alertUserLocationServicesDenied];
    } else if (status == kCLAuthorizationStatusNotDetermined) {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [[FPDeviceContext instance].locationManager stopUpdatingLocation];
    NSLog(@"Update failed with error: %@", error);
}

#pragma mark MKMapViewDeleagate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(nonnull MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[MKUserLocation class]])
        return;
    
    FPParkingSpotAnnotation *spotAnnotation = mapView.selectedAnnotations[0];
    if ([spotAnnotation isKindOfClass:[FPParkingSpotAnnotation class]]) {
        _selectedCalloutView = [[FPParkingSpotCalloutView alloc] initWithSpotAnnotation:spotAnnotation andUserLocation:self.locationManager.location];
        self.selectedCalloutView.calloutDelegate = self;
        view.userInteractionEnabled = true;
        [self.selectedCalloutView addToAnnotationView:view];
        [self.selectedCalloutView layoutIfNeeded];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(nonnull MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[MKUserLocation class]])
        return;
    
    if ([view.annotation isKindOfClass:[FPParkingSpotAnnotation class]]) {
        for (UIView *subView in view.subviews) {
            if ([subView isKindOfClass:[FPParkingSpotCalloutView class]]) {
                subView.userInteractionEnabled = false;
                [subView removeFromSuperview];
            }
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(nonnull id<MKAnnotation>)annotation {
    FPParkingSpotAnnotationView *spotView = nil;
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[FPParkingSpotAnnotation class]]) {
        spotView = (FPParkingSpotAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kParkingSpotAnnotationViewReuseIdentifier];
        if (!spotView) {
            spotView = [[FPParkingSpotAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kParkingSpotAnnotationViewReuseIdentifier];
            spotView.centerOffset = CGPointMake(0, -10);
            spotView.enabled = true;
        } else {
            spotView.annotation = annotation;
        }
    }
    
    return spotView;
}

#pragma mark FTParkingSpotCalloutViewDelegate

- (void)parkingSpotCalloutViewDidPressPayAndReserveSpot:(FPParkingSpotAnnotation *)spot {
    _selectedParkingSpot = spot.spot;
    BOOL result = [self.networkManager reserveFreeParkingSpot:self.selectedParkingSpot forMinutes:self.reservedTime];
    if (result) {
        //show successful alert controller
    }
}

- (void)parkingSpotCalloutViewDidPressMoreAboutSpot:(FPParkingSpotAnnotation *)spot {
    
}

#pragma mark FTSearchParkingSpotsViewDelegate

- (void)searchParkingSpotsViewDidSearchAroundLocation:(NSString *)locationAddress onDate:(NSDate *)date andTime:(NSDate *)time withReserveTime:(NSInteger)reserveTime {
    self.reservedTime = reserveTime;
    
    __block CLLocationCoordinate2D searchCoordinate;
    [[FPDeviceContext instance] locationCoordinatesFromAddressString:locationAddress completionHandler:^(CLLocationCoordinate2D currentCoordinate) {
        searchCoordinate = currentCoordinate;
        if (CLLocationCoordinate2DIsValid(searchCoordinate)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setMapCenterUsingCoordinate:searchCoordinate];
                [self populateParkingSpotsAroundCoordinate:searchCoordinate];
                [self.searchView endEditing:false];
            });
        }
    }];
}

#pragma mark UIGestureRecoginzerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UITextField class]] || [touch.view isKindOfClass:[UIButton class]]) {
        return false;
    }
    
    return true;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return true;
}

#pragma mark Private methods

- (void)alertUserLocationServicesDenied {
    _locationServicesOffAlertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Location Services Off", nil) message:NSLocalizedString(@"Turn On Location Services in Settings > Privacy to allows FindParking to determine your current location.", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:true completion:^{
            _locationServicesOffAlertController = nil;
        }];
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *settingsUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [application openURL:settingsUrl options:@{} completionHandler:nil];
        } else {
            [application openURL:settingsUrl];
        }
    }];
    
    [self.locationServicesOffAlertController addAction:settingsAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:true completion:nil];
        _locationServicesOffAlertController = nil;
    }];
    [self.locationServicesOffAlertController addAction:okAction];
    [self presentViewController:self.locationServicesOffAlertController animated:true completion:nil];
}

- (void)populateParkingSpotsAroundUserCoordinate {
    [self populateParkingSpotsAroundCoordinate:self.locationManager.location.coordinate];
}

- (void)populateParkingSpotsAroundCoordinate:(CLLocationCoordinate2D)coordinate {
    __weak FPSearchParkingSpotViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CLLocationCoordinate2D currentCoordinate = coordinate;
        [weakSelf.networkManager getFreeParkingSpotsUsingLatitude:currentCoordinate.latitude andLongitude:currentCoordinate.longitude
                                            withCompletionHandler:^(NSArray *spots, NSError *error) {
                                                if (!error) {
                                                    _parkingSpots = spots;
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        if ([[FPDeviceContext instance] isLocationServiceEnabled]) {
                                                            for (ParkingSpot *parkingSpot in weakSelf.parkingSpots) {
                                                                FPParkingSpotAnnotation *spotPin = [[FPParkingSpotAnnotation alloc] initWithParkingSpot:parkingSpot];
                                                                weakSelf.numberOfAnnotations += 1;
                                                                [weakSelf.parkingSpotAnnotations addObject:spotPin];
                                                            }
                                                            
                                                            [weakSelf.mapView addAnnotations:weakSelf.parkingSpotAnnotations];
                                                            self.searchView.spot = [self.parkingSpots firstObject];
                                                        }
                                                    });
                                                }
                                            }];
    });
}

- (void)showUserCurrentLocation {
    [UIView animateWithDuration:.8 animations:^{
        self.mapView.camera = self.mapCamera;
    }];
}

- (void)setNavigationItemLabel {
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = NSLocalizedString(@"PARKING APP", nil);
    self.navigationItem.titleView = label;
}

- (void)setMapCenterUsingCoordinate:(CLLocationCoordinate2D)coordinate {
    MKCoordinateRegion coordinateRegion = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.005, 0.005));
    [self.mapView setRegion:coordinateRegion animated:true];
}

- (void)didTapOnView:(id)sender {
    [self.searchViewBottomConstraint uninstall];
    if (!self.searchView.isHidden) {
        [self.searchView updateConstraints:^(MASConstraintMaker *make) {
            _searchViewBottomConstraint = make.bottom.equalTo(self.view.top).with.offset(64);
            make.top.lessThanOrEqualTo(self.view);
        }];
        self.searchView.hidden = true;
        [self.searchView endEditing:false];
    } else {
        [self.searchView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(44);
            make.height.greaterThanOrEqualTo(@(300));
        }];
        self.searchView.hidden = false;
        [self.searchView endEditing:true];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

@end
