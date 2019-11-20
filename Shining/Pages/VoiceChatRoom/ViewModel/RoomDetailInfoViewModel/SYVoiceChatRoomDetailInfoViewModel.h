//
//  SYVoiceChatRoomDetailInfoViewModel.h
//  Shining
//
//  Created by 杨玄 on 2019/3/13.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SYVoiceChatRoomName         = 0,    // 房间名称
    SYVoiceChatRoomPlay         = 1,    // 玩法公告
    SYVoiceChatRoomWelcome      = 2,    // 欢迎语
    SYVoiceChatRoomCover_1_1    = 3,    // 房间封面1:1
//    SYVoiceChatRoomCover_16_9   = 4,    // 房间封面16:9
    SYVoiceChatRoomBackdrop     = 4,    // 房间背景
    SYVoiceChatRoomManagerList  = 5,    // 管理员列表
    SYVoiceChatRoomForbideChat  = 6,    // 禁言名单
    SYVoiceChatRoomForbideEnter = 7,    // 禁入名单
    SYVoiceChatRoomEncryption   = 8,    // 房间加密
    SYVoiceChatRoomPassword     = 9,   // 房间密码
    SYVoiceChatRoomUnknow       //未知
} SYVoiceChatRoomDetailInfoType;

@protocol SYVoiceChatRoomDetailInfoViewModelDelegate <NSObject>

- (void)getChannelInfoSuccess;
- (void)getChannelInfoFailed;

@end

NS_ASSUME_NONNULL_BEGIN

typedef void(^openEncryptionBlock)(BOOL success);

@interface SYVoiceChatRoomDetailInfoViewModel : NSObject

@property (nonatomic, weak) id <SYVoiceChatRoomDetailInfoViewModelDelegate> delegate;

@property (nonatomic, assign) BOOL isRoomOwner;     // 房主

@property (nonatomic, assign) BOOL isLiving;        // 是否是直播

// 获取房间信息
- (void)requestChannelInfoWithChannelID:(NSString *)channelID;

// 打开加密按钮
- (void)openRoomEncryptionWithChannelId:(NSString *)channelId password:(NSString *)password success:(openEncryptionBlock)success;

// 关闭加密按钮
- (void)closeRoomEncryptionWithChannelId:(NSString *)channelId success:(openEncryptionBlock)success;

// Cell相关数据获取api
- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSString *)mainTitleWithIndexPath:(NSIndexPath *)indexPath;
- (NSString *)subTitleWithIndexPath:(NSIndexPath *)indexPath;
- (NSString *)subImageUrlStrWithIndexPath:(NSIndexPath *)indexPath;
- (BOOL)showBottomLine:(NSIndexPath *)indexPath;
- (BOOL)showUISwitchBtn:(NSIndexPath *)indexPath;
- (BOOL)judgeUISwitchBtnOpenState:(NSIndexPath *)indexPath;
- (SYVoiceChatRoomDetailInfoType)cellTypeWithIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)roomBackDropNum;

@end

NS_ASSUME_NONNULL_END
