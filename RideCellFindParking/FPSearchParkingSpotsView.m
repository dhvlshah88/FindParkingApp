//
//  FPSearchParkingSpotsView.m
//  RideCellFindParking
//
//  Created by Dhaval on 9/27/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "FPSearchParkingSpotsView.h"

@interface FPSearchParkingSpotsView ()

@end

@implementation FPSearchParkingSpotsView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpSubviews];
        self.backgroundColor = [UIColor clearColor];
        _hidden = false;
    }
    return self;
}

- (void)setUpSubviews {
    _containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.containerView];
    [self.containerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).with.offset(20);
        make.right.equalTo(self).with.offset(-20);
        make.bottom.equalTo(self).with.offset(-40);
    }];
    
    _locationTextField = [[UITextField alloc] init];
    self.locationTextField.placeholder = NSLocalizedString(@"Location", nil);
    self.locationTextField.text = @"";
    self.locationTextField.textColor = [UIColor lightGrayColor];
    self.locationTextField.font = [UIFont systemFontOfSize:20];
    self.locationTextField.textAlignment = NSTextAlignmentLeft;
    self.locationTextField.tintColor = [UIColor lightGrayColor];
    self.locationTextField.keyboardAppearance = UIKeyboardAppearanceLight;
    self.locationTextField.returnKeyType = UIReturnKeySearch;
    self.locationTextField.clearsOnBeginEditing = true;
    self.locationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.locationTextField sizeToFit];
    [self.containerView addSubview:self.locationTextField];
    [self.locationTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).with.offset(44);
        make.left.equalTo(self.containerView).with.offset(10);
        make.right.equalTo(self.containerView).with.offset(-10);
        make.height.equalTo(@(44));
    }];
    
    _dateTextField = [[APLTextField alloc] init];
    [self.dateTextField setAndSelectDate:[NSDate date]];
    self.dateTextField.placeholder = NSLocalizedString(@"Date", nil);
    self.dateTextField.textColor = [UIColor lightGrayColor];
    self.dateTextField.font = [UIFont systemFontOfSize:20];
    self.dateTextField.textAlignment = NSTextAlignmentLeft;
    self.dateTextField.tintColor = [UIColor lightGrayColor];
    self.dateTextField.keyboardAppearance = UIKeyboardAppearanceLight;
    self.dateTextField.returnKeyType = UIReturnKeyDone;
    self.dateTextField.clipsToBounds = true;
    self.dateTextField.hasDatePicker = true;
    [self.dateTextField sizeToFit];
    [self.containerView addSubview:self.dateTextField];
    [self.dateTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(10);
        make.width.equalTo(self.containerView).dividedBy(2);
        make.height.equalTo(@(44));
        make.top.equalTo(self.locationTextField.bottom);
    }];
    
    _timeTextField = [[UITextField alloc] init];
    self.timeTextField.text = @"";
    self.timeTextField.placeholder = NSLocalizedString(@"Time", nil);
    self.timeTextField.textColor = [UIColor lightGrayColor];
    self.timeTextField.font = [UIFont systemFontOfSize:20];
    self.timeTextField.textAlignment = NSTextAlignmentLeft;
    self.timeTextField.tintColor = [UIColor lightGrayColor];
    self.timeTextField.keyboardAppearance = UIKeyboardAppearanceLight;
    self.timeTextField.returnKeyType = UIReturnKeyDone;
    self.timeTextField.clipsToBounds = true;
    [self.timeTextField sizeToFit];
    [self.containerView addSubview:self.timeTextField];
    [self.timeTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateTextField.right);
        make.right.equalTo(self.containerView).with.offset(-10);
        make.height.equalTo(@(44));
        make.top.equalTo(self.dateTextField);
    }];

    _reservationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.reservationLabel.textColor = [UIColor lightGrayColor];
    self.reservationLabel.font = [UIFont systemFontOfSize:20];
    self.reservationLabel.text = NSLocalizedString(@"Reserve for:", nil);
    [self.reservationLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.containerView addSubview:self.reservationLabel];
    [self.reservationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.containerView).with.offset(10);
        make.top.equalTo(self.dateTextField.bottom).with.offset(30);
    }];
    
    _reservationTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.reservationTimeLabel.textColor = [UIColor colorWithRed:223/255.0 green:5/255.0 blue:90/255.0 alpha:1];
    self.reservationTimeLabel.font = [UIFont systemFontOfSize:20];
    self.reservationTimeLabel.text = [NSString stringWithFormat:@"%d min", (int)self.reservationTimeSlider.minimumValue];
    [self.reservationTimeLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.containerView addSubview:self.reservationTimeLabel];
    [self.reservationTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.reservationLabel.trailing).with.offset(10);
        make.top.equalTo(self.reservationLabel);
        make.bottom.equalTo(self.reservationLabel);
    }];
    
    _maxReservationTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.maxReservationTimeLabel.textColor = [UIColor lightGrayColor];
    self.maxReservationTimeLabel.font = [UIFont systemFontOfSize:16];
    self.maxReservationTimeLabel.text = [NSString stringWithFormat:@"%d min", (int)self.reservationTimeSlider.maximumValue];
    [self.maxReservationTimeLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.containerView addSubview:self.maxReservationTimeLabel];
    [self.maxReservationTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.containerView.trailing).with.offset(-10);
        make.bottom.equalTo(self.reservationLabel);
    }];
    
    _reservationTimeSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    [self.containerView addSubview:self.reservationTimeSlider];
    [self.reservationTimeSlider makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(10);
        make.right.equalTo(self.containerView).with.offset(-10);
        make.top.equalTo(self.reservationLabel.bottom).with.offset(0.5);
    }];
    self.reservationTimeSlider.tintColor = [UIColor colorWithRed:223/255.0 green:5/255.0 blue:90/255.0 alpha:1];
    self.reservationTimeSlider.thumbTintColor = [UIColor colorWithRed:223/255.0 green:5/255.0 blue:90/255.0 alpha:1];
    [self.reservationTimeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.reservationTimeSlider.userInteractionEnabled = true;
    self.reservationTimeSlider.continuous = true;
    
    _searchButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.searchButton setTitle:NSLocalizedString(@"Search", nil) forState:UIControlStateNormal];
    self.searchButton.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    self.searchButton.backgroundColor = [UIColor colorWithRed:82/255.0 green:193/255.0 blue:209/255.0 alpha:1.0];
    [self.searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.searchButton.userInteractionEnabled = true;
    self.searchButton.layer.cornerRadius = 4.0;
    [self.searchButton addTarget:self action:@selector(didPressSearchButton) forControlEvents:UIControlEventTouchUpInside];
    self.searchButton.layer.cornerRadius = 4.0;
    [self.searchButton sizeToFit];
    [self.containerView addSubview:self.searchButton];
    [self.searchButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reservationTimeSlider.bottom).with.offset(20);
        make.bottom.equalTo(self.containerView.bottom).with.offset(-10);
        make.centerX.equalTo(self.containerView);
        make.width.equalTo(@(150)).priorityHigh();
        make.height.equalTo(@(40)).priorityHigh();
    }];
    
    self.containerView.clipsToBounds = true;
    self.containerView.layer.cornerRadius = 2.0;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(350, UIViewNoIntrinsicMetric);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews {
    [super layoutSubviews];
    [self invalidateIntrinsicContentSize];
}

#pragma mark Private

- (void)setSpot:(ParkingSpot *)spot {
    _spot = spot;
    self.reservationTimeSlider.value = spot.parkingSpotLimit.minReserveTime;
    self.reservationTimeSlider.minimumValue = spot.parkingSpotLimit.minReserveTime;
    self.reservationTimeSlider.maximumValue = spot.parkingSpotLimit.maxReserveTime;
    self.reservationTimeLabel.text = [NSString stringWithFormat:@"%ld min", spot.parkingSpotLimit.minReserveTime];
    self.maxReservationTimeLabel.text = [NSString stringWithFormat:@"%ld min", spot.parkingSpotLimit.maxReserveTime];
}

- (void)sliderValueChanged:(UISlider *)slider {
    int newValue = self.reservationTimeSlider.value + 1;
    [self.reservationTimeSlider setValue:newValue animated:true];
    self.reservationTimeLabel.text = [NSString stringWithFormat:@"%d min", (int)self.reservationTimeSlider.value];
}

- (void)didPressSearchButton {
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat = @"hh:mm";
    timeFormatter.timeStyle = NSDateFormatterShortStyle;
    [self.searchDelegate searchParkingSpotsViewDidSearchAroundLocation:self.locationTextField.text onDate:[self.dateTextField getDate] andTime:[timeFormatter dateFromString:self.timeTextField.text] withReserveTime:self.reservationTimeSlider.value];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSArray *reversedSubviews = [[[self subviews] reverseObjectEnumerator] allObjects];
    
    for (UIView *subView in reversedSubviews) {
        CGPoint convertedPoint = [self convertPoint:point toView:subView];
        UIView *hitView = [subView hitTest:convertedPoint withEvent:event];
        
        if (hitView) {
            return hitView;
        }
    }
    
    return nil;
}


#pragma mark Public

- (void)resignFirstResponder {
    if ([self isFirstResponder])
        [self resignFirstResponder];
}

@end
