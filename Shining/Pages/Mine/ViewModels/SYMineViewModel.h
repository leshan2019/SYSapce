//
//  SYMineViewModel.h
//  Shining
//
//  Created by 杨玄 on 2019/3/25.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  个人中心界面cardType
 */
typedef enum : NSUInteger {
    SYMineListCellType_MyWallet = 0,        // 我的钱包
    SYMineListCellType_MyDressUpStore = 1,  // 装扮商城
    SYMineListCellType_MyVoice = 2,         // 我的声音
    SYMineListCellType_MyVipLevel = 3,      // 我的等级
    SYMineListCellType_MyRecommend = 4,     // 推荐给好友
    SYMineListCellType_MySetting = 5,       // 设置
    SYMineListCellType_Unknown = 6,          // 未知
    SYMineListCellType_DayTask = 7  //每日任务
} SYMineListCellType;

NS_ASSUME_NONNULL_BEGIN

/**
 *  个人中心 - ViewModel
 */
@interface SYMineViewModel : NSObject

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSString *)leftIconForIndexPath:(NSIndexPath *)indexPath;    // 图片
- (NSString *)mainTitleForIndexPath:(NSIndexPath *)indexPath;   // 标题
- (SYMineListCellType)cellTypeforIndexPath:(NSIndexPath *)indexPath;    // cell类型

@end

NS_ASSUME_NONNULL_END
