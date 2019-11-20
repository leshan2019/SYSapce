//
//  SYSettingManager.m
//  Shining
//
//  Created by mengxiangjian on 2019/2/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYSettingManager.h"
#import "SAMCategories.h"
#import "NSString+SYExtension.h"
#import "YYModel.h"
#import "ShiningSdkManager.h"

@implementation SYSettingManager

+ (BOOL)userHasLogin {
    NSString *accessToken = [NSString sy_safeString:[SYSettingManager accessToken]];
    UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];
    if (accessToken.length > 0 && userInfo && userInfo.userid.length > 0) {
        return YES;
    }
    return NO;
}

+ (NSString *)deviceUUID {
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
    if (!uuid) {
        uuid = [NSString sam_stringWithUUID];
        if (uuid) {
            [[NSUserDefaults standardUserDefaults] setObject:uuid
                                                      forKey:@"uuid"];
        }
    }
    return uuid;
}

+ (void)setAccessToken:(NSString *)token{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString sy_safeString:token]
                                                  forKey:@"accessToken"];

}

+ (NSString *)accessToken
{
//    return @"917a669fee0eba0819ee71384691dbee2660bac9bc2b29218bcea119b4a3fae72c9e15b423369f7beb14123307fd51d01c0ea3e1b565363306a70bcd15763a040eccb83000735a8975285f3eca877c3d";
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    return uuid;
}

+ (void)setUserInfo:(NSString *)userJSON {
    [[NSUserDefaults standardUserDefaults] setObject:userJSON
                                              forKey:@"user"];
}

+ (SYUserModel *)userInfo {
    SYUserModel *user = [[SYUserModel alloc]init];
    user.uid = @"test";
    NSString *json = [[NSUserDefaults standardUserDefaults] stringForKey:@"user"];
    if (json) {
        user = [SYUserModel yy_modelWithJSON:json];
        user.agoraToken = @"_no_need_token";
        user.uid = @"1000000";
    }
    return user;
}

+ (void)setGuestId:(NSString *)guestId {
    if (![NSString sy_isBlankString:guestId]) {
        [[NSUserDefaults standardUserDefaults] setObject:guestId
                                                  forKey:@"ShanYinGuestId"];
    }
}

+ (NSString *)guestId {
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"ShanYinGuestId"];
    return uuid;
}

+ (BOOL)isOpenNewMessageNotify {
    BOOL open = [[NSUserDefaults standardUserDefaults] boolForKey:@"OpenMessageNotify"];
    return open;
}

+ (void)setNewMessageNotify:(BOOL)open {
    [[NSUserDefaults standardUserDefaults] setBool:open forKey:@"OpenMessageNotify"];
}

+ (void)setVoiceRoomMixingAudioVolume:(float)volume {
    [[NSUserDefaults standardUserDefaults] setFloat:volume
                                             forKey:@"Mixing_Audio_Volume"];
}

+ (float)voiceRoomMixingAudioVolume {
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"Mixing_Audio_Volume"];
    if (number) {
        return [number floatValue];
    }
    return 0.25;
}

+ (void)setDanmuOpen:(BOOL)open {
    [[NSUserDefaults standardUserDefaults] setBool:open forKey:@"ChatRoom_open_danmu"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)openDanmu {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ChatRoom_open_danmu"];
}


+ (void)setVoiceRoomShareEnable:(BOOL)shareEnable {
    [[NSUserDefaults standardUserDefaults] setBool:shareEnable forKey:@"ChatRoom_Share_Enable"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)voiceRoomShareEnable {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ChatRoom_Share_Enable"];
}

+ (void)setPropShopEnable:(BOOL)enable {
    [[NSUserDefaults standardUserDefaults] setBool:enable forKey:@"ChatRoom_PropShop_Enable"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)propShopEnable {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ChatRoom_PropShop_Enable"];
}

// 道具商店开关
+ (void)setVoiceRoomDanmuEnable:(BOOL)enable {
    [[NSUserDefaults standardUserDefaults] setBool:enable forKey:@"ChatRoom_Danmu_Enable"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)voiceRoomDanmuEnable {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ChatRoom_Danmu_Enable"];
}

// 全服飘屏触发值
+ (void)setFloatScreenTrigger:(NSInteger)value {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:@"ChatRoom_FloatScreen_Value"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)floatScreenTrigger {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"ChatRoom_FloatScreen_Value"];
}

// 单房间飘屏触发值
+ (void)setInternalFloatScreenTrigger:(NSInteger)value {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:@"ChatRoom_InternalFloatScreen_Value"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)internalFloatScreenTrigger {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"ChatRoom_InternalFloatScreen_Value"];
}

// 砸蛋全服飘屏触发值
+ (void)setGameFloatScreenTrigger:(NSInteger)value {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:@"ChatRoom_GameFloatScreen_Value"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSInteger)gameFloatScreenTrigger {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"ChatRoom_GameFloatScreen_Value"];
}

// 砸蛋单房间飘屏触发值
+ (void)setGameInternalFloatScreenTrigger:(NSInteger)value {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:@"ChatRoom_GameInternalFloatScreen_Value"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)gameInternalFloatScreenTrigger {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"ChatRoom_GameInternalFloatScreen_Value"];
}

#pragma mark - RedPacket

+ (void)setRedPacketCapacityMaxLevel:(NSInteger)maxLevel {
    [[NSUserDefaults standardUserDefaults] setInteger:maxLevel forKey:@"IM_Redpacket_Permission"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)redPacketCapacityMaxLevel {
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:@"IM_Redpacket_Permission"];
    if (count < 0) {
        count = 0;
    }
    return count;
}

+ (void)setRedpacketMaxCount:(NSInteger)value {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:@"IM_RedpacketMaxCoun_Value"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)redpacketMaxCount {
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:@"IM_RedpacketMaxCoun_Value"];
    if (count <= 0) {
        count = 10000;
    }
    return count;
}

// 聊天室礼物背包开关
+ (void)setVoiceRoomGiftBagEnable:(BOOL)enable {
    [[NSUserDefaults standardUserDefaults] setBool:enable forKey:@"ChatRoom_GiftBag_Enable"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)voiceroomGiftBagEnable {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ChatRoom_GiftBag_Enable"];
}

// 普通用户是否显示在线人数
+ (void)setVoiceRoomShowOnline:(BOOL)show {
    [[NSUserDefaults standardUserDefaults] setBool:show forKey:@"ChatRoom_Online_Enable"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)voiceRoomShowOnline {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ChatRoom_Online_Enable"];
}

// 第一次进入flag
+ (void)setOffVoiceRoomFirstEnterFlag {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ChatRoom_FirstEnter_Flag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isVoiceRoomFirstEnter {
    NSNumber *n = [[NSUserDefaults standardUserDefaults] objectForKey:@"ChatRoom_FirstEnter_Flag"];
    if (!n) {
        return YES;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ChatRoom_FirstEnter_Flag"];
}

// 主播麦位降噪标志位
+ (void)setVoiceRoomMicDenoiseFlag:(BOOL)flag {
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:@"ChatRoom_Denoise_Flag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)voiceRoomMicDenoiseFlag {
    NSNumber *n = [[NSUserDefaults standardUserDefaults] objectForKey:@"ChatRoom_Denoise_Flag"];
    if (!n) {
        return YES;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ChatRoom_Denoise_Flag"];
}

// 更新麦位列表信息
+ (void)setUpdateRoleListInterval:(NSInteger)interval {
    [[NSUserDefaults standardUserDefaults] setInteger:interval forKey:@"ChatRoom_RoleList_Interval"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)updatedRoleListInterval {
    NSNumber *n = [[NSUserDefaults standardUserDefaults] objectForKey:@"ChatRoom_RoleList_Interval"];
    if (!n) {
        return 60;
    }
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"ChatRoom_RoleList_Interval"];
}

// api 环境开关
+ (void)setSyTestApi:(BOOL)isTest {
#ifdef UseSettingTestDevEnv
    [[NSUserDefaults standardUserDefaults] setBool:isTest forKey:@"kTestAPIKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
#else
    [[NSUserDefaults standardUserDefaults] setBool:isTest forKey:@"kProductTestAPIKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
#endif
}

+ (BOOL)syIsTestApi {
#ifdef UseSettingTestDevEnv
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kTestAPIKey"]) {
        return [[NSUserDefaults standardUserDefaults] boolForKey:@"kTestAPIKey"];
    }else {//开发模式下 未设置开关转态 默认为测试环境
        return YES;
    }
#else
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kProductTestAPIKey"]) {
        return [[NSUserDefaults standardUserDefaults] boolForKey:@"kProductTestAPIKey"];
    }else {//开发模式下 未设置开关转态 默认为测试环境
        return NO;
    }
#endif
}


+ (void)setShowNeedMobile:(BOOL)isMobile {
    [[NSUserDefaults standardUserDefaults] setBool:isMobile forKey:@"sy_need_mobile"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isShowNeedMobile {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"sy_need_mobile"];
}


+ (void)setShowNeedInfo:(BOOL)isInfo withUid:(NSString *)uid {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSDictionary *needInfoDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"sy_need_info"];
    if (needInfoDict) {
        [dict addEntriesFromDictionary:needInfoDict];
    }
    [dict setObject:[NSNumber numberWithBool:isInfo] forKey:uid];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"sy_need_info"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isShowNeedInfo:(NSString *)uid {
    NSDictionary *needInfoDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"sy_need_info"];
    NSNumber *isShow = [needInfoDict objectForKey:uid];
    if (isShow) {
        return [isShow boolValue];
    }else {
        return NO;
    }
}

+ (void)setGameMessageInterval:(NSInteger)interval {
    [[NSUserDefaults standardUserDefaults] setInteger:interval forKey:@"sy_game_cd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)gameMessageInterval {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"sy_game_cd"]) {
        return 60;
    }
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"sy_game_cd"];
}

+ (void)setBossCDMinutes:(NSInteger)minutes {
    [[NSUserDefaults standardUserDefaults] setInteger:minutes forKey:@"sy_boss_cd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)bossCDMinutes {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"sy_boss_cd"]) {
        return 120;
    }
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"sy_boss_cd"];
}

+ (void)setBossTrigger:(NSInteger)trigger {
    [[NSUserDefaults standardUserDefaults] setInteger:trigger forKey:@"sy_boss_trigger"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)bossTrigger {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"sy_boss_trigger"]) {
        return 520;
    }
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"sy_boss_trigger"];
}

+ (void)setChildInterval:(NSInteger)interval {
    [[NSUserDefaults standardUserDefaults] setInteger:interval forKey:@"sy_child_cd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)childInterval {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"sy_child_cd"]) {
        return 1;
    }
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"sy_child_cd"];
}

+ (void)setDownloadAppToast:(NSString *)toast {
    if (toast) {
        [[NSUserDefaults standardUserDefaults] setObject:toast forKey:@"sy_room_distribution"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSString *)downloadAppToast {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"sy_room_distribution"];
}

+ (void)setBeeHoneyMessageCD:(NSInteger)cd {
    [[NSUserDefaults standardUserDefaults] setInteger:cd forKey:@"sy_beeHoney_cd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)beeHoneyMessageCD {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"sy_beeHoney_cd"]) {
        return 60;
    }
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"sy_beeHoney_cd"];
}

// 砸蛋全服飘屏触发值
+ (void)setBeeGameFloatScreenTrigger:(NSInteger)value {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:@"ChatRoom_BeeGameFloatScreen_Value"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)beeGameFloatScreenTrigger {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"ChatRoom_BeeGameFloatScreen_Value"];
}

// 砸蛋单房间飘屏触发值
+ (void)setBeeGameInternalFloatScreenTrigger:(NSInteger)value {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:@"ChatRoom_BeeGameInternalFloatScreen_Value"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)beeGameInternalFloatScreenTrigger {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"ChatRoom_BeeGameInternalFloatScreen_Value"];
}

+ (void)setMutiSendJson:(NSString *)json {
    if (json) {
        [[NSUserDefaults standardUserDefaults] setObject:json forKey:@"sy_mutisend_json"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSString *)mutiSendJson {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"sy_mutisend_json"];
}

+ (void)setChildIdentity:(SYChildIdentityLevel)childIdentity {
    [[NSUserDefaults standardUserDefaults] setInteger:childIdentity
                                               forKey:@"sy_child_identity"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (SYChildIdentityLevel)childIdentity {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"sy_child_identity"];
}

+ (void)setRoomCategoryIdWhiteList:(NSArray <NSString *>*)roomIds {
    if (roomIds) {
        [[NSUserDefaults standardUserDefaults] setObject:roomIds
                                                  forKey:@"sy_roomCategoryId_whiteList"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSArray <NSString *>*)roomCategoryIdWhiteList {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"sy_roomCategoryId_whiteList"];
}

+ (void)setVerifyIdentityPageShowed:(BOOL)showed {
    [[NSUserDefaults standardUserDefaults] setBool:showed
                                            forKey:@"sy_verifyIdentity_showed"];
}

+ (BOOL)verifyIdentityPageShowed {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"sy_verifyIdentity_showed"];
}

+ (void)setAdolescentModelMaxAuthAge:(NSInteger)age {
    [[NSUserDefaults standardUserDefaults] setInteger:age forKey:@"sy_adolesentmodel_max_age"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)getAdolescentModelMaxAuthAge {
    NSInteger age = [[NSUserDefaults standardUserDefaults] integerForKey:@"sy_adolesentmodel_max_age"];
    if (age <= 0) {
        return 18;
    }
    return age;
}

+ (void)setRedpacketRatio:(CGFloat)ratio {
    [[NSUserDefaults standardUserDefaults] setFloat:ratio forKey:@"sy_transferpay_redpacket_ratio"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (CGFloat)getRedpacketRatio {
    CGFloat age = [[NSUserDefaults standardUserDefaults] floatForKey:@"sy_transferpay_redpacket_ratio"];
    return age;
}

+ (NSArray<NSString *> *)getSearchHistoryUserIds {
    NSArray *historyIds = [[NSUserDefaults standardUserDefaults] objectForKey:@"sy_search_history"];
    if (!historyIds) {
        historyIds = @[];
    }
    return historyIds;
}

+ (void)saveSearchHistoryUserId:(NSString *)userId {
    if (userId && userId.length > 0) {
        NSArray *historyArr = [SYSettingManager getSearchHistoryUserIds];
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:historyArr];
        if ([tempArr containsObject:userId]) {  // 删除重复元素
            [tempArr removeObject:userId];
        }
        [tempArr insertObject:userId atIndex:0];
        if (tempArr.count > 6) {                // 只保留最新的6条数据
            [tempArr removeLastObject];
        }
        NSArray *finalArr = [tempArr copy];
        [[NSUserDefaults standardUserDefaults] setObject:finalArr forKey:@"sy_search_history"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)cleanSearchHistroy {
    [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:@"sy_search_history"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+ (void)setGroupredSwitch:(BOOL)on {
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:@"sy_groupred_switch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getGroupredSwitch {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"sy_groupred_switch"];
}

+ (void)setGroupRedpacketRatio:(CGFloat)ratio {
    [[NSUserDefaults standardUserDefaults] setFloat:ratio forKey:@"sy_group_redpacket_ratio"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (CGFloat)getGroupRedpacketRatio {
    CGFloat ratio = [[NSUserDefaults standardUserDefaults] floatForKey:@"sy_group_redpacket_ratio"];
    return ratio;
}

+ (void)setGroupRedPacketOverScreenCount:(CGFloat)maxCoin {
    [[NSUserDefaults standardUserDefaults] setFloat:maxCoin forKey:@"sy_group_redpacket_overScreen_count"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (CGFloat)getGroupRedPacketOverScreenCount {
    CGFloat count = [[NSUserDefaults standardUserDefaults] floatForKey:@"sy_group_redpacket_overScreen_count"];
    return count;
}

+ (void)setLivingChannelID:(NSString *)channelID {
    if (![NSString sy_isBlankString:channelID]) {
        [[NSUserDefaults standardUserDefaults] setObject:channelID
                                                  forKey:@"sy_living_channel_id"];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sy_living_channel_id"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)livingChannelID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"sy_living_channel_id"];
}


+ (NSString *) smAntiDeviceId {
#ifdef ShiningSdk
    return [ShiningSdkManager le_did];
#else
    return @"";//[[SmAntiFraud shareInstance] getDeviceId];
#endif
}

//关闭直播间动效，默认开启
+ (void)setAnimationOff:(BOOL)isOff
{
    [[NSUserDefaults standardUserDefaults] setBool:isOff
                                            forKey:@"sy_animation_off"];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isAnimationOff
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"sy_animation_off"]) {
        return NO;
    }
     return [[NSUserDefaults standardUserDefaults] boolForKey:@"sy_animation_off"];
}

//榜单隐身，默认关闭
+ (void)setChartHide:(BOOL)isHide
{
    [[NSUserDefaults standardUserDefaults] setBool:isHide
                                              forKey:@"sy_chart_hide"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+ (BOOL)isChartHide
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"sy_chart_hide"]) {
        return NO;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"sy_chart_hide"];
}


+ (void)setSoundRecScore:(NSInteger)score
{
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"sy_sound_recScore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)getSoundRecScore
{
    NSInteger age = [[NSUserDefaults standardUserDefaults] integerForKey:@"sy_sound_recScore"];
    return age;
}

+ (void)setChartHideLevel:(NSInteger)score
{
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"sy_chart_level"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)getChartHideLevel
{
    NSInteger level = [[NSUserDefaults standardUserDefaults] integerForKey:@"sy_chart_level"];
    if (level<=0) {
        level = 25;
    }
    return level;
}

+ (void)setHasShowClickAvatarTip:(BOOL)show {
    [[NSUserDefaults standardUserDefaults] setBool:show
                                            forKey:@"sy_mine_click_avatar_tip"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)showClickAvatarTip {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"sy_mine_click_avatar_tip"]) {
        return YES;
    }
    return ![[NSUserDefaults standardUserDefaults] boolForKey:@"sy_mine_click_avatar_tip"];;
}

// 充值提醒文案
+ (void)setChargeTip:(NSString *)chargeTip {
    [[NSUserDefaults standardUserDefaults] setObject:chargeTip forKey:@"sy_charge_tip"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getChargeTip {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"sy_charge_tip"];
}

// 充值提醒跳转链接
+ (void)setChargeDownloadUrl:(NSString *)downloadUrl {
    [[NSUserDefaults standardUserDefaults] setObject:downloadUrl forKey:@"sy_charge_download_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getChargeDonwloadUrl {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"sy_charge_download_url"];
}

+ (void)setChargeTipOn:(BOOL)open {
    [[NSUserDefaults standardUserDefaults] setBool:open
                                               forKey:@"sy_charge_tip_open"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getChargeTipOn {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"sy_charge_tip_open"];;
}

@end
