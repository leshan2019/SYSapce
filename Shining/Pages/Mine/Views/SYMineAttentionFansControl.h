//
//  SYMineAttentionFansControl.h
//  Shining
//
//  Created by 杨玄 on 2019/7/4.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SYMineAttentionFansBlock)(NSString * _Nullable type);

NS_ASSUME_NONNULL_BEGIN

// 我的 - 我的关注+我的粉丝 - 控件
@interface SYMineAttentionFansControl : UIView

@property (nonatomic, copy) SYMineAttentionFansBlock clickBlock;

// 更新关注和粉丝数
- (void)updateControlWithAttentionCount:(NSInteger)attentionCount withFansCount:(NSInteger)fansCount;

@end

NS_ASSUME_NONNULL_END
