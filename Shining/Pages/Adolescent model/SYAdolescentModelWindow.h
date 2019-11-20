//
//  SYAdolescentModelWindow.h
//  Shining
//
//  Created by 杨玄 on 2019/9/2.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AuthenClick)(void);               // 去认证回调
typedef void(^AdolescentModelClick)(void);      // 不认证，进入青少年模式回调
typedef void(^TemporaryAuthenClick)(void);      // 暂停认证，进入正常模式

// 青少年模式类型
typedef enum : NSUInteger {
    SYAdolescentModelType_Normal,
    SYAdolescentModelType_Strict
} SYAdolescentModelType;

NS_ASSUME_NONNULL_BEGIN

/**
 *  青少年模式弹窗
 */
@interface SYAdolescentModelWindow : UIView

// createWindow
+ (instancetype)createSYAdolescentModelWindowWithType:(SYAdolescentModelType)type
                                               Authen:(AuthenClick)authenClick
                                      AdolescentModel:(AdolescentModelClick)adolesClick
                                       TempraryAuthen:(TemporaryAuthenClick)temporaryClick;

@end

NS_ASSUME_NONNULL_END
