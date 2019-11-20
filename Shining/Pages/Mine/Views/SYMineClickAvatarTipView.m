//
//  SYMineClickAvatarTipView.m
//  Shining
//
//  Created by yangxuan on 2019/10/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYMineClickAvatarTipView.h"

@interface SYMineClickAvatarTipView ()

@property (nonatomic, strong) UIImageView *clickTipImage;   // “点击头像可进入个人主页哦”

@end

@implementation SYMineClickAvatarTipView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.clickTipImage];
        CGFloat headerHeight = (iPhoneX ? 180+24 : 180);
        [self.clickTipImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(20);
            make.top.equalTo(self).with.offset(headerHeight - 48 - 2);
            make.size.mas_equalTo(CGSizeMake(166, 38));
        }];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [SYSettingManager setHasShowClickAvatarTip:YES];
    [self removeFromSuperview];
}

- (UIImageView *)clickTipImage {
    if (!_clickTipImage) {
        _clickTipImage = [UIImageView new];
        _clickTipImage.image = [UIImage imageNamed_sy:@"mine_enter_homepage_tip"];
    }
    return _clickTipImage;
}

@end
