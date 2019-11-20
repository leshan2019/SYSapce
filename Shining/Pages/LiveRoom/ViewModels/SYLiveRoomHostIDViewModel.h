//
//  SYLiveRoomHostIDViewModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/9/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYLiveRoomHostIDViewModel : NSObject

- (void)requestFollowUserWithUid:(NSString *)uid
                           block:(void(^)(BOOL success))block;

- (void)requestCancelFollowUserWithUid:(NSString *)uid
                                 block:(void(^)(BOOL success))block;

@end

NS_ASSUME_NONNULL_END
