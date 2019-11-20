//
//  MyShineDetailViewModel.h
//  Shining
//
//  Created by letv_lzb on 2019/3/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYShineDetailIncomeListModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^completionBlock)(BOOL isSuccess);

@interface MyShineDetailViewModel : NSObject

@property (nonatomic, strong)SYShineDetailIncomeListModel *listModel;

@property (nonatomic, strong)SYShineDetailIncomeListModel *consumeListModel;

/**
 获取蜜糖收入list

 @param completion completion block
 */
- (void)getShineIncomeList:(completionBlock)completion;

- (BOOL)isIncomeHasNextPage;

- (void)getIncomeNextPage:(completionBlock)completion;

- (BOOL)isIncomeEmptyData;



/**
 获取蜜糖消费list

 @param completion completion block
 */
- (void)getShineConsumeList:(completionBlock)completion;

- (BOOL)isConsumeHasNextPage;

- (void)getConsumeNextPage:(completionBlock)completion;

- (BOOL)isConsumeEmptyData;

@end

NS_ASSUME_NONNULL_END
