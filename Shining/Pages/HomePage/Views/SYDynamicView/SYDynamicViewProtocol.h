//
//  SYDynamicViewProtocol.h
//  Shining
//
//  Created by yangxuan on 2019/10/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 关注更新
typedef void(^AttentionBlock)(BOOL sucess);

@protocol SYDynamicViewProtocol <NSObject>

@optional

// 登录
- (void)SYDynamicViewClickLogin;

// 点击头像 - 进入个人主页
- (void)SYDynamicViewClickAvatar:(NSString *)userId;
// 点击直播中 - 进入直播间
- (void)SYDynamicViewClickEnterLivingRoom:(NSString *)roomId;
// 删除动态
- (void)SYDynamicViewClickDelete:(NSString *)momentId;
// 浏览图片 - 不用了
- (void)SYDynamicViewClickScanPhoto:(NSString *)photoUrl;
// 播放视频
- (void)SYDynamicViewClickPlayVideo:(NSString *)videoUrl;
// 关注主播
- (void)SYDynamicViewClickAttentionUser:(NSString *)userId
                               momentId:(NSString *)momentId
                                  block:(AttentionBlock)attentionBlock;
// 点赞+取消
- (void)SYDynamicViewClickLike:(BOOL)like
                      momentId:(NSString *)momentId
                        userId:(NSString *)userId;
// 评论
- (void)SYDynamicViewClickComment:(NSString *)momentId
                           userId:(NSString *)userId
                 onlyShowKeyboard:(BOOL)show;
// 打招呼
- (void)SYDynamicViewClickGreet:(UserProfileEntity *)userModel;

@end

NS_ASSUME_NONNULL_END
