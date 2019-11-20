//
//  SYVoiceRoomGiveGiftView.h
//  Shining
//
//  Created by 杨玄 on 2019/8/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYVoiceRoomGiveGiftViewDelegate <NSObject>

// 赠送好友
- (void)SYVoiceRoomGiveGiftViewClickGiveFriendBtn;
// 购买
- (void)SYVoiceRoomGiveGiftViewClickBuyBtn:(NSString *_Nonnull)userId;

@end

NS_ASSUME_NONNULL_BEGIN

/**
 *  装扮赠送view
 */
@interface SYVoiceRoomGiveGiftView : UIView

@property (nonatomic, weak) id <SYVoiceRoomGiveGiftViewDelegate> delegate;

- (void)updateGiveFriendId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
