//
//  FPSearchParkingSpotsView.h
//  RideCellFindParking
//
//  Created by Dhaval on 9/27/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "ParkingSpot.h"
#import "FPSearchParkingSpotsViewDelegate.h"
#import <APLTextField.h>

@interface FPSearchParkingSpotsView : UIView

@property (nonatomic, readonly, strong) UIView *containerView;
@property (nonatomic, readonly, strong) UITextField *locationTextField;
@property (nonatomic, readonly, strong) APLTextField *dateTextField;
@property (nonatomic, readonly, strong) UITextField *timeTextField;
@property (nonatomic, readonly, strong) UILabel *reservationLabel;
@property (nonatomic, readonly, strong) UILabel *reservationTimeLabel;
@property (nonatomic, readonly, strong) UILabel *maxReservationTimeLabel;
@property (nonatomic, readonly, strong) UISlider *reservationTimeSlider;
@property (nonatomic, readonly, strong) UIButton *searchButton;
@property (nonatomic, readwrite, strong) ParkingSpot *spot;
@property (nonatomic, weak, readwrite) id<FPSearchParkingSpotsViewDelegate> searchDelegate;
@property (nonatomic, readwrite, getter=isHidden) BOOL hidden;

- (void)resignFirstResponder;

@end
