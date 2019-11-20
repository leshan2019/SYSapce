//
//  UIViewController+SYExtension.h
//  Shining
//
//  Created by letv_lzb on 2019/4/3.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
//#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SYExtension)

@property (nonatomic, strong) MBProgressHUD *toast;

/**
 显示toast提示 自动消失

 @param text 文案
 @param delay 延迟多久自动小时
 */
- (void)sy_showToastView:(NSString *)text delay:(NSTimeInterval)delay;

/**
 显示toast提示 不自动消失

 @param text 文案
 */
- (void)sy_showToastView:(NSString *)text;

/**
 影藏toast

 @param delay 延迟多久 0 标示不延迟
 */
- (void)sy_hideToastView:(NSTimeInterval)delay;

//获取Window当前显示的ViewController
- (UIViewController*)currentViewController;
@end

NS_ASSUME_NONNULL_END
