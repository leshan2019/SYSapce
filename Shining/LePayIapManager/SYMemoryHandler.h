//
//  SYLepayIpaMemoryInstance.h
//  Shining
//
//  Created by letv_lzb on 2019/4/1.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYMemoryHandler : NSObject

/**
 itunes store 返回的套餐列表
 */
@property(nonatomic, strong)NSMutableArray *skProducts;

/**
 Bee语音充值套餐返回的列表
 */
@property(nonatomic, strong)NSMutableArray *syPackageProducts;

SYSingleCaseH(SYMemoryHandler)
@end

NS_ASSUME_NONNULL_END
