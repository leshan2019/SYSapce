//
//  SYWalletModel.h
//  Shining
//
//  Created by letv_lzb on 2019/3/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYMyWalletModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *number;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *descrip;

@end

NS_ASSUME_NONNULL_END
