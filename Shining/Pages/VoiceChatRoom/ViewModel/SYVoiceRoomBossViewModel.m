//
//  SYVoiceRoomBossViewModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/8/7.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomBossViewModel.h"
#import "SYVoiceRoomKingModel.h"
#import "SYGiftInfoManager.h"

@interface SYVoiceRoomBossViewModel ()

@property (nonatomic, strong) SYVoiceRoomKingModel *bossModel;

@end

@implementation SYVoiceRoomBossViewModel

- (instancetype)initWithBossModel:(SYVoiceRoomKingModel *)bossModel {
    self = [super init];
    if (self) {
        _bossModel = bossModel;
    }
    return self;
}

- (BOOL)isMyself {
    UserProfileEntity *user = [UserProfileEntity getUserProfileEntity];
    if (user.userid) {
        return [self.bossModel.userinfo.id isEqualToString:user.userid];
    }
    return NO;
}

- (BOOL)isValid {
    if ((self.bossModel.current_timestamp - self.bossModel.send_timestamp) >
        [SYSettingManager bossCDMinutes] * 60) {
        return NO;
    }
    return YES;
}

- (NSInteger)countDown {
    if (self.isValid) {
        return ([SYSettingManager bossCDMinutes] * 60 - (self.bossModel.current_timestamp - self.bossModel.send_timestamp));
    }
    return 0;
}

- (NSString *)userUid {
    return self.isValid ? self.bossModel.userinfo.id : nil;
}

- (NSString *)userName {
    return self.isValid ? self.bossModel.userinfo.name : nil;
}

- (NSString *)userAvatar {
    return self.isValid ? self.bossModel.userinfo.avatar : nil;
}

- (NSString *)userAvatarBox {
    return self.isValid ? [[SYGiftInfoManager sharedManager] avatarBoxURLWithPropId:self.bossModel.userinfo.avatarbox] : nil;
}

- (NSInteger)price {
    return self.isValid ? self.bossModel.gift_price : 0;
}

@end
