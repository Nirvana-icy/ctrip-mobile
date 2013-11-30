//
//  Item.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-17.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic,assign) NSUInteger productID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic, strong) NSString *thumbnailURL;

-(id)initWithDictionary:(NSDictionary *)dictionary;
@end
