//
//  SYMineVerifyIDCardViewModel.m
//  Shining
//
//  Created by 杨玄 on 2019/3/28.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYMineVerifyIDCardViewModel.h"

@interface SYMineVerifyIDCardViewModel ()

@property (nonatomic, strong) NSArray *dataSource;          // 数据源

@end

@implementation SYMineVerifyIDCardViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataSource = @[@[@"姓名", @"身份证号"],
                            @[@"身份证正面照", @"身份证反面照", @"手持身份证照"]];
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
    SYMineVerifyIDCardCellType type = [self cellTypeForIndexPath:indexPath];
    switch (type) {
        case SYMineVerifyIDCardCellType_IDCard_Name:
        {
            return @"请输入身份证上的姓名";
        }
            break;
        case SYMineVerifyIDCardCellType_IDCard_Number:
        {
            return @"请输入身份证上的号码";
        }
            break;
        case SYMineVerifyIDCardCellType_IDCard_Front:
        case SYMineVerifyIDCardCellType_IDCard_Reverse:
        case SYMineVerifyIDCardCellType_IDCard_HandSelf:
        {
            return @"仅支持.jpg格式";
        }
            break;
        default:
            return @"";
            break;
    }
    return @"";
}

- (SYMineVerifyIDCardCellType)cellTypeForIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    if (section == 0) {
        return item;
    } else if (section == 1) {
        if (item == 0) {
            return SYMineVerifyIDCardCellType_IDCard_Front;
        } else if (item == 1) {
            return SYMineVerifyIDCardCellType_IDCard_Reverse;
        } else if (item == 2) {
            return SYMineVerifyIDCardCellType_IDCard_HandSelf;
        }
    }
    return SYMineVerifyIDCardCellType_Unknow;
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
