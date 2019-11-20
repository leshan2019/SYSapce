//
//  SYVoiceChatRoomInfoViewModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/8.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SYChatRoomModel;

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SYVoiceChatRoomMicConfig0,
    SYVoiceChatRoomMicConfig6,
    SYVoiceChatRoomMicConfig8,
} SYVoiceChatRoomMicConfig;

@interface SYVoiceChatRoomInfoViewModel : NSObject

- (instancetype)initWithRoomModel:(SYChatRoomModel *)roomModel;

- (NSString *)roomID;
- (NSString *)roomName;
- (NSString *)roomIcon;
- (NSString *)roomDesc;
- (NSString *)roomGreeting;
- (NSString *)ownerName;
- (NSString *)ownerAvatarURL;
- (NSInteger)roomScore;
- (SYVoiceChatRoomMicConfig)micConfig;
- (NSString *)categoryName;
- (BOOL)isClosed; // 房间关闭状态
- (NSInteger)userNum;
- (NSString *)roomBackgroundImage;

@end

NS_ASSUME_NONNULL_END
