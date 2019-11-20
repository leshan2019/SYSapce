//
//  SYDynamicVideoView.h
//  Shining
//
//  Created by yangxuan on 2019/10/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickVideo)(NSString * _Nonnull videoUrl);

NS_ASSUME_NONNULL_BEGIN

// 动态Cell - 视频
@interface SYDynamicVideoView : UIView

// init
- (instancetype)initWithFrame:(CGRect)frame clickVideo:(ClickVideo)clickBlock;

// confiueVideo
- (void)configueVideoView:(NSDictionary *)videoDic;

// calculateHeight
+ (CGFloat)calculateVideoViewHeight:(NSDictionary *)videoDic;

@end

NS_ASSUME_NONNULL_END
