//
//  SYVoiceChatRoomCommonNavBar.h
//  Shining
//
//  Created by 杨玄 on 2019/3/13.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYCommonTopNavigationBarDelegate <NSObject>

@required
/**
 *  返回按钮点击回调
 */
- (void)handleGoBackBtnClick;

@optional
/**
 *  点击保存按钮回调
 */
- (void)handleSaveBtnClick;
/**
 *  点击添加按钮回调
 */
- (void)handleAddBtnClick;

@end

/**
 *  房间信息相关的共用的顶导
 */
@interface SYCommonTopNavigationBar : UIView

@property (nonatomic, weak) id<SYCommonTopNavigationBarDelegate> delegate;

// init
- (instancetype)initWithFrame:(CGRect)frame midTitle:(NSString *)title rightTitle:(NSString *)rightTitle hasAddBtn:(BOOL) hasAdd;

@end

