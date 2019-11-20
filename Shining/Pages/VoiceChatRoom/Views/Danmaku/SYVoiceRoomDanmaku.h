//
//  SYVoiceRoomDanmaku.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SYVoiceRoomDanmakuTypeUnknown,
    SYVoiceRoomDanmakuTypeDefault,
    SYVoiceRoomDanmakuTypeMidLevel,
    SYVoiceRoomDanmakuTypeHighLevel,
} SYVoiceRoomDanmakuType;

@interface SYVoiceRoomDanmaku : UIView

- (void)showWithAvatarURL:(NSString *)avatarURL
                  message:(NSString *)message
                     type:(SYVoiceRoomDanmakuType)type;

@end

NS_ASSUME_NONNULL_END
