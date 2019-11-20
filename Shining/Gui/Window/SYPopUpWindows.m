//
//  SYPopUpWindows.m
//  Shining
//
//  Created by 杨玄 on 2019/3/28.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYPopUpWindows.h"

@interface SYPopUpWindows ()
@property (nonatomic, strong) UIButton *bottomBack;         // 底部白色框
@property (nonatomic, strong) UILabel *mainTitle;           // 主标题
@property (nonatomic, strong) UILabel *subTitle;            // 副标题
@property (nonatomic, strong) UIView *horizonLine;          // 水平分割线
@property (nonatomic, strong) UIView *verticalLine;         // 垂直分割线
@property (nonatomic, strong) UIButton *leftBtn;            // 左边按钮
@property (nonatomic, strong) UIButton *rightBtn;           // 右边按钮
@property (nonatomic, strong) UIButton *midleBtn;           // 中间按钮
@property (nonatomic, strong) UILabel *contentText;         // 中间内容
@property (nonatomic, strong) UIImageView *contentLogo;     // 中间内容logo
@property (nonatomic, strong) UILabel *bottomText;          // 底部内容
@property (nonatomic, strong) UIButton *bottomRightBtn;     // 底部右侧按钮

@property (nonatomic, assign) BOOL enableClickArroundArea;  // 允许点击弹窗周围区域隐藏弹窗

@end


@implementation SYPopUpWindows

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.75);
        [self addSubview:self.bottomBack];
        [self.bottomBack addSubview:self.mainTitle];
        [self.bottomBack addSubview:self.subTitle];
        [self.bottomBack addSubview:self.horizonLine];
        [self.bottomBack addSubview:self.leftBtn];
        [self.bottomBack addSubview:self.verticalLine];
        [self.bottomBack addSubview:self.rightBtn];
        [self.bottomBack addSubview:self.midleBtn];
        [self.bottomBack addSubview:self.contentText];
        [self.bottomBack addSubview:self.contentLogo];
        [self.bottomBack addSubview:self.bottomText];
        [self.bottomBack addSubview:self.bottomRightBtn];
        self.enableClickArroundArea = YES;
    }
    return self;
}

#pragma mark - Public

- (void)updatePopUpWindowsWithType:(SYPopUpWindowsType)type withMainTitle:(NSString *)mainTitle withSubTitle:(NSString *)subTitle withBtnTexts:(NSArray *)btnTexts withBtnTextColors:(NSArray *)colors{
    [self layoutPopUpWindowsSubViews:type];
    self.mainTitle.text = mainTitle;
    self.subTitle.text = subTitle;
    NSString *midTitle = [NSString sy_safeString:[btnTexts objectAtIndex:0]];
    NSString *leftTitle = [NSString sy_safeString:[btnTexts objectAtIndex:0]];
    NSString *rightTitle = [NSString sy_safeString:[btnTexts objectAtIndex:1]];
    UIColor *midColor = [colors objectAtIndex:0];
    if (midColor) {
        [self.midleBtn setTitleColor:midColor forState:UIControlStateNormal];
    }
    UIColor *leftColor = [colors objectAtIndex:0];
    UIColor *rightColor = [colors objectAtIndex:1];
    if (leftColor) {
        [self.leftBtn setTitleColor:leftColor forState:UIControlStateNormal];
    }
    if (rightColor) {
        [self.rightBtn setTitleColor:rightColor forState:UIControlStateNormal];
    }
    if (type == SYPopUpWindowsType_Single) {
        [self.midleBtn setTitle:midTitle forState:UIControlStateNormal];
    } else if (type == SYPopUpWindowsType_Pair) {
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    }
    if ([NSString sy_isBlankString:subTitle]) {
        self.subTitle.hidden = YES;
        [self.mainTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomBack).with.offset(16);
            make.top.equalTo(self.bottomBack);
            make.right.equalTo(self.bottomBack).with.offset(-16);
            make.bottom.equalTo(self.horizonLine.mas_top);
        }];
        self.mainTitle.numberOfLines = 0;
    }
}

- (void)updatePopUpWindowswithMainTitle:(NSString *)mainTitle withSubTitle:(NSString *)subTitle withContentText:(NSString *)contentText withContentLogo:(NSString *)imgName withBottomText:(NSString *)bottomText withBtnTexts:(NSArray *)btnTexts withBtnTextColors:(NSArray *)colors {
    [self layoutPopUpWindowsSubViewsLetvLogin];
    self.mainTitle.text = mainTitle;
    self.subTitle.text = subTitle;
    self.contentText.text = contentText;
    [self.contentLogo sd_setImageWithURL:[NSURL URLWithString:imgName] placeholderImage:[UIImage imageNamed_sy:@"letv_chatHome_user"]];

    NSMutableAttributedString *idTextAttrStr = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString * attrIdStr = [[NSMutableAttributedString alloc] initWithString:bottomText];
    NSRange idRange = NSMakeRange(0, attrIdStr.length);
    // 设置字体大小
    [attrIdStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Regular" size:11] range:idRange];

    NSRange firstRange = [bottomText rangeOfString:@"登录即同意"];
    // 设置颜色
    [attrIdStr addAttribute:NSForegroundColorAttributeName value:[UIColor sy_colorWithHexString:@"#888888"] range:firstRange];

    [attrIdStr addAttribute:NSForegroundColorAttributeName value:[UIColor sy_colorWithHexString:@"#6233CC"] range:NSMakeRange(firstRange.length, idRange.length - firstRange.length)];
    [idTextAttrStr appendAttributedString:attrIdStr];
    self.bottomText.attributedText = idTextAttrStr;
    NSString *midTitle = [NSString sy_safeString:[btnTexts objectAtIndex:0]];
    NSString *bottomRightTitle = [NSString sy_safeString:[btnTexts objectAtIndex:1]];
    UIColor *middleColor = [colors objectAtIndex:0];
    UIColor *bottomRightColor = [colors objectAtIndex:1];
    if (midTitle) {
        [self.midleBtn setTitle:midTitle forState:UIControlStateNormal];
    }
    if (bottomRightTitle) {
        [self.bottomRightBtn setTitle:bottomRightTitle forState:UIControlStateNormal];
    }
    if (middleColor) {
        [self.midleBtn setTitleColor:middleColor forState:UIControlStateNormal];
    }
    if (bottomRightColor) {
        [self.bottomRightBtn setTitleColor:bottomRightColor forState:UIControlStateNormal];
    }
}


- (void)layoutPopUpWindowsSubViewsLetvLogin {
    [self.bottomBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(287, 259));
        make.center.equalTo(self);
    }];

    self.mainTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    self.mainTitle.textColor = [UIColor sy_colorWithHexString:@"#0B0B0B"];

    [self.mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomBack);
        make.size.mas_equalTo(CGSizeMake(238, 18));
        make.top.equalTo(self.bottomBack).with.offset(32);
    }];
    self.subTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    self.subTitle.textColor = [UIColor sy_colorWithHexString:@"#0B0B0B"];
    [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomBack);
        make.size.mas_equalTo(CGSizeMake(238, 18));
        make.top.equalTo(self.mainTitle.mas_bottom).with.offset(2);
    }];
    [self.contentLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomBack).with.offset(66);
        make.top.mas_equalTo(self.subTitle.mas_bottom).with.offset(12);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(32);
    }];
    self.contentLogo.layer.cornerRadius = 32/2;
    self.contentLogo.layer.masksToBounds = YES;

    [self.contentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentLogo.mas_right).with.offset(10);
        make.top.mas_equalTo(self.subTitle.mas_bottom).with.offset(12);
        make.size.mas_equalTo(CGSizeMake(100, 32));
    }];

    [self.midleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomBack);
        make.top.mas_equalTo(self.contentText.mas_bottom).with.offset(12);
        make.size.mas_equalTo(CGSizeMake(207, 34));
    }];
    self.midleBtn.backgroundColor = [UIColor sy_colorWithHexString:@"#7B40FF"];
    self.midleBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    self.midleBtn.layer.cornerRadius = 16.5;
    self.midleBtn.layer.borderWidth = 0.5;
    self.midleBtn.layer.borderColor = [UIColor blackColor].CGColor;

    [self.bottomText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomBack);
        make.top.mas_equalTo(self.midleBtn.mas_bottom).with.offset(6);
        make.size.mas_equalTo(CGSizeMake(200, 16));
    }];

    [self.bottomRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomBack);
        make.bottom.equalTo(self.bottomBack).with.offset(-30);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
}


- (void)layoutPopUpWindowsSubViews:(SYPopUpWindowsType)type {
    if (type == SYPopUpWindowsType_Single) {
        self.mainTitle.numberOfLines = 0;
        [self.bottomBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(270, 128));
            make.center.equalTo(self);
        }];
        [self.mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomBack).with.offset(16);
            make.top.equalTo(self.bottomBack);
            make.right.equalTo(self.bottomBack).with.offset(-16);
            make.height.mas_equalTo(78);
        }];
        [self.horizonLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomBack);
            make.right.equalTo(self.bottomBack);
            make.bottom.equalTo(self.bottomBack).with.offset(-49.5);
            make.height.mas_equalTo(0.5);
        }];
        [self.midleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomBack);
            make.right.equalTo(self.bottomBack);
            make.bottom.equalTo(self.bottomBack);
            make.height.mas_equalTo(49.5);
        }];
    } else if (type == SYPopUpWindowsType_Pair) {
        self.mainTitle.numberOfLines = 1;
        [self.bottomBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(270, 146));
            make.center.equalTo(self);
        }];
        [self.mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bottomBack);
            make.size.mas_equalTo(CGSizeMake(238, 18));
            make.top.equalTo(self.bottomBack).with.offset(30);
        }];
        [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bottomBack);
            make.size.mas_equalTo(CGSizeMake(238, 18));
            make.top.equalTo(self.mainTitle.mas_bottom);
        }];
        [self.horizonLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomBack);
            make.right.equalTo(self.bottomBack);
            make.bottom.equalTo(self.bottomBack).with.offset(-49.5);
            make.height.mas_equalTo(0.5);
        }];
        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomBack);
            make.bottom.equalTo(self.bottomBack);
            make.size.mas_equalTo(CGSizeMake(270/2, 49.5));
        }];
        [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bottomBack);
            make.top.equalTo(self.horizonLine.mas_bottom).with.offset(13);
            make.size.mas_equalTo(CGSizeMake(0.5, 25));
        }];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bottomBack);
            make.bottom.equalTo(self.bottomBack);
            make.size.mas_equalTo(CGSizeMake(270/2, 49.5));
        }];
    }
}

- (void)forbidClickWindowAroundArea {
    self.enableClickArroundArea = NO;
}

#pragma mark - 点击弹窗空白处

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.enableClickArroundArea) {
        return;
    }
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(handlePopUpWindowsCancel)]) {
        [self.delegate handlePopUpWindowsCancel];
    }
}

#pragma mark - LazyLoad

- (UIButton *)bottomBack {
    if (!_bottomBack) {
        _bottomBack = [UIButton new];
        _bottomBack.backgroundColor = [UIColor whiteColor];
        _bottomBack.clipsToBounds = YES;
        _bottomBack.layer.cornerRadius = 5;
    }
    return _bottomBack;
}

- (UILabel *)mainTitle {
    if (!_mainTitle) {
        _mainTitle = [UILabel new];
        _mainTitle.textColor = RGBACOLOR(68, 68, 68, 1);
        _mainTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _mainTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _mainTitle;
}

- (UILabel *)subTitle {
    if (!_subTitle) {
        _subTitle = [UILabel new];
        _subTitle.textColor = RGBACOLOR(153, 153, 153, 1);
        _subTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _subTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitle;
}


- (UILabel *)contentText {
    if (!_contentText) {
        _contentText = [UILabel new];
        _contentText.textColor = [UIColor sy_colorWithHexString:@"#888888"];
        _contentText.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _contentText.textAlignment = NSTextAlignmentLeft;
    }
    return _contentText;
}


- (UILabel *)bottomText {
    if (!_bottomText) {
        _bottomText = [UILabel new];
        _bottomText.textColor = [UIColor sy_colorWithHexString:@"#888888"];
        _bottomText.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _bottomText.textAlignment = NSTextAlignmentCenter;
        _bottomText.userInteractionEnabled = YES;
        UITapGestureRecognizer *r5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleClickbottomText)];
        r5.numberOfTapsRequired = 1;
        [_bottomText addGestureRecognizer:r5];
    }
    return _bottomText;
}

- (UIView *)horizonLine {
    if (!_horizonLine) {
        _horizonLine = [UIView new];
        _horizonLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.08);
    }
    return _horizonLine;
}

- (UIView *)verticalLine {
    if (!_verticalLine) {
        _verticalLine = [UIView new];
        _verticalLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.08);
    }
    return _verticalLine;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton new];
        _leftBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [_leftBtn addTarget:self action:@selector(handleClickLeftBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton new];
        _rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [_rightBtn addTarget:self action:@selector(handleClickRightBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UIButton *)midleBtn {
    if (!_midleBtn) {
        _midleBtn = [UIButton new];
        _midleBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [_midleBtn addTarget:self action:@selector(handleClickMidBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _midleBtn;
}

- (UIButton *)bottomRightBtn {
    if (!_bottomRightBtn) {
        _bottomRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomRightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _bottomRightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_bottomRightBtn addTarget:self action:@selector(handleClickBottomRightBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomRightBtn;
}

- (UIImageView *) contentLogo{
    if (!_contentLogo) {
        _contentLogo = [UIImageView new];
        _contentLogo.backgroundColor = [UIColor clearColor];
    }
    return _contentLogo;
}


#pragma mark - ClickBtn

// 中间按钮点击
- (void)handleClickMidBtnEvent {
    if (self.delegate && [self.delegate respondsToSelector:@selector(handlePopUpWindowsMidBtnClickEvent)]) {
        [self.delegate handlePopUpWindowsMidBtnClickEvent];
    }
}

// 左边按钮点击
- (void)handleClickLeftBtnEvent {
    if (self.delegate && [self.delegate respondsToSelector:@selector(handlePopUpWindowsLeftBtnClickEvent)]) {
        [self.delegate handlePopUpWindowsLeftBtnClickEvent];
    }
}

// 右边按钮点击
- (void)handleClickRightBtnEvent {
    if (self.delegate && [self.delegate respondsToSelector:@selector(handlePopUpWindowsRightBtnClickEvent)]) {
        [self.delegate handlePopUpWindowsRightBtnClickEvent];
    }
}
// 底部右侧按钮点击
- (void)handleClickBottomRightBtnEvent {
    if (self.delegate && [self.delegate respondsToSelector:@selector(handlePopUpWindowsBottomRightBtnClickEvent)]) {
        [self.delegate handlePopUpWindowsBottomRightBtnClickEvent];
    }
}

//底部文本协议点击事件
- (void)handleClickbottomText {
    if (self.delegate && [self.delegate respondsToSelector:@selector(handlePopUpWindowsBottomTextClickEvent)]) {
        [self.delegate handlePopUpWindowsBottomTextClickEvent];
    }
}


@end
