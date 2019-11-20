//
//  SYCircleSegmentControl.m
//  Shining
//
//  Created by 杨玄 on 2019/8/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYCircleSegmentControl.h"

@interface SYCircleSegmentControl ()

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, copy) SYCircleSegmentControlBlock clickBlock;

@end

@implementation SYCircleSegmentControl

- (instancetype)initSYCircleSegmentControl:(CGRect)frame withTitles:(NSArray *)titles withClickBlock:(SYCircleSegmentControlBlock)block {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = CGRectGetHeight(frame)/2.f;
        self.backgroundColor = RGBACOLOR(113,56,239,1);
        [self addSubview:self.leftView];
        [self addSubview:self.rightView];
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        NSString *leftTile = [titles objectAtIndex:0];
        NSString *rightTitle = [titles objectAtIndex:1];
        [self.leftBtn setTitle:leftTile forState:UIControlStateNormal];
        [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
        self.clickBlock = block;
    }
    return self;
}

- (void)updateLeftTitle:(NSString *)title {
    [self.leftBtn setTitle:title forState:UIControlStateNormal];
}

- (void)updateRightTitle:(NSString *)title {
    [self.rightBtn setTitle:title forState:UIControlStateNormal];
}

#pragma mark - btnClick

- (void)handleLeftBtnClickEvent {
    self.leftView.backgroundColor = RGBACOLOR(113,56,239,1);
    self.rightView.backgroundColor = RGBACOLOR(39,38,44,1);
    if (self.clickBlock) {
        self.clickBlock(0);
    }
}

- (void)handleRightBtnClickEvent {
    self.leftView.backgroundColor = RGBACOLOR(39,38,44,1);
    self.rightView.backgroundColor = RGBACOLOR(113,56,239,1);
    if (self.clickBlock) {
        self.clickBlock(1);
    }
}

#pragma mark - Lazyload

- (UIView *)leftView {
    if (!_leftView) {
        CGRect frame = CGRectMake(1, 1, CGRectGetWidth(self.frame)/2.0f - 1, CGRectGetHeight(self.frame) - 2);
        _leftView = [[UIView alloc] initWithFrame:frame];
        _leftView.backgroundColor = RGBACOLOR(113,56,239,1);
        _leftView.clipsToBounds = YES;
        CGRect bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(CGRectGetHeight(frame) / 2.0f, CGRectGetHeight(frame) / 2.0f)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = bounds;
        maskLayer.path = maskPath.CGPath;
        _leftView.layer.mask = maskLayer;
    }
    return _leftView;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame)/2.0f, CGRectGetHeight(self.frame));
        _leftBtn.backgroundColor = [UIColor clearColor];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(handleLeftBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIView *)rightView {
    if (!_rightView) {
        CGRect frame = CGRectMake(CGRectGetWidth(self.frame)/2.0f, 1, CGRectGetWidth(self.frame)/2.0f - 1, CGRectGetHeight(self.frame) - 2);
        _rightView = [[UIView alloc] initWithFrame:frame];
        _rightView.backgroundColor = RGBACOLOR(39,38,44,1);
        _rightView.clipsToBounds = YES;
        CGRect bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(CGRectGetHeight(frame) / 2.0f, CGRectGetHeight(frame) / 2.0f)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = bounds;
        maskLayer.path = maskPath.CGPath;
        _rightView.layer.mask = maskLayer;
    }
    return _rightView;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(CGRectGetWidth(self.frame)/2.0f, 0, CGRectGetWidth(self.frame)/2.0f, CGRectGetHeight(self.frame));
        _rightBtn.backgroundColor = [UIColor clearColor];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(handleRightBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

@end
