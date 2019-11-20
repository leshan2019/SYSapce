//
//  SYLoginNetManager.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/6.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYNetCommonManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYLoginNetManager : SYNetCommonManager

- (void)loginWithPhone:(NSString *)phone
               success:(SuccessBlock)success
               failure:(FailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
