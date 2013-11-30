//
//  MItemCell.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-17.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MItemCell : UITableViewCell

@property(nonatomic,strong) IBOutlet UILabel *nameLabel;
@property(nonatomic,strong) IBOutlet UILabel *priceLabel;
@property(nonatomic,strong) IBOutlet UILabel *descLabel;
@property(nonatomic,strong) IBOutlet UIImageView *thumbnailView;
@end
