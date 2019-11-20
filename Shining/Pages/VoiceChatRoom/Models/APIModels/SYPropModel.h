//
//  SYPropModel.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/4/29.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYPropPriceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYPropModel : NSObject <YYModel>
@property (nonatomic, assign) NSInteger propid;
@property (nonatomic, assign) NSInteger category_id;
@property (nonatomic, assign) NSInteger subcategory_id;
@property (nonatomic, assign) NSInteger orders; // 序号
@property (nonatomic, assign) NSInteger price; // 价格
@property (nonatomic, assign) NSInteger colddown_duration; // 冷却时间
@property (nonatomic, assign) NSInteger vip_level; // 所需用户等级
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *category_name;
@property (nonatomic, strong) NSString *subcategory_name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *animation; // 动画包地址
@property (nonatomic, strong) NSArray *pricelist;
@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, assign) NSInteger expire_time; // 过期时间 unix
@property (nonatomic, strong) NSString *expire_string; // 过期时间string

@end

NS_ASSUME_NONNULL_END
