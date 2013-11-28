//
//  AMapControllerViewController.h
//  ctrip-mobile
//
//  Created by caoguangyao on 8/14/13.
//  Copyright (c) 2013 caoguangyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAMapKit/MAMapKit.h"

@interface AMapController : UIViewController<MAMapViewDelegate>

@property (assign,nonatomic)CLLocationCoordinate2D coordinate;
@property (retain,nonatomic)NSString *name;
@property (retain,nonatomic)NSString *address;

@end
