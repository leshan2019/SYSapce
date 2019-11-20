//
//  SYPersonHomepageFansView.m
//  Shining
//
//  Created by 杨玄 on 2019/4/25.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepageFansView.h"
#import "SYVoiceRoomUserModel.h"

#define kSYVoiceRoomBoardImageViewTag 30302

@interface SYPersonHomepageFansView ()

// ui
@property (nonatomic, strong) UILabel *titleLabel;          // @"粉丝贡献"
@property (nonatomic, strong) UIButton *arrowBtn;           // @">"
@property (nonatomic, strong) UIView *bottomLine;           // line2
@property (nonatomic, strong) UIView *contentView;          // 放人物头像的contentView

// data
@property (nonatomic, strong) NSArray *fansArr;             // 粉丝数据

@property (nonatomic, copy) TapFansBlock tapFans;           // 点击粉丝
@property (nonatomic, copy) TapArrowBlock tapArrow;         // 点击arrow

@end

@implementation SYPersonHomepageFansView

- (instancetype)initFansContributionView:(CGRect)frame tapFans:(TapFansBlock)tapFans tapArrow:(TapArrowBlock)tapArrow {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        self.tapFans = tapFans;
        self.tapArrow = tapArrow;
    }
    return self;
}

- (void)updateFansView:(NSArray *)fansData {
    self.fansArr = fansData;
}

#pragma mark - Set

- (void)setFansArr:(NSArray *)fansArr {
    [self removeAllFansIcon];
    _fansArr = fansArr;
    if (fansArr) {
        NSInteger count = fansArr.count;
        NSArray *boxArr = @[@"voiceroom_crown_gold_s",@"voiceroom_crown_silver_s",@"voiceroom_crown_bronze_s"];
        for (int i = 0; i < count; i++) {
            UIImageView *boxImage = [UIImageView new];
            boxImage.image = [UIImage imageNamed_sy:[boxArr objectAtIndex:i]];
            boxImage.userInteractionEnabled = YES;
            boxImage.tag = kSYVoiceRoomBoardImageViewTag + i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tap:)];
            [boxImage addGestureRecognizer:tap];
            [self.contentView addSubview:boxImage];
            [boxImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(28, 32));
                make.bottom.equalTo(self.contentView).with.offset(-8);
                make.right.equalTo(self.contentView).with.offset(-(47+(count - 1 - i)*28));
            }];
            UIImageView *avatarView = [UIImageView new];
            avatarView.layer.cornerRadius = 12.f;
            avatarView.clipsToBounds = YES;
            SYVoiceRoomUserModel *model = [self userModelAtIndex:i];
            [avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatar]
                          placeholderImage:[UIImage imageNamed_sy:@"voiceroom_placeholder"]];
            [boxImage addSubview:avatarView];
            [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(24, 24));
                make.bottom.equalTo(self.contentView).with.offset(-9);
                make.right.equalTo(boxImage).with.offset(-1);
            }];
        }
    }
}

- (void)tap:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIView *view = [tap view];
    NSInteger index = view.tag - kSYVoiceRoomBoardImageViewTag;
    SYVoiceRoomUserModel *model = [self userModelAtIndex:index];
    NSString *uid = model.id;
    if (self.tapFans) {
        self.tapFans(uid);
    }
}

- (SYVoiceRoomUserModel *)userModelAtIndex:(NSInteger)index {
    if (index >= 0 && index < [self.fansArr count]) {
        SYVoiceRoomUserModel *user = self.fansArr[index];
        return user;
    }
    return nil;
}

#pragma mark - Private

- (void)initSubviews {
    self.backgroundColor = RGBACOLOR(247,247,247,1);
    [self addSubview:self.contentView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.arrowBtn];
    [self addSubview:self.bottomLine];
    [self mas_makeConstraints];
}

- (void)mas_makeConstraints {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.top.equalTo(self).with.offset(11);
        make.size.mas_equalTo(CGSizeMake(64, 22));
    }];
    
    [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-15);
        make.top.equalTo(self).with.offset(12);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];

    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

- (void)removeAllFansIcon {
    NSArray *subViews = [self.contentView subviews];
    if (subViews.count > 0) {
        UIView *subView = nil;
        for (int i = 0; i < subViews.count ; i++) {
            subView = [subViews objectAtIndex:i];
            [subView removeFromSuperview];
        }
    }
}

- (void)handleArrowBtnClickEvent {
    if (self.tapArrow) {
        self.tapArrow();
    }
}

#pragma mark - Lazyload

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        _titleLabel.textColor = RGBACOLOR(48,48,48,1);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"粉丝贡献";
    }
    return _titleLabel;
}

- (UIButton *)arrowBtn {
    if (!_arrowBtn) {
        _arrowBtn = [UIButton new];
        [_arrowBtn setImage:[UIImage imageNamed_sy:@"homepage_fans_arrow"] forState:UIControlStateNormal];
        [_arrowBtn addTarget:self action:@selector(handleArrowBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arrowBtn;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = RGBACOLOR(238,238,238,1);
    }
    return _bottomLine;
}

@end
