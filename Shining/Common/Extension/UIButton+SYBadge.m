//
//  UIButton+SYBadge.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/5/13.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "UIButton+SYBadge.h"

@implementation UIButton (SYBadge)
//显示小红点
- (void)sy_showBadgeOnItem{
    //移除之前的小红点
    [self sy_removeBadgeOnItem];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 ;
    badgeView.layer.cornerRadius = 5;//圆形
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (0.6);
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height+4);
    badgeView.frame = CGRectMake(x, y, 10, 10);//圆形大小为10
    [self addSubview:badgeView];
}

//隐藏小红点
- (void)sy_hideBadgeOnItem{
    //移除小红点
    [self sy_removeBadgeOnItem];
}


//移除小红点
- (void)sy_removeBadgeOnItem{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888) {
            [subView removeFromSuperview];
        }
    }
}
@end
