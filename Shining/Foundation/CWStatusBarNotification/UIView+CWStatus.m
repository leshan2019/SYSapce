//
//  UIView+CWStatus.m
//  LetvShiningModule
//
//  Created by letv_lzb on 2019/7/8.
//  Copyright © 2019 LeEco. All rights reserved.
//

#import "UIView+CWStatus.h"

@implementation UIView (CWStatus)

// 8.0以下系统模糊效果采用vImageBoxConvolve_ARGB8888方法
- (UIView *)sy_addBlurWithFrame:(CGRect)frame
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) { // 8.0系统以后使用系统自带效果
        //  创建需要的毛玻璃特效类型
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        //  毛玻璃view 视图
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //添加到要有毛玻璃特效的控件中
        // 首页收起时，tabscrollview需要有毛玻璃，如果tabscrollview和recommendcustomNav都加这个方法，会导致毛玻璃效果不一致，
        // 所以，只加在tabscrollview上，扩大effectview的范围
        effectView.frame = frame;
        effectView.tag = -3;
        [self addSubview:effectView];
        [self sendSubviewToBack:effectView];
        //设置模糊透明度
        effectView.alpha = 1;
        return effectView;
    }else {
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:frame];
        toolBar.opaque = NO;
        toolBar.barStyle = UIBarStyleDefault;
        toolBar.translucent = NO;
        toolBar.tag = -3;
        [self addSubview:toolBar];
        [self sendSubviewToBack:toolBar];
        return toolBar;
    }
}

@end
