//
//  SYVipLevelModel.h
//  Shining
//
//  Created by 杨玄 on 2019/7/4.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYVipLevelModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *level_name;      // 等级名称
@property (nonatomic, copy) NSString *level_pic;       // 等级图标
@property (nonatomic, assign) NSInteger min_coin_cost; // 最小花销金币
@property (nonatomic, assign) NSInteger max_coin_cost; // 最大花销金币
@property (nonatomic, assign) NSInteger vip_right;     // 等级对应的vip权益值
@property (nonatomic, assign) NSInteger id;

@end

NS_ASSUME_NONNULL_END

@interface SYVipLevelListModel : NSObject <YYModel>

@property (nonatomic, strong) NSArray* _Nullable list;

@end
