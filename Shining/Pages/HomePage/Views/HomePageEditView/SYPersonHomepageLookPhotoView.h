//
//  SYPersonHomepageLookPhotoView.h
//  Shining
//
//  Created by 杨玄 on 2019/4/30.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYPersonHomepageLookPhotoViewDelegate <NSObject>

// 删除照片
- (void)SYPersonHomepageLookPhotoViewDeletePhoto:(NSString *)photoUrl;

@end

NS_ASSUME_NONNULL_BEGIN

/**
 *  个人主页编辑VC - 查看形象照view
 */
@interface SYPersonHomepageLookPhotoView : UIView

@property (nonatomic, weak) id <SYPersonHomepageLookPhotoViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withPhotoUrl:(NSString *)url canDelete:(BOOL)canDelete;

@end

NS_ASSUME_NONNULL_END
