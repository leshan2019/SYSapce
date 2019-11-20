//
//  SYVoiceRoomRedpacketView.h
//  Shining
//
//  Created by yangxuan on 2019/9/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYVoiceRoomRedpacketViewDelegate <NSObject>

@required
- (NSInteger)hasPassedTime;

@end

NS_ASSUME_NONNULL_BEGIN

/**
 *  聊天室 - 群红包IconView
 */
@interface SYVoiceRoomRedpacketView : UIView


- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id <SYVoiceRoomRedpacketViewDelegate>)delegate
               withClickBlock:(void(^)(void))block;

// 更新可领取红包个数
- (void)updateRedpacketCount:(NSInteger)count;

// 更新红包可领取时间
- (void)updateRedpacketGetTime:(NSInteger)time;

// 停止正在运行的定时器
- (void)stopRuningTimer;

// 能否被领取
- (BOOL)canGetRedPacket;

@end

NS_ASSUME_NONNULL_END
