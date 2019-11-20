//
//  SYVoiceRoomPropCell.m
//  Shining
//
//  Created by mengxiangjian on 2019/5/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomPropCell.h"

@interface SYVoiceRoomPropCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *stateView;
@property (nonatomic, strong) UIImageView *coinView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIImageView *clockView;
@property (nonatomic, strong) UILabel *expireLabel;

@end

@implementation SYVoiceRoomPropCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor sam_colorWithHex:@"#F8F8FF"];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.stateView];
        [self.contentView addSubview:self.coinView];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.durationLabel];
        [self.contentView addSubview:self.expireLabel];
        [self.contentView addSubview:self.clockView];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 4.f;
    }
    return self;
}

- (void)showWithIcon:(NSString *)icon {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:icon]];
}

- (void)setDefaultPrice:(NSInteger)price durationTime:(NSString *)durationTime {
    self.coinView.hidden = NO;
    self.priceLabel.hidden = NO;
    self.durationLabel.hidden = NO;
    self.stateView.hidden = YES;
    self.clockView.hidden = YES;
    self.expireLabel.hidden = YES;
    self.priceLabel.text = [NSString stringWithFormat:@"%@", @(price)];
    self.durationLabel.text = durationTime;
}

- (void)setVipLevel:(NSInteger)vipLevel durationTime:(NSString *)durationTime {
    self.coinView.hidden = NO;
    self.priceLabel.hidden = NO;
    self.durationLabel.hidden = NO;
    self.stateView.hidden = YES;
    self.clockView.hidden = YES;
    self.expireLabel.hidden = YES;
    self.priceLabel.text = [NSString stringWithFormat:@"需要Vip%@", @(vipLevel)];
    self.durationLabel.text = durationTime;
}

- (void)setIsInUseWithExpireTime:(NSString *)expireTime {
    self.coinView.hidden = YES;
    self.priceLabel.hidden = YES;
    self.durationLabel.hidden = YES;
    self.stateView.hidden = NO;
    self.clockView.hidden = NO;
    self.expireLabel.hidden = NO;
    
    self.stateView.image = [UIImage imageNamed_sy:@"voiceroom_prop_inuse"];
    self.expireLabel.text = expireTime;
    
    [self adjustExpireLabel];
}

- (void)setIsMineWithExpireTime:(NSString *)expireTime {
    self.coinView.hidden = YES;
    self.priceLabel.hidden = YES;
    self.durationLabel.hidden = YES;
    self.stateView.hidden = NO;
    self.clockView.hidden = NO;
    self.expireLabel.hidden = NO;
    
    self.stateView.image = [UIImage imageNamed_sy:@"voiceroom_prop_isMine"];
    self.expireLabel.text = expireTime;
    
    [self adjustExpireLabel];
}

- (void)adjustExpireLabel {
    CGRect rect = [self.expireLabel.text boundingRectWithSize:CGSizeMake(99, self.expireLabel.sy_height)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName: self.expireLabel.font}
                                                      context:nil];
    self.expireLabel.sy_width = rect.size.width;
    self.expireLabel.sy_right = self.sy_width - 2.f;
    self.clockView.sy_right = self.expireLabel.sy_left - 2.f;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        CGFloat width = self.sy_width - 28.f;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(14.f, 8.f, width, width)];
    }
    return _imageView;
}

- (UIImageView *)coinView {
    if (!_coinView) {
        CGFloat height = 10.f;
        _coinView = [[UIImageView alloc] initWithFrame:CGRectMake(6.f, self.sy_height - 7.f - height, height, height)];
        _coinView.image = [UIImage imageNamed_sy:@"voiceroom_note"];
    }
    return _coinView;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.coinView.sy_right + 2.f, self.coinView.sy_top, 100.f, 12.f)];
        _priceLabel.font = [UIFont systemFontOfSize:10.f];
        _priceLabel.textColor = [UIColor sam_colorWithHex:@"#999999"];
    }
    return _priceLabel;
}

- (UIImageView *)stateView {
    if (!_stateView) {
        CGFloat height = 14.f;
        _stateView = [[UIImageView alloc] initWithFrame:CGRectMake(4.f, self.sy_height - 4.f - height, 34.f, height)];
    }
    return _stateView;
}

- (UILabel *)expireLabel {
    if (!_expireLabel) {
        CGFloat width = 26.f;
        CGFloat height = 12.f;
        _expireLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.sy_width - width - 4.f, self.sy_height - height - 5.f, width, height)];
        _expireLabel.font = [UIFont systemFontOfSize:10.f];
        _expireLabel.textColor = [UIColor sam_colorWithCSS:@"#7138EF"];
    }
    return _expireLabel;
}

- (UIImageView *)clockView {
    if (!_clockView) {
        CGFloat width = 10.f;
        _clockView = [[UIImageView alloc] initWithFrame:CGRectMake(self.expireLabel.sy_left - width - 2.f, self.sy_height - 6.f - width, width, width)];
        _clockView.image = [UIImage imageNamed_sy:@"voiceroom_prop_clock"];
    }
    return _clockView;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        CGFloat width = 26.f;
        CGFloat height = 12.f;
        _durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.sy_width - width - 2.f, self.sy_height - height - 5.f, width, height)];
        _durationLabel.font = [UIFont systemFontOfSize:10.f];
        _durationLabel.textColor = [UIColor sam_colorWithCSS:@"#0B0B0B"];
    }
    return _durationLabel;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.layer.borderColor = [UIColor sam_colorWithHex:@"#7138EF"].CGColor;
        self.layer.borderWidth = 1.f;
    } else {
        self.layer.borderColor = [UIColor sam_colorWithHex:@"#7138EF"].CGColor;
        self.layer.borderWidth = 0.f;
    }
}

@end
