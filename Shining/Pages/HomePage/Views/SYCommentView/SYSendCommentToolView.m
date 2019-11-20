//
//  SYSendCommentToolView.m
//  Shining
//
//  Created by yangxuan on 2019/10/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYSendCommentToolView.h"

@interface SYSendCommentToolView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *inputView;            // assistView
@property (nonatomic, strong) UIView *inputShadowView;        // 输入法阴影
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UIButton *sendBtn;

// 最都输入数
@property (nonatomic, assign) NSInteger maxNum;
@property (nonatomic, copy) SendCommentBlock sendBlock;

@end

@implementation SYSendCommentToolView

- (void)dealloc {
    [self removeNotification];
}

- (instancetype)initWithFrame:(CGRect)frame maxInputNum:(NSInteger)maxNum sendBlock:(nonnull SendCommentBlock)sendBlock{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        self.maxNum = maxNum;
        self.sendBlock = sendBlock;
        [self addNotification];
    }
    return self;
}

- (void)showKeyboard {
    [self.inputField becomeFirstResponder];
}

- (void)packUpKeyboard {
    [self.inputField resignFirstResponder];
}

- (void)setMaxNum:(NSInteger)maxNum {
    _maxNum = maxNum;
    if (maxNum < 20) {
        _maxNum = 20;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length > 0 && [string isEqualToString:@""]) {     // 点击键盘中删除按钮操作
        return YES;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (newLength <= self.maxNum) {
        return YES;
    } else {
        [SYToastView showToast:[NSString stringWithFormat:@"字数不能超过%ld字哦~",self.maxNum]];
        return NO;
    }
}

#pragma mark - Private

- (void)initSubViews {
    [self addSubview:self.inputView];
    [self.inputView addSubview:self.inputShadowView];
    [self.inputShadowView addSubview:self.inputField];
    [self.inputShadowView addSubview:self.sendBtn];
    [self mas_makeConstraints];
}

- (void)mas_makeConstraints {
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.inputShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputView).with.offset(15);
        make.right.equalTo(self.inputView).with.offset(-15);
        make.top.equalTo(self.inputView).with.offset(12);
        make.height.mas_equalTo(36);
    }];
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputShadowView).with.offset(20);
        make.top.equalTo(self.inputShadowView);
        make.right.equalTo(self.inputShadowView).with.offset(-51);
        make.bottom.equalTo(self.inputShadowView);
    }];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputShadowView).with.offset(5);
        make.right.equalTo(self.inputShadowView).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
}

// 发送弹幕
- (void)sendComment {
    self.sendBtn.enabled = NO;
    if (self.sendBlock) {
        self.sendBlock(self.inputField.text);
    }
    self.inputField.text = @"";
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateSendBtnStatue)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:nil];
}

- (void)updateSendBtnStatue {
    if (self.inputField.text.length > 0) {
        self.sendBtn.enabled = YES;
    } else {
        self.sendBtn.enabled = NO;
    }
}

#pragma mark - Lazyload

- (UIButton *)inputView {
    if (!_inputView) {
        _inputView = [UIButton new];
        _inputView.backgroundColor = RGBACOLOR(255,255,255,1);
        // 阴影颜色
        _inputView.layer.shadowColor = RGBACOLOR(0,0,0,0.03).CGColor;
        // 阴影偏移量 默认为(0,3)
        _inputView.layer.shadowOffset = CGSizeMake(0, -2);
        // 阴影透明度
        _inputView.layer.shadowOpacity = 1;
    }
    return _inputView;
}

- (UIView *)inputShadowView {
    if (!_inputShadowView) {
        _inputShadowView = [UIView new];
        _inputShadowView.backgroundColor = RGBACOLOR(246,246,246,1);
        _inputShadowView.layer.cornerRadius = 18;
    }
    return _inputShadowView;
}

- (UITextField *)inputField {
    if (!_inputField) {
        _inputField = [[UITextField alloc]init];
        _inputField.placeholder = @"想对TA说的话…";
        _inputField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _inputField.textColor = RGBACOLOR(201,201,201,1);
        _inputField.textAlignment = NSTextAlignmentLeft;
        _inputField.delegate = self;
    }
    return _inputField;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton new];
        [_sendBtn setImage:[UIImage imageNamed_sy:@"homepage_comment_send_no"] forState:UIControlStateDisabled];
        [_sendBtn setImage:[UIImage imageNamed_sy:@"homepage_comment_send_can"] forState:UIControlStateNormal];
        _sendBtn.enabled = NO;
        [_sendBtn addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

@end
