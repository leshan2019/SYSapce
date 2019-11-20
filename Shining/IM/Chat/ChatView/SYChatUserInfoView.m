//
//  ChatUserInfoView.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/3/5.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYChatUserInfoView.h"
#import "UILabel+SYAutoWidthAndHeight.h"
#import "SYUserServiceAPI.h"
#import "SYSignProvider.h"
#import "SYDistrictProvider.h"
#import "SYGiftNetManager.h"

@interface SYChatUserInfoView()
@property (nonatomic, strong) UIImageView *bgImg;
@property (nonatomic, strong) UIImageView *avatarImg;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UIView *ageAndGenderBgView;
@property (nonatomic, strong) UIImageView *genderImg;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *constellationLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIButton *soundAtrrButton;
@property (nonatomic, strong) UILabel *addFriendLabel;
@property (nonatomic, strong) UIButton *addFriendBtn;

@property (nonatomic, strong) UserProfileEntity *userProfileEntity;
@end

@implementation SYChatUserInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andUserInfo:(UserProfileEntity *)userProfileEntity
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        self.userProfileEntity = userProfileEntity;
        [self refreshView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgImg];
    [self addSubview:self.avatarImg];
    [self addSubview:self.nickNameLabel];
    [self addSubview:self.ageAndGenderBgView];
    [self.ageAndGenderBgView addSubview:self.genderImg];
    [self.ageAndGenderBgView addSubview:self.ageLabel];
    [self addSubview:self.constellationLabel];
    [self addSubview:self.locationLabel];
    [self addSubview:self.soundAtrrButton];
    [self addSubview:self.addFriendLabel];
    [self addSubview:self.addFriendBtn];
}

- (void)refreshView{
    if (self.userProfileEntity) {
        [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:self.userProfileEntity.avatar_imgurl] placeholderImage:[UIImage imageNamed_sy:@"user"]];
        self.nickNameLabel.text = self.userProfileEntity.username;
        self.ageLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[SYUtil ageWithBirthdayString:self.userProfileEntity.birthday]];
        if (![NSString sy_isBlankString: self.userProfileEntity.birthday]) {
             self.constellationLabel.text = [[SYSignProvider shared] signOfDateString: self.userProfileEntity.birthday];
        }
        if (![NSString sy_isBlankString:self.userProfileEntity.residence_place]) {
            SYDistrict *district = [[SYDistrictProvider shared]districtOfId:[self.userProfileEntity.residence_place integerValue]];
            if ([NSObject sy_empty:district]) {
                self.locationLabel.text = @"保密";
            } else {
                self.locationLabel.text = [NSString stringWithFormat:@"%@%@",[NSString sy_safeString: district.provinceName],[NSString sy_safeString:district.districtName]];
            }
        }
       
        
        [[SYUserServiceAPI sharedInstance]requestIsFollowed:self.userProfileEntity.userid finishBlock:^(BOOL followed) {
            if (followed) {
                [self refreshShowFollowText:followed];
            }
        }];
    
    }
}

#pragma mark =============== Getter && Setter ===============
- (UIImageView *)bgImg
{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _bgImg.image = [UIImage imageNamed_sy:@"chat_info_bg"];
        _bgImg.backgroundColor = [UIColor clearColor];
    }
    return _bgImg;
}

- (UIImageView *)avatarImg
{
    if (!_avatarImg) {
        _avatarImg = [[UIImageView alloc]initWithFrame:CGRectMake(26, 20, 60, 60)];
        _avatarImg.layer.cornerRadius = _avatarImg.frame.size.height/2;
        _avatarImg.clipsToBounds = YES;
        _avatarImg.backgroundColor = [UIColor clearColor];
        _avatarImg.image = [UIImage imageNamed_sy:@"user"];

    }
    return _avatarImg;
}

- (UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarImg.frame)+8, self.avatarImg.frame.origin.y+5, 150, 20)];
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
        _nickNameLabel.text = @"萝莉大梦girl";
        _nickNameLabel.textColor = [UIColor whiteColor];
    }
    return _nickNameLabel;
}

- (UIView *)ageAndGenderBgView{
    if (!_ageAndGenderBgView) {
        _ageAndGenderBgView = [[UIView alloc]initWithFrame:CGRectMake(self.nickNameLabel.frame.origin.x,CGRectGetMaxY(self.nickNameLabel.frame)+10, 34, 14)];
        _ageAndGenderBgView.backgroundColor = [UIColor sy_colorWithHexString:@"#FFFFFF" alpha:0.24];
    }
    return _ageAndGenderBgView;
}

- (UIImageView *)genderImg
{
    if (!_genderImg) {
        _genderImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, (_ageAndGenderBgView.frame.size.height - 7)/2, 7, 7)];
        _genderImg.backgroundColor = [UIColor grayColor];
        _genderImg.image = [UIImage imageNamed_sy:@"voiceroom_girl"];
    }
    return _genderImg;
}

- (UILabel *)ageLabel{
    if (!_ageLabel) {
        _ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.genderImg.frame), 0, 30, 14)];
        _ageLabel.textAlignment = NSTextAlignmentLeft;
        _ageLabel.text = @"20";
        _ageLabel.font = [UIFont systemFontOfSize:10.f];
        _ageLabel.textColor = [UIColor whiteColor];
    }
    return _ageLabel;
}

- (UILabel *)constellationLabel{
    if (!_constellationLabel) {
        _constellationLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.ageAndGenderBgView.frame)+10, self.ageAndGenderBgView.frame.origin.y, 40, 14)];
        _constellationLabel.textAlignment = NSTextAlignmentLeft;
        _constellationLabel.text = @"天蝎座";
        _constellationLabel.font = [UIFont systemFontOfSize:10.f];
        _constellationLabel.textColor = [UIColor whiteColor];
        [_constellationLabel sizeToFit];
    }
    return _constellationLabel;
}
- (UILabel *)locationLabel{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.constellationLabel.frame)+8, self.constellationLabel.frame.origin.y, 100, 14)];
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        _locationLabel.text = @"安徽芜湖";
        _locationLabel.font = [UIFont systemFontOfSize:10.f];
        _locationLabel.textColor = [UIColor whiteColor];
        [_constellationLabel sizeToFit];
    }
    return _locationLabel;
}

- (UIButton *)soundAtrrButton{
    if (!_soundAtrrButton) {
        CGFloat imageW = [UIImage imageNamed_sy:@"chat_info_voiceBtn"].size.width;
        CGFloat titleW = 42.f;
        CGFloat space = 6.f;
        _soundAtrrButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
        _soundAtrrButton.frame = CGRectMake(self.frame.size.width-42-70, self.avatarImg.frame.origin.y, 70, 24);
        [_soundAtrrButton setTitle:@"甜美音" forState:UIControlStateNormal];
        [_soundAtrrButton setTitleColor:[UIColor sy_colorWithHexString:@"#7B40FF"] forState:UIControlStateNormal];
        [_soundAtrrButton setImage:[UIImage imageNamed_sy:@"chat_info_voiceBtn"] forState:UIControlStateNormal];
        [_soundAtrrButton setBackgroundColor:[UIColor sy_colorWithHexString:@"#F3F3F3"]];
        _soundAtrrButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _soundAtrrButton.titleLabel.font=[UIFont systemFontOfSize:12];
        _soundAtrrButton.layer.cornerRadius = 10.f;
//        CGFloat titleW = _soundAtrrButton.titleLabel.bounds.size.width;
        [_soundAtrrButton setTitleEdgeInsets: UIEdgeInsetsMake(0, -(imageW + space/2)+8, 0, imageW + space/2)];
        [_soundAtrrButton setImageEdgeInsets: UIEdgeInsetsMake(0, titleW+space/2, 0, -(titleW+space/2))];
        
        if (CGRectGetMaxX(self.nickNameLabel.frame)>_soundAtrrButton.frame.origin.x) {
            CGRect rect = self.nickNameLabel.frame;
            rect.size.width = _soundAtrrButton.frame.origin.x - self.nickNameLabel.frame.origin.x - 5;
            self.nickNameLabel.frame = rect;
        }

    }
    return _soundAtrrButton;
}

- (UILabel *)addFriendLabel{
    if (!_addFriendLabel) {
        CGFloat width = [UILabel sy_getWidthWithTitle:@"进一步了解我~" font:[UIFont systemFontOfSize:12.f]];
        _addFriendLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.bgImg.frame.size.width-width)/2, self.bgImg.frame.size.height-40, width, 40)];
        _addFriendLabel.textAlignment = NSTextAlignmentCenter;
        _addFriendLabel.text = @"进一步了解我~";
        _addFriendLabel.textColor = [UIColor sy_colorWithHexString:@"#444444"];
        _addFriendLabel.font = [UIFont systemFontOfSize:12.f];

    }
    return _addFriendLabel;
}

- (UIButton *)addFriendBtn{
    if (!_addFriendBtn) {
        _addFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addFriendBtn.frame = CGRectMake(CGRectGetMaxX(self.addFriendLabel.frame), self.addFriendLabel.frame.origin.y+6, 100, 40);
        [_addFriendBtn setTitleColor:[UIColor sy_colorWithHexString:@"#7B40FF"] forState:UIControlStateNormal];
        [_addFriendBtn setTitle:@"关注我" forState:UIControlStateNormal];
        _addFriendBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        _addFriendBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_addFriendBtn sizeToFit];
        [_addFriendBtn addTarget:self action:@selector(addFollow:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addFriendBtn;
}

- (void)addFollow:(id)sender
{
    NSString *uid = self.userProfileEntity.userid;
    if ([NSString sy_isBlankString: uid]) {
        [SYToastView showToast:@"关注失败"];
        return;
    }
    if (self.delegate) {
        [self.delegate addFollow:uid];
    }
    [[SYUserServiceAPI sharedInstance]requestFollowUserWithUid:uid success:^(id  _Nullable response) {
        [SYToastView showToast:@"已关注"];
        [self refreshShowFollowText:YES];
        SYGiftNetManager *netManager = [SYGiftNetManager new];
        [netManager dailyTaskLog:3];
        
    } failure:^(NSError * _Nullable error) {
        [SYToastView showToast:@"关注失败"];
    }];
}

- (void)refreshShowFollowText:(BOOL)isFollowed
{
    self.isFollowed = isFollowed;
    NSString *title = isFollowed?@"快来和我聊天吧~":@"进一步了解我~";
    CGFloat width = [UILabel sy_getWidthWithTitle:title font:[UIFont systemFontOfSize:12.f]];
    CGRect rect = self.addFriendLabel.frame;
    rect.size.width = width;
    self.addFriendLabel.frame = rect;
    self.addFriendLabel.text = title;
    self.addFriendBtn.hidden = isFollowed;
    
    if (!isFollowed) {
        CGPoint center =  self.addFriendLabel.center;
        center.x -= self.addFriendBtn.frame.size.width/2;
        self.addFriendLabel.center = center;
       
    }else{
        CGPoint center =  self.addFriendLabel.center;
        center.x = self.center.x;
        self.addFriendLabel.center = center;
    }
    CGRect newRect = self.addFriendBtn.frame;
    newRect.origin.x = CGRectGetMaxX(self.addFriendLabel.frame);
    self.addFriendBtn.frame = newRect;
}

@end
