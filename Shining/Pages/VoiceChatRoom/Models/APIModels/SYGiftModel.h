//
//  SYGiftModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYGiftModel : NSObject

@property (nonatomic, assign) NSInteger giftid;
@property (nonatomic, assign) NSInteger category_id;
@property (nonatomic, assign) NSInteger subcategory_id;
@property (nonatomic, assign) NSInteger orders; // 序号
@property (nonatomic, assign) NSInteger price; // 价格
@property (nonatomic, assign) NSInteger colddown_duration; // 冷却时间
@property (nonatomic, assign) NSInteger vip_level; // 所需用户等级
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *category_name;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *subcategory_name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *animation; // 动画包地址
@property (nonatomic, strong) NSString *userid; // 收礼物uid
@property (nonatomic, assign) NSInteger nums; // 礼物背包礼物数量；送礼物数量
@property (nonatomic, assign) NSInteger minusNum; //负数礼物的负数值
@property (nonatomic, assign) BOOL multisend; //是否可以连送

@end

NS_ASSUME_NONNULL_END
