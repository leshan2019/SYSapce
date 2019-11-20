//
//  SYPersonHomepageIntroView.m
//  Shining
//
//  Created by 杨玄 on 2019/4/18.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepageIntroView.h"
#import "SYVoiceRoomSexView.h"
#import "SYVIPLevelView.h"
#import "SYBroadcasterLevelView.h"

@interface SYPersonHomepageIntroView ()

// View
@property (nonatomic, strong) UILabel *nameLabel;                       // 姓名
@property (nonatomic, strong) SYVoiceRoomSexView *genderView;           // 性别+年龄
@property (nonatomic, strong) SYBroadcasterLevelView *broadCasterView;  // 主播等级
@property (nonatomic, strong) SYVIPLevelView *vipLevelView;             // Vip等级
@property (nonatomic, strong) UILabel *signatureLabel;                  // 个性签名
@property (nonatomic, strong) UILabel *attentionLabel;                  // 关注
@property (nonatomic, strong) UILabel *attentionNumlabel;               // 59
@property (nonatomic, strong) UILabel *fansLabel;                       // 粉丝
@property (nonatomic, strong) UILabel *fansNumLabel;                    // 12996
@property (nonatomic, strong) UIView *bottomLine;                       // 下划线

@end

@implementation SYPersonHomepageIntroView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

#pragma mark - Publick

- (void)updateHomepageIntroViewWithName:(NSString *)name gender:(NSString *)gender age:(NSInteger)age viplevel:(NSInteger)viplevel broadCasterLevel:(NSInteger)broadCasterLevel isBroadcaster:(NSInteger)isBroadcaster signatureStr:(nonnull NSString *)signatureStr isSuperAdmin:(NSInteger)isSuperAdmin{
    // name
    self.nameLabel.text = name;

    // gender
    [self.genderView setSex:gender andAge:age];
    CGFloat genderWidth = self.genderView.sy_width;
    [self.genderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(genderWidth);
    }];

    BOOL showBroadCasterView = (isBroadcaster == 1) || (isSuperAdmin == 1);
    if (showBroadCasterView) {
        self.broadCasterView.hidden = NO;
        // broadcasterLevel
        [self.broadCasterView showWithBroadcasterLevel:broadCasterLevel];
        CGRect broadFrame = self.broadCasterView.frame;
        [self.broadCasterView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(broadFrame.size.width);
        }];
        // vipLevel
        [self.vipLevelView showWithVipLevel:viplevel];
        CGRect levelFrame = self.vipLevelView.frame;
        [self.vipLevelView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.broadCasterView.mas_right).with.offset(10);
            make.width.mas_equalTo(levelFrame.size.width);
        }];
        if (isSuperAdmin) {
            [self.broadCasterView showWithSuperAdmin];
        }
    } else {
        self.broadCasterView.hidden = YES;
        // vipLevel
        [self.vipLevelView showWithVipLevel:viplevel];
        CGRect levelFrame = self.vipLevelView.frame;
        [self.vipLevelView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.genderView.mas_right).with.offset(10);
            make.width.mas_equalTo(levelFrame.size.width);
        }];
    }

    // 签名
    if (signatureStr.length > 0) {
        self.signatureLabel.hidden = NO;
        self.signatureLabel.text = signatureStr;
        [self.genderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.signatureLabel).with.offset(12+9);
        }];
    } else {
        self.signatureLabel.hidden = YES;
        self.signatureLabel.text = @"";
        [self.genderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.signatureLabel);
        }];
    }
}

- (void)updateHomepageIntrolViewWithAttentionCount:(NSInteger)attentionCount fansCount:(NSInteger)fansCount {
    // attention
    NSString *attentionStr = [NSString stringWithFormat:@"%ld",attentionCount];
    CGFloat width = [attentionStr sizeWithAttributes:@{ NSFontAttributeName:self.attentionNumlabel.font }].width;
    [self.attentionNumlabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width+1);
    }];
    self.attentionNumlabel.text = attentionStr;

    // fans
    NSString *fansStr = [NSString stringWithFormat:@"%ld",fansCount];
    width = [fansStr sizeWithAttributes:@{ NSFontAttributeName:self.fansNumLabel.font}].width;
    [self.fansNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width+1);
    }];
    self.fansNumLabel.text = fansStr;
}

#pragma mark - PrivateMethod

- (void)initSubView {
    self.backgroundColor = RGBACOLOR(247,247,247,1);
    [self addSubview:self.nameLabel];
    [self addSubview:self.genderView];
    [self addSubview:self.broadCasterView];
    [self addSubview:self.vipLevelView];
    [self addSubview:self.signatureLabel];
    [self addSubview:self.attentionLabel];
    [self addSubview:self.attentionNumlabel];
    [self addSubview:self.fansLabel];
    [self addSubview:self.fansNumLabel];
    [self addSubview:self.bottomLine];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.right.equalTo(self).with.offset(-144);
        make.top.equalTo(self).with.offset(15);
        make.height.mas_equalTo(25);
    }];
    
    [self.signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.right.equalTo(self).with.offset(-20);
        make.height.mas_equalTo(12);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(5);
    }];

    [self.genderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.top.equalTo(self.signatureLabel).with.offset(12+9);
        make.size.mas_equalTo(CGSizeMake(40, 14));
    }];

    [self.broadCasterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.genderView.mas_right).with.offset(10);
        make.centerY.equalTo(self.genderView);
        make.size.mas_equalTo(CGSizeMake(34, 14));
    }];

    [self.vipLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.broadCasterView.mas_right).with.offset(10);
        make.centerY.equalTo(self.genderView);
        make.size.mas_equalTo(CGSizeMake(34, 14));
    }];

    [self.attentionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.top.equalTo(self.genderView.mas_bottom).with.offset(13);
        make.size.mas_equalTo(CGSizeMake(24, 17));
    }];

    [self.attentionNumlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.attentionLabel.mas_right).with.offset(5);
        make.centerY.equalTo(self.attentionLabel);
        make.size.mas_equalTo(CGSizeMake(20, 22));
    }];
    
    [self.fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.attentionNumlabel.mas_right).with.offset(17);
        make.centerY.equalTo(self.attentionLabel);
        make.size.mas_equalTo(CGSizeMake(24, 17));
    }];
    
    [self.fansNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fansLabel.mas_right).with.offset(5);
        make.centerY.equalTo(self.attentionLabel);
        make.size.mas_equalTo(CGSizeMake(45, 22));
    }];

    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - Lazyload

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
        _nameLabel.textColor = RGBACOLOR(48,48,48,1);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (SYVoiceRoomSexView *)genderView {
    if (!_genderView) {
        _genderView = [[SYVoiceRoomSexView alloc] initWithFrame:CGRectMake(0, 0, 34, 14)];
    }
    return _genderView;
}

- (SYBroadcasterLevelView *)broadCasterView {
    if (!_broadCasterView) {
        _broadCasterView = [[SYBroadcasterLevelView alloc] initWithFrame:CGRectZero];
        _broadCasterView.hidden = YES;
    }
    return _broadCasterView;
}

- (SYVIPLevelView *)vipLevelView {
    if (!_vipLevelView) {
        _vipLevelView = [[SYVIPLevelView alloc] initWithFrame:CGRectZero];
    }
    return _vipLevelView;
}

- (UILabel *)signatureLabel {
    if (!_signatureLabel) {
        _signatureLabel = [UILabel new];
        _signatureLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _signatureLabel.textColor = RGBACOLOR(153, 153, 153, 1);
        _signatureLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _signatureLabel;
}

- (UILabel *)attentionLabel {
    if (!_attentionLabel) {
        _attentionLabel = [UILabel new];
        _attentionLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _attentionLabel.textColor = RGBACOLOR(48,48,48,1);
        _attentionLabel.textAlignment = NSTextAlignmentLeft;
        _attentionLabel.text = @"关注";
    }
    return _attentionLabel;
}

- (UILabel *)attentionNumlabel {
    if (!_attentionNumlabel) {
        _attentionNumlabel = [UILabel new];
        _attentionNumlabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        _attentionNumlabel.textColor = RGBACOLOR(48,48,48,1);
        _attentionNumlabel.textAlignment = NSTextAlignmentLeft;
        _attentionNumlabel.text = @"0";
    }
    return _attentionNumlabel;
}

- (UILabel *)fansLabel {
    if (!_fansLabel) {
        _fansLabel = [UILabel new];
        _fansLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _fansLabel.textColor = RGBACOLOR(48,48,48,1);
        _fansLabel.textAlignment = NSTextAlignmentLeft;
        _fansLabel.text = @"粉丝";
    }
    return _fansLabel;
}

- (UILabel *)fansNumLabel {
    if (!_fansNumLabel) {
        _fansNumLabel = [UILabel new];
        _fansNumLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        _fansNumLabel.textColor = RGBACOLOR(48,48,48,1);
        _fansNumLabel.textAlignment = NSTextAlignmentLeft;
        _fansNumLabel.text = @"0";
    }
    return _fansNumLabel;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = RGBACOLOR(238,238,238,1);
    }
    return _bottomLine;
}

@end
