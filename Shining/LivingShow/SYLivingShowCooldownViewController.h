//
//  SYLivingShowCooldownViewController.h
//  Shining
//
//  Created by Zhang Qigang on 2019/9/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SYLivingShowCooldownViewController;

@protocol SYLivingShowCooldownViewControllerDelegate <NSObject>
@optional
- (void) cooldownControllerTimeout: (SYLivingShowCooldownViewController*) controller;
@end

@interface SYLivingShowCooldownViewController : UIViewController
@property (nonatomic, weak) id<SYLivingShowCooldownViewControllerDelegate> delegate;
- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithCounterOfSeconds: (NSInteger) seconds;
@end

NS_ASSUME_NONNULL_END
