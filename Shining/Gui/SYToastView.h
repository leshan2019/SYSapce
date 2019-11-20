//
//  SYToastView.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/14.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYToastView : MBProgressHUD
//
+ (void)showToast:(NSString *)toast;
//
+ (void)sy_showToast:(NSString *)toast;
+ (void)sy_showToast:(NSString *)toast onView:(UIView*)view;
@end

NS_ASSUME_NONNULL_END
