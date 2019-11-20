//
//  ConversationListCell.h
//  Shining
//
//  Created by 杨玄 on 2019/3/15.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYVoiceRoomSexView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  消息模块 - 聊天列表cell
 */
@interface ConversationListCell : UITableViewCell

@property (strong, nonatomic) UIImageView *avatarView;
@property (strong, nonatomic) UILabel *badgeView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) SYVoiceRoomSexView *sexView;
@property (strong, nonatomic) UIView *bottomLine;

@property (strong, nonatomic) id<IConversationModel> model;

@end

NS_ASSUME_NONNULL_END
