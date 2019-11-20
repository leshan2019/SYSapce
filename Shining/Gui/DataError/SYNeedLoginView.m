//
//  SYNeedLoginView.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/10/24.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYNeedLoginView.h"

@interface SYNeedLoginView()
@property (strong, nonatomic) UIImageView *tipImage;
@property (strong, nonatomic, readwrite) UILabel *tipLabel;
@property (strong, nonatomic) UIButton *refreshBtn;
@end

@implementation SYNeedLoginView

- (instancetype)initWithFrame:(CGRect)frame withTipImage:(NSString *)image withTipStr:(NSString *)tip
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(245, 246, 247, 1);
        [self addSubview:self.tipImage];
        [self addSubview:self.tipLabel];
        [self addSubview:self.refreshBtn];
        UIImage *emptyImage = [UIImage imageNamed_sy:image];
        self.tipImage.image = emptyImage;
        self.tipLabel.text = tip;
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).with.offset(30);
            make.size.mas_equalTo(CGSizeMake(280, 20));
        }];
        [self.tipImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(emptyImage.size);
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.tipLabel.mas_top).with.offset(-16);
        }];
        
        [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(220, 48));
            make.centerX.equalTo(self);
            make.top.equalTo(self.tipLabel.mas_bottom).with.offset(29);
        }];
    }
    return self;
}

#pragma mark - LazyLoad

- (UIImageView *)tipImage {
    if (!_tipImage) {
        _tipImage = [UIImageView new];
        _tipImage.contentMode = UIViewContentModeScaleAspectFill;
        _tipImage.clipsToBounds = YES;
    }
    return _tipImage;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _tipLabel.textColor = [UIColor sam_colorWithHex:@"#0B0B0B"];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    }
    return _tipLabel;
}

- (UIButton *)refreshBtn {
    if (!_refreshBtn) {
        _refreshBtn = [UIButton new];
        [_refreshBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_refreshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_refreshBtn setBackgroundImage:[UIImage imageNamed_sy:@"friend_loginbtn_bg"] forState:UIControlStateNormal];
        _refreshBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        _refreshBtn.layer.cornerRadius = 14;
        _refreshBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _refreshBtn;
}

- (void)updateTipText:(NSString *)tipText
{
    self.tipLabel.text = tipText;
    [self setNeedsLayout];
}

-(void)updateForLoginTip:(nullable id)target action:(SEL)action
{
    [self.refreshBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
