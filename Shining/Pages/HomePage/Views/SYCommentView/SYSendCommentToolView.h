//
//  SYSendCommentToolView.h
//  Shining
//
//  Created by yangxuan on 2019/10/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SendCommentBlock)(NSString * _Nonnull text);

NS_ASSUME_NONNULL_BEGIN

@interface SYSendCommentToolView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                  maxInputNum:(NSInteger)maxNum
                    sendBlock:(SendCommentBlock)sendBlock;

// 显示键盘
- (void)showKeyboard;

// 收起键盘
- (void)packUpKeyboard;

@end

NS_ASSUME_NONNULL_END
