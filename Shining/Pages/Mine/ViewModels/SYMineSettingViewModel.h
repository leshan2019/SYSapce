//
//  SYMineSettingViewModel.h
//  Shining
//
//  Created by 杨玄 on 2019/3/21.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  设置界面 - 身份认证结果类型
 */
typedef enum : NSUInteger {
    SYUserIDCardVerifyType_NoAuthority = 0,     // 未认证
    SYUserIDCardVerifyType_Authorizing = 1,     // 认证中
    SYUserIDCardVerifyType_Authoritative = 2,   // 已认证
    SYUserIDCardVerifyType_Unknown              // 未知
} SYUserIDCardVerifyType;

/**
 *  设置界面 - cardType
 */
typedef enum : NSUInteger {
    SYMineSettingCellType_CleanUpCache = 0, // 清除缓存
    SYMineSettingCellType_NewMessage = 1,   // 新消息通知
    SYMineSettingCellType_Version = 2,      // 版本检测
    SYMineSettingCellType_IDCard = 3,       // 身份认证
    SYMineSettingCellType_AboutMe = 4,      // 关于我们
    SYMineSettingCellType_LoginOut = 5,     // 退出登录
    SYMineSettingCellType_FeedBack = 6,     // 用户反馈
    SYMineSettingCellType_Test = 7,         // 调试设置
    SYMineSettingCellType_Noise,            // 降噪开关
    SYMineSettingCellType_Unknown,          // 未知
    SYMineSettingCellType_TestVideoPush,    // 测试推流
    SYMineSettingCellType_TestVideoPull,    // 测试拉流
    SYMineSettingCellType_TestTokenIO,          // 信令测试
} SYMineSettingCellType;

NS_ASSUME_NONNULL_BEGIN

/**
 *  设置 - ViewModel
 */
@interface SYMineSettingViewModel : NSObject

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSString *)mainTitleForIndexPath:(NSIndexPath *)indexPath;   // 标题
- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath;    // 副标题
- (SYMineSettingCellType)cellTypeForIndexPath:(NSIndexPath *)indexPath;
- (BOOL)hasOpenNewMessageNotify:(NSIndexPath *)indexPath ;      // 是否打开新消息通知
- (BOOL)showBottomLine:(NSIndexPath *)indexPath;                // 是否展示分割线
@end

NS_ASSUME_NONNULL_END
