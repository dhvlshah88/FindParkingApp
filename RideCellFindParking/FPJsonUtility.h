//
//  FPJsonUtility.h
//  RideCellFindParking
//
//  Created by Dhaval on 9/26/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FPJsonUtility : NSObject

+ (NSArray *)freeParkingSpots:(id)jsonData;

@end
