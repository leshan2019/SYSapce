//
//  SYTransferPopView.m
//  Shining
//
//  Created by letv_lzb on 2019/7/18.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYTransferPopView.h"

@interface SYTransferPopView ()

#pragma mark - ** UI **
@property (nonatomic, strong) UIButton *whiteWidow;         // 底部白框
@property (nonatomic, strong) UILabel *redPacketLabel;      // "红包"
@property (nonatomic, strong) UIImageView *honeyImage;      // 蜂蜜icon
@property (nonatomic, strong) UILabel *honeyLabel;          // 蜂蜜数量
@property (nonatomic, strong) UIView *horizonline;          // 分割线
@property (nonatomic, strong) UILabel *tipLabel;            // "一经确认，不可退回"
@property (nonatomic, strong) UIButton *cancelBtn;          // 取消
@property (nonatomic, strong) UIButton *ensureBtn;          // 确认

#pragma mark - ** Block **
@property (nonatomic, copy) SYTransferEnsureBlock ensureBlock;

@end

@implementation SYTransferPopView

- (instancetype)initSYTransferPopViewWithHoneyCount:(NSInteger)honeyCount ensureBlock:(SYTransferEnsureBlock)ensureBlock {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.backgroundColor = RGBACOLOR(0,0,0,0.4);

    // subViews
    [self addSubview:self.whiteWidow];
    [self.whiteWidow addSubview:self.redPacketLabel];
    [self.whiteWidow addSubview:self.honeyImage];
    [self.whiteWidow addSubview:self.honeyLabel];
    [self.whiteWidow addSubview:self.horizonline];
    [self.whiteWidow addSubview:self.tipLabel];
    [self.whiteWidow addSubview:self.cancelBtn];
    [self.whiteWidow addSubview:self.ensureBtn];
    // callBack
    self.ensureBlock = ensureBlock;
    // layoutSubViews
    [self mas_makeConstranitsWithSubviews];
    [self updateHoneyCount:honeyCount];
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

#pragma mark - PrivateMethod

// 点击取消
- (void)handleCancelBtnClickEvent {
    [self removeFromSuperview];
}

// 点击确认
- (void)handleEnsureBtnClickEvent {
    [self removeFromSuperview];
    if (self.ensureBlock) {
        self.ensureBlock();
    }
}

- (void)mas_makeConstranitsWithSubviews {
    [self.whiteWidow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(315, 260));
        make.center.equalTo(self);
    }];
    [self.redPacketLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 18));
        make.centerX.equalTo(self.whiteWidow);
        make.top.equalTo(self.whiteWidow).with.offset(40);
    }];
    [self.honeyImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.left.equalTo(self.whiteWidow).with.offset(102);
        make.top.equalTo(self.whiteWidow).with.offset(76);
    }];
    [self.honeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(82, 36));
        make.left.equalTo(self.honeyImage.mas_right).with.offset(6);
        make.top.equalTo(self.whiteWidow).with.offset(70);
    }];
    [self.horizonline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(self.whiteWidow).with.offset(20);
        make.right.equalTo(self.whiteWidow).with.offset(-20);
        make.top.equalTo(self.whiteWidow).with.offset(137);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(110, 16));
        make.left.equalTo(self.whiteWidow).with.offset(20);
        make.top.equalTo(self.whiteWidow).with.offset(140);
    }];
    [self.ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(184, 42));
        make.centerX.equalTo(self.whiteWidow);
        make.top.equalTo(self.whiteWidow).with.offset(188);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 44));
        make.top.equalTo(self.whiteWidow);
        make.right.equalTo(self.whiteWidow);
    }];
}

- (void)updateHoneyCount:(NSInteger)honeyCount {
    if (honeyCount < 0) {
        honeyCount = 0;
    }
    NSString *honeystr = [NSString stringWithFormat:@"%ld",honeyCount];
    self.honeyLabel.text = honeystr;
    CGFloat honeyWidth = [honeystr sizeWithAttributes:@{NSFontAttributeName: self.honeyLabel.font}].width + 1 ;
    [self.honeyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(honeyWidth);
    }];
    CGFloat fixLeft = (315 - 24 - 6 - honeyWidth)/2.0;
    [self.honeyImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteWidow).with.offset(fixLeft);
    }];
}

#pragma mark - Lazyload

- (UIButton *)whiteWidow {
    if (!_whiteWidow) {
        _whiteWidow = [UIButton new];
        _whiteWidow.backgroundColor = [UIColor whiteColor];
        _whiteWidow.clipsToBounds = YES;
        _whiteWidow.layer.cornerRadius = 5.0;
    }
    return _whiteWidow;
}

- (UILabel *)redPacketLabel {
    if (!_redPacketLabel) {
        _redPacketLabel = [UILabel new];
        _redPacketLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _redPacketLabel.text = @"红包";
        _redPacketLabel.textColor = RGBACOLOR(68,68,68,1);
    }
    return _redPacketLabel;
}

- (UIImageView *)honeyImage {
    if (!_honeyImage) {
        _honeyImage = [UIImageView new];
        _honeyImage.image = [UIImage imageNamed_sy:@"transgerBeeCoin"];
        _honeyImage.backgroundColor = [UIColor clearColor];
    }
    return _honeyImage;
}

- (UILabel *)honeyLabel {
    if (!_honeyLabel) {
        _honeyLabel = [UILabel new];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:34];
        if (!font) {
            font = [UIFont fontWithName:@"PingFang-SC-Medium" size:34];
        }
        _honeyLabel.font = font;
        _honeyLabel.textColor = RGBACOLOR(11,11,11,1);
    }
    return _honeyLabel;
}

- (UIView *)horizonline {
    if (!_horizonline) {
        _horizonline = [UIView new];
        _horizonline.backgroundColor = RGBACOLOR(0,0,0,0.08);
        _horizonline.clipsToBounds = YES;
        _horizonline.layer.cornerRadius = 0.5;
    }
    return _horizonline;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        _tipLabel.text = @"一经确认，不可退回";
        _tipLabel.textColor = RGBACOLOR(102,102,102,1);
    }
    return _tipLabel;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        [_cancelBtn setImage:[UIImage imageNamed_sy:@"login_close"] forState:UIControlStateNormal];
        [_cancelBtn setImage:[UIImage imageNamed_sy:@"login_close"] forState:UIControlStateHighlighted];
        [_cancelBtn addTarget:self action:@selector(handleCancelBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.backgroundColor = [UIColor clearColor];
    }
    return _cancelBtn;
}

- (UIButton *)ensureBtn {
    if (!_ensureBtn) {
        _ensureBtn = [UIButton new];
        [_ensureBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_ensureBtn setTitleColor:RGBACOLOR(255,255,255,1) forState:UIControlStateNormal];
        _ensureBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:18];
        _ensureBtn.backgroundColor = RGBACOLOR(113,56,239,1);
        _ensureBtn.clipsToBounds = YES;
        _ensureBtn.layer.cornerRadius = 6;
        [_ensureBtn addTarget:self action:@selector(handleEnsureBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ensureBtn;
}

@end
