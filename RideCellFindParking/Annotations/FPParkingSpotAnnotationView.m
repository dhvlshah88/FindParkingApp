//
//  ParkingSpotAnnotationView.m
//  RideCellFindParking
//
//  Created by Dhaval on 9/27/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "FPParkingSpotAnnotationView.h"

@interface FPParkingSpotAnnotationView ()

@property (nonatomic, strong) FPParkingSpotAnnotation *spotAnnotation;

@end

@implementation FPParkingSpotAnnotationView

- (instancetype)initWithAnnotation:(FPParkingSpotAnnotation *)spotAnnotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:spotAnnotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _spotAnnotation = spotAnnotation;
        self.frame = CGRectMake(0, 0, 36, 36);
        self.opaque = false;
    }
    
    return self;
}

//  Only override drawRect: if you perform custom drawing.
//  An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
     CGContextRef currentContext = UIGraphicsGetCurrentContext();

     CGContextSetRGBFillColor(currentContext, 82/255.0, 193/255.0, 209/255.0, 0.7);
     CGContextFillEllipseInRect(currentContext, rect);
     
     CGContextSetLineWidth(currentContext, 6);
//     CGContextSetRGBStrokeColor(currentContext, 82/255.0, 1/255.0, 209/255.0, 1);

     UIColor *strokeColor = [UIColor colorWithRed:82/255.0 green:193/255.0 blue:209/255.0 alpha:1];
     CGPoint center = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
     CGContextAddArc(currentContext, center.x, center.y, 15, 0, 2*M_PI, 0);
     [strokeColor setStroke];
     CGContextStrokePath(currentContext);
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
