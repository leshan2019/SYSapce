//
//  SYMineAttentionFansControl.m
//  Shining
//
//  Created by 杨玄 on 2019/7/4.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYMineAttentionFansControl.h"

@interface SYMineAttentionFansControl ()

// 关注
@property (nonatomic, strong) UIButton *attentionBtn;
@property (nonatomic, strong) UILabel *attentionTipLabel;
@property (nonatomic, strong) UILabel *attentionCountLabel;

// 分割线
@property (nonatomic, strong) UIView *verticalLine;

// 粉丝
@property (nonatomic, strong) UIButton *fansBtn;
@property (nonatomic, strong) UILabel *fansTipLabel;
@property (nonatomic, strong) UILabel *fansCountLabel;

@end

@implementation SYMineAttentionFansControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 10;
    self.backgroundColor = [UIColor whiteColor];
    [self addSubviews];
    [self addShadow];
    return self;
}

#pragma mark - Public

- (void)updateControlWithAttentionCount:(NSInteger)attentionCount withFansCount:(NSInteger)fansCount {
    self.attentionCountLabel.text = [NSString stringWithFormat:@"%ld",attentionCount];
    self.fansCountLabel.text = [NSString stringWithFormat:@"%ld",fansCount];
}

#pragma mark - Private

- (void)addSubviews {
    [self addSubview:self.attentionBtn];
    [self addSubview:self.fansBtn];
    [self addSubview:self.verticalLine];
    [self.attentionBtn addSubview:self.attentionCountLabel];
    [self.attentionBtn addSubview:self.attentionTipLabel];
    [self.fansBtn addSubview:self.fansCountLabel];
    [self.fansBtn addSubview:self.fansTipLabel];

    [self.attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.right.equalTo(self).with.offset(-self.sy_width/2);
        make.bottom.equalTo(self);
    }];
    [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(1, 17));
    }];
    [self.fansBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(self.sy_width/2);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    [self.attentionCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.attentionBtn);
        make.right.equalTo(self.attentionBtn);
        make.top.equalTo(self.attentionBtn).with.offset(10);
        make.height.mas_equalTo(18);
    }];
    [self.attentionTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.attentionBtn);
        make.right.equalTo(self.attentionBtn);
        make.top.equalTo(self.attentionCountLabel.mas_bottom).with.offset(2);
        make.height.mas_equalTo(14);
    }];
    [self.fansCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fansBtn);
        make.right.equalTo(self.fansBtn);
        make.top.equalTo(self.fansBtn).with.offset(10);
        make.height.mas_equalTo(18);
    }];
    [self.fansTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fansBtn);
        make.right.equalTo(self.fansBtn);
        make.top.equalTo(self.fansCountLabel.mas_bottom).with.offset(2);
        make.height.mas_equalTo(14);
    }];
}

// 添加阴影效果
- (void)addShadow {
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.12f;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowRadius = 6;
    self.layer.shadowPath = shadowPath.CGPath;
}

- (void)handleAttentionBtnClick {
    if (self.clickBlock) {
        self.clickBlock(@"我的关注");
    }
}

- (void)handleFansBtnClick {
    if (self.clickBlock) {
        self.clickBlock(@"我的粉丝");
    }
}

#pragma mark - Lazyload

- (UIButton *)attentionBtn {
    if (!_attentionBtn) {
        _attentionBtn = [UIButton new];
        [_attentionBtn addTarget:self action:@selector(handleAttentionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attentionBtn;
}

- (UIButton *)fansBtn {
    if (!_fansBtn) {
        _fansBtn = [UIButton new];
        [_fansBtn addTarget:self action:@selector(handleFansBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fansBtn;
}

- (UILabel *)attentionCountLabel {
    if (!_attentionCountLabel) {
        _attentionCountLabel = [UILabel new];
        _attentionCountLabel.font = [UIFont fontWithName:@"ArialMT" size:16];
        _attentionCountLabel.textColor = RGBACOLOR(113,56,239,1);
        _attentionCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _attentionCountLabel;
}

- (UILabel *)attentionTipLabel {
    if (!_attentionTipLabel) {
        _attentionTipLabel = [UILabel new];
        _attentionTipLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        _attentionTipLabel.textColor = RGBACOLOR(111,111,111,1);
        _attentionTipLabel.textAlignment = NSTextAlignmentCenter;
        _attentionTipLabel.text = @"我的关注";
    }
    return _attentionTipLabel;
}

- (UIView *)verticalLine {
    if (!_verticalLine) {
        _verticalLine = [UIView new];
        _verticalLine.backgroundColor = RGBACOLOR(0,0,0,0.2);
    }
    return _verticalLine;
}

- (UILabel *)fansCountLabel {
    if (!_fansCountLabel) {
        _fansCountLabel = [UILabel new];
        _fansCountLabel.font = [UIFont fontWithName:@"ArialMT" size:16];
        _fansCountLabel.textColor = RGBACOLOR(113,56,239,1);
        _fansCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _fansCountLabel;
}

- (UILabel *)fansTipLabel {
    if (!_fansTipLabel) {
        _fansTipLabel = [UILabel new];
        _fansTipLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        _fansTipLabel.textColor = RGBACOLOR(111,111,111,1);
        _fansTipLabel.textAlignment = NSTextAlignmentCenter;
        _fansTipLabel.text = @"我的粉丝";
    }
    return _fansTipLabel;
}





@end
