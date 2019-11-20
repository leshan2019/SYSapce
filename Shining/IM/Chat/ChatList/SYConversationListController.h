//
//  ConversationListController.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/2/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "EaseConversationListViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  聊天列表
 */
@interface SYConversationListController : EaseConversationListViewController

// 此vc被用于"私信"功能
@property (nonatomic, assign) BOOL usedByPrivateMessage;

@property (strong, nonatomic) NSMutableArray *conversationsArray;

- (void)refresh;
- (void)refreshDataSource;

- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;
@end

NS_ASSUME_NONNULL_END
