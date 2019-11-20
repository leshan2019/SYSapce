//
//  SYNoNetworkView.h
//  Shining
//
//  Created by 杨玄 on 2019/5/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYNoNetworkViewDelegate <NSObject>

// 点击刷新按钮
- (void)SYNoNetworkViewClickRefreshBtn;

@end

NS_ASSUME_NONNULL_BEGIN

/**
 *  Bee语音 - 网络未连接提示view
 */
@interface SYNoNetworkView : UIView

// init
- (instancetype)initSYNoNetworkViewWithFrame:(CGRect)frame
                                withDelegate:(id<SYNoNetworkViewDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
