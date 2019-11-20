//
//  SYVoiceRoomGameViewModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYChatEngineEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomGameViewModel : NSObject

- (NSInteger)gameCount;
- (NSString *)titleAtIndex:(NSInteger)index;
- (NSString *)imageNameAtIndex:(NSInteger)index;
- (SYVoiceRoomGameType)gameTypeAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
