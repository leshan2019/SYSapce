//
//  SYVoiceRoomDanmuTypeCell.m
//  Shining
//
//  Created by 杨玄 on 2019/4/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomDanmuTypeCell.h"

@interface SYVoiceRoomDanmuTypeCell ()

@property (nonatomic, strong) UILabel *nameLabel;   // 弹幕name
@property (nonatomic, strong) UILabel *priceLabel;  // 弹幕price

@end

@implementation SYVoiceRoomDanmuTypeCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(56, 20));
            make.top.equalTo(self.contentView).with.offset(5);
        }];
        [self.contentView addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.nameLabel.mas_bottom).with.offset(2);
            make.height.mas_equalTo(13);
        }];
    }
    return self;
}

#pragma mark - Public

- (void)updateDanmuTypeCellWithName:(NSString *)name withPrice:(NSInteger)price {
    self.nameLabel.text = name;
    self.priceLabel.text = [NSString stringWithFormat:@"%ld个蜜豆/条",price];
}

- (void)updateDanmuTypeCellSelectState:(BOOL)selected withVipDanmu:(BOOL)vip canBeSend:(BOOL)canBeSend vipLevel:(NSInteger)vipLevel {
    if (!vip || (vip && canBeSend)) {
        if (selected) {
            self.nameLabel.backgroundColor = RGBACOLOR(123,64,255,1);
            self.nameLabel.textColor = [UIColor whiteColor];
        } else {
            self.nameLabel.backgroundColor = [UIColor clearColor];
            self.nameLabel.textColor = RGBACOLOR(123,64,255,1);
        }
    } else {
        // Vip等级不够，价格展示为@“VIP12开启” - 2019/5/14 - 产品定的
        self.nameLabel.layer.borderColor = RGBACOLOR(186,192,197,1).CGColor;
        self.nameLabel.backgroundColor = RGBACOLOR(186,192,197,1);
        self.nameLabel.textColor = [UIColor whiteColor];
        self.priceLabel.text = [NSString stringWithFormat:@"VIP%ld开启", (long)vipLevel];
    }
}

#pragma mark - LazyLoad

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.clipsToBounds = YES;
        _nameLabel.layer.cornerRadius = 10;
        _nameLabel.layer.borderWidth = 1;
        _nameLabel.layer.borderColor = RGBACOLOR(123,64,255,1).CGColor;
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.textColor = RGBACOLOR(68, 68, 68, 1);
        _priceLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:9];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLabel;
}
@end
