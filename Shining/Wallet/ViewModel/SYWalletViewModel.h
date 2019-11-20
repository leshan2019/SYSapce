//
//  SYWalletViewModel.h
//  Shining
//
//  Created by letv_lzb on 2019/3/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYWalletListModel.h"
#import "SYWalletModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^completionBlock)(BOOL isSuccess);

@interface SYWalletViewModel : NSObject

@property (nonatomic, strong) SYWalletListModel *listModel;

/**
 获取我的钱包list

 @param completion completion block
 */
- (void)getWalletList:(completionBlock)completion;

/**
 是否没有数据

 @return 是否为空
 */
- (BOOL)isEmptyData;

@end

NS_ASSUME_NONNULL_END
