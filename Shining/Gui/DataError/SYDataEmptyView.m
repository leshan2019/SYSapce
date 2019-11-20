//
//  SYDataEmptyView.m
//  Shining
//
//  Created by 杨玄 on 2019/3/30.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYDataEmptyView.h"

@interface SYDataEmptyView ()

@property (strong, nonatomic) UIImageView *tipImage;
@property (strong, nonatomic, readwrite) UILabel *tipLabel;
@property (strong, nonatomic) UIButton *refreshBtn;
@end

@implementation SYDataEmptyView

- (instancetype)initWithFrame:(CGRect)frame withTipImage:(NSString *)image withTipStr:(NSString *)tip {
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
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(280, 20));
        }];
        [self.tipImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(emptyImage.size);
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.tipLabel.mas_top).with.offset(-10);
        }];
        
        [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(85, 28));
            make.centerX.equalTo(self);
            make.top.equalTo(self.tipLabel.mas_bottom).with.offset(20);
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
        _tipLabel.textColor = RGBACOLOR(153, 153, 153, 1);
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    }
    return _tipLabel;
}

- (UIButton *)refreshBtn {
    if (!_refreshBtn) {
        _refreshBtn = [UIButton new];
        [_refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
        [_refreshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _refreshBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        _refreshBtn.layer.cornerRadius = 14;
        _refreshBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _refreshBtn.hidden =YES;
    }
    return _refreshBtn;
}

- (void)updateTipText:(NSString *)tipText
{
    self.tipLabel.text = tipText;
    [self setNeedsLayout];
}

- (void)updateForNoImage
{
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).with.offset(-30);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(280, 20));
    }];
}

- (void)updataForBtn:(nullable id)target action:(SEL)action
{
    [self updateForNoImage];
    self.tipLabel.textColor = [UIColor whiteColor];
    self.refreshBtn.hidden = NO;
    [self.refreshBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
    self.tipLabel.text = @"别紧张，请检查网络后刷新页面";
}

-(void)updateForLoginTip:(nullable id)target action:(SEL)action
{
    [self updataForBtn:target action:action];
    self.tipLabel.text = @"您需要登陆，才可以为您匹配合适的小伙伴哦～";
    [self.refreshBtn setTitle:@"登录" forState:UIControlStateNormal];
    
}

@end
