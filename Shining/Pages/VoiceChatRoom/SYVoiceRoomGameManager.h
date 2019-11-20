//
//  SYVoiceRoomGameManager.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYChatEngineEnum.h"
#import "SYVoiceRoomGame.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomGameManager : NSObject

+ (NSInteger)gameCount;
+ (NSString *)gameTitleAtIndex:(NSInteger)index;
+ (NSString *)gameImageNameAtIndex:(NSInteger)index;
+ (SYVoiceRoomGameType)gameTypeAtIndex:(NSInteger)index;
+ (NSString *)gameImageNameWithGameType:(SYVoiceRoomGameType)gameType
                                  value:(NSInteger)value;


- (void)playGameWithGame:(SYVoiceRoomGameType)game
              startBlock:(void(^)(SYVoiceRoomGame *gameModel))startBlock
                endBlock:(void(^)(SYVoiceRoomGame *gameModel))endBlock;

- (NSString *)gameImageNameWithGameType:(SYVoiceRoomGameType)gameType;
- (NSArray *)gameAnimateImageNamesWithGameType:(SYVoiceRoomGameType)gameType;
@end

NS_ASSUME_NONNULL_END
