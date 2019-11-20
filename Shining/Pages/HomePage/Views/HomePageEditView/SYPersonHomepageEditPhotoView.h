//
//  SYPersonHomepageEditPhotoView.h
//  Shining
//
//  Created by 杨玄 on 2019/4/26.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  形象照类型
 */
typedef enum : NSUInteger {
    SYHomepagePhotoType_Unknown,    // 未知
    SYHomepagePhotoType_First,      // 第一张形象照
    SYHomepagePhotoType_Second,     // 第二张形象照
    SYHomepagePhotoType_Third,      // 第三张形象照
} SYHomepagePhotoType;

@protocol SYPersonHomepageEditPhotoViewDelegate <NSObject>

// 点击上传照片按钮
- (void)handleHomepageEditPhotoViewUploadBtnCLickEvent;

// 点击单张照片
- (void)handleHomepageEditPhotoViewPhotoClick:(NSString *)photoUrl withType:(SYHomepagePhotoType)type;

@end

NS_ASSUME_NONNULL_BEGIN

/**
 *  个人主页编辑 - 形象照view
 */
@interface SYPersonHomepageEditPhotoView : UIView

@property (nonatomic, weak) id <SYPersonHomepageEditPhotoViewDelegate> delegate;

// 更新形象照
- (void)updateHomepageEditPhotoViewWithPhotoOne:(NSString *)photo1
                                       photoTwo:(NSString *)photo2
                                     photoThree:(NSString *)photo3;

@end

NS_ASSUME_NONNULL_END
