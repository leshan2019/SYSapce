//
//  SYDayTaskViewModel.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/9/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYDayTaskViewModel.h"
#import "SYGiftNetManager.h"

@interface SYDayTaskViewModel()
{
    SYGiftNetManager *_netManager;
}
@property (nonatomic, strong) NSArray *dataSource;          // 数据源
@end

@implementation SYDayTaskViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _netManager = [SYGiftNetManager new];
        self.dataSource = @[@"签到任务",@"观看两场直播(单场>=5min)(0/2)",@"直播间发表2条评论(0/2)",@"微信分享直播间",@"关注10个主播(0/5)",@"直播间内打赏主播超2000蜜豆(0/2000)"];
       
    }
    return self;
}

- (void)updateListData:(void(^)(BOOL))finishBlock {
    
    [_netManager requestDayTaskListWithSuccess:^(id  _Nullable response) {
        NSDictionary *dict = (NSDictionary *)response;
//        NSString *code = [dict objectForKey:@"code"];
        NSArray *listArray = [dict objectForKey:@"list"];
        NSMutableArray *array = [NSMutableArray array];
        for (int i=0; i<listArray.count; i++) {
            NSDictionary *modelDict = listArray[i];
            SYDayTaskItemModel *model = [SYDayTaskItemModel yy_modelWithDictionary:modelDict];
            if (![NSObject sy_empty:model]) {
                [array addObject:model];
            }
        }

        self.listArray = [NSArray arrayWithArray:array];
        if (finishBlock) {
            finishBlock(YES);
        }


    } failure:^(NSError * _Nullable error) {
        if (finishBlock) {
            finishBlock(NO);
        }
    }];
    
//    NSMutableArray *array = [NSMutableArray array];
//    [array addObject:[self creatDayTaskItem]];
//    [array addObject:[self creatDayTaskItem]];
//    [array addObject:[self creatDayTaskItem]];
//    [array addObject:[self creatDayTaskItem]];
//    [array addObject:[self creatDayTaskItem]];
//    self.listArray = [NSArray arrayWithArray:array];

}

- (void)getReward:(NSString *)taskid finish:(void(^)(BOOL))finishBlock
{
    [_netManager requestDayTaskRewardWithTaskId:taskid finish:^(BOOL isSuccess) {
        if (finishBlock) {
            finishBlock(isSuccess);
        }
    }];

}

- (SYDayTaskItemModel *)creatDayTaskItem {
    SYDayTaskItemModel *model = [SYDayTaskItemModel new];
    model.title = @"test";
    model.subTitle = @"经验值*200/幸运草*10（随机）";
    model.currentProgress = arc4random() % 5;
    model.allProgress = 5;
    model.status = arc4random() % 3;
    
    return model;
}

#pragma mark - Public
- (NSInteger)numberOfRows {
    return self.listArray.count+1;
}

- (NSString *)leftIconForIndexPath:(NSIndexPath *)indexPath {
    return @"mine_daytask";
}

- (NSString *)mainTitleForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 ) {
        return @"签到";
    }
    NSInteger realIndex = indexPath.row -1;
    if (!self.listArray || self.listArray.count<=realIndex || realIndex<0) {
        return @"";
    }
    SYDayTaskItemModel *model = [self.listArray objectAtIndex:realIndex];
    return [NSString sy_safeString:model.title];
}

- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 ) {
        return @"";
    }
    NSInteger realIndex = indexPath.row -1;
    if (!self.listArray || self.listArray.count<=realIndex || realIndex<0) {
        return @"";
    }
    SYDayTaskItemModel *model = [self.listArray objectAtIndex:realIndex];
    return [NSString sy_safeString:model.subTitle];
}

- (NSString *)progressForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 ) {
        return @"";
    }
    
    NSInteger realIndex = indexPath.row -1;
    if (!self.listArray || self.listArray.count<=realIndex || realIndex<0) {
        return @"";
    }
    SYDayTaskItemModel *model = [self.listArray objectAtIndex:realIndex];
    NSString *progressTitle = [NSString stringWithFormat:@"(%ld/%ld)",(long)model.currentProgress,(long)model.allProgress];
    return [NSString sy_safeString:progressTitle];
}

- (SYDayTaskItemStatus)getStatusForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 ) {
        return SYDayTaskItemStatus_Unknown;
    }
    NSInteger realIndex = indexPath.row -1;
    if (!self.listArray || self.listArray.count<=realIndex || realIndex<0) {
        return SYDayTaskItemStatus_Default;
    }
    SYDayTaskItemModel *model = [self.listArray objectAtIndex:realIndex];
    return model.status;
}
@end
