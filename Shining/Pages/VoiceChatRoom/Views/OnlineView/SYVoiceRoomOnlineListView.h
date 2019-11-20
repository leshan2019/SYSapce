//
//  SYVoiceRoomOnlineListView.h
//  Shining
//
//  Created by 杨玄 on 2019/4/23.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYVoiceRoomUserModel.h"

@protocol SYVoiceRoomOnlineListViewDelegate <NSObject>

- (void)onlineListViewDidFetchOnlineNumber:(NSInteger)num;
- (void)handleOnlineListViewClickEventWithModel:(SYVoiceRoomUserModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN

/**
 *  聊天室 - 在线用户列表
 */
@interface SYVoiceRoomOnlineListView : UIView

@property (nonatomic, weak) id <SYVoiceRoomOnlineListViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withChannelID:(NSString *)channelId;

@end

NS_ASSUME_NONNULL_END
