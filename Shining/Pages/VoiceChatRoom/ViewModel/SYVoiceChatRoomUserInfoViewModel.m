//
//  SYVoiceChatRoomUserInfoViewModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/14.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceChatRoomUserInfoViewModel.h"
#import "SYVoiceChatNetManager.h"
#import "SYUserServiceAPI.h"
#import "SYDistrictProvider.h"
#import "SYSignProvider.h"
#import "SYVoiceChatUserViewModel.h"
#import "SYVoiceRoomUser.h"

@interface SYVoiceChatRoomUserInfoViewModel ()

@property (nonatomic, strong) NSString *channelID;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) SYVoiceChatNetManager *netManager;
@property (nonatomic, strong) SYVoiceRoomUserStatusModel *userStatus;

@end

@implementation SYVoiceChatRoomUserInfoViewModel

- (instancetype)initWithChannelID:(NSString *)channelID
                              uid:(NSString *)uid {
    self = [super init];
    if (self) {
        _channelID = channelID;
        _uid = uid;
        _netManager = [[SYVoiceChatNetManager alloc] init];
    }
    return self;
}

- (void)requestUserStatusInfoWithBlock:(void(^)(BOOL success))block {
    [self.netManager requestUserStatusWithChannelID:self.channelID
                                                uid:self.uid
                                            success:^(id  _Nullable response) {
                                                [self handleUserStatus:response];
                                                if (block) {
                                                    block(YES);
                                                }
                                            } failure:^(NSError * _Nullable error) {
                                                if (block) {
                                                    block(NO);
                                                }
                                            }];
}

- (void)requestFollowUserWithBlock:(void(^)(BOOL success))block {
    [[SYUserServiceAPI sharedInstance] requestFollowUserWithUid:self.userUid
                                                        success:^(id  _Nullable response) {
                                                            self.userStatus.hasCare = YES;
                                                            if (block) {
                                                                block(YES);
                                                            }
                                                        } failure:^(NSError * _Nullable error) {
                                                            if (block) {
                                                                block(NO);
                                                            }
                                                        }];
}

- (void)requestCancelFollowUserWithBlock:(void(^)(BOOL success))block {
    [[SYUserServiceAPI sharedInstance] requestCancelFollowUserWithUid:self.userUid
                                                              success:^(id  _Nullable response) {
                                                                  self.userStatus.hasCare = NO;
                                                                  if (block) {
                                                                      block(YES);
                                                                  }
                                                              } failure:^(NSError * _Nullable error) {
                                                                  if (block) {
                                                                      block(NO);
                                                                  }
                                                              }];
}

- (void)requestLBZTicketWithBlock:(void(^)(NSDictionary *ticketDict))block {
    [[SYUserServiceAPI sharedInstance] requestLebzTicket:^(id  _Nullable response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            if (block) {
                block(response);
                return;
            }
        }
        if (block) {
            block(nil);
        }
    } failure:^(NSError * _Nullable error) {
        if (block) {
            block(nil);
        }
    }];
}

- (void)setIsForbiddenChat:(BOOL)isForbiddenChat {
    self.userStatus.disSay = isForbiddenChat;
}

- (void)setIsForbiddenEnter:(BOOL)isForbiddenEnter {
    self.userStatus.disJoin = isForbiddenEnter;
}

- (void)handleUserStatus:(id)response {
    if ([response isKindOfClass:[SYVoiceRoomUserStatusModel class]]) {
        self.userStatus = response;
    }
}

- (NSString *)username {
    return self.userStatus.userInfo.name;
}

- (NSString *)userUid {
    return self.userStatus.userInfo.id;
}

- (NSString *)userBestid {
    return self.userStatus.userInfo.bestid;
}

- (NSString *)userAvatar {
    return self.userStatus.userInfo.avatar;
}

- (NSString *)userGender {
    return self.userStatus.userInfo.gender;
}

- (NSInteger)level {
    return self.userStatus.userInfo.level;
}

- (NSInteger)age {
    return [SYUtil ageWithBirthdayString:self.userStatus.userInfo.birthday];
}

- (NSString *)location {
    SYDistrict *district = [[SYDistrictProvider shared] districtOfId:self.userStatus.userInfo.residence_place];
    if ([NSObject sy_empty:district]) {
        return @"保密";
    }
    return [NSString stringWithFormat:@"%@%@",district.provinceName, district.districtName];
}

- (NSString *)sign {
    return [[SYSignProvider shared] signOfDateString:self.userStatus.userInfo.birthday];
}

- (NSInteger)userAvatarBox {
    return self.userStatus.userInfo.avatarbox;
}

- (NSString *)voiceURL {
    return self.userStatus.userInfo.voice_url;
}

- (NSInteger)voiceDuration {
    NSInteger duration = self.userStatus.userInfo.voice_duration;
    if (duration == 0 && ![NSString sy_isBlankString:self.voiceURL]) {
        AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:self.voiceURL]];
        CMTime time = [asset duration];
        float floatSecond = CMTimeGetSeconds(time);
        duration = floor(floatSecond);
    }
    return duration;
}

- (NSInteger)broadcasterLevel {
    return self.userStatus.userInfo.streamer_level;
}

- (NSInteger)isBroadcaster {
    return self.userStatus.userInfo.is_streamer;
}

- (NSInteger)isSuperAdmin {
    return self.userStatus.userInfo.is_super_admin;
}

- (NSString *)em_username {
    return self.userStatus.userInfo.em_username;
}

- (NSString *)signature {
    return self.userStatus.userInfo.signature;
}

- (BOOL)isForbiddenChat {
    return self.userStatus.disSay;
}

- (BOOL)isForbiddenEnter {
    return self.userStatus.disJoin;
}

- (BOOL)isFollow {
    return self.userStatus.hasCare;
}

- (SYVoiceChatUserViewModel *)userViewModel {
    if (self.userStatus) {
        SYVoiceRoomUserModel *user = self.userStatus.userInfo;
        NSDictionary *dict = [user yy_modelToJSONObject];
        SYVoiceRoomUser *_user = [SYVoiceRoomUser yy_modelWithDictionary:dict];
        SYVoiceChatUserViewModel *viewModel = [[SYVoiceChatUserViewModel alloc] initWithUser:_user
                                                                                     isMuted:NO];
        return viewModel;
    }
    return nil;
}

@end
