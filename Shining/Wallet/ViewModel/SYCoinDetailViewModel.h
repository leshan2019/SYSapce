//
//  SYCoinDetailViewModel.h
//  Shining
//
//  Created by letv_lzb on 2019/3/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYCoinDetailListModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^completionBlock)(BOOL isSuccess);

@interface SYCoinDetailViewModel : NSObject

@property (nonatomic, strong)SYCoinDetailListModel *incomeListModel;

@property (nonatomic, strong)SYCoinDetailListModel *consumeListModel;

/**
 获取金币收入list

 @param completion completion block
 */
- (void)getCoinIncomeList:(completionBlock)completion;

/**
 金币收入是否有下一页

 @return 是否
 */
- (BOOL)isIncomeHasNextPage;

/**
 获取金币收入下一页

 @param completion callback
 */
- (void)getIncomeNextPage:(completionBlock)completion;
/**
 金币收入list 是否为空

 @return BOOL
 */
- (BOOL)isIncomeEmptyData;


/**
 获取金币消费list

 @param completion completion block
 */
- (void)getCoinConsumeList:(completionBlock)completion;

/**
 金币消费是否有下一页

 @return BOOL
 */
- (BOOL)isConsumeHasNextPage;

/**
 获取金币消费下一页

 @param completion callback
 */
- (void)getConsumeNextPage:(completionBlock)completion;

/**
 金币消费list 是否为空

 @return BOOL
 */
- (BOOL)isConsumeEmptyData;

@end

NS_ASSUME_NONNULL_END
