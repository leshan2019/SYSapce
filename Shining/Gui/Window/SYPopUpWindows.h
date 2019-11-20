//
//  SYPopUpWindows.h
//  Shining
//
//  Created by 杨玄 on 2019/3/28.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SYPopUpWindowsType_Single,      // 单个按钮
    SYPopUpWindowsType_Pair,        // 两个按钮
    SYPopUpWindowsType_LetvLogin    // 自定义乐视视频sdk 静默登陆弹窗
} SYPopUpWindowsType;

@protocol SYPopUpWindowsDelegate <NSObject>

@optional
// 左边按钮点击回调 - SYPopUpWindowsType_Pair
- (void)handlePopUpWindowsLeftBtnClickEvent;
// 右边按钮点击回调 - SYPopUpWindowsType_Pair
- (void)handlePopUpWindowsRightBtnClickEvent;
// 中间按钮点击回调 - SYPopUpWindowsType_Single
- (void)handlePopUpWindowsMidBtnClickEvent;
// 底部右侧按钮点击回调 - SYPopUpWindowsType_LetvLogin
- (void)handlePopUpWindowsBottomRightBtnClickEvent;
// 底部文本协议点击事件 - SYPopUpWindowsType_LetvLogin
- (void)handlePopUpWindowsBottomTextClickEvent;
// 弹窗点击其它区域退出回调
- (void)handlePopUpWindowsCancel;

@end

/**
 *  可操作提示弹窗 - 目前只支持两种类型（SYPopUpWindowsType）
 */
@interface SYPopUpWindows : UIView

@property (nonatomic, weak) id<SYPopUpWindowsDelegate> delegate;
 
- (void)updatePopUpWindowsWithType:(SYPopUpWindowsType)type
                     withMainTitle:(NSString *)mainTitle
                      withSubTitle:(NSString *)subTitle
                      withBtnTexts:(NSArray *)btnTexts
                 withBtnTextColors:(NSArray *)colors;

// 禁止点击弹窗周围区域隐藏弹窗
- (void)forbidClickWindowAroundArea;

/**
 乐视视频sdk 专用
 */
- (void)updatePopUpWindowswithMainTitle:(NSString *)mainTitle withSubTitle:(NSString *)subTitle withContentText:(NSString *)contentText withContentLogo:(NSString *)imgName withBottomText:(NSString *)bottomText withBtnTexts:(NSArray *)btnTexts withBtnTextColors:(NSArray *)colors;

@end

