//
//  SYSettingManager.h
//  Shining
//
//  Created by mengxiangjian on 2019/2/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYUserModel.h"
//#import "SmAntiFraud.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYSettingManager : NSObject

// 用户是否已经登录
+ (BOOL)userHasLogin;

+ (NSString *)deviceUUID;
//+ (SYUserModel *)userInfo;
+ (void)setAccessToken:(NSString *)token;
+ (NSString *)accessToken;
+ (void)setUserInfo:(NSString *)userJSON;

+ (void)setGuestId:(NSString *)guestId;
+ (NSString *)guestId;

// 设置 - 打开新消息通知
+ (BOOL)isOpenNewMessageNotify;
+ (void)setNewMessageNotify:(BOOL)open;

+ (void)setVoiceRoomMixingAudioVolume:(float)volume;
+ (float)voiceRoomMixingAudioVolume;

// 弹幕类型开关
+ (void)setDanmuOpen:(BOOL)open;
+ (BOOL)openDanmu;

// 聊天室分享开关
+ (void)setVoiceRoomShareEnable:(BOOL)shareEnable;
+ (BOOL)voiceRoomShareEnable;

// 道具商店开关
+ (void)setPropShopEnable:(BOOL)enable;
+ (BOOL)propShopEnable;

// 道具商店开关
+ (void)setVoiceRoomDanmuEnable:(BOOL)enable;
+ (BOOL)voiceRoomDanmuEnable;

// 全服飘屏触发值
+ (void)setFloatScreenTrigger:(NSInteger)value;
+ (NSInteger)floatScreenTrigger;

// 单房间飘屏触发值
+ (void)setInternalFloatScreenTrigger:(NSInteger)value;
+ (NSInteger)internalFloatScreenTrigger;

// 砸蛋全服飘屏触发值
+ (void)setGameFloatScreenTrigger:(NSInteger)value;
+ (NSInteger)gameFloatScreenTrigger;

// 砸蛋单房间飘屏触发值
+ (void)setGameInternalFloatScreenTrigger:(NSInteger)value;
+ (NSInteger)gameInternalFloatScreenTrigger;

// 红包入口开放等级值
+ (void)setRedPacketCapacityMaxLevel:(NSInteger)maxLevel;
+ (NSInteger)redPacketCapacityMaxLevel;

//个人红包单子最大值
+ (void)setRedpacketMaxCount:(NSInteger)value;
+ (NSInteger)redpacketMaxCount;

// 聊天室礼物背包开关
+ (void)setVoiceRoomGiftBagEnable:(BOOL)enable;
+ (BOOL)voiceroomGiftBagEnable;

// 普通用户是否显示在线人数
+ (void)setVoiceRoomShowOnline:(BOOL)show;
+ (BOOL)voiceRoomShowOnline;

// 第一次进入flag
+ (void)setOffVoiceRoomFirstEnterFlag;
+ (BOOL)isVoiceRoomFirstEnter;

// 主播麦位降噪标志位
+ (void)setVoiceRoomMicDenoiseFlag:(BOOL)flag;
+ (BOOL)voiceRoomMicDenoiseFlag;

// 更新麦位列表信息
+ (void)setUpdateRoleListInterval:(NSInteger)interval;
+ (NSInteger)updatedRoleListInterval;

// api 环境开关
+ (void)setSyTestApi:(BOOL)isTest;
+ (BOOL)syIsTestApi;

//是否设置过完善资料
+ (void)setShowNeedInfo:(BOOL)isInfo withUid:(NSString *)uid;
+ (BOOL)isShowNeedInfo:(NSString *)uid;

+ (void)setShowNeedMobile:(BOOL)isMobile;
+ (BOOL)isShowNeedMobile;

+ (void)setGameMessageInterval:(NSInteger)interval;
+ (NSInteger)gameMessageInterval;

+ (void)setBossCDMinutes:(NSInteger)minutes;
+ (NSInteger)bossCDMinutes;

+ (void)setBossTrigger:(NSInteger)trigger;
+ (NSInteger)bossTrigger;

+ (void)setChildInterval:(NSInteger)interval;
+ (NSInteger)childInterval;

+ (void)setDownloadAppToast:(NSString *)toast;
+ (NSString *)downloadAppToast;

+ (void)setBeeHoneyMessageCD:(NSInteger)cd;
+ (NSInteger)beeHoneyMessageCD;

// 采蜜全服飘屏触发值
+ (void)setBeeGameFloatScreenTrigger:(NSInteger)value;
+ (NSInteger)beeGameFloatScreenTrigger;

// 采蜜单房间飘屏触发值
+ (void)setBeeGameInternalFloatScreenTrigger:(NSInteger)value;
+ (NSInteger)beeGameInternalFloatScreenTrigger;

+ (void)setMutiSendJson:(NSString *)json;
+ (NSString *)mutiSendJson;

+ (void)setChildIdentity:(SYChildIdentityLevel)childIdentity;
+ (SYChildIdentityLevel)childIdentity;

+ (void)setRoomCategoryIdWhiteList:(NSArray <NSString *>*)roomIds;
+ (NSArray <NSString *>*)roomCategoryIdWhiteList;

+ (void)setVerifyIdentityPageShowed:(BOOL)showed;
+ (BOOL)verifyIdentityPageShowed;

// 青少年模式，身份证识别最大年龄
+ (void)setAdolescentModelMaxAuthAge:(NSInteger)age;
+ (NSInteger)getAdolescentModelMaxAuthAge;

//转账手续费比率
+ (void)setRedpacketRatio:(CGFloat)ratio;
+ (CGFloat)getRedpacketRatio;

// 搜索历史
+ (NSArray<NSString *>*)getSearchHistoryUserIds;
+ (void)saveSearchHistoryUserId:(NSString *)userId;
+ (void)cleanSearchHistroy;

// 聊天室群红包
+ (void)setGroupredSwitch:(BOOL)on;
+ (BOOL)getGroupredSwitch;

// 聊天室群红包手续费比率
+ (void)setGroupRedpacketRatio:(CGFloat)ratio;
+ (CGFloat)getGroupRedpacketRatio;

// 聊天室群红包飘屏金额
+ (void)setGroupRedPacketOverScreenCount:(CGFloat)maxCoin;
+ (CGFloat)getGroupRedPacketOverScreenCount;

+ (void)setLivingChannelID:(NSString * __nullable)channelID;
+ (NSString *)livingChannelID;

//数美deviceid
+ (NSString *) smAntiDeviceId;

//关闭直播间动效，默认开启
+ (void)setAnimationOff:(BOOL)isOff;
+ (BOOL)isAnimationOff;

//声音匹配的配置分数
+ (void)setSoundRecScore:(NSInteger)score;
+ (NSInteger)getSoundRecScore;

// 我的页面是否已经提示过“点击头像可进入个人主页哦~”
+ (void)setHasShowClickAvatarTip:(BOOL)show;
+ (BOOL)showClickAvatarTip;

//榜单隐身
+ (void)setChartHide:(BOOL)isHide;
+ (BOOL)isChartHide;
+ (void)setChartHideLevel:(NSInteger)score;
+ (NSInteger)getChartHideLevel;
// 充值提醒文案
+ (void)setChargeTip:(NSString *)chargeTip;
+ (NSString *)getChargeTip;

// 充值提醒跳转链接
+ (void)setChargeDownloadUrl:(NSString *)downloadUrl;
+ (NSString *)getChargeDonwloadUrl;

// 充值提醒开关
+ (void)setChargeTipOn:(BOOL)open;
+ (BOOL)getChargeTipOn;
@end

NS_ASSUME_NONNULL_END
