//
//  ConversationAttentionView.h
//  Shining
//
//  Created by 杨玄 on 2019/3/16.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConversationAttentionView;

@protocol ConversationAttentionViewDelegate <NSObject>

@optional
- (void)conversationAttentionView:(ConversationAttentionView *_Nonnull)view didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)conversationAttentionView:(ConversationAttentionView *)view enterChatRoomWithRoomId:(NSString *)roomId;
@end

NS_ASSUME_NONNULL_BEGIN

/**
 *  消息模块 - 关注列表view封装
 */
@interface ConversationAttentionView : UIView

@property (nonatomic, weak) id <ConversationAttentionViewDelegate> delegate;

// 刷新关注列表
- (void)reloadAttentionViewWithDataSource:(NSMutableArray *)listArr;

@end

NS_ASSUME_NONNULL_END
