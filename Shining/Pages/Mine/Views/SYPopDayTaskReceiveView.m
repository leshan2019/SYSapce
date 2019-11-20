//
//  SYPopDayTaskReceiveView.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/9/26.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYPopDayTaskReceiveView.h"

@interface SYPopDayTaskReceiveView()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *btn;
@end

@implementation SYPopDayTaskReceiveView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.f/255.0f green:0.f/255.0f blue:0.f/255.0f alpha:0.5];
        [self buildUI];
    }
    return self;
}

- (void)buildUI{
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc ]init];
//    [tap addTarget:self action:@selector(close)];
//    [self addGestureRecognizer:tap];
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self addSubview:self.btn];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(270, 196));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left);
        make.right.equalTo(self.bgView.mas_right);
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).with.offset(45);
        make.right.equalTo(self.bgView.mas_right).with.offset(-45);
        make.bottom.equalTo(self.bgView.mas_bottom).with.offset(-25);
        make.height.mas_equalTo(38);
    }];
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIImageView new];
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.image = [UIImage imageNamed_sy:@"daytask_dialog_bg_success"];
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor sam_colorWithHex:@"#444444"];
        _titleLabel.textAlignment =NSTextAlignmentCenter;
        _titleLabel.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
        _titleLabel.text = @"领取成功";
    }
    return _titleLabel;
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = [UIButton new];
        [_btn setTitle:@"确定" forState:UIControlStateNormal];
        _btn.layer.cornerRadius = 14;
        [_btn setBackgroundImage:[UIImage imageNamed_sy:@"daytask_confirm_bg"] forState:UIControlStateNormal];
        _btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btn addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _btn;
}


- (void)closeView:(id)sender{
    self.hidden = YES;
}

- (void)updateUI:(BOOL)isSuccess
{
    if (isSuccess) {
        self.bgView.image = [UIImage imageNamed_sy:@"daytask_dialog_bg_success"];
        self.titleLabel.text = @"领取成功";
    }else{
        self.bgView.image = [UIImage imageNamed_sy:@"daytask_dialog_bg_fail"];
        self.titleLabel.text = @"领取失败,请稍后再试";
    }
}
@end
