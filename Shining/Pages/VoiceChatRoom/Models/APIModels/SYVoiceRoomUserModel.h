//
//  SYVoiceRoomUserModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomUserModel : NSObject <YYModel>

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *bestid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *signature; // 个性签名
@property (nonatomic, strong) NSString *gender; // 性别 male female
@property (nonatomic, strong) NSString *birthday; // 生日
@property (nonatomic, assign) NSInteger residence_place;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, assign) NSInteger sum; // 收益或贡献总量
@property (nonatomic, assign) NSInteger avatarbox;           // 头像框propid
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) NSString *voice_url;
@property (nonatomic, assign) NSInteger voice_duration;
@property (nonatomic, assign) NSInteger streamer_level;     // 主播等级
@property (nonatomic, assign) NSInteger is_streamer;        // 是否是主播：1-是 0-否
@property (nonatomic, strong) NSString *em_username;
@property (nonatomic, assign) NSInteger is_super_admin; //是否超管

@end

NS_ASSUME_NONNULL_END
