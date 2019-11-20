//
//  SYVoiceRoomPropView.h
//  Shining
//
//  Created by mengxiangjian on 2019/5/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BuyGiftForFriendBlock)(BOOL success, NSInteger code);

NS_ASSUME_NONNULL_BEGIN

@protocol SYVoiceRoomPropViewDelegate <NSObject>

- (void)propViewDidLackOfBalance;
- (void)propViewDidSelectAvatarBox:(NSString *)avatarBox;
- (void)propViewDidSlelectDriverBox:(NSInteger)propID;
// 点击赠送按钮
- (void)propViewClickGiveGiftsBtn;
@end

@interface SYVoiceRoomPropView : UIView

@property (nonatomic, weak) id <SYVoiceRoomPropViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
                     propType:(NSInteger)propType;

- (void)requestData;

// 赠送礼物接口
- (void)buyGiftForFriend:(NSString *)userId success:(BuyGiftForFriendBlock)block;

@end

NS_ASSUME_NONNULL_END
