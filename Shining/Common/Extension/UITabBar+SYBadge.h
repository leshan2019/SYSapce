//
//  UITabBar+SYBadge.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/4/2.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (SYBadge)

- (void)sy_showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)sy_hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end

NS_ASSUME_NONNULL_END
