//
//  SYVoiceRoomUser.h
//  Shining
//
//  Created by mengxiangjian on 2019/2/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomUser : NSObject <YYModel>

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *bestid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger vehicle; // 座驾id
@property (nonatomic, assign) NSInteger avatarBox; // 座驾id
@property (nonatomic, assign) NSInteger streamer_level;
@property (nonatomic, assign) NSInteger is_streamer;        // 是否是主播：1-是 0-否
@property (nonatomic, assign) NSInteger is_super_admin;
@property (nonatomic, assign) BOOL isMuted;

@end

NS_ASSUME_NONNULL_END
