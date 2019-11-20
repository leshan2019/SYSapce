//
//  SYNavigationController.h
//  LetvShiningModule
//
//  Created by mengxiangjian on 2019/5/7.
//  Copyright © 2019 LeEco. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYNavigationController : UINavigationController

// 此vc被用于"私信"功能
@property (nonatomic, assign) BOOL usedByPrivateMessage;

@end

@interface UINavigationController (SYExtension)

- (void)sy_pushViewController: (UIViewController*)controller
       animatedWithTransition: (UIViewAnimationTransition)transition;

- (UIViewController*)sy_popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition;

@end

NS_ASSUME_NONNULL_END
