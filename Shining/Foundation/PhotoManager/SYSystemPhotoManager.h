//
//  SYSystemPhotoManager.h
//  Shining
//
//  Created by 杨玄 on 2019/3/13.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

// 获取的图片比例
typedef enum : NSUInteger {
    SYSystemPhotoRatio_OneToOne,            // 1:1
    SYSystemPhotoRatio_SixteenToNine,       // 16:9
    SYSystemPhotoRatio_IDCard,              // 身份证
} SYSystemPhotoSizeRatioType;

typedef void(^completeBlock)(SYSystemPhotoSizeRatioType type, UIImage * _Nonnull image);

NS_ASSUME_NONNULL_BEGIN

@interface SYSystemPhotoManager : NSObject

- (instancetype)initWithViewController:(UIViewController *)vc withBlock:(completeBlock)complete;

// 更新获取图片比例类型
- (void)updateSYSystemPhotoRatioType:(SYSystemPhotoSizeRatioType)type;

// 打开摄像头
- (void)openPhotoGraph;

// 打开手机相册
- (void)openPhotoAlbum;

+ (BOOL)checkCameraPermission;
+ (BOOL)checkPhotoAlbumPermission;
+ (void)handleForPermissionDeny:(UIViewController *)controller isCameraOrPhoto:(BOOL)isCamera;
+ (void)showPermissionDenyAlert:(UIViewController *)controller isCameraOrPhoto:(BOOL)isCamera;

@end

NS_ASSUME_NONNULL_END
