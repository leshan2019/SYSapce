//
//  MyCoinViewModel.h
//  Shining
//
//  Created by letv_lzb on 2019/3/29.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYCoinPackageListModel.h"
#import "SYCoinPackageModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^completionBlock)(BOOL isSuccess);

@interface MyCoinViewModel : NSObject
@property(nonatomic, strong)SYCoinPackageListModel *lepayListModel;
@property(nonatomic, strong)SYCoinPackageListModel *lebzListModel;

/**
 经过IAP验证后的套餐list 信息
 */
@property(nonatomic, assign)BOOL varifyIapSuccess;

/**
 lebz 获取充值套餐list

 @param completion completion block
 */
- (void)getLebzCoinPackageList:(completionBlock)completion;

- (BOOL)isLebzCoinPackageNextPage;

- (void)getLebzCoinPackageNextPage:(completionBlock)completion;

- (BOOL)isLebzCoinPackageEmptyData;

/**
 lepay 获取充值套餐list

 @param completion completion block
 */
- (void)getLepayCoinPackageList:(completionBlock)completion;

- (BOOL)isLepayCoinPackageEmptyData;

- (BOOL)isLepayCoinPackageNextPage;

- (void)getLepayCoinPackageNextPage:(completionBlock)completion;






/**
 去itunes Store 验证套餐信息（价格及是否存在）。

 @param coinPackages 充值套餐列表
 */
- (void)varifyIapProductInfo:(NSArray *)coinPackages;



/**
 获取iAP验证后的SYCoinPackageModel 实例

 @param productId apple_id
 @return SYCoinPackageModel 实例
 */
- (SYCoinPackageModel *)getVarifyedIapProduct:(NSString *)productId;


- (void)requestMyCoinWithSuccess:(void(^)(NSNumber *coin))success;

@end

NS_ASSUME_NONNULL_END
