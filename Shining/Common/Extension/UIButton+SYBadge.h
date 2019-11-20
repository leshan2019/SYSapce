//
//  UIButton+SYBadge.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/5/13.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (SYBadge)
- (void)sy_showBadgeOnItem;   //显示小红点

- (void)sy_hideBadgeOnItem; //隐藏小红点
@end

NS_ASSUME_NONNULL_END
