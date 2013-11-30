//
//  OrderEntity.h
//  ctrip-mobile
//
//  Created by cao guangyao on 13-5-5.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OrderEntity : NSManagedObject

@property (nonatomic, strong) NSString * expirationDate;
@property (nonatomic, strong) NSString * orderID;
@property (nonatomic, strong) NSString * ticketPassword;
@property (nonatomic, strong) NSString * productID;
@property (nonatomic, strong) NSString * productName;
@property (nonatomic, strong) NSString * orderStatus;
@property (nonatomic, strong) NSString * ticketID;
@property (nonatomic, strong) NSString * orderEmail;
@property (nonatomic, strong) NSString * orderTel;
@property (nonatomic, strong) NSString * orderQuantity;
@property (nonatomic, strong) NSString * orderPrice;

@end
