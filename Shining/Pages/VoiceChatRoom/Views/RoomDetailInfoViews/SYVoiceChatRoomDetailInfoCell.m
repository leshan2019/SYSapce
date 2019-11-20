//
//  SYVoiceRoomDetailInfoCell.m
//  Shining
//
//  Created by 杨玄 on 2019/3/13.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYVoiceChatRoomDetailInfoCell.h"

@interface SYVoiceChatRoomDetailInfoCell ()

@property (nonatomic, strong) UILabel *mainTitle;           //主标题
@property (nonatomic, strong) UILabel *subTitle;            //副标题
@property (nonatomic, strong) UIImageView *subImage;        //副image
@property (nonatomic, strong) UIImageView *rightIcon;       //右侧角标
@property (nonatomic, strong) UIView *bottomLine;           //分割线
@property (nonatomic, strong) UISwitch *switchBtn;          // 开关按钮
@end

@implementation SYVoiceChatRoomDetailInfoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.mainTitle];
        [self.contentView addSubview:self.subTitle];
        [self.contentView addSubview:self.subImage];
        [self.contentView addSubview:self.rightIcon];
        [self.contentView addSubview:self.bottomLine];

        [self.mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(0, 15));
        }];

        [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];

        [self.subImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-28);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(32, 32));
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

- (void)updateImage:(UIImage *)image {
    self.subImage.image = image;
    self.subImage.hidden = image ? NO : YES;
}

- (void)openUISwitBtn:(BOOL)open {
    if (_switchBtn) {
        _switchBtn.on = open;
    }
}

- (void)updateCellTitle:(NSString *)title SubTitle:(NSString *)subTitle SubImage:(NSString *)imageUrl showBottomLine:(BOOL)show withSwitchBtn:(BOOL)hasSwitch subImage_16_9:(BOOL)imageIs_16_9 {
    // BottomLine
    self.bottomLine.hidden = !show;

     // SubImage
    UIImage *defaultImage;
    if (imageIs_16_9) {
        defaultImage = [UIImage imageNamed_sy:@"voiceroom_icon_default_16_9"];
        [self.subImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(57, 32));
        }];
    } else {
        defaultImage = [UIImage imageNamed_sy:@"voiceroom_icon_default"];
        [self.subImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
    }
    self.subImage.hidden = imageUrl.length <= 0;
    if (![NSString sy_isBlankString:imageUrl]) {
        NSRange httpRange = [imageUrl rangeOfString:@"http"];
        if (httpRange.location != NSNotFound) {
            [self.subImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:defaultImage];
        } else {
            self.subImage.image = [UIImage imageNamed_sy:imageUrl];
        }
    }

    // MainTitle
    CGFloat titleWidth = [title sizeWithAttributes:@{ NSFontAttributeName :  [UIFont fontWithName:@"PingFangSC-Regular" size:15] }].width;
    [self.mainTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleWidth+1);
    }];
    self.mainTitle.text = title;
    self.mainTitle.hidden = title.length <= 0;

    // SubTitle
    [self.subTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainTitle.mas_right).with.offset(2);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(16);
        if (imageUrl.length <= 0) {
            make.right.equalTo(self.rightIcon.mas_left).with.offset(-2);
        } else {
            make.right.equalTo(self.subImage.mas_left).with.offset(-2);
        }
    }];

    self.subTitle.text = subTitle;
    self.subTitle.hidden = subTitle.length <= 0;

    // UISwitchBtn
    if (hasSwitch) {
        [self.contentView addSubview:self.switchBtn];
        [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(49, 31));
            make.centerY.equalTo(self.mainTitle);
            make.right.equalTo(self.contentView).with.offset(-10);
        }];
    } else {
        if (_switchBtn) {
            [_switchBtn removeFromSuperview];
            _switchBtn = nil;
        }
    }
}

#pragma mark - BtnClickEvent

- (void)handleSwitchBtnClickEvent:(UISwitch *)switchBtn {
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(SYVoiceChatRoomDetailInfoCellOpenUISwitchBtn:)]) {
        [self.delegate SYVoiceChatRoomDetailInfoCellOpenUISwitchBtn:switchBtn.on];
    }
}

#pragma mark - LazyLoad

- (UILabel *)mainTitle {
    if (!_mainTitle) {
        _mainTitle = [UILabel new];
        _mainTitle.textColor = RGBACOLOR(11, 11, 11, 1);
        _mainTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _mainTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _mainTitle;
}

- (UILabel *)subTitle {
    if (!_subTitle) {
        _subTitle = [UILabel new];
        _subTitle.textColor = RGBACOLOR(153, 153, 153, 1);
        _subTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _subTitle.textAlignment = NSTextAlignmentRight;
    }
    return _subTitle;
}

- (UIImageView *)subImage {
    if (!_subImage) {
        _subImage = [UIImageView new];
        _subImage.clipsToBounds = YES;
        _subImage.contentMode = UIViewContentModeScaleAspectFill;
        _subImage.layer.cornerRadius = 2;
    }
    return _subImage;
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

- (UISwitch *)switchBtn {
    if (!_switchBtn) {
        _switchBtn = [[UISwitch alloc] initWithFrame:CGRectZero];
        [_switchBtn setTintColor:RGBACOLOR(223, 223, 223, 1)];
        [_switchBtn setBackgroundColor:RGBACOLOR(223, 223, 223, 1)];
        [_switchBtn setOnTintColor:RGBACOLOR(113, 56, 239, 1)];
        [_switchBtn setThumbTintColor:[UIColor whiteColor]];
        _switchBtn.clipsToBounds = YES;
        _switchBtn.layer.cornerRadius = 15.5f;
        [_switchBtn addTarget:self action:@selector(handleSwitchBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchBtn;
}

@end
