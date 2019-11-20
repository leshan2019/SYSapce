//
//  SYVoiceRoomGameManager.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomGameManager.h"

static NSArray *gameNames;
static NSArray *imageNames;
static NSArray *gameTypes;

@implementation SYVoiceRoomGameManager

+ (void)initialize {
    if (self == [SYVoiceRoomGameManager class]) {
        gameNames = @[@"摇骰子", @"猜拳", @"摇数字", @"爆灯"];
        imageNames = @[@"voiceroom_game_touzi",@"voiceroom_game_caiquan", @"game_num_1",@"voiceroom_game_baodeng"];
        gameTypes = @[@(SYVoiceRoomGameTouzi), @(SYVoiceRoomGameCaiquan), @(SYVoiceRoomGameNumber), @(SYVoiceRoomGameBaodeng)];
    }
}

+ (NSInteger)gameCount {
    return [gameNames count];
}

+ (NSString *)gameTitleAtIndex:(NSInteger)index {
    if (index >= 0 && index < [gameNames count]) {
        return gameNames[index];
    }
    return nil;
}

+ (NSString *)gameImageNameAtIndex:(NSInteger)index {
    if (index >= 0 && index < [imageNames count]) {
        return imageNames[index];
    }
    return nil;
}

+ (SYVoiceRoomGameType)gameTypeAtIndex:(NSInteger)index {
    if (index >= 0 && index < [gameTypes count]) {
        return (SYVoiceRoomGameType)[gameTypes[index] integerValue];
    }
    return SYVoiceRoomGameUnknown;
}

+ (NSString *)gameImageNameWithGameType:(SYVoiceRoomGameType)gameType
                                  value:(NSInteger)value {
    NSString *prefix = @"";
    if (gameType == SYVoiceRoomGameTouzi) {
        prefix = @"game_touzi_";
        return [prefix stringByAppendingFormat:@"%ld", (long)value];
    } else if (gameType == SYVoiceRoomGameCaiquan) {
        prefix = @"game_caiquan_";
        return [prefix stringByAppendingFormat:@"%ld", (long)value];
    } else if (gameType == SYVoiceRoomGameBaodeng) {
        return @"voiceroom_game_baodeng";
    } else if (gameType == SYVoiceRoomGameNumber) {
        prefix = @"game_num_result_";
        return [prefix stringByAppendingFormat:@"%ld", (long)value];
    }
    return prefix;
}

- (void)playGameWithGame:(SYVoiceRoomGameType)game
              startBlock:(void(^)(SYVoiceRoomGame *gameModel))startBlock
                endBlock:(void(^)(SYVoiceRoomGame *gameModel))endBlock {
    SYVoiceRoomGame *gameModel = [SYVoiceRoomGame new];
    if (startBlock) {
        gameModel.type = game;
        gameModel.value = [self valueWithGameType:game];
        if (startBlock) {
            startBlock(gameModel);
        }
    }
}

- (NSString *)gameImageNameWithGameType:(SYVoiceRoomGameType)gameType {
    NSInteger index = [gameTypes indexOfObject:@(gameType)];
    if (index != NSNotFound) {
        if (index >= 0 && index < [imageNames count]) {
            return imageNames[index];
        }
    }
    return @"";
}

- (NSArray *)gameAnimateImageNamesWithGameType:(SYVoiceRoomGameType)gameType {
    NSMutableArray *array = [NSMutableArray new];
    if (gameType == SYVoiceRoomGameTouzi) {
        for (int i = 1; i <= 6; i ++) {
            [array addObject:[NSString stringWithFormat:@"game_touzi_%ld", (long)i]];
        }
    } else if (gameType == SYVoiceRoomGameCaiquan) {
        for (int i = 1; i <= 3; i ++) {
            [array addObject:[NSString stringWithFormat:@"game_caiquan_%ld", (long)i]];
        }
    } else if (gameType == SYVoiceRoomGameBaodeng) {
        for (int i = 1; i <= 4; i ++) {
            [array addObject:[NSString stringWithFormat:@"game_baodeng_%ld", (long)i]];
        }
    } else if (gameType == SYVoiceRoomGameNumber) {
        for (int i = 1; i <= 16; i ++) {
            [array addObject:[NSString stringWithFormat:@"game_num_%ld", (long)i]];
        }
    }
    return array;
}

- (NSInteger)valueWithGameType:(SYVoiceRoomGameType)type {
    NSInteger value = 0;
    switch (type) {
        case SYVoiceRoomGameTouzi:
        {
            value = arc4random_uniform(6) + 1;
        }
            break;
        case SYVoiceRoomGameCaiquan:
        {
            value = arc4random_uniform(3) + 1;
        }
            break;
        case SYVoiceRoomGameNumber:
        {
            value = arc4random_uniform(9) + 1;
        }
            break;
            
        default:
            break;
    }
    return value;
}

@end
