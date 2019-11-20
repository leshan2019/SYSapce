//
//  SYLiveRoomHostIDViewModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/9/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomHostIDViewModel.h"
#import "SYUserServiceAPI.h"

@implementation SYLiveRoomHostIDViewModel

- (void)requestFollowUserWithUid:(NSString *)uid
                           block:(void(^)(BOOL success))block {
    [[SYUserServiceAPI sharedInstance] requestFollowUserWithUid:uid
                                                        success:^(id  _Nullable response) {
                                                            if (block) {
                                                                block(YES);
                                                            }
                                                        } failure:^(NSError * _Nullable error) {
                                                            if (block) {
                                                                block(NO);
                                                            }
                                                        }];
}

- (void)requestCancelFollowUserWithUid:(NSString *)uid
                                 block:(void(^)(BOOL success))block {
    [[SYUserServiceAPI sharedInstance] requestCancelFollowUserWithUid:uid
                                                              success:^(id  _Nullable response) {
                                                                  if (block) {
                                                                      block(YES);
                                                                  }
                                                              } failure:^(NSError * _Nullable error) {
                                                                  if (block) {
                                                                      block(NO);
                                                                  }
                                                              }];
}

@end
