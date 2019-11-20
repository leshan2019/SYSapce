//
//  SYImageCutterViewController.h
//  Shining
//
//  Created by 杨玄 on 2019/5/15.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYImageCutterViewController;

@protocol SYImageCutterViewControllerDelegate <NSObject>

// 取消
- (void)SYImageCutterVCClickCancelBtn:(SYImageCutterViewController *_Nonnull)VC;

// 确定
- (void)SYImageCutterVC:(SYImageCutterViewController *)VC clickEnterBtnWithEditedImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_BEGIN

/**
 *  图片编辑器
 */
@interface SYImageCutterViewController : UIViewController

@property (nonatomic, weak) id <SYImageCutterViewControllerDelegate> delegate;

- (instancetype)initSYImageCutterVCWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end

NS_ASSUME_NONNULL_END
