//
//  SYPersonHomepageViewModel.h
//  Shining
//
//  Created by 杨玄 on 2019/4/18.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYChatRoomModel.h"
#import "SYAudioPlayer.h"

@protocol SYPersonHomepageViewModelDelegate <NSObject>

// 停止播放录音
- (void)SYPersonHomepageViewModelStopPlayRecord;

@end

typedef void(^getHomepageDataSuccess)(BOOL success);
typedef void(^attentionUserBefore)(BOOL success);
typedef void(^attentionUserSuccess)(BOOL success);
typedef void(^getAttentionCountSuccess)(BOOL success);
typedef void(^getIfInRoomSuccess)(BOOL success);
typedef void(^getFansContributionSuccess)(BOOL success);
typedef void(^getDynamicListSuccess)(BOOL success);

NS_ASSUME_NONNULL_BEGIN

@interface SYPersonHomepageViewModel : NSObject

@property (nonatomic, weak) id <SYPersonHomepageViewModelDelegate> delegate;

// 请求个人主页数据
- (void)requestHomepageDataWithUserId:(NSString *)userId
                              success:(getHomepageDataSuccess)success;

// 请求个人主页的关注和粉丝数量
- (void)requestHomepageAttentionAndFansCountWithUserId:(NSString *)userId
                                                succes:(getAttentionCountSuccess)success;

// 判断用户是否在房间内
- (void)requestHomepageUserIfHasInChatRoomWithUserId:(NSString *)userId
                                             success:(getIfInRoomSuccess)success;

// 请求主播个人粉丝贡献榜
- (void)requestHomepageUserFansContributionListWithUserId:(NSString *)userId
                                                  success:(getFansContributionSuccess)success;

// 用户model
- (UserProfileEntity *)getHomepageUserModel;

// 用户进入的房间model
- (SYChatRoomModel *)getUserEnterRoomModel;

// 照片墙
- (NSArray *)getPhotoWallPhotoArr;

// 关注数
- (NSInteger)getUserAttentionCount;

// 粉丝数
- (NSInteger)getUserFansCount;

// 是否在房间中
- (BOOL)getUserIfEnterRoom;
- (NSString *)getUserEnterRoomIcon;
- (NSString *)getUserEnterRoomName;

// 用户坐标
- (NSString *)getUserLocation;

// 用户星座
- (NSString *)getUserConstellation;

// 关注
- (void)requestAttentionUserWithUserid:(NSString *)userId
                               success:(attentionUserSuccess)success;

// 取消关注
- (void)requestCancelAttentionUserWithUserid:(NSString *)userId
                               success:(attentionUserSuccess)success;

// 是否已经关注过用户
- (void)requestAttentionUserBefore:(NSString *)userId
                           success:(attentionUserBefore)success;

// 粉丝贡献榜list
- (NSArray *)fansContributionList;


@end

NS_ASSUME_NONNULL_END
