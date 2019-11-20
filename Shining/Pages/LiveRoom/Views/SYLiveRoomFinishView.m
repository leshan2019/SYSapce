//
//  SYLiveRoomFinishView.m
//  Shining
//
//  Created by leeco on 2019/9/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomFinishView.h"
#import "SYVIPLevelView.h"
#import "SYVoiceRoomSexView.h"
#import "SYBroadcasterLevelView.h"
@interface SYLiveRoomFinishView()
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIView *backTransparentView;
@property(nonatomic,strong)UIImageView*headerIcon;
@property(nonatomic,strong)UIView*headerIconBg;
@property(nonatomic,strong)CAGradientLayer*gradientLayer;
@property(nonatomic,strong)UILabel*titleLabel;
@property(nonatomic,strong)SYVIPLevelView*userLevelIcon;
@property(nonatomic,strong)SYBroadcasterLevelView*hostLevelIcon;
@property(nonatomic,strong)SYVoiceRoomSexView*userAgeIcon;
@property(nonatomic,strong)UILabel*nameLabel;
@property(nonatomic,strong)UIButton*infoBtn;
@property(nonatomic,strong)UIButton*addAttentionBtn;
@property (nonatomic,assign)BOOL isFollowing;
@property(nonatomic,strong)UIButton*backBtn;

@end
@implementation SYLiveRoomFinishView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backImageView];
        [self addSubview:self.backTransparentView];
        //毛玻璃
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *_effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView.frame = self.bounds;
        [self addSubview:_effectView];
        [self addSubview:self.headerIconBg];
        [self.headerIconBg.layer addSublayer:self.gradientLayer];
        [self.headerIconBg addSubview:self.headerIcon];
        [self addSubview:self.titleLabel];
        [self addSubview:self.userLevelIcon];
        [self addSubview:self.hostLevelIcon];
        [self addSubview:self.userAgeIcon];
        [self addSubview:self.nameLabel];
        [self addSubview:self.infoBtn];
        [self addSubview:self.addAttentionBtn];
        [self addSubview:self.backBtn];
    }
    return self;
}
- (UIButton *)backBtn{
    if (!_backBtn) {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(6, 1, 36, 44)];
        [btn setImage:[UIImage imageNamed_sy:@"voiceroom_back_w"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn = btn;
    }
    return _backBtn;
}
- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backImageView;
}
- (UIView *)backTransparentView {
    if (!_backTransparentView) {
        _backTransparentView = [[UIView alloc] initWithFrame:self.bounds];
        _backTransparentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _backTransparentView;
}
- (UIView *)headerIconBg{
    if (!_headerIconBg) {
        UIView*bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 96*dp, 96*dp)];
        bg.layer.cornerRadius = 96*dp/2.f;
        bg.layer.masksToBounds = YES;
        _headerIconBg = bg;
    }
    return _headerIconBg;
}
- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = CGRectMake(0, 0, self.headerIconBg.sy_width, self.headerIconBg.sy_height);
        _gradientLayer.cornerRadius = self.headerIconBg.sy_width/2.f;
        _gradientLayer.colors = @[(__bridge id)[UIColor sy_colorWithHexString:@"#B3B3B3"].CGColor, (__bridge id)[UIColor sy_colorWithHexString:@"#E3E3E3"].CGColor];//
        _gradientLayer.locations = @[@(0), @(1)];
    }
    return _gradientLayer;
}
- (UIImageView *)headerIcon{
    if (!_headerIcon) {
        UIImageView*icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.headerIconBg.sy_width-3, self.headerIconBg.sy_width-3)];
        icon.backgroundColor = [UIColor orangeColor];
        icon.layer.cornerRadius = (self.headerIconBg.sy_width-3)/2.f;
        icon.layer.masksToBounds = YES;
        _headerIcon = icon;
    }
    return _headerIcon;
}
- (SYVIPLevelView *)userLevelIcon{
    if (!_userLevelIcon) {
        SYVIPLevelView*icon = [[SYVIPLevelView alloc]init];
        [icon setFrame:CGRectMake(0, 0, 34, 14)];
        icon.backgroundColor = [UIColor orangeColor];
        icon.layer.cornerRadius = 7.f;
//        icon.hidden = YES;
        _userLevelIcon = icon;
    }
    return _userLevelIcon;
}
- (SYBroadcasterLevelView *)hostLevelIcon{
    if (!_hostLevelIcon) {
        SYBroadcasterLevelView*icon = [[SYBroadcasterLevelView alloc]init];
        [icon setFrame:CGRectMake(0, 0, 34, 14)];
        icon.layer.cornerRadius = 7.f;
//        icon.hidden = YES;
        _hostLevelIcon = icon;
    }
    return _hostLevelIcon;
}
- (SYVoiceRoomSexView *)userAgeIcon{
    if (!_userAgeIcon) {
        SYVoiceRoomSexView*icon = [[SYVoiceRoomSexView alloc]init];
        [icon setFrame:CGRectMake(0, 0, 34, 14)];
        icon.layer.cornerRadius = 7.f;
//        icon.hidden = YES;
        _userAgeIcon = icon;
    }
    return _userAgeIcon;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        UILabel*lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = [UIColor whiteColor];
        _nameLabel = lab;
    }
    return _nameLabel;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel*lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.sy_width, 28)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = @"本场直播已结束";
        lab.backgroundColor = [UIColor clearColor];
        lab.font = [UIFont systemFontOfSize:20];
        lab.textColor = [UIColor whiteColor];
        _titleLabel = lab;
    }
    return _titleLabel;
}
- (UIButton *)infoBtn{
    if (!_infoBtn) {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"主页" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.borderWidth = 1;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.layer.borderColor = [UIColor sy_colorWithHexString:@"#979797"].CGColor;
        [btn setFrame:CGRectMake(0, 0, 87, 30)];
        btn.layer.cornerRadius = 15;
        [btn addTarget:self action:@selector(infoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _infoBtn = btn;
    }
    return _infoBtn;
}
- (UIButton *)addAttentionBtn{
    if (!_addAttentionBtn) {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"+关注" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.borderWidth = 1;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.layer.borderColor = [UIColor sy_colorWithHexString:@"#979797"].CGColor;
        [btn setFrame:CGRectMake(0, 0, 87, 30)];
        btn.layer.cornerRadius = 15;
        [btn addTarget:self action:@selector(addAddAttentionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _addAttentionBtn = btn;
    }
    return _addAttentionBtn;
}
-(void)backBtnClicked:(id)sender{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(liveRoomFinishView_clickBackBtn)]) {
        [self.delegate liveRoomFinishView_clickBackBtn];
    }
}
-(void)infoBtnClicked:(id)sender{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(liveRoomFinishView_clickInfoBtn)]) {
        [self.delegate liveRoomFinishView_clickInfoBtn];
    }
}
-(void)addAddAttentionBtnClicked:(id)sender{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(liveRoomFinishView_clickAddAttentionBtn)]) {
        [self.delegate liveRoomFinishView_clickAddAttentionBtn];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat y = 20;
    if (iPhoneX) {
        y = 44;
    }
    self.backBtn.sy_top = 1+y;
    self.headerIconBg.sy_top = 38 + y;
    self.headerIconBg.sy_centerX = self.sy_centerX;
    self.headerIcon.sy_centerX = CGRectGetMidX(self.headerIconBg.bounds);
    self.headerIcon.sy_centerY = CGRectGetMidY(self.headerIconBg.bounds);
    self.titleLabel.sy_top = self.headerIconBg.sy_bottom + 133;
    self.infoBtn.sy_top = self.headerIconBg.sy_bottom + 58;
    self.infoBtn.sy_right = self.sy_centerX - (30*dp)/2.f;
    self.addAttentionBtn.sy_top = self.headerIconBg.sy_bottom + 58;
    self.addAttentionBtn.sy_left = self.infoBtn.sy_right + 30*dp;
    self.nameLabel.sy_top = self.headerIconBg.sy_bottom+18;

    self.hostLevelIcon.sy_centerY = self.userLevelIcon.sy_centerY = self.userAgeIcon.sy_centerY = self.nameLabel.sy_centerY;
    //
}
- (void)setUserInfoAvatar:(NSString *)avatarUrl
                 userName:(NSString * _Nullable)userName
                userLevel:(NSInteger)userLevel
                hostLevel:(NSInteger)hostLevel
                  userAge:(NSInteger)userAge
                  userSex:(SYSexType)sex
               isFollowed:(BOOL)isFollowed{
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed_sy:@"voiceroom_placeholder"]];
    [self.headerIcon sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed_sy:@"voiceroom_placeholder"]];
    self.nameLabel.text = userName;
    [self.nameLabel sizeToFit];
    if (self.nameLabel.sy_width>115) {
        self.nameLabel.sy_width = 115;
    }
    [self.hostLevelIcon showWithBroadcasterLevel:hostLevel];
    [self.userLevelIcon showWithVipLevel:userLevel];
    NSString*sexStr= @"";
    if (sex == SYSexType_male) {
        sexStr = @"male";
    }else if (sex == SYSexType_female){
        sexStr = @"female";
    }
    [self.userAgeIcon setSex:sexStr andAge:userAge];
    CGFloat infoWidth = 34+4+34+4 +self.userAgeIcon.sy_width+4+self.nameLabel.sy_width;
    CGFloat x = (self.sy_width - infoWidth)/2.f;
    self.hostLevelIcon.sy_left = x;
    self.userLevelIcon.sy_left = self.hostLevelIcon.sy_right +4;
    self.userAgeIcon.sy_left = self.userLevelIcon.sy_right +4;
    self.nameLabel.sy_left = self.userAgeIcon.sy_right+4;

    [self setFollowState:isFollowed];
}

- (void)setFollowState:(BOOL)isFollowing {
    self.isFollowing = isFollowing;
    if (isFollowing) {
        [self.addAttentionBtn setTitle:@"已关注"
                              forState:UIControlStateNormal];
    } else {
        [self.addAttentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
    }
}

@end
