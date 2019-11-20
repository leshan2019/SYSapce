//
//  SYWalletModel.h
//  Shining
//
//  Created by letv_lzb on 2019/3/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <YYModel/YYModel.h>
#import "SYMyWalletModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYWalletListModel : NSObject <YYModel>

@property (nonatomic, strong)NSArray *data;

@end

NS_ASSUME_NONNULL_END
