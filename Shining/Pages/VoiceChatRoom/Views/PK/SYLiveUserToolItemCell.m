//
//  SYLiveUserToolItemCell.m
//  Shining
//
//  Created by letv_lzb on 2019/10/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveUserToolItemCell.h"

@interface SYLiveUserToolItemCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *pkIndicator;
@property (nonatomic, strong) UILabel *redIndicator;
@property (nonatomic, assign) BOOL isPKing;
@end

@implementation SYLiveUserToolItemCell



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.pkIndicator];
        [self addSubview:self.redIndicator];
    }
    return self;
}
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 16, 40, 40)];
        _iconView.backgroundColor =[UIColor clearColor];
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.iconView.sy_bottom + 8.f, self.sy_width , 13.f)];
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:10];
        _titleLabel.textColor = [UIColor sy_colorWithHexString:@"#888888"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}


- (UILabel *)pkIndicator {
    if (!_pkIndicator) {
        _pkIndicator = [[UILabel alloc] initWithFrame:CGRectMake(self.iconView.sy_left+1.f, self.iconView.sy_top + 27.f, 38.f, 15.f)];
        _pkIndicator.backgroundColor = [UIColor sy_colorWithHexString:@"#666666"];
        _pkIndicator.textAlignment = NSTextAlignmentCenter;
        _pkIndicator.textColor = [UIColor whiteColor];
        _pkIndicator.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:10];
        _pkIndicator.text = @"未开始";
        _pkIndicator.layer.cornerRadius = 7.5f;
        _pkIndicator.clipsToBounds = YES;
        _pkIndicator.hidden = YES;
    }
    return _pkIndicator;
}


- (UILabel *)redIndicator {
    if (!_redIndicator) {
        _redIndicator = [[UILabel alloc] initWithFrame:CGRectMake(self.iconView.sy_left+32.f*dp, self.iconView.sy_top + 5.f*dp, 6.f*dp, 6.f*dp)];
        _redIndicator.backgroundColor = [UIColor sy_colorWithHexString:@"#FF0046"];
        _redIndicator.layer.cornerRadius = 3.f*dp;
        _redIndicator.clipsToBounds = YES;
        _redIndicator.hidden = YES;
    }
    return _redIndicator;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.iconView.sy_top = 16*dp;
    self.iconView.sy_left = (self.sy_width-40)/2.f;
    self.titleLabel.sy_top = self.iconView.sy_bottom+8*dp;
    self.pkIndicator.sy_top = self.iconView.sy_top + 27.f*dp;
    self.pkIndicator.sy_left = self.iconView.sy_left+1.f*dp;
    self.redIndicator.sy_left = self.iconView.sy_left+32.f*dp;
    self.redIndicator.sy_top = self.iconView.sy_top + 5.f*dp;
}
- (void)setIcon:(UIImage *)image andTitle:(NSString *)title{
    [self setIcon:image andTitle:title showRedIcon:NO];
}


- (void)setIcon:(UIImage*)image andTitle:(NSString*)title showRedIcon:(BOOL)isShowRedIcon {
    [self.iconView setImage:image];
    [self.titleLabel setText:title];
    [self updateRedState:isShowRedIcon];
}


- (void)updateRedState:(BOOL)isShowRedIcon {
    self.redIndicator.hidden = !isShowRedIcon;
}

- (void)setPKing:(BOOL)pking {
    self.isPKing = pking;
    self.pkIndicator.hidden = pking;
}

@end
