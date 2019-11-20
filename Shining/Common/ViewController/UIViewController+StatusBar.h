//
//  UIViewController+StatusBar.h
//  Shining
//
//  Created by yangxuan on 2019/10/30.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
    info.plist中 新增 “View controller-based status bar appearance = no” ,
    导致- (UIStatusBarStyle)preferredStatusBarStyle {}方法失效
    以后设置状态栏颜色，都通过这两个方法
 */
@interface UIViewController (StatusBar)

// 设置状态栏白色
- (void)sy_setStatusBarLight;

// 设置状态栏黑色
- (void)sy_setStatusBarDard;

@end

NS_ASSUME_NONNULL_END
