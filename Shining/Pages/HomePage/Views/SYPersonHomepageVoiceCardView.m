//
//  SYPersonHomepageVoiceCardView.m
//  Shining
//
//  Created by yangxuan on 2019/10/17.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepageVoiceCardView.h"
#import "SYPersonHomepageVoiceControl.h"

@interface SYPersonHomepageVoiceCardView ()

@property (nonatomic, strong) UILabel *titleLabel;          // "声音名片"
@property (nonatomic, strong) UIButton *recordBtn;          // 录制声音
@property (nonatomic, strong) SYPersonHomepageVoiceControl *voiceControl;
@property (nonatomic, strong) UIButton *arrowBtn;           // ">"
@property (nonatomic, strong) UIView *bottomLine;           // line2

@property (nonatomic, copy) FirstRecord recordBlock;        // 录制声音
@property (nonatomic, copy) AgainRecord tapArrowBlock;      // 再次录制

@property (nonatomic, assign) BOOL needArrow;

@end

@implementation SYPersonHomepageVoiceCardView

- (instancetype)initVoiceCardViewWithFrame:(CGRect)frame recordVoice:(FirstRecord)recordBlock tapArrowBlock:(AgainRecord)tapArrowBLock {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        self.recordBlock = recordBlock;
        self.tapArrowBlock = tapArrowBLock;
        self.needArrow = YES;
    }
    return self;
}

- (void)updateVoiceControl:(NSString *)voiceUrl voiceDuration:(NSInteger)duration {
    BOOL hasVoice = ![NSString sy_isBlankString:voiceUrl];
    self.recordBtn.hidden = hasVoice;
    self.voiceControl.hidden = !hasVoice;
    if (!self.needArrow) {
        self.arrowBtn.hidden = YES;
    } else {
        self.arrowBtn.hidden = !hasVoice;
    }
    if (hasVoice) {
        [self.voiceControl updateVoiceControl:voiceUrl voiceDuration:duration];
        [self.voiceControl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(self.needArrow ? -45 : -15);
        }];
    }
}

- (void)stopPlayVoice {
    [self.voiceControl stopPlay];
}

- (void)updateTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)hideArrowBtn {
    self.needArrow = NO;
}

- (void)showBottomLine:(BOOL)show {
    self.bottomLine.hidden = !show;
}

#pragma mark - Private

- (void)initSubViews {
    self.backgroundColor = RGBACOLOR(247,247,247,1);
    [self addSubview:self.titleLabel];
    [self addSubview:self.recordBtn];
    [self addSubview:self.voiceControl];
    [self addSubview:self.arrowBtn];
    [self addSubview:self.bottomLine];
    [self mas_makeConstraints];
}

- (void)mas_makeConstraints {

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(64, 22));
    }];
    
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(81, 30));
    }];

    [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    [self.voiceControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(78, 30));
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
}

#pragma mark - Click

// 录制声音
- (void)handleRecordBtnClickEvent {
    if (self.recordBlock) {
        self.recordBlock();
    }
}

// 再次录制icon
- (void)handleArrowBtnClickEvent {
    if (self.tapArrowBlock) {
        self.tapArrowBlock();
    }
}

- (void)handleVoiceClickEvent:(UIButton *)btn {
    [self.voiceControl clickSYPersonHomepageVoiceControl];
}

#pragma mark - Lazyload

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        _titleLabel.textColor = RGBACOLOR(48,48,48,1);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"声音名片";
    }
    return _titleLabel;
}

- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [UIButton new];
        _recordBtn.backgroundColor = RGBACOLOR(255, 255, 255, 1);
        _recordBtn.clipsToBounds = YES;
        _recordBtn.layer.cornerRadius = 15;
        _recordBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        [_recordBtn setTitle:@"录制声音" forState:UIControlStateNormal];
        [_recordBtn setTitleColor:RGBACOLOR(123,64,255,1) forState:UIControlStateNormal];
        [_recordBtn addTarget:self action:@selector(handleRecordBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}

- (UIButton *)arrowBtn {
    if (!_arrowBtn) {
        _arrowBtn = [UIButton new];
        [_arrowBtn setImage:[UIImage imageNamed_sy:@"homepage_fans_arrow"] forState:UIControlStateNormal];
        [_arrowBtn addTarget:self action:@selector(handleArrowBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
        _arrowBtn.hidden = YES;
    }
    return _arrowBtn;
}

- (SYPersonHomepageVoiceControl *)voiceControl {
    if (!_voiceControl) {
        _voiceControl = [[SYPersonHomepageVoiceControl alloc] initWithFrame:CGRectZero];
        [_voiceControl addTarget:self action:@selector(handleVoiceClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        _voiceControl.hidden = YES;
    }
    return _voiceControl;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = RGBACOLOR(238,238,238,1);
    }
    return _bottomLine;
}

@end
