//
//  SYMineHeaderView.m
//  Shining
//
//  Created by 杨玄 on 2019/3/25.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYMineHeaderView.h"
#import "SYBroadcasterLevelView.h"

@interface SYMineHeaderView ()

@property (nonatomic, strong) UIImageView *headBackImage;   // 背景图
@property (nonatomic, strong) UIImageView *headerIcon;      // 头像
@property (nonatomic, strong) UILabel *nameLabel;           // 名字
@property (nonatomic, strong) SYBroadcasterLevelView *broadCasterView;  // 主播等级
@property (nonatomic, strong) UILabel *idLabel;             // Bee语音号
@property (nonatomic, strong) UIButton *duplicateBtn;       // 复制id
@property (nonatomic, strong) UIButton *editBtn;            // 编辑资料

@property (nonatomic, strong) NSString *idText;             // 保存id号

@end

@implementation SYMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubview:self.headBackImage];
        [self addSubview:self.headerIcon];
        [self addSubview:self.nameLabel];
        [self addSubview:self.broadCasterView];
        [self addSubview:self.idLabel];
        [self addSubview:self.editBtn];

        [self.headBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        [self.headerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(66, 66));
            make.bottom.equalTo(self).with.offset(-48);
            make.left.equalTo(self).with.offset(20);
        }];
        [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerIcon.mas_right).with.offset(6);
            make.bottom.equalTo(self).with.offset(-59);
            make.height.mas_equalTo(14);
            make.width.mas_equalTo(0);
        }];

        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.idLabel.mas_left);
            make.bottom.equalTo(self.idLabel.mas_top).with.offset(-7);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(0);
        }];

        [self.broadCasterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_right).with.offset(6);
            make.centerY.equalTo(self.nameLabel);
            make.size.mas_equalTo(CGSizeMake(34, 14));
        }];

        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).with.offset(-82);
            make.size.mas_equalTo(CGSizeMake(44, 20));
            make.right.equalTo(self).with.offset(-20);
        }];
    }
    return self;
}

- (void)updateHeaderViewWithAvatar:(NSString *)avatar name:(NSString *)name idNumber:(NSString *)idNum withBroadCasterLevel:(NSInteger)broadCasterLevel isBroadcaster:(NSInteger)isBroadcaster isSuperAdmin:(NSInteger)isSuperAdmin bestId:(nonnull NSString *)bestId{

    // avatar
    [self.headerIcon sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed_sy:@"mine_head_default"]];

    // id
    if ([bestId integerValue] > 0) {
        idNum = bestId;
    }
    NSString *idText = [NSString stringWithFormat:@"ID：%@",idNum];
    self.idLabel.text = idText;
    CGFloat idWidth = [idText sizeWithAttributes:@{ NSFontAttributeName:self.idLabel.font }].width;
    [self.idLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(idWidth+1);
    }];

    CGRect broadFrame;

    // 主播等级
    BOOL showBroadCasterView = (isBroadcaster == 1) || (isSuperAdmin == 1);
    self.broadCasterView.hidden = !showBroadCasterView;
    if (showBroadCasterView) {
        [self.broadCasterView showWithBroadcasterLevel:broadCasterLevel];
        broadFrame = self.broadCasterView.frame;
        [self.broadCasterView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(broadFrame.size.width);
        }];
        if (isSuperAdmin) {
            [self.broadCasterView showWithSuperAdmin];
        }
    }

    // name
    self.nameLabel.text = name;
    CGFloat maxNameWidth;
    if (showBroadCasterView) {
        maxNameWidth = __MainScreen_Width - 92 - 64 - 20 - 6 - broadFrame.size.width;
    } else {
        maxNameWidth = __MainScreen_Width - 92 - 64 - 20 ;
    }
    CGFloat titleWidth = [name sizeWithAttributes:@{ NSFontAttributeName : self.nameLabel.font }].width;
    if (titleWidth > maxNameWidth) {
        titleWidth = maxNameWidth;
    }
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleWidth+1);
    }];
}

#pragma mark - LazyLoad

- (UIImageView *)headBackImage {
    if (!_headBackImage) {
        _headBackImage = [UIImageView new];
        _headBackImage.image = [UIImage imageNamed_sy:@"mine_head_back"];
    }
    return _headBackImage;
}

- (UIImageView *)headerIcon {
    if (!_headerIcon) {
        _headerIcon = [UIImageView new];
        _headerIcon.contentMode = UIViewContentModeScaleAspectFill;
        _headerIcon.clipsToBounds = YES;
        _headerIcon.layer.cornerRadius = 30;
        _headerIcon.userInteractionEnabled = YES;
        _headerIcon.image = [UIImage imageNamed_sy:@"mine_head_default"];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture)];
        [_headerIcon addGestureRecognizer:tapGesture];
    }
    return _headerIcon;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:22];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (SYBroadcasterLevelView *)broadCasterView {
    if (!_broadCasterView) {
        _broadCasterView = [[SYBroadcasterLevelView alloc] initWithFrame:CGRectZero];
        _broadCasterView.hidden = YES;
    }
    return _broadCasterView;
}

- (UILabel *)idLabel {
    if (!_idLabel) {
        _idLabel = [UILabel new];
        _idLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        _idLabel.textColor = [UIColor whiteColor];
        _idLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _idLabel;
}

- (UIButton *)duplicateBtn {
    if (!_duplicateBtn) {
        _duplicateBtn = [UIButton new];
        [_duplicateBtn setTitle:@"复制" forState:UIControlStateNormal];
        [_duplicateBtn setTitleColor:RGBACOLOR(153, 153, 153, 1) forState:UIControlStateNormal];
        _duplicateBtn.titleLabel.font =  [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
        [_duplicateBtn addTarget:self action:@selector(handleDuplicateBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _duplicateBtn;
}

- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [UIButton new];
        [_editBtn addTarget:self action:@selector(hanldeEditBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        _editBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        [_editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        CGRect btnBounds = CGRectMake(0, 0, 44, 20);
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:btnBounds cornerRadius:10];
        CAShapeLayer *shapeLayer = [CAShapeLayer new];
        shapeLayer.frame = btnBounds;
        shapeLayer.path = bezierPath.CGPath;
        shapeLayer.lineWidth = 0.5;
        shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        [_editBtn.layer addSublayer:shapeLayer];
    }
    return _editBtn;
}

#pragma mark - BtnClickEvent

- (void)hanldeEditBtnClickEvent {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editPersonalInformation)]) {
        [self.delegate editPersonalInformation];
    }
}

- (void)handleDuplicateBtnClickEvent {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString sy_safeString:self.idText];
    [SYToastView showToast:@"复制成功"];
}

- (void)handleTapGesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickAvatar)]) {
        [self.delegate clickAvatar];
    }
}

@end
