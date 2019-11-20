//
//  SYVoiceRoomBoardView.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SYVoiceRoomBoardViewTypeVoiceRoom,
    SYVoiceRoomBoardViewTypeLiveRoom,
} SYVoiceRoomBoardViewType;

// 聊天室排行榜入口

NS_ASSUME_NONNULL_BEGIN

@protocol SYVoiceRoomBoardViewDelegate <NSObject>

- (void)voiceRoomBoardViewDidEnterLeaderBoard;
- (void)voiceRoomBoardViewDidTouchUserWithUid:(NSString *)uid;

@end

@interface SYVoiceRoomBoardView : UIView

@property (nonatomic, weak) id <SYVoiceRoomBoardViewDelegate> delegate;

+ (CGFloat)minimumWidth;

- (instancetype)initWithFrame:(CGRect)frame
                    channelID:(NSString *)channelID;

- (instancetype)initWithFrame:(CGRect)frame
                    channelID:(NSString *)channelID
                         type:(SYVoiceRoomBoardViewType)type;

- (void)requestData;

@end

NS_ASSUME_NONNULL_END
