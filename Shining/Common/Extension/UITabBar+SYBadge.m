//
//  UITabBar+SYBadge.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/4/2.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "UITabBar+SYBadge.h"

#define SYTabbarItemNums 5.0

@implementation UITabBar (SYBadge)
//显示小红点
- (void)sy_showBadgeOnItemIndex:(int)index{
    //移除之前的小红点
    [self sy_removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 5;//圆形
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.6) / SYTabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10, 10);//圆形大小为10
    [self addSubview:badgeView];
}

//隐藏小红点
- (void)sy_hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self sy_removeBadgeOnItemIndex:index];
}


//移除小红点
- (void)sy_removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}
@end
