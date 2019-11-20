//
//  SYCoinDetailViewModel.m
//  Shining
//
//  Created by letv_lzb on 2019/3/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYCoinDetailViewModel.h"
#import "SYWalletNetWorkManager.h"

@interface SYCoinDetailViewModel ()

/**
 收入当前页
 */
@property (nonatomic, assign)NSInteger incomePage;

/**
 收入每页条数
 */
@property (nonatomic, assign)NSInteger incomePageSize;

/**
 消费当前页
 */
@property (nonatomic, assign)NSInteger consumePage;

/**
 消费每页条数
 */
@property (nonatomic, assign)NSInteger consumePageSize;
@end

@implementation SYCoinDetailViewModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.incomePage = 1;
        self.incomePageSize = 20;
        self.consumePage = 1;
        self.consumePageSize = 20;
    }
    return self;
}


/**
 获取金币收入list

 @param completion completion block
 */
- (void)getCoinIncomeList:(completionBlock)completion
{
    SYWalletNetWorkManager *newWork = [[SYWalletNetWorkManager alloc] init];
    __weak typeof(self) weakSelf = self;
    [newWork requestCoinIncomeList:self.incomePage pageNum:self.incomePageSize success:^(id  _Nullable response) {
        SYCoinDetailListModel *listModel = (SYCoinDetailListModel *)response;
        if ([listModel.currentpage integerValue] > 1) {
            NSMutableArray *tempList = [NSMutableArray arrayWithArray:weakSelf.incomeListModel.list];
            [tempList addObjectsFromArray:listModel.list];
            listModel.list = tempList;
        }
        weakSelf.incomePage = [listModel.currentpage integerValue];
        weakSelf.incomeListModel = listModel;
        if (completion) {
            completion(YES);
        }
    } failure:^(NSError * _Nullable error) {
        if (completion) {
            completion(NO);
        }
    }];
}

- (BOOL)isIncomeHasNextPage
{
    if ([self.incomeListModel.currentpage integerValue] < [self.incomeListModel.totalpage integerValue]) {
        return YES;
    }
    return NO;
}

- (void)getIncomeNextPage:(completionBlock)completion
{
    if (!self.isIncomeHasNextPage) {
        return;
    }
    self.incomePage = [self.incomeListModel.currentpage integerValue] + 1;
    [self getCoinIncomeList:completion];
}

- (BOOL)isIncomeEmptyData
{
    if (!self.incomeListModel
        || !self.incomeListModel.list
        || self.incomeListModel.list.count <= 0) {
        return YES;
    }
    return NO;
}


/**
 获取金币消费list

 @param completion completion block
 */
- (void)getCoinConsumeList:(completionBlock)completion
{
    SYWalletNetWorkManager *newWork = [[SYWalletNetWorkManager alloc] init];
    __weak typeof(self) weakSelf = self;
    [newWork requestCoinConsumeList:self.consumePage pageNum:self.consumePageSize success:^(id  _Nullable response) {
        SYCoinDetailListModel *listModel = (SYCoinDetailListModel *)response;
        if ([listModel.currentpage integerValue] > 1) {
            NSMutableArray *tempList = [NSMutableArray arrayWithArray:weakSelf.consumeListModel.list];
            [tempList addObjectsFromArray:listModel.list];
            listModel.list = tempList;
        }
        weakSelf.consumePage = [listModel.currentpage integerValue];
        weakSelf.consumeListModel = listModel;
        if (completion) {
            completion(YES);
        }
    } failure:^(NSError * _Nullable error) {
        if (completion) {
            completion(NO);
        }
    }];
}

- (BOOL)isConsumeHasNextPage
{
    if ([self.consumeListModel.currentpage integerValue] < [self.consumeListModel.totalpage integerValue]) {
        return YES;
    }
    return NO;
}

- (void)getConsumeNextPage:(completionBlock)completion
{
    if (!self.isConsumeHasNextPage) {
        return;
    }
    self.consumePage = [self.consumeListModel.currentpage integerValue] + 1;
    [self getCoinConsumeList:completion];
}

- (BOOL)isConsumeEmptyData
{
    if (!self.consumeListModel
        || !self.consumeListModel.list
        || self.consumeListModel.list.count <= 0) {
        return YES;
    }
    return NO;
}

@end
