//
//  SYPersonHomepageDynamicView.h
//  Shining
//
//  Created by yangxuan on 2019/10/17.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYDynamicViewProtocol.h"

@protocol SYDynamicViewScrollDelegate <NSObject>

// 偏移量
- (void)changeOffSet:(CGFloat)y;

@end

typedef void(^ScrollToSquareBlock)(void);

NS_ASSUME_NONNULL_BEGIN

// 动态类型
typedef enum : NSUInteger {
    SYDynamicType_Homepage, // 主页动态
    SYDynamicType_Square,   // 广场动态
    SYDynamicType_Concern,  // 关注动态
} SYDynamicType;

/**
 * 个人主页 - 动态View
*/
@interface SYPersonHomepageDynamicView : UIView

// 创建
- (instancetype)initWithFrame:(CGRect)frame type:(SYDynamicType)dynamicType;

// 交互事件delete
@property (nonatomic, weak) id <SYDynamicViewProtocol> delegate;

// 处理手势冲突，不要随便改动哦
@property (nonatomic, weak) id <SYDynamicViewScrollDelegate>offSetDelegate;

// 配置用户id
- (void)configeUserId:(NSString *)userId;

// 请求第一页数据
- (void)requestFirstPageListData;

- (UIScrollView *)getDynamicScrollView;

// 关注页跳转到广场d页的block
- (void)configeJumpToSquareBlock:(ScrollToSquareBlock)block;

@end

NS_ASSUME_NONNULL_END
