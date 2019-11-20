//
//  SYVipPrivilegeModel.h
//  Shining
//
//  Created by 杨玄 on 2019/7/3.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 会员权益model
@interface SYVipPrivilegeModel : NSObject<YYModel>

@property (nonatomic, copy) NSString *descp;        // 权益说明
@property (nonatomic, assign) NSInteger vip_level;  // 所需vip等级
@property (nonatomic, copy) NSString *icon;         // icon
@property (nonatomic, copy) NSString *rightname;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSInteger id;

@end

NS_ASSUME_NONNULL_END

// 会员权益listModel
@interface SYVipPrivilegeListModel : NSObject<YYModel>

@property (nonatomic, strong) NSArray* _Nullable list;

@end
