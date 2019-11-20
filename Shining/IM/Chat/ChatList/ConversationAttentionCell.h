//
//  ConversationAttentionCell.h
//  Shining
//
//  Created by 杨玄 on 2019/3/15.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConversationAttentionCellDelegate <NSObject>

- (void)ConversationAttentionCellClickEnterChatRoomWithRoomId:(NSString *_Nonnull)roomId;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ConversationAttentionCell : UITableViewCell

@property (nonatomic, weak) id <ConversationAttentionCellDelegate> delegate;

- (void)updateCellWithHeaderImage:(NSString *)imageUrl
                         withName:(NSString *)name
                       withGender:(NSString *)gender
                          withAge:(NSUInteger)age
                           withId:(NSString *)idText
                       withRoomId:(NSString *)roomId;

@end

NS_ASSUME_NONNULL_END
