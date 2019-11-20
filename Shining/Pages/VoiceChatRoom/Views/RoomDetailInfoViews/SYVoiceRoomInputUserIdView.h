//
//  SYVoiceRoomInputUserIdView.h
//  Shining
//
//  Created by 杨玄 on 2019/3/14.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYVoiceRoomInputUserIdViewDelegate <NSObject>

- (void)handleInputUserIdViewCancelBtnClick;

- (void)handleInputUserIdViewAddBtnClick;

@end

NS_ASSUME_NONNULL_BEGIN

/**
 *  添加管理员，输入用户id弹窗
 */
@interface SYVoiceRoomInputUserIdView : UIView

@property (nonatomic, weak) id <SYVoiceRoomInputUserIdViewDelegate> delegate;

@property (nonatomic, readonly, copy) NSString *userId; //用户id

@end

NS_ASSUME_NONNULL_END
