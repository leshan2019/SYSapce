//
//  SYMineSettingViewModel.m
//  Shining
//
//  Created by 杨玄 on 2019/3/21.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYMineSettingViewModel.h"
#import "SYUserServiceAPI.h"

@interface SYMineSettingViewModel ()

@property (nonatomic, strong) NSArray *dataSource;          // 数据源

@end

@implementation SYMineSettingViewModel

- (instancetype)init {
    self = [super init];
    if (self) {

#ifdef UseSettingTestDevEnv
        self.dataSource = @[@[@"清除缓存"],
                            @[@"身份认证", @"关于我们",@"用户反馈"], // @"主播麦位降噪"
                            @[@"退出登录"],@[@"调试设置"],@[@"推流测试", @"拉流测试", @"信令测试"]];
#else
        self.dataSource = @[@[@"清除缓存"],
                            @[@"身份认证", @"关于我们",@"用户反馈"],
                            @[@"退出登录"]];
#endif
    }
    return self;
}

#pragma mark - Public

- (NSInteger)numberOfSections {
    return self.dataSource.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    NSArray *subArr = [self.dataSource objectAtIndex:section];
    if (subArr) {
        return subArr.count;
    }
    return 0;
}

- (NSString *)mainTitleForIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    NSArray *subArr = [self.dataSource objectAtIndex:section];
    if (subArr) {
        return [NSString sy_safeString:[subArr objectAtIndex:item]];
    }
    return @"";
}

- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath {
    SYMineSettingCellType type = [self cellTypeForIndexPath:indexPath];
    switch (type) {
        case SYMineSettingCellType_CleanUpCache: {
            NSUInteger cacheSize = [[SDImageCache sharedImageCache] getSize];
            return [SYUtil fileSizeWithInteger:cacheSize];
        }
            break;
        case SYMineSettingCellType_Version: {
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString * currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            return currentVersion?:@"";
        }
            break;
        case SYMineSettingCellType_IDCard: {
            UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];
            NSInteger authModel = userInfo.auth_model;
            if (authModel == 2) {
                return @"已认证";
            }
            return @"未认证";
        }
            break;
        default:
            return @"";
            break;
    }
    return @"";
}

- (SYMineSettingCellType)cellTypeForIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    if (section == 0) {
        return item;
    } else if (section == 1) {
        if (item == 0) {
            return SYMineSettingCellType_IDCard;
        } else if (item == 1) {
            return SYMineSettingCellType_AboutMe;
        } else if (item == 2) {
            return SYMineSettingCellType_FeedBack;
        }
//        else if (item == 3) {
//            return SYMineSettingCellType_Noise;
//        }
    } else if (section == 2) {
        return SYMineSettingCellType_LoginOut;
    }
#ifdef UseSettingTestDevEnv
    else if (section == 3) {
        return SYMineSettingCellType_Test;
    } else if (section == 4) {
        if (item == 0) {
            return SYMineSettingCellType_TestVideoPush;
        } else if (item == 1) {
            return SYMineSettingCellType_TestVideoPull;
        } else if (item == 2) {
            return SYMineSettingCellType_TestTokenIO;
        } else {
            return SYMineSettingCellType_TestTokenIO;
        }
    }
#endif
    return SYMineSettingCellType_Unknown;
}

- (BOOL)hasOpenNewMessageNotify:(NSIndexPath *)indexPath {
    SYMineSettingCellType type = [self cellTypeForIndexPath:indexPath];
    if (type == SYMineSettingCellType_Noise) {
        return [SYSettingManager voiceRoomMicDenoiseFlag];
    }
    return [SYSettingManager isOpenNewMessageNotify];
}

- (BOOL)showBottomLine:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    NSArray *subArr = [self.dataSource objectAtIndex:section];
    if (subArr && item == subArr.count - 1) {
        return NO;
    }
    return YES;
}

@end
