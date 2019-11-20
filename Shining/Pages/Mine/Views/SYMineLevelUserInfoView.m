//
//  SYMineLevelUserInfoView.m
//  Shining
//
//  Created by 杨玄 on 2019/6/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYMineLevelUserInfoView.h"
#import "SYVIPLevelView.h"


@interface SYMineLevelUserInfoView ()

@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) UIView *avatarBackImage;
@property (nonatomic, strong) UIImageView *avatarIcon;          // userIcon
@property (nonatomic, strong) UILabel *nameLabel;               // userName
@property (nonatomic, strong) SYVIPLevelView *levelView;        // 等级
@property (nonatomic, strong) UIView *levelTotalProgress;       // 总等级
@property (nonatomic, strong) UIView *levelCurrentProgress;     // 当前等级进度
@property (nonatomic, strong) UILabel *currentLevelLabel;       // 当前等级
@property (nonatomic, strong) UILabel *nextLevelLabel;          // 下一等级
@property (nonatomic, strong) UILabel *consumeLabel;            // 消费+升级

@end

@implementation SYMineLevelUserInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self initSubviews];
    [self mas_makeConstraintsWithSubviews];
    return self;
}

#pragma mark - Public

- (void)updateUserInfoWithName:(NSString *)name avatarUrl:(NSString *)avatarUrl currentLevel:(NSInteger)level nextLevel:(NSInteger)nextLevel consumeHoney:(NSInteger)consumeHoney currentLevelMinCoin:(NSInteger)minCoin currentLevelMaxCoin:(NSInteger)maxCoin {
    // avatar
    [self.avatarIcon sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed_sy:@"mine_head_default"]];
    // vipLevel
    [self.levelView showWithVipLevel:level];
    CGRect levelFrame = self.levelView.frame;
    [self.levelView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(levelFrame.size.width);
    }];
    // name
    CGFloat maxNameW = 144 - levelFrame.size.width - 6;
    self.nameLabel.text = name;
    CGFloat titleWidth = [name sizeWithAttributes:@{ NSFontAttributeName : self.nameLabel.font }].width+1;
    if (titleWidth > maxNameW) {
        titleWidth = maxNameW;
    }
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleWidth);
    }];
    self.currentLevelLabel.text = [NSString stringWithFormat:@"VIP%ld",level];
    self.nextLevelLabel.text = [NSString stringWithFormat:@"VIP%ld",nextLevel];
    if (nextLevel == 0) {
        self.nextLevelLabel.text = @"已到达最高等级";
    }
    // progress
    if (consumeHoney < 0) {
        consumeHoney = 0;
    }
    if (minCoin > consumeHoney) {
        minCoin = consumeHoney;
    }
    if (maxCoin < consumeHoney) {
        maxCoin = consumeHoney;
    }
    CGFloat currentLevelSurpass = consumeHoney - minCoin; // 当前消耗的和当前等级最低消耗金币差值
    CGFloat currentLevelTotal = maxCoin - minCoin + 1;    // 一共需要消耗多少才能到下一级
    CGFloat percent = currentLevelSurpass / currentLevelTotal;
    if (percent < 0 ) {
        percent = 0;
    }
    if (percent > 1) {
        percent = 1;
    }
    [self.levelCurrentProgress mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo( percent * 144 );
    }];
    // honey
    NSInteger upgradeHoney = maxCoin - consumeHoney + 1;         // 升级需要的蜜豆
    if (upgradeHoney < 0) {
        upgradeHoney = 0;
    }
    NSString *consumeStr = [NSString stringWithFormat:@"已消费:%ld蜜豆  距升级:%ld蜜豆",consumeHoney,upgradeHoney];
    CGFloat consumeMaxW = 304 - 6*2;
    titleWidth = [consumeStr sizeWithAttributes:@{ NSFontAttributeName : self.consumeLabel.font }].width + 1;
    if (titleWidth > consumeMaxW) {
        titleWidth = consumeMaxW;
    }
    [self.consumeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleWidth);
    }];
    self.consumeLabel.text = consumeStr;
}

#pragma mark - Private

- (void)initSubviews {
    [self addSubview:self.backImage];
    [self.backImage addSubview:self.avatarBackImage];
    [self.avatarBackImage addSubview:self.avatarIcon];
    [self.avatarBackImage addSubview:self.nameLabel];
    [self.avatarBackImage addSubview:self.levelView];
    [self.avatarBackImage addSubview:self.levelTotalProgress];
    [self.avatarBackImage addSubview:self.levelCurrentProgress];
    [self.avatarBackImage addSubview:self.currentLevelLabel];
    [self.avatarBackImage addSubview:self.nextLevelLabel];
    [self.backImage addSubview:self.consumeLabel];
}

- (void)mas_makeConstraintsWithSubviews {
    [self.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.avatarBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(259, 62));
        make.top.equalTo(self.backImage).with.offset(30);
        make.centerX.equalTo(self.backImage);
    }];
    [self.avatarIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(54, 54));
        make.left.equalTo(self.avatarBackImage.mas_left).with.offset(4);
        make.centerY.equalTo(self.avatarBackImage);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarIcon.mas_right).with.offset(9);
        make.top.equalTo(self.avatarBackImage).with.offset(10);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(0);
    }];
    [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).with.offset(6);
        make.centerY.equalTo(self.nameLabel);
        make.size.mas_equalTo(CGSizeMake(34, 14));
    }];
    [self.levelTotalProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarIcon.mas_right).with.offset(9);
        make.centerY.equalTo(self.avatarIcon);
        make.size.mas_equalTo(CGSizeMake(144, 4));
    }];
    [self.levelCurrentProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarIcon.mas_right).with.offset(9);
        make.centerY.equalTo(self.avatarIcon);
        make.size.mas_equalTo(CGSizeMake(0, 4));
    }];
    [self.currentLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarIcon.mas_right).with.offset(9);
        make.top.equalTo(self.levelTotalProgress.mas_bottom).with.offset(3);
        make.size.mas_equalTo(CGSizeMake(72, 14));
    }];
    [self.nextLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.levelTotalProgress.mas_right);
        make.top.equalTo(self.levelTotalProgress.mas_bottom).with.offset(3);
        make.size.mas_equalTo(CGSizeMake(72, 14));
    }];
    [self.consumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarBackImage.mas_bottom).with.offset(14);
        make.centerX.equalTo(self.backImage);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(17);
    }];
}

#pragma mark - Lazyload

- (UIImageView *)backImage {
    if (!_backImage) {
        _backImage = [UIImageView new];
        _backImage.image = [UIImage imageNamed_sy:@"mine_level_avatar_bag"];
        _backImage.clipsToBounds = YES;
    }
    return _backImage;
}

- (UIView *)avatarBackImage {
    if (!_avatarBackImage) {
        _avatarBackImage = [UIView new];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, 259, 62);
        gradientLayer.colors = @[(id)RGBACOLOR(255,255,255,1).CGColor, (id)RGBACOLOR(255,255,255,0.55).CGColor, (id)RGBACOLOR(255,255,255,0).CGColor];
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1, 0.5);
        gradientLayer.cornerRadius = 31;
        [_avatarBackImage.layer addSublayer:gradientLayer];
    }
    return _avatarBackImage;
}

- (UIImageView *)avatarIcon {
    if (!_avatarIcon) {
        _avatarIcon = [UIImageView new];
        _avatarIcon.clipsToBounds = YES;
        _avatarIcon.layer.cornerRadius = 27;
        _avatarIcon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatarIcon;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _nameLabel.textColor = RGBACOLOR(103,71,29,1);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (SYVIPLevelView *)levelView {
    if (!_levelView) {
        _levelView = [[SYVIPLevelView alloc] initWithFrame:CGRectZero];
    }
    return _levelView;
}

- (UIView *)levelTotalProgress {
    if (!_levelTotalProgress) {
        _levelTotalProgress = [UIView new];
        _levelTotalProgress.backgroundColor = RGBACOLOR(68,68,68,1);
        _levelTotalProgress.clipsToBounds = YES;
        _levelTotalProgress.layer.cornerRadius = 2;
    }
    return _levelTotalProgress;
}

- (UIView *)levelCurrentProgress {
    if (!_levelCurrentProgress) {
        _levelCurrentProgress = [UIView new];
        _levelCurrentProgress.backgroundColor = RGBACOLOR(208,153,73,1);
        _levelCurrentProgress.clipsToBounds = YES;
        _levelCurrentProgress.layer.cornerRadius = 2;
    }
    return _levelCurrentProgress;
}

- (UILabel *)currentLevelLabel {
    if (!_currentLevelLabel) {
        _currentLevelLabel = [UILabel new];
        _currentLevelLabel.font = [UIFont systemFontOfSize:10];
        _currentLevelLabel.textColor = RGBACOLOR(103,71,29,1);
        _currentLevelLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _currentLevelLabel;
}

- (UILabel *)nextLevelLabel {
    if (!_nextLevelLabel) {
        _nextLevelLabel = [UILabel new];
        _nextLevelLabel.font = [UIFont systemFontOfSize:10];
        _nextLevelLabel.textColor = RGBACOLOR(139,87,42,1);
        _nextLevelLabel.textAlignment = NSTextAlignmentRight;
    }
    return _nextLevelLabel;
}

- (UILabel *)consumeLabel {
    if (!_consumeLabel) {
        _consumeLabel = [UILabel new];
        _consumeLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _consumeLabel.textColor = RGBACOLOR(103,71,29,1);
        _consumeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _consumeLabel;
}

@end
