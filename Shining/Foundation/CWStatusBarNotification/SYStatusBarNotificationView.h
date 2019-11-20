//
//  SYStatusBarNotificationView.h
//  LetvShiningModule
//
//  Created by letv_lzb on 2019/7/9.
//  Copyright © 2019 LeEco. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYStatusBarNotificationView : UIView

@property (nonatomic, strong)UIView *backView;

/**
 Description

 @param title 标题
 @param body 内容
 */
- (void)bindDataWithTitle:(NSString *)title body:(NSString *)body;

@end

NS_ASSUME_NONNULL_END
