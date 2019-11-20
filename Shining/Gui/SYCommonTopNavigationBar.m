//
//  SYVoiceChatRoomCommonNavBar.m
//  Shining
//
//  Created by 杨玄 on 2019/3/13.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYCommonTopNavigationBar.h"
//#import <Masonry.h>

@interface SYCommonTopNavigationBar ()

@property (nonatomic, strong) UIButton *goBackBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *rightTitleBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation SYCommonTopNavigationBar

- (instancetype)initWithFrame:(CGRect)frame midTitle:(NSString *)title rightTitle:(NSString *)rightTitle hasAddBtn:(BOOL)hasAdd {
    self = [super initWithFrame: frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(245, 246, 247, 0.82);
        [self addSubview:self.goBackBtn];
        [self addSubview:self.titleLabel];
        [self addSubview:self.rightTitleBtn];
        [self addSubview:self.addBtn];
        [self addSubview:self.bottomLine];
        [self.goBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.bottom.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(36, 44));
        }];
        NSInteger titleWidth = [title sizeWithAttributes:@{ NSFontAttributeName :  [UIFont fontWithName:@"PingFang-SC-Regular" size:17] }].width;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).with.offset(-11);
            make.width.mas_equalTo(titleWidth);
            make.height.mas_equalTo(22);
        }];
        self.titleLabel.text = title;
        [self.rightTitleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-15);
            make.bottom.equalTo(self).with.offset(-15);
            make.size.mas_equalTo(CGSizeMake(24, 14));
        }];
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(36, 44));
        }];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.bottom.equalTo(self);
            make.right.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
        [self.rightTitleBtn setTitle:[NSString sy_safeString:rightTitle] forState:UIControlStateNormal];
        self.rightTitleBtn.hidden = [NSString sy_isBlankString:rightTitle];
        self.addBtn.hidden = !hasAdd;
    }
    return self;
}

#pragma mark - Lazyload

- (UIButton *)goBackBtn {
    if (!_goBackBtn) {
        _goBackBtn = [UIButton new];
        [_goBackBtn addTarget:self action:@selector(handleGoBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_goBackBtn setImage:[UIImage imageNamed_sy:@"voiceroom_topnav_back_normale"] forState:UIControlStateNormal];
        [_goBackBtn setImage:[UIImage imageNamed_sy:@"voiceroom_topnav_back_selected"] forState:UIControlStateHighlighted];
    }
    return _goBackBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = RGBACOLOR(0, 0, 0, 1);
        _titleLabel.font =  [UIFont fontWithName:@"PingFang-SC-Regular" size:17];
    }
    return _titleLabel;
}

- (UIButton *)rightTitleBtn {
    if (!_rightTitleBtn) {
        _rightTitleBtn = [UIButton new];
        [_rightTitleBtn addTarget:self action:@selector(handleSaveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_rightTitleBtn setTitleColor:RGBACOLOR(0, 0, 0, 1) forState:UIControlStateNormal];
        _rightTitleBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    }
    return _rightTitleBtn;
}

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton new];
        [_addBtn addTarget:self action:@selector(handleAddBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_addBtn setImage:[UIImage imageNamed_sy:@"voiceroom_topnav_add"] forState:UIControlStateNormal];
    }
    return _addBtn;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.08);
    }
    return _bottomLine;
}

- (void)handleGoBackBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleGoBackBtnClick)]) {
        [self.delegate handleGoBackBtnClick];
    }
}

- (void)handleSaveBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleSaveBtnClick)]) {
        [self.delegate handleSaveBtnClick];
    }
}

- (void)handleAddBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleAddBtnClick)]) {
        [self.delegate handleAddBtnClick];
    }
}

@end
