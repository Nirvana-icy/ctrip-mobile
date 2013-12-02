//
//  MapOptionController.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-11-30.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapOptions.h"

@interface MapOptionController : UITableViewController

@property (strong,nonatomic)NSObject<MapOptions> *delegate;

@end
