//
//  SYVoiceRoomGameViewModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomGameViewModel.h"
#import "SYVoiceRoomGameManager.h"

@implementation SYVoiceRoomGameViewModel

- (NSInteger)gameCount {
    return [SYVoiceRoomGameManager gameCount];
}

- (NSString *)titleAtIndex:(NSInteger)index {
    return [SYVoiceRoomGameManager gameTitleAtIndex:index];
}

- (NSString *)imageNameAtIndex:(NSInteger)index {
    return [SYVoiceRoomGameManager gameImageNameAtIndex:index];
}

- (SYVoiceRoomGameType)gameTypeAtIndex:(NSInteger)index {
    return [SYVoiceRoomGameManager gameTypeAtIndex:index];
}

@end
