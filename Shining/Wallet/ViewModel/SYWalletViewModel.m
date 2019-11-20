//
//  SYWalletViewModel.m
//  Shining
//
//  Created by letv_lzb on 2019/3/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYWalletViewModel.h"
#import "SYWalletNetWorkManager.h"


@interface SYWalletViewModel ()

@end

@implementation SYWalletViewModel


/**
 获取我的钱包list

 @param completion completion block
 */
- (void)getWalletList:(completionBlock)completion
{
    SYWalletNetWorkManager *newWork = [[SYWalletNetWorkManager alloc] init];
    __weak typeof(self) weakSelf = self;
    [newWork requestWalletList:^(id  _Nullable response) {
        weakSelf.listModel = (SYWalletListModel *)response;
        if (completion) {
            completion(YES);
        }
    } failure:^(NSError * _Nullable error) {
        if (completion) {
            completion(NO);
        }
    }];
}

- (BOOL)isEmptyData {
    return !self.listModel ||
    !self.listModel.data ||
    self.listModel.data.count <= 0 ;
}

@end
