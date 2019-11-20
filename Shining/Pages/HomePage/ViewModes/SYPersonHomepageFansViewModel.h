//
//  SYPersonHomepageFansViewModel.h
//  Shining
//
//  Created by 杨玄 on 2019/9/6.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYGiftNetManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYPersonHomepageFansViewModel : NSObject

@property (nonatomic, strong) NSString *userId;

// 请求粉丝贡献列表
- (void)requestFansContributionData:(SYGiftTimeRange)range
                               page:(NSInteger)page
                            success:(void(^)(BOOL success))success
                            failure:(void(^)())failure;

- (NSInteger)numberOfItems;
- (NSString *)userIDAtIndex:(NSInteger)index;
- (NSString *)usernameAtIndex:(NSInteger)index;
- (NSInteger)userAgeAtIndex:(NSInteger)index;
- (NSInteger)userVipLevelAtIndex:(NSInteger)index;
- (NSInteger)userBroadcasterLevelAtIndex:(NSInteger)index;
- (NSInteger)userIsBroadcasterAtIndex:(NSInteger)index;
- (NSString *)genderAtIndex:(NSInteger)index;
- (NSString *)avatarAtIndex:(NSInteger)index;
- (NSString *)sumStringAtIndex:(NSInteger)index;
- (NSString *)avatarBoxAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
