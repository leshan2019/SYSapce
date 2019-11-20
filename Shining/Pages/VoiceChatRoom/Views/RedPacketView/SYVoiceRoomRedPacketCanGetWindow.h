//
//  SYVoiceRoomRedPacketCanGetWindow.h
//  Shining
//
//  Created by yangxuan on 2019/9/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol  SYVoiceRoomRedPacketCanGetWindowDelegate <NSObject>

@required
- (void)SYVoiceRoomRedPacketCanGetWindowClickGetBtn:(id)model;
- (NSInteger)hasPassedTime;

@end

/**
 *  聊天室 - 未领取的红包弹窗
 */
@interface SYVoiceRoomRedPacketCanGetWindow : UIView

@property (nonatomic, weak) id <SYVoiceRoomRedPacketCanGetWindowDelegate> delegate;

// 更新未领取红包列表数据
- (void)updateRecpacketData:(NSArray *)data;

@end

NS_ASSUME_NONNULL_END
