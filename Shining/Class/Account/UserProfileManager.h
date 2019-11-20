//
//  UserProfileManager.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/2/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPARSE_HXUSER @"hxuser"
#define kPARSE_HXUSER_USERNAME @"username"
#define kPARSE_HXUSER_NICKNAME @"nickname"
#define kPARSE_HXUSER_AVATAR @"avatar"
#define kPARSE_HXUSER_UID @"uid"

@class MessageModel;
@class PFObject;
@class UserProfileEntity;

@interface UserProfileManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isLogined; // 是否已经登录

- (void)initParse;

- (void)clearParse;

- (void)logOut;

- (void)logOut:(void (^)(BOOL isSucess))aCompletionBlock;

- (void)login:(NSString *)userName Password:(NSString *)password VC:(UIViewController *)vc;

- (void)fetchGuestInfo;

- (void)removeUserProfile;

/*
 *  获取用户信息 by username
 */
- (void)loadUserProfileInBackground:(NSArray*)usernames
                       saveToLoacal:(BOOL)save
                         completion:(void (^)(BOOL success, NSError *error))completion;

/*
 *  获取用户信息 by buddy
 */
- (void)loadUserProfileInBackgroundWithBuddy:(NSArray*)buddyList
                                saveToLoacal:(BOOL)save
                                  completion:(void (^)(BOOL success, NSError *error))completion;


/*
 *  获取本地用户信息
 */
- (UserProfileEntity*)getUserProfileByUsername:(NSString*)username;

/*
 *  获取当前用户信息
 */
- (UserProfileEntity*)getCurUserProfile;

/*
 *  根据username获取当前用户昵称
 */
- (NSString*)getNickNameWithUsername:(NSString*)username;

/*
 *  根据username获取当前用户uid
 */
- (NSString *)getUidWithUsername:(NSString *)username;

//#ifdef ShiningSdk
/**
 是否用户手动退出

 @return yes or no
 */
- (BOOL)isUserManualLogin;


/**
 设置用户时候手动退出

 @param isManual isM
 */
- (void)setUserManualLogin:(BOOL)isManual;
//#endif


/**
 是否用户手动退出

 @return yes or no
 */
- (BOOL)getIsFromLoginPage;


/**
 设置用户时候手动退出

 @param isManual isM
 */
- (void)setFromLoginPage:(BOOL)isManual;


/**
 设置未绑定手机号的登陆用户 获取的临时token

 @param accessToken token
 */
- (void)setTempAccessToken:(NSString *)accessToken;

/**
 获取未绑定手机号的登陆用户 获取的临时token

 @return tempAccessToken
 */
- (NSString *)getTempAccessToken;

/**
 设置是否需要补全信息

 @param need_info needInfo
 */
- (void)setNeedInfo:(BOOL)need_info;

- (BOOL)checkNextNeedInfo:(UIViewController *)showVC;


/**
 设置是否需要绑定手机号

 @param need_mobile mobile
 */
- (void)setNeedMobile:(BOOL)need_mobile;

- (BOOL)getNeed_mobile;

- (BOOL)checkNextNeedMobile:(UIViewController *)showVC;

/**
 完善信提示弹窗

 @param showVC vc
 */
- (void)showNeedInfoPopWindows:(UIViewController *)showVC;


@end


@interface UserProfileEntity : NSObject<NSCoding>

+ (instancetype)initWithPFObject:(PFObject*)object;

+ (void)saveUserProfileEntity:(NSDictionary *)userDict;

+ (instancetype) getUserProfileEntity;

+ (void)saveOtherUserInfo:(UserProfileEntity *)userInfo;

+ (instancetype)getUserProfileEntityByEMUserName:(NSString *)em_userName;

// 返回名字的首字母 
- (NSString *)firstLetterWithUserName;

// 返回生日的年月日
- (NSString *)changeBirthdayToYearMonthDay;

@property (nonatomic,strong) NSString *objectId;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSString *guestId;

@property (nonatomic,assign) NSInteger status_flag;         // 用户状态 0：正常 1：封禁
@property (nonatomic,strong) NSString *userid;              // 用户id
@property (nonatomic,strong) NSString *bestid;              // 靓号id
@property (nonatomic,strong) NSString *username;            // 姓名
@property (nonatomic,strong) NSString *mobile;              // 手机号
@property (nonatomic,strong) NSString *gender;              // 性别 ： male female
@property (nonatomic,strong) NSString *birthday;            // 生日 ： “1970-01-01”
@property (nonatomic,strong) NSString *signature;           // 个性签名
@property (nonatomic,strong) NSString *residence_place;     // 所在地id
@property (nonatomic,strong) NSString *status;              // 用户状态：0-正常 1-封禁
@property (nonatomic,strong) NSString *reg_time;            // 注册时间
@property (nonatomic,strong) NSString *em_username;         // 环信用户名

@property (nonatomic,assign) NSInteger level;               // 用户等级
@property (nonatomic,assign) NSInteger level_point;         // 等级积分 - 消费蜜豆

@property (nonatomic,assign) NSInteger vipright;            // vip权益值

@property (nonatomic,strong) NSString *avatar_imgurl;       // 头像
@property (nonatomic,strong) NSString *photo_imgurl1;       // 照片墙1
@property (nonatomic,strong) NSString *photo_imgurl2;       // 照片墙1
@property (nonatomic,strong) NSString *photo_imgurl3;       // 照片墙1

@property (nonatomic,strong) NSString *voice_url;           // 录音url
@property (nonatomic,assign) NSInteger voice_duration;      // 语音时长
@property (nonatomic,strong) NSString *video_url;           // 视频url
@property (nonatomic,strong) NSString *video_imgurl;        // 视频封面

@property (nonatomic,assign) NSInteger vehicle;             // 坐骑propid
@property (nonatomic,assign) NSInteger avatarbox;           // 头像框propid

// 主播等级 - 用户接口返回，可以判断主播等级 (>0 一定是主播; =0 可能是主播，可能是普通用户)
@property (nonatomic, assign) NSInteger streamer_level;     // 主播等级

// Note: is_streamer,streamer_roomid,streamer_roomname 用户接口不返回，这3个字段只适用于关注列表接口
@property (nonatomic, assign) NSInteger is_streamer;        // 是否是主播：1-是 0-否
@property (nonatomic, assign) NSInteger streamer_roomid;    // 主播开播后，此值为所在房间id
@property (nonatomic, strong) NSString *streamer_roomname;  // 主播开播后，此值为所在房间名称

@property (nonatomic, assign) NSInteger auth_model; // 模式。未确定1、成年2、青少年3。

@property (nonatomic, assign) NSInteger is_super_admin; //是否超级管理员
/**
 vip权益解释如下：比如权益有ABCD四种，设计A权益标识为1(二进制1) B权益标识为2(二进制10) C权益标识为4(二进制100) D权益标识为8（二进制1000）
 假设用户有AC两种权益，则vip权益值为1+4 = 5  (二进制101) 判断有没有对应权益只需要看权益所在位是否为1，也就是  101(vip权益值)^1(权益标识A) = 1 ，101^ 10(权益C) = 0 则无此权益
 */
@end
