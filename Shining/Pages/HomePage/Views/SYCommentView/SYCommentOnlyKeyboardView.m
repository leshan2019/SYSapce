//
//  SYCommentOnlyKeyboardView.m
//  Shining
//
//  Created by yangxuan on 2019/10/31.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYCommentOnlyKeyboardView.h"
#import "SYSendCommentToolView.h"
#import "SYUserServiceAPI.h"
#import "SYCommentViewModel.h"

@interface SYCommentOnlyKeyboardView ()

@property (nonatomic, strong) SYCommentViewModel *viewModel;

@property (nonatomic, strong) SYSendCommentToolView *inputBar; // 输入view
@property (nonatomic, strong) NSString *momentId;           // 动态id
@property (nonatomic, copy) UpdateCommentBlock updateBlock;

@end

@implementation SYCommentOnlyKeyboardView

- (void)dealloc {
    [self removeKeyboardNotifications];
}

- (instancetype)initWithFrame:(CGRect)frame momentId:(NSString *)momentId block:(nonnull UpdateCommentBlock)updateBlock{
    self = [super initWithFrame:frame];
    if (self) {
        self.momentId = momentId;
        self.updateBlock = updateBlock;
        [self initSubviews];
        [self addKeyboardNotifcations];
        [self.inputBar showKeyboard];
    }
    return self;
}

- (void)initSubviews {
    [self addSubview:self.inputBar];
    [self.inputBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self).with.offset(iPhoneX ? -34 : 0);
        make.height.mas_equalTo(64);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.inputBar packUpKeyboard];
    [self removeFromSuperview];
}

#pragma mark - UIKeyboardNotification

- (void)addKeyboardNotifcations {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    [self.inputBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-keyboardHeight);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self.inputBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(iPhoneX ? -34 : 0);
    }];
}

// 发送评论
- (void)sendComment:(NSString *)commentStr {
    [self.inputBar packUpKeyboard];
    [self removeFromSuperview];
    [self.viewModel requestValidText:commentStr success:^(BOOL result) {
        if (result) {
            [self.viewModel requestSendComment:self.momentId content:commentStr success:^(BOOL sendSuccess) {
                if (sendSuccess) {
                    if (self.updateBlock) {
                        self.updateBlock(1);
                    }
                    [SYToastView showToast:@"发送成功"];
                } else {
                    [SYToastView showToast:@"发送失败"];
                }
            }];
        } else {
            [SYToastView showToast:@"发送内容包含敏感词，请重新输入~"];
        }
    }];
}

#pragma mark - Lazyload

- (SYCommentViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [SYCommentViewModel new];
    }
    return _viewModel;
}

- (SYSendCommentToolView *)inputBar {
    if (!_inputBar) {
        __weak typeof(self) weakSelf = self;
        _inputBar = [[SYSendCommentToolView alloc] initWithFrame:CGRectZero maxInputNum:150 sendBlock:^(NSString *text) {
            [weakSelf sendComment:text];
        }];
    }
    return _inputBar;
}

@end
