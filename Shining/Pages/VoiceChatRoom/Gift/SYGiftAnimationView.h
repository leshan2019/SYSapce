//
//  SYGiftRenderHandler.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/27.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYAnimationModel.h"
#import "SYVoiceRoomAudioEffectProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SYGiftAnimationRenderHandlerDelegate <NSObject>

@optional
- (void)giftAnimationRenderHandlerStartAnimation;
- (BOOL)isAnimationOff;
@end

@interface SYGiftAnimationView : UIView

@property (nonatomic, weak) id <SYGiftAnimationRenderHandlerDelegate> delegate;
@property (nonatomic, weak) id <SYVoiceRoomAudioEffectProtocol> audioEffectPlayer;

- (void)addGiftAnimationWithGiftID:(NSInteger)giftID;

- (void)addGiftAnimationWithAnimationModel:(SYAnimationModel *)model;

- (void)destory;

@end

NS_ASSUME_NONNULL_END
