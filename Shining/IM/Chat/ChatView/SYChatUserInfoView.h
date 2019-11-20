//
//  ChatUserInfoView.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/3/5.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYChatUserInfoViewDelegate <NSObject>

@optional
- (void)addFollow:(NSString *)userId;

@end

@interface SYChatUserInfoView : UIView
@property(nonatomic,weak)id<SYChatUserInfoViewDelegate> delegate;
@property(nonatomic,assign)BOOL isFollowed;
- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame andUserInfo:(UserProfileEntity *)userProfileEntity;

- (void)refreshShowFollowText:(BOOL)isFollowed;
@end

