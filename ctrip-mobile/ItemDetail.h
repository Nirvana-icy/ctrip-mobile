//
//  ItemDetail.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-22.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ItemDetail : NSObject

@property (assign,nonatomic) NSUInteger productID;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *desc;
@property (strong,nonatomic) NSString *ruleDesc;
@property (strong,nonatomic) NSString *headDesc;
@property (strong,nonatomic) NSString *price;
@property (strong,nonatomic) NSString *address;
@property (strong,nonatomic) NSString *tel;
@property (assign,nonatomic) CLLocationCoordinate2D location;
@property (strong,nonatomic) NSArray *imageList;
@property (strong,nonatomic) NSArray *imageDictList;
@property (strong,nonatomic) NSString *oURL;

@property (strong,nonatomic) NSArray *descList;
@property (strong,nonatomic) NSArray *ruleDescList;
@property (strong,nonatomic) NSArray *headDescList;

-(id) initWithDictionary:(NSDictionary *)dictionary;
@end
