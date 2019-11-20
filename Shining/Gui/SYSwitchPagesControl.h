//
//  SYSwitchPagesControl.h
//  Shining
//
//  Created by 杨玄 on 2019/3/28.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYSwitchPagesControlDelegate <NSObject>

// 点击左侧按钮回调
- (void)handleSwitchPagesControlLeftBtnClickEvent;
// 点击右侧按钮回调
- (void)handleSwitchPagesControlRightBtnClickEvent;

@end

/**
 *  选择页卡控件 - 目前只支持2页
 *  Usage: 参照聊天|关注用法
 */
@interface SYSwitchPagesControl : UIView

@property (nonatomic, weak) id <SYSwitchPagesControlDelegate> delegate;

/**
 *  设置初始选中索引
 *  范围：0 | 1
 */
@property (nonatomic, assign) NSInteger selectedControl;

/**
 *  自定义UI
 *  Note: 颜色可以不设置，有默认颜色
 */
- (void)configueCustomUIWithTitle:(NSArray *)titles withNormalColors:(NSArray *)normalColors withSelectedColors:(NSArray *)selectedColors;

@end

