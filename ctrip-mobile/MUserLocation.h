//
//  MUserLocation.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-11-30.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@protocol MUserLocation <NSObject>

-(void)userLocationUpdated:(CLLocation *) location;

@end
