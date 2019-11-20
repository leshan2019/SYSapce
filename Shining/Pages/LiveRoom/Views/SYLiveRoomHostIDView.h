//
//  SYLiveRoomHostIDView.h
//  Shining
//
//  Created by mengxiangjian on 2019/9/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYLiveRoomHostIDViewDelegate <NSObject>

- (void)liveRoomHostViewDidTapUserWithUid:(NSString *)uid;
- (BOOL)liveRoomHostViewCanFollowUser;
- (void)liveRoomHostViewDidFollowUserWithUid:(NSString *)uid
                                    username:(NSString *)username;
- (void)liveRoomHostViewDidTapShowFansView:(NSDictionary*)dic;

@end

@interface SYLiveRoomHostIDView : UIView

@property (nonatomic, weak) id <SYLiveRoomHostIDViewDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isFollowing;

- (void)showWithUsername:(NSString *)username
                  userID:(NSString *)userID
                  bestID:(NSString *)bestID
               avatarURL:(NSString *)avatarURL
             followState:(BOOL)isFollowing;

- (void)setFollowState:(BOOL)isFollowing;

- (void)setUserRoleWithIsHost:(BOOL)isHost;

@end

NS_ASSUME_NONNULL_END
