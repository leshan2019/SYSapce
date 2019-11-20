//
//  SYLeaderBoardViewModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/1.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYLeaderBoardView.h"
#import "SYGiftNetManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYLeaderBoardViewModel : NSObject

@property (nonatomic, assign, readonly) SYLeaderBoardViewType type;
@property (nonatomic, strong, readonly) NSString *channelID;

- (instancetype)initWithViewChannelID:(NSString *)channelID
                                 type:(SYLeaderBoardViewType)type;

- (void)requestDataListWithTimeRange:(SYGiftTimeRange)range
                               block:(void(^)(BOOL success))block;

- (NSInteger)rowCount;
- (NSString *)userIDAtIndex:(NSInteger)index;
- (NSString *)usernameAtIndex:(NSInteger)index;
- (NSInteger)userAgeAtIndex:(NSInteger)index;
- (NSInteger)userVipLevelAtIndex:(NSInteger)index;
- (NSInteger)userBroadcasterLevelAtIndex:(NSInteger)index;
- (NSInteger)userIsBroadcasterAtIndex:(NSInteger)index;
//- (BOOL)isGirlAtIndex:(NSInteger)index;
- (NSString *)genderAtIndex:(NSInteger)index;
- (NSString *)avatarAtIndex:(NSInteger)index;
- (NSString *)sumStringAtIndex:(NSInteger)index;
- (NSString *)avatarBoxAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
