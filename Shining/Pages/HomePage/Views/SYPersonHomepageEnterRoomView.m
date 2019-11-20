//
//  SYPersonHomepageEnterRoomView.m
//  Shining
//
//  Created by 杨玄 on 2019/4/24.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepageEnterRoomView.h"
#import "SYPersonHomepageMarqueeView.h"

@interface SYPersonHomepageEnterRoomView ()

@property (nonatomic, strong) UIImageView *backImage;       // 背景图
@property (nonatomic, strong) UIImageView *roomIcon;        // 房间icon
@property (nonatomic, strong) UIView *roomMask;             // 房间icon上的蒙层
@property (nonatomic, strong) UIImageView *animationView;   // 动画view
@property (nonatomic, strong) UILabel *tipLabel;            // "当前正在："
@property (nonatomic, strong) SYPersonHomepageMarqueeView *roomName;    // 房间name
@property (nonatomic, strong) UIImageView *enterIcon;       // 右侧角标

@end

@implementation SYPersonHomepageEnterRoomView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
        [self mas_makeConstraintsWithSubviews];
    }
    return self;
}

#pragma mark - Public

- (void)updateHomepageEnterRoomViewWithRoomIcon:(NSString *)roomIcon roomName:(NSString *)roomName {
    [self.roomIcon sd_setImageWithURL:[NSURL URLWithString:[NSString sy_safeString:roomIcon]] placeholderImage:nil];
    [self.roomName updateText: roomName];
}

- (void)startAnimating {
    [self.animationView startAnimating];
}

- (void)stopAnimating {
    [self.animationView stopAnimating];
}

#pragma mark - Private

- (void)initSubView {
    [self addSubview:self.backImage];
    [self.backImage addSubview:self.roomIcon];
    [self.backImage addSubview:self.roomMask];
    [self.roomMask addSubview:self.animationView];
    [self.backImage addSubview:self.tipLabel];
    [self.backImage addSubview:self.roomName];
    [self.backImage addSubview:self.enterIcon];
}

- (void)mas_makeConstraintsWithSubviews {
    [self.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.roomIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(26, 26));
        make.left.equalTo(self.backImage).with.offset(5);
        make.centerY.equalTo(self.backImage);
    }];
    [self.roomMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(26, 26));
        make.left.equalTo(self.backImage).with.offset(5);
        make.centerY.equalTo(self.backImage);
    }];
    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 12));
        make.center.equalTo(self.roomMask);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(62, 11));
        make.left.equalTo(self.roomIcon.mas_right).with.offset(5);
        make.top.equalTo(self.backImage).with.offset(6);
    }];
    [self.enterIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.right.equalTo(self.backImage).with.offset(-5);
        make.centerY.equalTo(self.backImage);
    }];
    [self.roomName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.roomIcon.mas_right).with.offset(5);
        make.top.equalTo(self.tipLabel.mas_bottom);
        make.right.equalTo(self.enterIcon.mas_left);
        make.height.mas_equalTo(14);
    }];
}

#pragma mark - Lazyload

- (UIImageView *)backImage {
    if (!_backImage) {
        _backImage = [UIImageView new];
        _backImage.image = [UIImage imageNamed_sy:@"homepage_enter_room"];
        _backImage.backgroundColor = [UIColor redColor];
        _backImage.clipsToBounds = YES;
        _backImage.layer.cornerRadius = 18;
    }
    return _backImage;
}

- (UIImageView *)roomIcon {
    if (!_roomIcon) {
        _roomIcon = [UIImageView new];
        _roomIcon.clipsToBounds = YES;
        _roomIcon.layer.cornerRadius = 13;
        _roomIcon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _roomIcon;
}

- (UIView *)roomMask {
    if (!_roomMask) {
        _roomMask = [UIView new];
        _roomMask.backgroundColor = RGBACOLOR(0, 0, 0, 0.35);
        _roomMask.clipsToBounds = YES;
        _roomMask.layer.cornerRadius = 13;
    }
    return _roomMask;
}

- (UIImageView *)animationView {
    if (!_animationView) {
        _animationView = [UIImageView new];
        NSArray *animatedArr = @[[UIImage imageNamed_sy:@"homepage_animate_1"],
                                 [UIImage imageNamed_sy:@"homepage_animate_2"],
                                 [UIImage imageNamed_sy:@"homepage_animate_3"]];
        _animationView.animationImages = animatedArr;
        _animationView.animationDuration = 0.5;
        [_animationView startAnimating];
    }
    return _animationView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:8];
        _tipLabel.textColor = RGBACOLOR(255,255,255,0.85);
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.text = @"当前正在[直播]：";
    }
    return _tipLabel;
}

- (SYPersonHomepageMarqueeView *)roomName {
    if (!_roomName) {
        CGRect frame = CGRectMake(0, 0, 77, 14);
        _roomName = [[SYPersonHomepageMarqueeView alloc] initWithFrame:frame];
    }
    return _roomName;
}

- (UIImageView *)enterIcon {
    if (!_enterIcon) {
        _enterIcon = [UIImageView new];
        _enterIcon.image = [UIImage imageNamed_sy:@"homepage_voice_arrow"];
    }
    return _enterIcon;
}
@end
