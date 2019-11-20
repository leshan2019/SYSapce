//
//  MyShineDetailTopBarView.m
//  Shining
//
//  Created by letv_lzb on 2019/3/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "MyShineDetailTopBarView.h"

@interface MyShineDetailTopBarView ()
@property (nonatomic, strong) UIButton *chatBtn;        //聊天按钮
@property (nonatomic, strong) UIButton *attentionBtn;   //关注按钮
@property (nonatomic, strong) UIView *verticalLine;     //分割线
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation MyShineDetailTopBarView


- (instancetype)init{
    self = [super init];
    if (self) {
        // 添加控件
        [self addSubview:self.chatBtn];
        [self addSubview:self.attentionBtn];
        [self addSubview:self.verticalLine];
        [self addSubview:self.bottomLine];

        [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(__MainScreen_Width/2, 40));
        }];

        [self.attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(__MainScreen_Width/2, 40));
        }];

        [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.center);
            make.size.mas_equalTo(CGSizeMake(1, 20));
        }];

        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        // 添加控件
        [self addSubview:self.chatBtn];
        [self addSubview:self.attentionBtn];
        [self addSubview:self.verticalLine];
        [self addSubview:self.bottomLine];

        [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(__MainScreen_Width/2, 40));
        }];

        [self.attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(__MainScreen_Width/2, 40));
        }];

        [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.center);
            make.size.mas_equalTo(CGSizeMake(1, 20));
        }];

        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}


- (void)setSelectedControl:(NSInteger)selectedControl {
    _selectedControl = selectedControl;
    switch (selectedControl) {
        case 0:{
            [self handleChatBtnClick:self.chatBtn];
        }
            break;
        case 1:{
            [self handleAttentionBtnClick:self.attentionBtn];
        }
            break;
        default:
            break;
    }
}
#pragma mark - LazyLoad

- (UIButton *)chatBtn {
    if (!_chatBtn) {
        _chatBtn = [UIButton new];
        _chatBtn.backgroundColor = RGBACOLOR(245, 246, 247, 1);
        [_chatBtn setTitle:@"收入" forState:UIControlStateNormal];
        _chatBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_chatBtn setTitleColor:RGBACOLOR(68, 68, 68, 1) forState:UIControlStateNormal];
        [_chatBtn setTitleColor:RGBACOLOR(113, 56, 238, 1) forState:UIControlStateSelected];
        [_chatBtn addTarget:self action:@selector(handleChatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatBtn;
}

- (UIButton *)attentionBtn {
    if (!_attentionBtn) {
        _attentionBtn = [UIButton new];
        _attentionBtn.backgroundColor = RGBACOLOR(245, 246, 247, 1);
        [_attentionBtn setTitle:@"消耗" forState:UIControlStateNormal];
        _attentionBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_attentionBtn setTitleColor:RGBACOLOR(68, 68, 68, 1) forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:RGBACOLOR(113, 56, 238, 1) forState:UIControlStateSelected];
        [_attentionBtn addTarget:self action:@selector(handleAttentionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attentionBtn;
}

- (UIView *)verticalLine {
    if (!_verticalLine) {
        _verticalLine = [UIView new];
        _verticalLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.15);
    }
    return _verticalLine;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.08);
    }
    return _bottomLine;
}

#pragma mark - BtnMethod

- (void)handleChatBtnClick:(UIButton *)chatBtn {
    if (chatBtn.isSelected) {
        return;
    }
    _selectedControl = 0;
    chatBtn.selected = YES;
    self.attentionBtn.selected = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleConversationControlLeftClickEvent)]) {
        [self.delegate handleConversationControlLeftClickEvent];
    }
}

- (void)handleAttentionBtnClick:(UIButton *)attentionBtn {
    if (attentionBtn.isSelected) {
        return;
    }
    _selectedControl = 1;
    attentionBtn.selected = YES;
    self.chatBtn.selected = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleConversationControlRightClickEvent)]) {
        [self.delegate handleConversationControlRightClickEvent];
    }
}

@end
