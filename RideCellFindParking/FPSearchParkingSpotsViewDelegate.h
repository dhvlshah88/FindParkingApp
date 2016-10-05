//
//  FPSearchParkingSpotsViewDelegate.h
//  RideCellFindParking
//
//  Created by Dhaval on 9/28/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FPSearchParkingSpotsViewDelegate <NSObject>

- (void)searchParkingSpotsViewDidSearchAroundLocation:(NSString *)locationAddress onDate:(NSDate *)date andTime:(NSDate *)time withReserveTime:(NSInteger)reserveTime;

@end
