//
//  SYVoiceChatRoomUserInfoViewModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/14.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SYVoiceChatUserViewModel;

@interface SYVoiceChatRoomUserInfoViewModel : NSObject

- (instancetype)initWithChannelID:(NSString *)channelID
                              uid:(NSString *)uid;

- (void)requestUserStatusInfoWithBlock:(void(^)(BOOL success))block;
- (void)requestFollowUserWithBlock:(void(^)(BOOL success))block;
- (void)requestCancelFollowUserWithBlock:(void(^)(BOOL success))block;
- (void)requestLBZTicketWithBlock:(void(^)(NSDictionary *ticketDict))block;

// action
- (void)setIsForbiddenChat:(BOOL)isForbiddenChat;
- (void)setIsForbiddenEnter:(BOOL)isForbiddenEnter;

// datasource
- (NSString *)username;
- (NSString *)userUid;
- (NSString *)userBestid;
- (NSString *)userAvatar;
- (NSString *)userGender;
- (NSInteger)level;
- (NSInteger)age;
- (NSString *)location;
- (NSString *)sign;
- (NSInteger)userAvatarBox;
- (NSString *)voiceURL;
- (NSInteger)voiceDuration;
- (NSInteger)broadcasterLevel;
- (NSInteger)isBroadcaster;
- (NSInteger)isSuperAdmin;
- (NSString *)em_username;
- (NSString *)signature;

- (BOOL)isForbiddenChat;
- (BOOL)isForbiddenEnter;
- (BOOL)isFollow;

- (SYVoiceChatUserViewModel *)userViewModel;

@end

NS_ASSUME_NONNULL_END
