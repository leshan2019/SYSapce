//
//  UIViewController+SYExtension.m
//  Shining
//
//  Created by letv_lzb on 2019/4/3.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "UIViewController+SYExtension.h"


static void *toastKey = &toastKey;

@implementation UIViewController (SYExtension)


-(void)setToast:(MBProgressHUD *)toast
{
    objc_setAssociatedObject(self, &toastKey, toast, OBJC_ASSOCIATION_RETAIN);
}

-(MBProgressHUD *)toast
{
    return objc_getAssociatedObject(self, &toastKey);
}


- (void)sy_showToastView:(NSString *)text {
    if (self.toast) {
        [self.toast hide:NO];
    }
    self.toast = [MBProgressHUD showHUDAddedTo:self.view
                                        animated:YES];
    self.toast.labelText = text;
    self.toast.mode = MBProgressHUDModeText;
}

- (void)sy_showToastView:(NSString *)text delay:(NSTimeInterval)delay {
    if (self.toast) {
        [self.toast hide:NO];
    }
    self.toast = [MBProgressHUD showHUDAddedTo:self.view
                                      animated:YES];
    self.toast.labelText = text;
    self.toast.mode = MBProgressHUDModeText;
    [self.toast hide:YES afterDelay:delay];
}

- (void)sy_hideToastView:(NSTimeInterval)delay {
    if (!self.toast) {
        return;
    }
    if (delay <= 0) {
        [self.toast hide:NO];
    }else{
        [self.toast hide:YES afterDelay:delay];
    }
}

- (UIViewController*)currentViewController{
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (1) {
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
        
    }
    
    return vc;
}




@end
