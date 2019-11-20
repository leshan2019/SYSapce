//
//  SYPersonHomepageInfoView.m
//  Shining
//
//  Created by 杨玄 on 2019/4/25.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepageInfoView.h"

@interface SYPersonHomepageInfoView ()

@property (nonatomic, strong) UILabel *accountLabel;            // “账号信息”
@property (nonatomic, strong) UILabel *idLabel;                 // “Bee语音ID: 123132”
@property (nonatomic, strong) UILabel *personLabel;             // “个人信息”
@property (nonatomic, strong) UILabel *coordinateLabel;         // “坐标”
@property (nonatomic, strong) UILabel *constellationLabel;      // “星座”

@end

@implementation SYPersonHomepageInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(247,247,247,1);
        [self addSubview:self.accountLabel];
        [self addSubview:self.idLabel];
        [self addSubview:self.personLabel];
        [self addSubview:self.constellationLabel];
        [self addSubview:self.coordinateLabel];

        [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(20);
            make.top.equalTo(self).with.offset(16);
            make.size.mas_equalTo(CGSizeMake(48, 17));
        }];

        [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(20);
            make.top.equalTo(self.accountLabel.mas_bottom).with.offset(5);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(20);
        }];

        [self.personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(20);
            make.top.equalTo(self.idLabel.mas_bottom).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(48, 17));
        }];
        
        [self.constellationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(20);
            make.top.equalTo(self.personLabel.mas_bottom).with.offset(5);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(20);
        }];

        [self.coordinateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(20);
            make.top.equalTo(self.constellationLabel.mas_bottom).with.offset(5);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(20);
        }];
        
    }
    return self;
}

#pragma mark - Public

- (void)updateHomepageInfoViewWithId:(NSString *)idStr coordinate:(NSString *)coordinate constellation:(NSString *)constellation {
    self.idLabel.text = [NSString stringWithFormat:@"Bee语音ID：%@",idStr];
    self.coordinateLabel.text = [NSString stringWithFormat:@"坐标：%@",coordinate];
    self.constellationLabel.text = [NSString stringWithFormat:@"星座：%@",constellation];
}

#pragma mark - Lazyload

- (UILabel *)accountLabel {
    if (!_accountLabel) {
        _accountLabel = [UILabel new];
        _accountLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _accountLabel.textColor = RGBACOLOR(48,48,48,1);
        _accountLabel.textAlignment = NSTextAlignmentLeft;
        _accountLabel.text = @"账号信息";
    }
    return _accountLabel;
}

- (UILabel *)idLabel {
    if (!_idLabel) {
        _idLabel = [UILabel new];
        _idLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _idLabel.textColor = RGBACOLOR(96,96,96,1);
        _idLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _idLabel;
}

- (UILabel *)personLabel {
    if (!_personLabel) {
        _personLabel = [UILabel new];
        _personLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _personLabel.textColor = RGBACOLOR(48,48,48,1);
        _personLabel.textAlignment = NSTextAlignmentLeft;
        _personLabel.text = @"个人信息";
    }
    return _personLabel;
}

- (UILabel *)coordinateLabel {
    if (!_coordinateLabel) {
        _coordinateLabel = [UILabel new];
        _coordinateLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _coordinateLabel.textColor = RGBACOLOR(96,96,96,1);
        _coordinateLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _coordinateLabel;
}

- (UILabel *)constellationLabel {
    if (!_constellationLabel) {
        _constellationLabel = [UILabel new];
        _constellationLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _constellationLabel.textColor = RGBACOLOR(96,96,96,1);
        _constellationLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _constellationLabel;
}

@end
