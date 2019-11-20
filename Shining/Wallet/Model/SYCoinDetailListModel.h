//
//  SYCoinDetailListModel.h
//  Shining
//
//  Created by letv_lzb on 2019/3/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYCoinDetailListModel : NSObject<YYModel>
@property(nonatomic, strong)NSArray *list;
@property(nonatomic, strong)NSNumber *totalpage;
@property(nonatomic, strong)NSNumber *currentpage;
@end

NS_ASSUME_NONNULL_END
