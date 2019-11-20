//
//  SYVoiceMicUserViewModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/2/27.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYChatEngineEnum.h"

@class SYVoiceRoomUser;

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceChatUserViewModel : NSObject

- (instancetype)initWithUser:(SYVoiceRoomUser *)user
                     isMuted:(BOOL)isMuted;

- (instancetype)initWithUser:(SYVoiceRoomUser *)user
                     isMuted:(BOOL)isMuted
                     isPKing:(BOOL)isPKing
                   beanValue:(NSInteger)beanValue;

@property (nonatomic, strong, readonly) SYVoiceRoomUser *user;
@property (nonatomic, strong, readonly) NSString *uid;
@property (nonatomic, strong, readonly) NSString *bestid;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *avatarURL;
@property (nonatomic, strong, readonly) NSString *gender; // male, female
@property (nonatomic, strong, readonly) NSString *birthday;
@property (nonatomic, assign, readonly) NSInteger age;
@property (nonatomic, assign, readonly) NSInteger level;
@property (nonatomic, assign, readonly) NSInteger broadcaster_level;
@property (nonatomic, assign, readonly) NSString *avatarBox;
@property (nonatomic, assign, readonly) BOOL isMuted; // 是否被静音
@property (nonatomic, strong) NSString *kickedUid;
@property (nonatomic, assign) BOOL bossMic;
@property (nonatomic, strong, readonly) NSString *beanString; // 蜜豆字符串
@property (nonatomic, assign) BOOL isMaxPKBeans; // 当前pk最多蜜豆
@property (nonatomic, assign) BOOL isMinPKBeans; // 当前pk最少蜜豆

@end

NS_ASSUME_NONNULL_END
