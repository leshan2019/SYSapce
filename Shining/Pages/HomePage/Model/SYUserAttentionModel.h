//
//  SYUserAttentionModel.h
//  Shining
//
//  Created by 杨玄 on 2019/4/29.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYUserAttentionModel : NSObject<YYModel>

@property (nonatomic, assign) NSInteger concern_total;  // 关注数量
@property (nonatomic, assign) NSInteger fans_total;     // 粉丝数量

@end

NS_ASSUME_NONNULL_END
