//
//  SYVoiceRoomMicAnimationModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/8/6.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SYVoiceRoomMicAnimationTypeGame,
    SYVoiceRoomMicAnimationTypeExpression,
} SYVoiceRoomMicAnimationType;

@interface SYVoiceRoomMicAnimationModel : NSObject

@property (nonatomic, assign) SYVoiceRoomMicAnimationType type;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) NSInteger repeat;
@property (nonatomic, strong) NSString *result; // 游戏结果图片名

@end

NS_ASSUME_NONNULL_END
