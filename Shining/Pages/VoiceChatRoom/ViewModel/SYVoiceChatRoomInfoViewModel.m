//
//  SYVoiceChatRoomInfoViewModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/8.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceChatRoomInfoViewModel.h"
#import "SYChatRoomModel.h"

@interface SYVoiceChatRoomInfoViewModel ()

@property (nonatomic, strong) SYChatRoomModel *roomModel;

@end

@implementation SYVoiceChatRoomInfoViewModel

- (instancetype)initWithRoomModel:(SYChatRoomModel *)roomModel {
    self = [super init];
    if (self) {
        _roomModel = roomModel;
    }
    return self;
}

- (NSString *)roomID {
    return self.roomModel.id;
}
- (NSString *)roomName {
    return self.roomModel.name;
}
- (NSString *)roomIcon {
    return self.roomModel.icon;
}
- (NSString *)roomDesc {
    return self.roomModel.desc;
}
- (NSString *)roomGreeting {
    return self.roomModel.greeting;
}
- (NSInteger)roomScore {
    return self.roomModel.score;
}
- (NSString *)ownerName {
    return self.roomModel.userInfo.name;
}
- (NSString *)ownerAvatarURL {
    return self.roomModel.userInfo.avatar;
}

- (NSString *)categoryName {
    return self.roomModel.categoryName;
}

- (NSInteger)userNum {
    return self.roomModel.concurrentUser;
}

- (SYVoiceChatRoomMicConfig)micConfig {
    SYVoiceChatRoomMicConfig config = SYVoiceChatRoomMicConfig6;
    if ([self.roomModel.micConfig isEqualToString:@"1+0"]) {
        config = SYVoiceChatRoomMicConfig0;
    } else if ([self.roomModel.micConfig isEqualToString:@"1+8"]) {
        config = SYVoiceChatRoomMicConfig8;
    }
    return config;
}

- (BOOL)isClosed {
    return (self.roomModel.status == 1);
}

- (NSString *)roomBackgroundImage {
    if (self.roomModel.background < 0 || self.roomModel.background > 3) {
        return @"voiceroom_bg_0";
    }
    return [NSString stringWithFormat:@"voiceroom_bg_%ld",self.roomModel.background];
}

@end
