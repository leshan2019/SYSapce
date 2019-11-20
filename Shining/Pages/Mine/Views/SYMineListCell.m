//
//  SYMineListCell.m
//  Shining
//
//  Created by 杨玄 on 2019/3/25.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYMineListCell.h"
#import "SYVIPLevelView.h"

@interface SYMineListCell ()

@property (nonatomic, strong) UIImageView *leftIcon;        //左侧角标
@property (nonatomic, strong) UILabel *mainTitle;           //主标题
@property (nonatomic, strong) UIImageView *rightIcon;       //右侧角标
@property (nonatomic, strong) UIView *bottomLine;           //分割线
@property (nonatomic, strong) SYVIPLevelView *levelView;    // 等级
@property (nonatomic, strong) UILabel *redLbl;              // 红点

@end

@implementation SYMineListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];

        [self.contentView addSubview:self.leftIcon];
        [self.contentView addSubview:self.mainTitle];
        [self.contentView addSubview:self.levelView];
        [self.contentView addSubview:self.rightIcon];
        [self.contentView addSubview:self.bottomLine];
        [self.contentView addSubview:self.redLbl];

        [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(24, 24));
            make.centerY.equalTo(self.contentView);
        }];

        [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-20);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];

        [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rightIcon.mas_left).with.offset(-2);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(34, 14));
        }];

        [self.mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftIcon.mas_right).with.offset(10);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.levelView.mas_left).with.offset(-10);
            make.height.mas_equalTo(15);
        }];

        [self.redLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.right.equalTo(self.rightIcon.mas_left).with.offset(-5);
            make.centerY.equalTo(self.mainTitle);
        }];
        
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

#pragma mark - Public

- (void)updateMyneListCellWithType:(SYMineListCellType)type withIcon:(NSString *)icon title:(NSString *)title userLevel:(NSInteger)level {
    self.leftIcon.image = [UIImage imageNamed_sy:icon];
    self.mainTitle.text = title;
    if (type == SYMineListCellType_MyVipLevel) {
        self.levelView.hidden = NO;
        // level
        [self.levelView showWithVipLevel:level];
        CGRect levelFrame = self.levelView.frame;
        [self.levelView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(levelFrame.size.width);
        }];
    } else {
        self.levelView.hidden = YES;
    }
}

- (void)showUnreadRedPoint:(BOOL)isShow {
    self.redLbl.hidden = !isShow;
}

#pragma mark - LazyLoad

- (UIImageView *)leftIcon {
    if (!_leftIcon) {
        _leftIcon = [UIImageView new];
    }
    return _leftIcon;
}

- (UILabel *)mainTitle {
    if (!_mainTitle) {
        _mainTitle = [UILabel new];
        _mainTitle.textColor = RGBACOLOR(11, 11, 11, 1);
        _mainTitle.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _mainTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _mainTitle;
}

- (SYVIPLevelView *)levelView {
    if (!_levelView) {
        _levelView = [[SYVIPLevelView alloc] initWithFrame:CGRectZero];
    }
    return _levelView;
}

- (UIImageView *)rightIcon {
    if (!_rightIcon) {
        _rightIcon = [UIImageView new];
        _rightIcon.image = [UIImage imageNamed_sy:@"voiceroom_right_icon"];
    }
    return _rightIcon;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.08);
    }
    return _bottomLine;
}

- (UILabel *)redLbl {
    if (!_redLbl) {
        _redLbl = [UILabel new];
        _redLbl.layer.backgroundColor = [UIColor redColor].CGColor;
        _redLbl.textColor = RGBACOLOR(11, 11, 11, 1);
        _redLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _redLbl.textAlignment = NSTextAlignmentCenter;
        _redLbl.hidden = YES;
        _redLbl.layer.cornerRadius = 10/2;
    }
    return _redLbl;
}

@end
