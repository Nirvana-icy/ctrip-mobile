//
//  TOrder.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-24.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TOrder : NSObject
//required data
@property (nonatomic,strong) NSString *productID;
@property (nonatomic,strong) NSString *productName;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *quantity;

@property (nonatomic,strong) NSString *price;
//return data
@property (nonatomic,strong) NSString *amount;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *orderID;
@property (nonatomic,strong) NSString *createTime;

@end
