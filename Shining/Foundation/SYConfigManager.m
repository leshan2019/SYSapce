//
//  SYConfigManager.m
//  Shining
//
//  Created by mengxiangjian on 2019/6/3.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYConfigManager.h"
#import "SYAPPServiceAPI.h"

@implementation SYConfigManager

+ (void)requestLaunchAdData:(void (^)(BOOL success, id response))complete {
    [[SYAPPServiceAPI sharedInstance] requestLaunchAdConfigWithSuccess:^(id  _Nullable response) {
        if (complete) {
            complete(YES,response);
        }
    } failure:^(NSError * _Nullable error) {
        if (complete) {
            complete(NO,nil);
        }
    }];
}


+ (void)requestConfig {
    [[SYAPPServiceAPI sharedInstance] requestSystemConfigWithSuccess:^(id  _Nullable response) {
        NSLog(@"config: %@", response);
        if ([response isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)response;
            for (NSDictionary *dict in arr) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    NSString *key = dict[@"config_name"];
                    NSNumber *value = dict[@"config_value"];
                    if ([key isEqualToString:@"share"]) {
                        [SYSettingManager setVoiceRoomShareEnable:[value boolValue]];
                    } else if ([key isEqualToString:@"propshop"]) {
                        [SYSettingManager setPropShopEnable:[value boolValue]];
                    } else if ([key isEqualToString:@"danmu"]) {
                        [SYSettingManager setVoiceRoomDanmuEnable:[value boolValue]];
                    } else if ([key isEqualToString:@"floating_screen"]) {
                        [SYSettingManager setFloatScreenTrigger:[value integerValue]];
                    } else if ([key isEqualToString:@"floating_single"]) {
                        [SYSettingManager setInternalFloatScreenTrigger:[value integerValue]];
                    } else if ([key isEqualToString:@"gift_bag"]) {
                        [SYSettingManager setVoiceRoomGiftBagEnable:[value boolValue]];
                    } else if ([key isEqualToString:@"pull_users"]) {
                        [SYSettingManager setUpdateRoleListInterval:[value integerValue]];
                    } else if ([key isEqualToString:@"breakegg_single"]) {
                        [SYSettingManager setGameInternalFloatScreenTrigger:[value integerValue]];
                    } else if ([key isEqualToString:@"breakegg_screen"]) {
                        [SYSettingManager setGameFloatScreenTrigger:[value integerValue]];
                    } else if ([key isEqualToString:@"redpacket_max"]) {
                        [SYSettingManager setRedpacketMaxCount:[value integerValue]];
                    } else if ([key isEqualToString:@"online_number"]) {
                        [SYSettingManager setVoiceRoomShowOnline:[value boolValue]];
                    } else if ([key isEqualToString:@"newred_permission"]) {
                        [SYSettingManager setRedPacketCapacityMaxLevel:[value integerValue]];
                    } else if ([key isEqualToString:@"boss_cd"]) {
                        [SYSettingManager setBossCDMinutes:[value integerValue]];
                    } else if ([key isEqualToString:@"boss_line"]) {
                        [SYSettingManager setBossTrigger:[value integerValue]];
                    } else if ([key isEqualToString:@"eggmessage_cd"]) {
                        [SYSettingManager setGameMessageInterval:[value integerValue]];
                    } else if ([key isEqualToString:@"yuyin_child"]) {
                        [SYSettingManager setChildInterval:[value integerValue]];
                    } else if ([key isEqualToString:@"room_distribution"]) {
                        [SYSettingManager setDownloadAppToast:(NSString *)value];
                    } else if ([key isEqualToString:@"sy_apiStatus"]) {
                        [SYSettingManager setSyTestApi:[value boolValue]];
                    } else if ([key isEqualToString:@"honey_cd"]) {
                        [SYSettingManager setBeeHoneyMessageCD:[value integerValue]];
                    } else if ([key isEqualToString:@"honey_single"]) {
                        [SYSettingManager setBeeGameInternalFloatScreenTrigger:[value integerValue]];
                    } else if ([key isEqualToString:@"honey_screen"]) {
                        [SYSettingManager setBeeGameFloatScreenTrigger:[value integerValue]];
                    } else if ([key isEqualToString:@"multisend_list"]) {
                        [SYSettingManager setMutiSendJson:(NSString *)value];
                    } else if ([key isEqualToString:@"identity_child"]) {
                        [SYSettingManager setChildIdentity:[value integerValue]];
                    } else if ([key isEqualToString:@"whitelist_child"]) {
                        NSString *listString = (NSString *)value;
                        NSArray *list = [listString componentsSeparatedByString:@","];
                        [SYSettingManager setRoomCategoryIdWhiteList:list];
                    } else if ([key isEqualToString:@"identity_age"]) {
                        [SYSettingManager setAdolescentModelMaxAuthAge:[value integerValue]];
                    } else if ([key isEqualToString:@"redpacket_ratio"]) {
                        [SYSettingManager setRedpacketRatio:[value floatValue]];
                    } else if ([key isEqualToString:@"groupred_switch"]) {
                        [SYSettingManager setGroupredSwitch:[value boolValue]];
                    } else if ([key isEqualToString:@"groupred_ratio"]) {
                        [SYSettingManager setGroupRedpacketRatio:[value floatValue]];
                    } else if ([key isEqualToString:@"red_screen"]) {
                        [SYSettingManager setGroupRedPacketOverScreenCount:[value floatValue]];
                    } else if ([key isEqualToString:@"voice_rec"]){
                        [SYSettingManager setSoundRecScore:[value integerValue]];
                    }else if ([key isEqualToString:@"faker_list"]){
                        [SYSettingManager setChartHideLevel:[value integerValue]];
                    } else if ([key isEqualToString:@"chargeTip"]){
                        [SYSettingManager setChargeTip:(NSString *)value];
                    } else if ([key isEqualToString:@"chargeDownloadUrl"]){
                        [SYSettingManager setChargeDownloadUrl:(NSString *)value];
                    } else if ([key isEqualToString:@"chargeswitch"]) {
                        [SYSettingManager setChargeTipOn:[value boolValue]];
                    }
                }
            }
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

@end
