//
//  UIView+SYExtension.h
//  Shining
//
//  Created by letv_lzb on 2019/3/14.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SYExtension)

@property (nonatomic, assign) CGFloat sy_top;
@property (nonatomic, assign) CGFloat sy_bottom;
@property (nonatomic, assign) CGFloat sy_left;
@property (nonatomic, assign) CGFloat sy_right;
@property (nonatomic, assign) CGFloat sy_x;
@property (nonatomic, assign) CGFloat sy_y;
@property (nonatomic, assign) CGFloat sy_centerX;
@property (nonatomic, assign) CGFloat sy_centerY;
@property (nonatomic, assign) CGFloat sy_width;
@property (nonatomic, assign) CGFloat sy_height;
@property (nonatomic, assign) CGSize  sy_size;
@property (nonatomic, assign) CGPoint sy_origin;

/**
 *  给view切圆角
 *  corners : 哪个角
 *  cornerRadii : 圆角size
 */
- (instancetype)sy_cornerByRoundingCorners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius;
/**
 *  给view所有角切圆角
 *  cornerRadii : 圆角size
 */
- (instancetype)sy_cornerAllCornersWithCornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
