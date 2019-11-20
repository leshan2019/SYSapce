//
//  SYDynamicPhotoView.h
//  Shining
//
//  Created by yangxuan on 2019/10/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickPhoto)(NSString * _Nonnull imageUrl);

NS_ASSUME_NONNULL_BEGIN

// 动态Cell - 图片
@interface SYDynamicPhotoView : UIView

// init
- (instancetype)initWithFrame:(CGRect)frame clickPhoto:(ClickPhoto)clickBlock;

// confiuePhoto
- (void)configuePhotoView:(NSArray *)photoArr;

// calculateHeight
+ (CGFloat)calculatePhotoViewHeight:(NSInteger)photoCount;

@end

NS_ASSUME_NONNULL_END
