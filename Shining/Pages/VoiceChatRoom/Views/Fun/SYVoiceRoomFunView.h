//
//  SYVoiceRoomFunView.h
//  Shining
//
//  Created by mengxiangjian on 2019/8/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYChatEngineEnum.h"

@protocol SYVoiceRoomFunViewDelegate <NSObject>

- (void)voiceRoomFunViewDidSelectExpression:(NSInteger)expressionId;
- (void)voiceRoomFunViewDidSelectGame:(SYVoiceRoomGameType)game;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomFunView : UIView

@property (nonatomic, weak) id <SYVoiceRoomFunViewDelegate> delegate;

- (void)setGameEntranceHidden:(BOOL)hidden;
- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
