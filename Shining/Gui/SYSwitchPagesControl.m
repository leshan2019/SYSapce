//
//  SYSwitchPagesControl.m
//  Shining
//
//  Created by 杨玄 on 2019/3/28.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYSwitchPagesControl.h"

@interface SYSwitchPagesControl ()

@property (nonatomic, strong) UIView *topLine;          // 顶部分割线
@property (nonatomic, strong) UIButton *leftBtn;        // left按钮
@property (nonatomic, strong) UIButton *rightBtn;       // right按钮
@property (nonatomic, strong) UIView *verticalLine;     // 中间分割线
@property (nonatomic, strong) UIView *bottomLine;       // 底部分割线

@end

@implementation SYSwitchPagesControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        // 添加控件
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        [self addSubview:self.verticalLine];
        [self addSubview:self.topLine];
        [self addSubview:self.bottomLine];

        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(__MainScreen_Width/2, 40));
        }];

        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(__MainScreen_Width/2, 40));
        }];

        [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.center);
            make.size.mas_equalTo(CGSizeMake(1, 20));
        }];

        [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.right.equalTo(self);
            make.height.mas_equalTo(0.5);
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

#pragma mark - Public

- (void)configueCustomUIWithTitle:(NSArray *)titles withNormalColors:(NSArray *)normalColors withSelectedColors:(NSArray *)selectedColors {
    NSString *leftTitle = [NSString sy_safeString:[titles objectAtIndex:0]];
    NSString *rightTitle = [NSString sy_safeString:[titles objectAtIndex:1]];
    UIColor *leftNormalColor = [normalColors objectAtIndex:0];
    UIColor *rightNormalColor = [normalColors objectAtIndex:1];
    if (!leftNormalColor) {
        leftNormalColor = RGBACOLOR(68, 68, 68, 1);
    }
    if (!rightNormalColor) {
        rightNormalColor = RGBACOLOR(68, 68, 68, 1);
    }
    UIColor *leftSelectColor = [selectedColors objectAtIndex:0];
    UIColor *rightSelectColor = [selectedColors objectAtIndex:1];
    if (!leftSelectColor) {
        leftSelectColor = RGBACOLOR(113, 56, 238, 1);
    }
    if (!rightSelectColor) {
        rightSelectColor = RGBACOLOR(113, 56, 238, 1);
    }

    [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:leftNormalColor forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:leftSelectColor forState:UIControlStateSelected];

    [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:rightNormalColor forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:rightSelectColor forState:UIControlStateSelected];
}

#pragma mark - Setter

- (void)setSelectedControl:(NSInteger)selectedControl {
    _selectedControl = selectedControl;
    switch (selectedControl) {
        case 0:{
            [self handleLeftBtnClickEvent:self.leftBtn];
        }
            break;
        case 1:{
            [self handleRightBtnClickEvent:self.rightBtn];
        }
            break;
        default:
            break;
    }
}

#pragma mark - ClickEvent

- (void)handleLeftBtnClickEvent:(UIButton *)btn {
    if (btn.isSelected) {
        return;
    }
    _selectedControl = 0;
    btn.selected = YES;
    self.rightBtn.selected = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleSwitchPagesControlLeftBtnClickEvent)]) {
        [self.delegate handleSwitchPagesControlLeftBtnClickEvent];
    }
}

- (void)handleRightBtnClickEvent:(UIButton *)btn {
    if (btn.isSelected) {
        return;
    }
    _selectedControl = 1;
    btn.selected = YES;
    self.leftBtn.selected = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleSwitchPagesControlRightBtnClickEvent)]) {
        [self.delegate handleSwitchPagesControlRightBtnClickEvent];
    }
}

#pragma mark - LazyLoad

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton new];
        _leftBtn.backgroundColor = RGBACOLOR(245, 246, 247, 1);
        _leftBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_leftBtn addTarget:self action:@selector(handleLeftBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton new];
        _rightBtn.backgroundColor = RGBACOLOR(245, 246, 247, 1);
        _rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_rightBtn addTarget:self action:@selector(handleRightBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UIView *)verticalLine {
    if (!_verticalLine) {
        _verticalLine = [UIView new];
        _verticalLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.15);
    }
    return _verticalLine;
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [UIView new];
        _topLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.08);
    }
    return _topLine;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.08);
    }
    return _bottomLine;
}

@end
