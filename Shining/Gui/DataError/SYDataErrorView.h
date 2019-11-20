//
//  SYDataErrorView.h
//  Shining
//
//  Created by 杨玄 on 2019/5/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYDataErrorViewDelegate <NSObject>

// 点击刷新
- (void)SYDataErrorViewClickRefreshBtn;

@end

NS_ASSUME_NONNULL_BEGIN

// Bee语音 - 获取数据失败view
@interface SYDataErrorView : UIView

// init
- (instancetype)initSYDataErrorViewWithFrame:(CGRect)frame
                                withDelegate:(id<SYDataErrorViewDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
