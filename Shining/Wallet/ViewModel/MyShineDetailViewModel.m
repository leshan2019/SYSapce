//
//  MyShineDetailViewModel.m
//  Shining
//
//  Created by letv_lzb on 2019/3/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "MyShineDetailViewModel.h"
#import "SYWalletNetWorkManager.h"


@interface MyShineDetailViewModel ()
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, assign)NSInteger pageSize;

@property (nonatomic, assign)NSInteger consumePage;
@property (nonatomic, assign)NSInteger consumePageSize;

@end

@implementation MyShineDetailViewModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = 1;
        self.pageSize = 20;
        self.consumePage = 1;
        self.consumePageSize = 20;
    }
    return self;
}

- (void)getShineIncomeList:(completionBlock)completion
{
    SYWalletNetWorkManager *newWork = [[SYWalletNetWorkManager alloc] init];
    __weak typeof(self) weakSelf = self;
    [newWork requestShineIncomeList:self.page pageNum:self.pageSize success:^(id  _Nullable response) {
        SYShineDetailIncomeListModel *tempList = (SYShineDetailIncomeListModel *)response;
        if ([tempList.currentpage integerValue] > 1) {
            NSMutableArray *temp = [NSMutableArray arrayWithArray:weakSelf.listModel.list];
            [temp addObjectsFromArray:tempList.list];
            tempList.list = temp;
        }
        weakSelf.page = [tempList.currentpage integerValue];
        weakSelf.listModel = tempList;
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
    if ([self.listModel.currentpage integerValue] < [self.listModel.totalpage integerValue]) {
        return YES;
    }
    return NO;
}

- (void)getIncomeNextPage:(completionBlock)completion
{
    if (!self.isIncomeHasNextPage) {
        return;
    }
    self.page = [self.listModel.currentpage integerValue] + 1;
    [self getShineIncomeList:completion];
}


- (BOOL)isIncomeEmptyData
{
    if (!self.listModel
        || !self.listModel.list
        || self.listModel.list.count <= 0) {
        return YES;
    }
    return NO;
}




/**
 获取蜜糖消费list

 @param completion completion block
 */
- (void)getShineConsumeList:(completionBlock)completion {
    if (completion) {//暂时没有此功能，直接返回失败！
        completion(NO);
    }
    return;
    SYWalletNetWorkManager *newWork = [[SYWalletNetWorkManager alloc] init];
    __weak typeof(self) weakSelf = self;
    [newWork requestShineConsumeList:self.consumePage pageNum:self.consumePageSize success:^(id  _Nullable response) {
        SYShineDetailIncomeListModel *tempList = (SYShineDetailIncomeListModel *)response;
        if ([tempList.currentpage integerValue] > 1) {
            NSMutableArray *temp = [NSMutableArray arrayWithArray:weakSelf.consumeListModel.list];
            [temp addObjectsFromArray:tempList.list];
            tempList.list = temp;
        }
        weakSelf.consumePage = [tempList.currentpage integerValue];
        weakSelf.consumeListModel = tempList;
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
    if (![self isConsumeHasNextPage]) {
        return;
    }
    self.consumePage = [self.consumeListModel.currentpage integerValue] + 1;
    [self getShineConsumeList:completion];
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
