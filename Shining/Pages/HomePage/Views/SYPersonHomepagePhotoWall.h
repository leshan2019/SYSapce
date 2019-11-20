//
//  SYPersonHomepagePhotoWall.h
//  Shining
//
//  Created by 杨玄 on 2019/4/18.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYPersonHomepagePhotoWallDelegate <NSObject>

// 点击播放小视频
- (void)handleSYPersonHomepagePhotoWallVideoClick:(NSString *_Nullable)videoUrl;

@end

NS_ASSUME_NONNULL_BEGIN

/**
 *  个人主页 - 照片墙
 */
@interface SYPersonHomepagePhotoWall : UIView

@property (nonatomic, weak) id <SYPersonHomepagePhotoWallDelegate> delegate;

- (void)updatePhotoWallWithPhotos:(NSArray<NSString *> *)photoArr videoImage:(NSString *)videoImageUrl videoUrl:(NSString *)videoUrl;

@end

NS_ASSUME_NONNULL_END
