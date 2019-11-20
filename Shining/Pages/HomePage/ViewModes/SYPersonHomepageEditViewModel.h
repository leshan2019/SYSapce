//
//  SYPersonHomepageEditViewModel.h
//  Shining
//
//  Created by 杨玄 on 2019/4/26.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYPersonHomepageEditPhotoView.h"
#import "SYAudioPlayer.h"

@protocol SYPersonHomepageEditViewModelDelegate <NSObject>

// 停止播放录音
- (void)SYPersonHomepageEditViewModelStopPlayRecord;

@end

NS_ASSUME_NONNULL_BEGIN

typedef void(^getHomepageDataSuccess)(BOOL success);
typedef void(^uploadPhotoSuccess)(BOOL success);
typedef void(^uploadVoiceSuccess)(BOOL success);
typedef void(^deleteVoiceSuccess)(BOOL success);
typedef void(^deletePhotoSuccess)(BOOL success);

@interface SYPersonHomepageEditViewModel : NSObject

@property (nonatomic, weak) id <SYPersonHomepageEditViewModelDelegate> delegate;

// 刷新个人数据
- (void)requestHomepageData:(getHomepageDataSuccess)result;

// 刷新个人关注和粉丝数
- (void)requestHomepageUserAttentionAndFansCount:(getHomepageDataSuccess)result;

// 上传个人形象照
- (void)requestUploadPhoto:(UIImage *)photo
                   success:(uploadPhotoSuccess)result;

// 删除形象照
- (void)requestDeletePhoto:(SYHomepagePhotoType)type
                   success:(deletePhotoSuccess)result;

// 上传录音
- (void)requestUploadVoice:(NSString *)voiceUrl
                  duration:(NSInteger)duration
                   success:(uploadVoiceSuccess)result;

// 删除录音
- (void)requestDeleteVoice:(deleteVoiceSuccess)result;

// 获取个人model
- (UserProfileEntity *)getHomepageUserModel;

// 关注数
- (NSInteger)getUserAttentionCount;

// 粉丝数
- (NSInteger)getUserFansCount;

// 获取录音url
- (NSString *)getVoiceUrl;

// 获取录音时长
- (NSInteger)getVoiceDuration;

@end

NS_ASSUME_NONNULL_END
