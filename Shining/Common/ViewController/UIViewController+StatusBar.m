//
//  UIViewController+StatusBar.m
//  Shining
//
//  Created by yangxuan on 2019/10/30.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "UIViewController+StatusBar.h"

@implementation UIViewController (StatusBar)

- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    return UIUserInterfaceStyleLight;
}

- (void)sy_setStatusBarLight {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)sy_setStatusBarDard {
    if (@available(iOS 13.0, *)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

@end
