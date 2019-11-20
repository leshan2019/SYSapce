//
//  SYMineAboutUsViewModel.m
//  Shining
//
//  Created by 杨玄 on 2019/3/28.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYMineAboutUsViewModel.h"

@interface SYMineAboutUsViewModel ()

@property (nonatomic, strong) NSArray *dataSource;          // 数据源

@end

@implementation SYMineAboutUsViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataSource = @[@"社区规范", @"用户协议", @"客服QQ"];
    }
    return self;
}

#pragma mark - Public

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (NSString *)mainTitleForIndexPath:(NSIndexPath *)indexPath {
    return [NSString sy_safeString:[self.dataSource objectAtIndex:indexPath.row]];
}

- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath {
    SYMineAboutUsCellType type = [self cellTypeForIndexPath:indexPath];
    if (type == SYMineAboutUsCellType_ServiceQQ) {
        return @"3301263576";
    }
    return @"";
}

- (SYMineAboutUsCellType)cellTypeForIndexPath:(NSIndexPath *)indexPath {
    NSInteger item = indexPath.item;
    if (item < 0 || item > self.dataSource.count) {
        return SYMineAboutUsCellType_Unknown;
    }
    return item;
}

@end
