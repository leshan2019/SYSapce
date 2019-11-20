//
//  SYVoiceMicUserViewModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/2/27.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceChatUserViewModel.h"
#import "SYVoiceRoomUser.h"
#import "SYGiftInfoManager.h"

@interface SYVoiceChatUserViewModel ()

@property (nonatomic, strong) SYVoiceRoomUser *user;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatarURL;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) BOOL isMuted; // 是否被静音

@property (nonatomic, assign) BOOL isPKing;
@property (nonatomic, assign) NSInteger beanValue;

@end

@implementation SYVoiceChatUserViewModel

- (instancetype)initWithUser:(SYVoiceRoomUser *)user
                     isMuted:(BOOL)isMuted {
    return [self initWithUser:user
                      isMuted:isMuted
                      isPKing:NO
                    beanValue:0];
}

- (instancetype)initWithUser:(SYVoiceRoomUser *)user
                     isMuted:(BOOL)isMuted
                     isPKing:(BOOL)isPKing
                   beanValue:(NSInteger)beanValue {
    self = [super init];
    if (self) {
        _user = user;
        _uid = user.uid;
        _bestid = user.bestid;
        _name = user.username;
        _avatarURL = user.icon;
        _isMuted = isMuted;
        _birthday = user.birthday;
        _age = user.age;
        _gender = user.gender;
        _level = user.level;
        _isPKing = isPKing;
        _beanValue = beanValue;
        _broadcaster_level = user.streamer_level;
    }
    return self;
}

- (NSString *)avatarBox {
    return [[SYGiftInfoManager sharedManager] avatarBoxURLWithPropId:self.user.avatarBox];
}

- (NSString *)beanString {
    if (self.isPKing) {
        return [NSString stringWithFormat:@"%ld", (long)self.beanValue];
    }
    return nil;
}

@end
