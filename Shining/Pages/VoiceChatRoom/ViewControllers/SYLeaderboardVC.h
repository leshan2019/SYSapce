//
//  SYLeaderboardVC.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/1.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYLeaderboardVC : UIViewController

@property (nonatomic, copy) void(^followSuccessBlock)(NSString * _Nonnull userId, NSString * _Nonnull userName);

- (instancetype)initWithChannelID:(NSString *)channelID;

@property (nonatomic, assign) BOOL onlyShowOutcome;

@end

NS_ASSUME_NONNULL_END
