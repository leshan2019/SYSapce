//
//  SYVideoRoomHomeRoomCell.m
//  Shining
//
//  Created by leeco on 2019/9/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVideoRoomHomeRoomCell.h"

@interface SYVideoRoomHomeRoomCell ()

@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *hotLabel;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UIImageView *lockView;
@property (nonatomic, strong) UIImageView *roomTypeView;
@property (nonatomic, strong) UIView *roomStateView;
@end
@implementation SYVideoRoomHomeRoomCell
+ (CGSize)cellSizeWithWidth:(CGFloat)width {
    CGFloat cellWidth = (width - 20) / 2.f;
    CGFloat cellHeight = cellWidth + 6.f;
    return CGSizeMake(cellWidth, cellHeight);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = DEFAULT_THEME_BG_COLOR;
        self.contentView.backgroundColor = DEFAULT_THEME_BG_COLOR;

        [self.contentView addSubview:self.thumbImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.thumbImageView.layer addSublayer:self.gradientLayer];
        [self.thumbImageView addSubview:self.iconView];
        [self.thumbImageView addSubview:self.hotLabel];
        [self.thumbImageView addSubview:self.lockView];
        [self.thumbImageView addSubview:self.roomStateView];
        [self.thumbImageView addSubview:self.roomTypeView];
    }
    return self;
}

- (UIImageView *)thumbImageView {
    if (!_thumbImageView) {
        _thumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.f, self.sy_width, self.sy_width)];
        _thumbImageView.clipsToBounds = YES;
        _thumbImageView.layer.cornerRadius = 6.f;
    }
    return _thumbImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.thumbImageView.sy_bottom -22.f, self.sy_width, 17)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.f];
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = CGRectMake(0, 0, self.thumbImageView.sy_width, self.thumbImageView.sy_height);
        _gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor, (__bridge id)[UIColor colorWithWhite:0 alpha:0.5].CGColor];
        _gradientLayer.locations = @[@(0.1), @(1)];
    }
    return _gradientLayer;
}

- (UIImageView *)roomTypeView{
    if (!_roomTypeView) {
        UIImageView*img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 48*dp, 20*dp)];
        img.backgroundColor = [UIColor clearColor];
        img.contentMode = UIViewContentModeScaleAspectFit;
        _roomTypeView = img;
    }
    return _roomTypeView;
}
- (UIView *)roomStateView{
    if (!_roomStateView) {
        UIView* bg = [[UIView alloc]initWithFrame:CGRectMake(self.thumbImageView.sy_width-52*dp, 11, 46*dp, 18*dp)];
        bg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        bg.layer.cornerRadius = 9*dp;
        UIView* dot = [[UIView alloc]initWithFrame:CGRectMake(5*dp, 7*dp, 4, 4)];
        dot.backgroundColor = [UIColor greenColor];
        dot.layer.cornerRadius = 2;
        [bg addSubview:dot];
        UILabel*title = [[UILabel alloc]initWithFrame:CGRectMake(0, 2*dp, 32*dp, 14*dp)];
        title.text = @"直播中";
        title.font = [UIFont systemFontOfSize:10];
        if (dp<1) {
            title.font = [UIFont systemFontOfSize:8];
        }
        title.textColor = [UIColor whiteColor];
        title.sy_left = dot.sy_right+2;
        title.backgroundColor = [UIColor clearColor];
        [bg addSubview:title];
        _roomStateView = bg;
    }
    return _roomStateView;
}
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(self.thumbImageView.sy_width - 48.f, self.thumbImageView.sy_height - 18.f - 7.f, 18.f, 18.f)];
    }
    return _iconView;
}

- (UILabel *)hotLabel {
    if (!_hotLabel) {
        _hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconView.sy_right + 2.f, self.iconView.sy_top + 5, 30.f, 13)];
        _hotLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        _hotLabel.font = [UIFont boldSystemFontOfSize:14.f];
        _hotLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _hotLabel;
}

- (UIImageView *)lockView {
    if (!_lockView) {
        _lockView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40.f, 40.f)];
        _lockView.center = CGPointMake(self.thumbImageView.sy_width / 2.f, self.thumbImageView.sy_height / 2.f);
        _lockView.image = [UIImage imageNamed_sy:@"voiceroom_lock"];
    }
    return _lockView;
}

- (void)showWithTitle:(NSString *)title
            avatarURL:(NSString *)avatarURL
                score:(NSInteger)score
             roomType:(NSInteger)type
         roomTypeIcon:(nonnull NSString *)typeUrl
             isLocked:(BOOL)isLocked {
    self.iconView.image = [UIImage gifImageNamed_sy:@"voiceroom_home_fire_gif"];
    [self.thumbImageView sd_setImageWithURL:[NSURL URLWithString:avatarURL]
                           placeholderImage:[SYUtil placeholderImageWithSize:self.thumbImageView.sy_size]];
    self.titleLabel.text = title;
    self.hotLabel.text = [NSString stringWithFormat:@"%ld", (long)score];
    self.lockView.hidden = !isLocked;
    self.roomStateView.hidden = ( type == 1);
    [self.roomTypeView sd_setImageWithURL:[NSURL URLWithString:typeUrl]];
    CGRect rect = [self.hotLabel.text boundingRectWithSize:CGSizeMake(99, self.hotLabel.sy_height)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName: self.hotLabel.font}
                                                   context:nil];
    self.hotLabel.sy_width = rect.size.width;
    self.hotLabel.sy_right = self.thumbImageView.sy_width - 10.f;
    self.iconView.sy_right = self.hotLabel.sy_left - 2.f;
    self.titleLabel.sy_width = self.iconView.sy_left - 15;
    self.titleLabel.sy_right = self.iconView.sy_left - 5;
    

}
@end
