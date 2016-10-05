//
//  FPParkingSpotCalloutView.m
//  RideCellFindParking
//
//  Created by Dhaval on 9/27/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "FPParkingSpotCalloutView.h"
#import "FPDeviceContext.h"

static CGFloat const tipHeight = 10.0;
static CGFloat const tipWidth = 20.0;

@interface FPParkingSpotCalloutView ()

@property (nonatomic, strong) UILabel *spotNameLabel;
@property (nonatomic, strong) UILabel *spotAddressLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *openSpotsLabel;
@property (nonatomic, strong) UILabel *openSpots;
@property (nonatomic, strong) UILabel *costPerMinuteLabel;
@property (nonatomic, strong) UILabel *costPerMinute;
@property (nonatomic, strong) UILabel *distanceFromMeLabel;
@property (nonatomic, strong) UILabel *distanceFromMe;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) CLLocation *userLocation;

@end

@implementation FPParkingSpotCalloutView

- (instancetype)initWithSpotAnnotation:(FPParkingSpotAnnotation *)spotAnnotation andUserLocation:(CLLocation *)userLocation {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        _spotAnnotation = spotAnnotation;
        _userLocation = userLocation;
        [self setUpSubviews];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = true;
    }
    
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(370, 200);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UIColor *fillColor = [UIColor colorWithRed:82/255.0 green:193/255.0 blue:209/255.0 alpha:0.9];
    
    CGFloat tipLeft = rect.origin.x + (rect.size.width / 2.0) - (tipWidth / 2.0);
    CGPoint tipBottom = CGPointMake(rect.origin.x + (rect.size.width / 2.0), rect.origin.y + rect.size.height);
    CGFloat heightWithoutTip = rect.size.height - 2 * tipHeight - tipHeight/2;
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef tipPath = CGPathCreateMutable();
    CGPathMoveToPoint(tipPath, NULL, tipLeft, heightWithoutTip);
    CGPathAddLineToPoint(tipPath, NULL, tipBottom.x, tipBottom.y);
    CGPathAddLineToPoint(tipPath, NULL, tipLeft + tipWidth, heightWithoutTip);
    CGPathCloseSubpath(tipPath);
    
    [fillColor setFill];
    CGContextAddPath(currentContext, tipPath);
    CGContextFillPath(currentContext);
    CGPathRelease(tipPath);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self invalidateIntrinsicContentSize];
}

- (void)setUpSubviews {
    UIEdgeInsets inset = UIEdgeInsetsMake(10, 10, 20, 10);
    CLLocation *parkingLocation = [[CLLocation alloc] initWithLatitude:self.spotAnnotation.spot.coordinate.latitude longitude:self.spotAnnotation.spot.coordinate.longitude];
    
    _containerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.containerView.backgroundColor = [UIColor colorWithRed:82/255.0 green:193/255.0 blue:209/255.0 alpha:0.9];
    self.containerView.opaque = false;
    self.containerView.clipsToBounds = true;
    self.containerView.layer.cornerRadius = 2.0;
    [self addSubview:self.containerView];
    [self.containerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(inset.top/2.0);
        make.left.equalTo(self).with.offset(inset.left/2.0);
        make.right.equalTo(self).with.offset(-inset.right/2.0);
        make.width.greaterThanOrEqualTo(@(inset.left + inset.right));
        make.bottom.equalTo(self).with.offset(-inset.bottom-inset.right/2.0);
    }];
    
    _spotNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.spotNameLabel.textColor = [UIColor whiteColor];
    self.spotNameLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightBold];
    self.spotNameLabel.textAlignment = NSTextAlignmentLeft;
    self.spotNameLabel.text = self.spotAnnotation.spot.spotName;
    self.spotNameLabel.numberOfLines = 1;
    self.spotNameLabel.preferredMaxLayoutWidth = self.frame.size.width - 2 * 20;
    [self.spotNameLabel sizeToFit];
    [self.containerView addSubview:self.spotNameLabel];
    [self.spotNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(20);
        make.top.equalTo(self.containerView).with.offset(10);
        make.right.equalTo(self.containerView).with.offset(-20);
    }];
    
    _spotAddressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.spotAddressLabel.textColor = [UIColor whiteColor];
    self.spotAddressLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightLight];
    self.spotAddressLabel.textAlignment = NSTextAlignmentLeft;
    
    [[FPDeviceContext instance] addressReserveGecodeLocation:parkingLocation completionHandler:^(NSString *address) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.spotAddressLabel.text = address;
            self.spotAnnotation.spot.spotAddress = address;
        });
    }];

    self.spotAddressLabel.preferredMaxLayoutWidth = self.frame.size.width - 2 * 20;
    [self.spotAddressLabel sizeToFit];
    [self.spotAddressLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    [self.containerView addSubview:self.spotAddressLabel];
    [self.spotAddressLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.spotNameLabel);
        make.top.equalTo(self.spotNameLabel.bottom).with.offset(3);
        make.right.equalTo(self.spotNameLabel);
    }];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.containerView addSubview:self.lineView];
    self.lineView.backgroundColor = [UIColor whiteColor];
    [self.lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.containerView);
        make.width.equalTo(self.containerView);
        make.top.equalTo(self.spotAddressLabel.bottom).with.offset(2);
        make.height.equalTo(@(1/[[UIScreen mainScreen] scale]));
    }];
    
    _openSpotsLabel = [[UILabel alloc] init];
    self.openSpotsLabel.textColor = [UIColor whiteColor];
    self.openSpotsLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightLight];
    self.openSpotsLabel.textAlignment = NSTextAlignmentCenter;
    self.openSpotsLabel.text = NSLocalizedString(@"Open Spots", nil);
    [self.openSpotsLabel sizeToFit];
    [self.openSpotsLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.containerView addSubview:self.openSpotsLabel];
    
    _openSpots = [[UILabel alloc] init];
    self.openSpots.textColor = [UIColor whiteColor];
    self.openSpots.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightSemibold];
    self.openSpots.textAlignment = NSTextAlignmentCenter;
    self.openSpots.text = [NSString stringWithFormat:@"%ld", self.spotAnnotation.spot.spotId];
    [self.containerView addSubview:self.openSpots];
    
    _costPerMinuteLabel = [[UILabel alloc] init];
    self.costPerMinuteLabel.textColor = [UIColor whiteColor];
    self.costPerMinuteLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightLight];
    self.costPerMinuteLabel.textAlignment = NSTextAlignmentCenter;
    self.costPerMinuteLabel.text = NSLocalizedString(@"Cost", nil);
    [self.costPerMinuteLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.containerView addSubview:self.costPerMinuteLabel];
    
    _costPerMinute = [[UILabel alloc] init];
    self.costPerMinute.textColor = [UIColor whiteColor];
    self.costPerMinute.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightSemibold];
    self.costPerMinute.textAlignment = NSTextAlignmentCenter;
    self.costPerMinute.text = [NSString stringWithFormat:@"%.2f/min", self.spotAnnotation.spot.costPerMinute];
    [self.containerView addSubview:self.costPerMinute];
    
    _distanceFromMeLabel = [[UILabel alloc] init];
    self.distanceFromMeLabel.textColor = [UIColor whiteColor];
    self.distanceFromMeLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightLight];
    self.distanceFromMeLabel.textAlignment = NSTextAlignmentCenter;
    self.distanceFromMeLabel.text = NSLocalizedString(@"Distance", nil);
    [self.distanceFromMeLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.containerView addSubview:self.distanceFromMeLabel];
    
    _distanceFromMe = [[UILabel alloc] init];
    self.distanceFromMe.textColor = [UIColor whiteColor];
    self.distanceFromMe.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightSemibold];
    self.distanceFromMe.textAlignment = NSTextAlignmentCenter;
    CLLocationDistance distance = [self.userLocation distanceFromLocation:parkingLocation];
    self.distanceFromMe.text = [NSString stringWithFormat:@"%.1f", (distance/1609.344)];
    [self.containerView addSubview:self.distanceFromMe];
    
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.moreButton setTitle:NSLocalizedString(@"More", nil)  forState:UIControlStateNormal];
    self.moreButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.moreButton.backgroundColor = [UIColor clearColor];
    self.moreButton.userInteractionEnabled = true;
    [self.moreButton addTarget:self action:@selector(didPressMoreButton) forControlEvents:UIControlEventTouchUpInside];
    [self.moreButton sizeToFit];
    [self.containerView addSubview:self.moreButton];
    [self.moreButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView);
        make.bottom.equalTo(self.containerView).with.offset(-10);
//        make.width.equalTo(@(40)).priorityHigh();
        make.height.equalTo(@(20)).priorityHigh();
    }];
    
    _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.payButton setTitle:NSLocalizedString(@"Pay and Reserve", nil) forState:UIControlStateNormal];
    [self.payButton setTitleColor:[UIColor colorWithRed:83/255.0 green:193/255.0 blue:209/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.payButton.backgroundColor = [UIColor whiteColor];
    self.payButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.payButton.titleLabel.font = [UIFont systemFontOfSize:20];
    self.payButton.layer.cornerRadius = 4.0;
    [self.payButton sizeToFit];
    self.payButton.userInteractionEnabled = true;
    [self.payButton addTarget:self action:@selector(didPressPayAndReserveButton) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.payButton];
    [self.payButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.moreButton.top).with.offset(-5);
        make.centerX.equalTo(self.containerView);
        make.top.greaterThanOrEqualTo(self.costPerMinute.bottom).with.priorityLow();
        make.width.equalTo(@(200)).priorityHigh();
        make.height.equalTo(@(30)).priorityHigh();
    }];
    
    [self.openSpotsLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.containerView).with.offset(20);
        make.trailing.lessThanOrEqualTo(self.costPerMinuteLabel.leading);
//        make.width.equalTo(@(self.frame.size.width/3));
        make.top.equalTo(self.lineView.bottom).with.offset(5);
    }];
    
    [self.openSpots makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.openSpotsLabel.bottom).with.offset(5);
        make.centerX.equalTo(self.openSpotsLabel);
    }];
    
    [self.costPerMinuteLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.greaterThanOrEqualTo(self.openSpotsLabel.trailing).with.offset(10);
        make.trailing.lessThanOrEqualTo(self.distanceFromMeLabel.leading).with.offset(-10);
//        make.width.equalTo(@(self.frame.size.width/3));
        make.top.equalTo(self.lineView.bottom).with.offset(5);
    }];
    
    [self.costPerMinute makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.costPerMinuteLabel.bottom).with.offset(5);
        make.centerX.equalTo(self.costPerMinuteLabel);
    }];
    
    [self.distanceFromMeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.greaterThanOrEqualTo(self.costPerMinuteLabel.trailing).with.offset(10);
//        make.width.equalTo(@(self.frame.size.width/3));
        make.top.equalTo(self.lineView.bottom).with.offset(5);
        make.trailing.equalTo(self.containerView).with.offset(-10);
    }];
    
    [self.distanceFromMe makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceFromMeLabel.bottom).with.offset(5);
        make.centerX.equalTo(self.distanceFromMeLabel);
    }];
    
    [self invalidateIntrinsicContentSize];
}

- (void)addToAnnotationView:(MKAnnotationView *)annotationView {
    [annotationView addSubview:self];
    
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(annotationView.top).with.offset(-5);
        make.centerX.equalTo(annotationView.centerX).with.offset(-5);
    }];
}

- (void)didPressPayAndReserveButton {
    [self.calloutDelegate parkingSpotCalloutViewDidPressPayAndReserveSpot:self.spotAnnotation];
}

- (void)didPressMoreButton {
    [self.calloutDelegate parkingSpotCalloutViewDidPressMoreAboutSpot:self.spotAnnotation];
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

@end
