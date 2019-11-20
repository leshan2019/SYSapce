//
//  SYCommonStatusManager.h
//  Shining
//
//  Created by jiuqi on 2019/10/16.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYCommonStatusManager : NSObject

+ (instancetype)sharedInstance;

- (void)checkDayTaskUnReceived :(void(^)(BOOL))finishBlock;
@end

NS_ASSUME_NONNULL_END
