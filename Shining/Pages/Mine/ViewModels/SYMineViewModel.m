//
//  SYMineViewModel.m
//  Shining
//
//  Created by 杨玄 on 2019/3/25.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYMineViewModel.h"

@interface SYMineViewModel ()

@property (nonatomic, assign) BOOL hasOpenDropShop;         // 是否已经打开装扮商城开关
@property (nonatomic, strong) NSArray *dataSource;          // 数据源

@end

@implementation SYMineViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hasOpenDropShop = [SYSettingManager propShopEnable];
        self.dataSource = @[@[@"每日任务",@"我的钱包", @"我的等级"],
                            @[@"设置"]];
        if (self.hasOpenDropShop) {
            self.dataSource = @[@[@"每日任务",@"我的钱包", @"装扮商城", @"我的等级"],
                                @[@"设置"]];
        }
    }
    return self;
}

#pragma mark - Public

- (NSInteger)numberOfSections {
    return self.dataSource.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    NSArray *subArr = [self.dataSource objectAtIndex:section];
    return subArr ? subArr.count : 0;
}

- (NSString *)leftIconForIndexPath:(NSIndexPath *)indexPath {
    SYMineListCellType type = [self cellTypeforIndexPath:indexPath];
    switch (type) {
        case SYMineListCellType_MyWallet:
            return @"mine_wallet";
            break;
        case SYMineListCellType_MyDressUpStore:
            return @"mine_voice";
            break;
        case SYMineListCellType_MyVoice:
            return @"mine_voice";
            break;
        case SYMineListCellType_MyVipLevel:
            return @"mine_level";
            break;
        case SYMineListCellType_MyRecommend:
            return @"mine_sharefriend";
            break;
        case SYMineListCellType_MySetting:
            return @"mine_setting";
            break;
        case SYMineListCellType_DayTask:
            return @"mine_daytask";
            break;
        default:
            return @"";
            break;
    }
}

- (NSString *)mainTitleForIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    NSArray *subArr = [self.dataSource objectAtIndex:section];
    if (!subArr) {
        return @"";
    }
    return [NSString sy_safeString:[subArr objectAtIndex:item]];
}

- (SYMineListCellType)cellTypeforIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    if (section == 0) {
        if (item == 0) {
            return SYMineListCellType_DayTask;
        }
        if (self.hasOpenDropShop) {
            if (item == 1) {
                return SYMineListCellType_MyWallet;
            }
            else if (item == 2) {
                return SYMineListCellType_MyDressUpStore;
            } else if (item == 3) {
                return SYMineListCellType_MyVipLevel;
            }
        } else {
            if (item == 1) {
                return SYMineListCellType_MyWallet;
            }else if(item == 2){
                return SYMineListCellType_MyVipLevel;
            }
        }
    }
    if (section == 1 && item == 0) {
        return SYMineListCellType_MySetting;
    }
    return SYMineListCellType_Unknown;
}

@end
