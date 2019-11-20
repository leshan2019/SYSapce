//
//  SYVoiceRoomBossViewModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/8/7.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SYVoiceRoomKingModel;

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomBossViewModel : NSObject

@property (nonatomic, strong, readonly) NSString *userUid;
@property (nonatomic, strong, readonly) NSString *userName;
@property (nonatomic, strong, readonly) NSString *userAvatar;
@property (nonatomic, strong, readonly) NSString *userAvatarBox;
@property (nonatomic, assign, readonly) NSInteger price;

- (instancetype)initWithBossModel:(SYVoiceRoomKingModel *)bossModel;

- (BOOL)isValid; // 老板位是否有人
- (NSInteger)countDown; // 倒计时剩余时间
- (BOOL)isMyself; // 老板是自己

@end

NS_ASSUME_NONNULL_END
