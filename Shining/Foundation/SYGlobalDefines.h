//
//  SYGlobalDefines.h
//  Shining
//
//  Created by mengxiangjian on 2019/2/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//
#ifndef SYGlobalDefines_h
#define SYGlobalDefines_h

#define weakify(...) \
    rac_keywordify \
    metamacro_foreach_cxt(rac_weakify_,, __weak, __VA_ARGS__)


#define strongify(...) \
    rac_keywordify \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wshadow\"") \
    metamacro_foreach(rac_strongify_,, __VA_ARGS__) \
    _Pragma("clang diagnostic pop")


//设备屏幕大小
#define __MainScreenFrame   [[UIScreen mainScreen] bounds]
//设备屏幕宽
#define __MainScreen_Width  ((__MainScreenFrame.size.width)<(__MainScreenFrame.size.height)?(__MainScreenFrame.size.width):(__MainScreenFrame.size.height))
#define __MainScreen_Height ((__MainScreenFrame.size.height)>(__MainScreenFrame.size.width)?(__MainScreenFrame.size.height):(__MainScreenFrame.size.width))

#define iPhone5 (CGSizeEqualToSize(CGSizeMake(320, 568), CGSizeMake(__MainScreen_Width, __MainScreen_Height)))
#define iPhone6 (CGSizeEqualToSize(CGSizeMake(375, 667), CGSizeMake(__MainScreen_Width, __MainScreen_Height)))
#define iPhoneXsMax (CGSizeEqualToSize(CGSizeMake(414, 896), CGSizeMake(__MainScreen_Width, __MainScreen_Height)))
#define iPhoneX (CGSizeEqualToSize(CGSizeMake(375, 812), CGSizeMake(__MainScreen_Width, __MainScreen_Height)) || iPhoneXsMax)
//#define ShiningSdk
#define SHANYIN_PCODE   @"220210000"
#define KNOTIFICATION_USERINFOREADY @"ShiningUserInfoReady"

#ifdef ShiningSdk
#define SHANYIN_VERSION @"1.6"
#else
#define UseSettingTestDevEnv
#define SHANYIN_VERSION ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
#endif

// 人脸license文件名
#define FACE_LICENSE_NAME    @"idl-license"
// 人脸license后缀
#define FACE_LICENSE_SUFFIX  @"face-ios"

// （您申请的应用名称(appname)+「-face-ios」后缀，如申请的应用名称(appname)为test123，则此处填写test123-face-ios）
// 在后台 -> 产品服务 -> 人脸识别 -> 客户端SDK管理查看，如果没有的话就新建一个
#define FACE_LICENSE_ID        @"LetvBeeFace-face-ios"

// OCR license文件名
#define OCR_LICENSE_NAME @"aip"
// OCR license后缀
#define OCR_LICENSE_SUFFIX @"license"

// 以下两个在后台 -> 产品服务 -> 人脸识别 -> 应用列表下面查看，如果没有的话就新建一个
// 您的API Key
#define FACE_API_KEY @"yBi8HRDiG3PbsB2gQDBpalj2"

// 您的Secret Key
#define FACE_SECRET_KEY @"3NzaltTWXEOqdj665hslrf5P7QjndAff"
#define dp  [UIScreen mainScreen].bounds.size.width / 375.0
typedef NS_ENUM(NSInteger, ThridPlatFormType) {
    ThridPlatFormNone,//默认从0开始
    ThridPlatFormWeChat,
    ThridPlatFormQQ,
    ThirdPlatFormLetv
};

typedef enum : NSUInteger {
    SYChildIdentityLevelHigh = 0, // 未成年限制等级高
    SYChildIdentityLevelLow, // 低，可以跳过认证
    SYChildIdentityLevelNone, // 无
} SYChildIdentityLevel;

typedef enum : NSUInteger {
    SYUserModeUnknown = 1,
    SYUserModeAdult,
    SYUserModeTeenager,
} SYUserMode;

#define SY_AMAP_APPKEY @"334e46d29c15576c39ec479e2d6fbb0e"

typedef NS_ENUM(NSInteger, FirstCategoryType) {
    FirstCategoryType_default,             //默认
    FirstCategoryType_voice,               // 音频
    FirstCategoryType_video,               // 视频
    FirstCategoryType_hot,                 // 热门
};

#endif /* SYGlobalDefines_h */
