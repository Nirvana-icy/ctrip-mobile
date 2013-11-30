//
//  UserDefaults.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-17.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaults : NSObject

@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) NSString *keyWords;

@property (nonatomic,strong) NSString *beginDate;
@property (nonatomic,strong) NSString *endDate;
@property (nonatomic,strong) NSString *timeRange;

@property (nonatomic,strong) NSString *lowPrice;
@property (nonatomic,strong) NSString *upperPrice;
@property (nonatomic,strong) NSString *sortType;

@end
