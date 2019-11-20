//
//  UserProfileManager.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/2/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "UserProfileManager.h"
#import "EMDemoOptions.h"
#import "EMAlertController.h"
#import "SYUserServiceAPI.h"
//TODO
#import <Parse/Parse.h>
#import "SYPerfectUserInfoVC.h"
#import "SYPopUpWindows.h"

//#import "MessageModel.h"

#define kCURRENT_USERNAME [[EMClient sharedClient] currentUsername]

static UserProfileManager *sharedInstance = nil;
@interface UserProfileManager ()<SYPopUpWindowsDelegate>
{
    NSString *_curusername;
}

@property (nonatomic, strong) NSMutableDictionary *users;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) PFACL *defaultACL;
//#ifdef ShiningSdk
@property (nonatomic, assign) BOOL isUserLogin;
@property (nonatomic, assign) BOOL isFromLoginPage;
//#endif
@property (nonatomic, copy) NSString *tempAccessTK;//未绑定手机号的临时token

@property (nonatomic, strong) SYPopUpWindows *popupWindow;
@property (nonatomic, weak) UIViewController *showViewController;

@end

@implementation UserProfileManager

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _users = [NSMutableDictionary dictionary];
        
        _defaultACL = [PFACL ACL];
        [_defaultACL setPublicReadAccess:YES];
        [_defaultACL setPublicWriteAccess:YES];
//#ifdef ShiningSdk
        _isUserLogin = NO;
//#endif

    }
    return self;
}

//#ifdef ShiningSdk

/**
 是否强制弹出完善信息页面

 @return isUserLoing
 */
- (BOOL)isUserManualLogin {
    return self.isUserLogin;
}


/**
  登录成功后接口是否强制走完善信息页

 @param isManual isManual
 */
- (void)setUserManualLogin:(BOOL)isManual{
    _isUserLogin = isManual;
}



/**
 是否来自手动登录界面

 @return isFromLoginPage
 */
- (BOOL)getIsFromLoginPage {
    return self.isFromLoginPage;
}


/**
 设置是否来自手动登录界面

 @param isManual isM
 */
- (void)setFromLoginPage:(BOOL)isManual {
    _isFromLoginPage = isManual;
}

//#endif

- (BOOL)isLogined {
    NSData * data = [[NSUserDefaults standardUserDefaults]objectForKey:@"userinfo"];
    return (data);
}

- (void)initParse
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    id objectId = [ud objectForKey:[NSString stringWithFormat:@"%@%@",kPARSE_HXUSER,kCURRENT_USERNAME]];
    if (objectId) {
        self.objectId = objectId;
    }
    _curusername = kCURRENT_USERNAME;
    [self initData];
}

- (void)clearParse
{
    self.objectId = nil;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:[NSString stringWithFormat:@"%@%@",kPARSE_HXUSER,_curusername]];
    [ud removeObjectForKey:@"userinfo"];
    _curusername = nil;
    [self.users removeAllObjects];
}

- (void)initData
{
    [self.users removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:kPARSE_HXUSER];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (objects && [objects count] > 0) {
            for (id user in objects) {
                if ([user isKindOfClass:[PFObject class]]) {
                    UserProfileEntity *entity = [UserProfileEntity initWithPFObject:user];
                    if (entity.username.length > 0) {
                        [self.users setObject:entity forKey:entity.username];
                    }
                }
            }
        }

    }];
}

- (void)loadUserProfileInBackgroundWithBuddy:(NSArray*)buddyList
                                saveToLoacal:(BOOL)save
                                  completion:(void (^)(BOOL success, NSError *error))completion
{
    NSMutableArray *usernames = [NSMutableArray array];
    for (NSString *buddy in buddyList)
    {
        if ([buddy length])
        {
            if (![self getUserProfileByUsername:buddy]) {
                [usernames addObject:buddy];
            }
        }
    }
    if ([usernames count] == 0) {
        if (completion) {
            completion(YES,nil);
        }
        return;
    }
    [self loadUserProfileInBackground:usernames saveToLoacal:save completion:completion];
}

- (void)loadUserProfileInBackground:(NSArray*)usernames
                       saveToLoacal:(BOOL)save
                         completion:(void (^)(BOOL success, NSError *error))completion
{
    PFQuery *query = [PFQuery queryWithClassName:kPARSE_HXUSER];
    [query whereKey:kPARSE_HXUSER_USERNAME containedIn:usernames];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (id user in objects) {
                if ([user isKindOfClass:[PFObject class]]) {
                    PFObject *pfuser = (PFObject*)user;
                    if (save) {
                        [self savePFUserInDisk:pfuser];
                    } else {
                        [self savePFUserInMemory:pfuser];
                    }
                }
            }
            if (completion) {
                completion(YES, nil);
            }
        } else {
            if (completion) {
                completion(NO, error);
            }
        }
    }];
}

- (UserProfileEntity*)getUserProfileByUsername:(NSString*)username
{
//    if ([_users objectForKey:username]) {
//        return [_users objectForKey:username];
    
    UserProfileEntity *user = [UserProfileEntity getUserProfileEntityByEMUserName:username];
    
    return user;
}

- (UserProfileEntity*)getCurUserProfile
{
    if ([_users objectForKey:kCURRENT_USERNAME]) {
        return [_users objectForKey:kCURRENT_USERNAME];
    }
    
    return nil;
}

- (NSString*)getNickNameWithUsername:(NSString*)username
{
    UserProfileEntity* entity = [self getUserProfileByUsername:username];
    if (entity.nickname && entity.nickname.length > 0) {
        return entity.nickname;
    } else {
        return username;
    }
}

- (NSString *)getUidWithUsername:(NSString *)username
{
    UserProfileEntity* entity = [self getUserProfileByUsername:username];
    if (entity.userid && entity.userid.length > 0) {
        return entity.userid;
    } else {
        return @"";
    }
}

#pragma mark - private

- (void)savePFUserInDisk:(PFObject*)object
{
    if (object) {
//        [object pinInBackgroundWithName:kCURRENT_USERNAME];
        [self savePFUserInMemory:object];
    }
}

- (void)savePFUserInMemory:(PFObject*)object
{
    if (object) {
        UserProfileEntity *entity = [UserProfileEntity initWithPFObject:object];
        [_users setObject:entity forKey:entity.username];
    }
}

- (void)queryPFObjectWithCompletion:(void (^)(PFObject *object, NSError *error))completion
{
    PFQuery *query = [PFQuery queryWithClassName:kPARSE_HXUSER];
    [query whereKey:kPARSE_HXUSER_USERNAME equalTo:kCURRENT_USERNAME];
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            if (objects && [objects count] > 0) {
                PFObject *object = [objects objectAtIndex:0];
                [object setACL:weakSelf.defaultACL];
                weakSelf.objectId = object.objectId;
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:object.objectId forKey:[NSString stringWithFormat:@"%@%@",kPARSE_HXUSER,kCURRENT_USERNAME]];
                [ud synchronize];
                if (completion) {
                    completion (object, error);
                }
            } else {
                PFObject *object = [PFObject objectWithClassName:kPARSE_HXUSER];
                object[kPARSE_HXUSER_USERNAME] = kCURRENT_USERNAME;
                completion (object, error);
            }
        } else {
            if (completion) {
                completion (nil, error);
            }
        }
    }];
}

- (void)logOut{
    [self removeUserProfile];
    [[EMClient sharedClient].options setIsAutoLogin:NO];
    EMDemoOptions *demoOptions = [EMDemoOptions sharedOptions];
    demoOptions.isAutoLogin = NO;
    [demoOptions archive];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[EMClient sharedClient] logout:YES completion:^(EMError *aError) {

        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    });
}



- (void)logOut:(void (^)(BOOL isSucess))aCompletionBlock {
    [self removeUserProfile];
    [[EMClient sharedClient].options setIsAutoLogin:NO];
    EMDemoOptions *demoOptions = [EMDemoOptions sharedOptions];
    demoOptions.isAutoLogin = NO;
    [demoOptions archive];
    [[EMClient sharedClient] logout:YES completion:^(EMError *aError) {
        BOOL isSucess = NO;
        if (!aError) {
            isSucess = YES;
        }
        if (aCompletionBlock) {
            aCompletionBlock(isSucess);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }];

}


- (void)removeUserProfile {
    [self setTempAccessToken:@""];
    [UserProfileEntity saveUserProfileEntity:nil];
    [SYSettingManager setAccessToken:@""];
    [SYSettingManager setUserInfo:@""];
    [SYSettingManager setShowNeedMobile:NO];
}

- (void)logoutBeforeLogin {
    [self removeUserProfile];
    [[EMClient sharedClient].options setIsAutoLogin:NO];
    EMDemoOptions *demoOptions = [EMDemoOptions sharedOptions];
    demoOptions.isAutoLogin = NO;
    [demoOptions archive];
    [[EMClient sharedClient] logout:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

#pragma mark - 登录环信SDK（username&password）
- (void)login:(NSString *)userName Password:(NSString *)password VC:(UIViewController *)vc
{
    if ([userName length] == 0 || [password length] == 0) {
        NSString *errorDes =  @"登录失败";
        [EMAlertController showErrorAlert:errorDes];
        return;
    }
    
    if (!gIsInitializedSDK) {
        gIsInitializedSDK = YES;
        EMOptions *options = [[EMDemoOptions sharedOptions] toOptions];
        [[EMClient sharedClient] initializeSDKWithOptions:options];
    }
    
    __weak typeof(vc) weakVC = vc;
    void (^finishBlock) (NSString *aName, EMError *aError) = ^(NSString *aName, EMError *aError) {
        [weakVC hideHud];
         [[UserProfileManager sharedInstance] setTempAccessToken:@""];
        if (!aError) {
            //设置是否自动登录
            [[EMClient sharedClient].options setIsAutoLogin:YES];
            
            EMDemoOptions *options = [EMDemoOptions sharedOptions];
            options.isAutoLogin = YES;
            options.loggedInUsername = userName;
            options.loggedInPassword = password;
            [options archive];
            //发送自动登录状态通知
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:[NSNumber numberWithBool:YES]];
            
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            
            if (vc) {
                [vc dismissViewControllerAnimated:YES completion:nil];
            }
            
            return ;
        }
        
        NSString *errorDes = @"登录失败，请重试";
        switch (aError.code) {
            case EMErrorUserNotFound:
                errorDes = @"用户ID不存在";
                break;
            case EMErrorNetworkUnavailable:
                errorDes = @"网络未连接";
                break;
            case EMErrorServerNotReachable:
                errorDes = @"无法连接服务器";
                break;
            case EMErrorUserAuthenticationFailed:
                errorDes = /*aError.errorDescription*/@"密码验证失败";
                break;
            case EMErrorUserLoginTooManyDevices:
                errorDes = @"登录设备数已达上限";
                break;
            default:
                errorDes = [NSString stringWithFormat:@"登录失败，请重试,错误码%d", aError.code];
                break;
        }
        //发送自动登录状态通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:[NSNumber numberWithBool:NO]];
        [EMAlertController showErrorAlert:errorDes];
    };
    
    [vc showHudInView:vc.view hint:@"加载中..."/*NSLocalizedString(@"login.ongoing", @"Is Login...")*/];
    [[EMClient sharedClient] loginWithUsername:userName password:password completion:finishBlock];
}

- (void)fetchGuestInfo {
    [[SYUserServiceAPI sharedInstance] requestGuestAccountWithSuccess:^(id  _Nullable response) {
        if ([response isKindOfClass:[SYGuestModel class]]) {
            SYGuestModel *guest = (SYGuestModel *)response;
            [self guestLogin:guest.em_username password:guest.em_password];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

- (void)guestLogin:(NSString *)userName password:(NSString *)password {
    if ([userName length] == 0 || [password length] == 0) {
        NSString *errorDes =  @"登录失败";
        [EMAlertController showErrorAlert:errorDes];
        return;
    }
    
    if (!gIsInitializedSDK) {
        gIsInitializedSDK = YES;
        EMOptions *options = [[EMDemoOptions sharedOptions] toOptions];
        [[EMClient sharedClient] initializeSDKWithOptions:options];
    }
    
    void (^finishBlock) (NSString *aName, EMError *aError) = ^(NSString *aName, EMError *aError) {
        
        if (!aError) {
            // 不设置自动登录
//            [[EMClient sharedClient].options setIsAutoLogin:YES];
//
//            EMDemoOptions *options = [EMDemoOptions sharedOptions];
//            options.isAutoLogin = YES;
//            options.loggedInUsername = userName;
//            options.loggedInPassword = password;
//            [options archive];
            
            //发送自动登录状态通知
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:[NSNumber numberWithBool:YES]];
            
            return ;
        }
        
        NSString *errorDes = @"登录失败，请重试";
        switch (aError.code) {
            case EMErrorUserNotFound:
                errorDes = @"用户ID不存在";
                break;
            case EMErrorNetworkUnavailable:
                errorDes = @"网络未连接";
                break;
            case EMErrorServerNotReachable:
                errorDes = @"无法连接服务器";
                break;
            case EMErrorUserAuthenticationFailed:
                errorDes = aError.errorDescription;
                break;
            case EMErrorUserLoginTooManyDevices:
                errorDes = @"登录设备数已达上限";
                break;
            default:
                errorDes = [NSString stringWithFormat:@"登录失败，请重试,错误码%d", aError.code];
                break;
        }
        [EMAlertController showErrorAlert:errorDes];
    };
    
    [[EMClient sharedClient] loginWithUsername:userName password:password completion:finishBlock];
}


/**
 设置未绑定手机号的登陆用户 获取的临时token

 @param accessToken token
 */
- (void)setTempAccessToken:(NSString *)accessToken {
    _tempAccessTK = accessToken;
}

/**
 获取未绑定手机号的登陆用户 获取的临时token

 @return tempAccessToken
 */
- (NSString *)getTempAccessToken {
    return self.tempAccessTK;
}

- (void)setNeedInfo:(BOOL)need_info {
    UserProfileEntity *user = [UserProfileEntity getUserProfileEntity];
    if (need_info) {
        [SYSettingManager setShowNeedInfo:!need_info withUid:user.userid];
    }else {
        if ([SYSettingManager isShowNeedInfo:user.userid]) {
            return;
        }
        [SYSettingManager setShowNeedInfo:NO withUid:user.userid];
    }
}

- (BOOL)checkNextNeedInfo:(UIViewController *)showVC {
    UserProfileEntity *user = [UserProfileEntity getUserProfileEntity];
    if (![SYSettingManager isShowNeedInfo:user.userid]) {
        [self showNeedInfoPopWindows:showVC];
        return YES;
    }
    return NO;
}


- (void)setNeedMobile:(BOOL)need_mobile {
    [SYSettingManager setShowNeedMobile:need_mobile];
}

- (BOOL)getNeed_mobile {
    return [SYSettingManager isShowNeedMobile];
}


- (BOOL)checkNextNeedMobile:(UIViewController *)showVC {
    if ([SYSettingManager isShowNeedMobile]) {
        return YES;
    }
    return NO;
}


- (void)showNeedInfoPopWindows:(UIViewController *)showVC {
    if (self.popupWindow) {
        [self.popupWindow removeFromSuperview];
        self.popupWindow = nil;
    }
    self.showViewController = showVC;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.popupWindow = [[SYPopUpWindows alloc] initWithFrame:CGRectZero];
    self.popupWindow.delegate = self;
    self.popupWindow.tag = 343434;
    [self.popupWindow updatePopUpWindowsWithType:SYPopUpWindowsType_Pair withMainTitle:@"完善信息可以丰富展示内容哦~" withSubTitle:@"" withBtnTexts:@[@"取消",@"去完善"] withBtnTextColors:@[RGBACOLOR(102, 102, 102, 1),RGBACOLOR(11, 11, 11, 1)]];
    [window addSubview:self.popupWindow];
    [self.popupWindow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];

}



#pragma mark - SYPopUpWindowsDelegate

- (void)handlePopUpWindowsLeftBtnClickEvent {
    if (self.popupWindow && self.popupWindow.superview) {
        if (self.popupWindow.tag == 343434) {
            [self.popupWindow removeFromSuperview];
            self.popupWindow = nil;
        }
    }
    UserProfileEntity *user = [UserProfileEntity getUserProfileEntity];
    [SYSettingManager setShowNeedInfo:YES withUid:user.userid];
}

- (void)handlePopUpWindowsRightBtnClickEvent {
    if (self.popupWindow && self.popupWindow.superview) {
        if (self.popupWindow.tag == 343434) {
            [self.popupWindow removeFromSuperview];
            self.popupWindow = nil;
            if (self.showViewController) {
                SYPerfectUserInfoVC *vc = [[SYPerfectUserInfoVC alloc] init];
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                [self.showViewController presentViewController:vc animated:YES completion:nil];
            }
        }
    }
}


- (void)handlePopUpWindowsCancel {
    if (self.popupWindow && self.popupWindow.tag == 343434) {
        self.popupWindow = nil;
    }
    UserProfileEntity *user = [UserProfileEntity getUserProfileEntity];
    [SYSettingManager setShowNeedInfo:YES withUid:user.userid];
}

@end

@implementation UserProfileEntity
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.userid forKey:@"userid"];
    [aCoder encodeObject:self.bestid forKey:@"bestid"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    [aCoder encodeObject:self.signature forKey:@"signature"];
    [aCoder encodeObject:self.residence_place forKey:@"residence_place"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.reg_time forKey:@"reg_time"];
    [aCoder encodeObject:self.em_username forKey:@"em_username"];

    [aCoder encodeInteger:self.status_flag forKey:@"status_flag"];
    [aCoder encodeInteger:self.level forKey:@"level"];
    [aCoder encodeInteger:self.level_point forKey:@"level_point"];
    [aCoder encodeInteger:self.vipright forKey:@"vipright"];
    [aCoder encodeInteger:self.vehicle forKey:@"vehicle"];
    [aCoder encodeInteger:self.avatarbox forKey:@"avatarbox"];
    [aCoder encodeInteger:self.voice_duration forKey:@"voice_duration"];

    [aCoder encodeObject:self.avatar_imgurl forKey:@"avatar_imgurl"];
    [aCoder encodeObject:self.photo_imgurl1 forKey:@"photo_imgurl1"];
    [aCoder encodeObject:self.photo_imgurl2 forKey:@"photo_imgurl2"];
    [aCoder encodeObject:self.photo_imgurl3 forKey:@"photo_imgurl3"];
    [aCoder encodeObject:self.voice_url forKey:@"voice_url"];
    [aCoder encodeObject:self.video_url forKey:@"video_url"];
    [aCoder encodeObject:self.video_imgurl forKey:@"video_imgurl"];
    [aCoder encodeInteger:self.streamer_level forKey:@"streamer_level"];
    [aCoder encodeInteger:self.is_streamer forKey:@"is_streamer"];
    [aCoder encodeInteger:self.streamer_roomid forKey:@"streamer_roomid"];
    [aCoder encodeObject:self.streamer_roomname forKey:@"streamer_roomname"];
    [aCoder encodeInteger:self.auth_model forKey:@"auth_model"];
    [aCoder encodeInteger:self.is_super_admin forKey:@"is_super_admin"];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]){
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.userid = [aDecoder decodeObjectForKey:@"userid"];
        self.bestid = [aDecoder decodeObjectForKey:@"bestid"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
        self.signature = [aDecoder decodeObjectForKey:@"signature"];
        self.residence_place = [aDecoder decodeObjectForKey:@"residence_place"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.reg_time = [aDecoder decodeObjectForKey:@"reg_time"];
        self.em_username = [aDecoder decodeObjectForKey:@"em_username"];

        self.status_flag = [aDecoder decodeIntegerForKey:@"status_flag"];
        self.level = [aDecoder decodeIntegerForKey:@"level"];
        self.level_point = [aDecoder decodeIntegerForKey:@"level_point"];
        self.vipright = [aDecoder decodeIntegerForKey:@"vipright"];
        self.vehicle = [aDecoder decodeIntegerForKey:@"vehicle"];
        self.avatarbox = [aDecoder decodeIntegerForKey:@"avatarbox"];
        self.voice_duration = [aDecoder decodeIntegerForKey:@"voice_duration"];
        self.avatar_imgurl = [aDecoder decodeObjectForKey:@"avatar_imgurl"];
        self.photo_imgurl1 = [aDecoder decodeObjectForKey:@"photo_imgurl1"];
        self.photo_imgurl2 = [aDecoder decodeObjectForKey:@"photo_imgurl2"];
        self.photo_imgurl3 = [aDecoder decodeObjectForKey:@"photo_imgurl3"];
        self.voice_url = [aDecoder decodeObjectForKey:@"voice_url"];
        self.video_url = [aDecoder decodeObjectForKey:@"video_url"];
        self.video_imgurl = [aDecoder decodeObjectForKey:@"video_imgurl"];
        self.is_streamer = [aDecoder decodeIntegerForKey:@"is_streamer"];
        self.streamer_level = [aDecoder decodeIntegerForKey:@"streamer_level"];
        self.streamer_roomid = [aDecoder decodeIntegerForKey:@"streamer_roomid"];
        self.streamer_roomname = [aDecoder decodeObjectForKey:@"streamer_roomname"];
        self.auth_model = [aDecoder decodeIntegerForKey:@"auth_model"];
        self.is_super_admin = [aDecoder decodeIntegerForKey:@"is_super_admin"];
    }
    return self;
}

+ (instancetype) initWithPFObject:(PFObject *)object
{
    UserProfileEntity *entity = [[UserProfileEntity alloc] init];
    entity.username = object[kPARSE_HXUSER_USERNAME];
    entity.nickname = object[kPARSE_HXUSER_NICKNAME];
    entity.userid   = object[kPARSE_HXUSER_UID];
    PFFile *userImageFile = object[kPARSE_HXUSER_AVATAR];
    if (userImageFile) {
        entity.imageUrl = userImageFile.url;
    }
    return entity;
}

+ (void)saveUserProfileEntity:(NSDictionary *)userDict
{
    if ([NSObject sy_empty:userDict]) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"userinfo"];
        [defaults synchronize];
        return;
    }
    UserProfileEntity *entity = [UserProfileEntity yy_modelWithDictionary:userDict];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSData * data  = [NSKeyedArchiver archivedDataWithRootObject:entity];
    
    [defaults setObject:data forKey:@"userinfo"];
    
    [defaults synchronize];
}

+ (instancetype) getUserProfileEntity
{
    NSData * data = [[NSUserDefaults standardUserDefaults]objectForKey:@"userinfo"];

    UserProfileEntity *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (!userInfo) {
        userInfo = [UserProfileEntity new];
        userInfo.username = @"乐视视频游客用户";
//        userInfo.guestId = [SYSettingManager guestId];
    }

    return userInfo;
}

+ (void)saveOtherUserInfo:(UserProfileEntity *)userInfo
{
    if ([NSObject sy_empty:userInfo]) {
        return;
    }
    NSString *em_userName = userInfo.em_username;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    
    [defaults setObject:data forKey:em_userName];
    
    [defaults synchronize];
}

+ (instancetype)getUserProfileEntityByEMUserName:(NSString *)em_userName
{
    NSData * data = [[NSUserDefaults standardUserDefaults]objectForKey:em_userName];
    
    if([NSObject sy_empty:data]){
        return nil;
    }
    UserProfileEntity *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return userInfo;
}

- (NSString *)firstLetterWithUserName {
    NSMutableString *name = [self.username mutableCopy];
    CFStringTransform((CFMutableStringRef)name, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)name, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinYin = [name capitalizedString];
    if (pinYin && pinYin.length > 0) {
        return [pinYin substringToIndex:1];
    }
    return @"";
}

@end
