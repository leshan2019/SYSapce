//
//  SYActivityVideoPlayView.h
//  Shining
//
//  Created by yangxuan on 2019/11/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYActivityVideoPlayViewDelegate <NSObject>

- (void)SYActivityVideoPlayViewPlayVideo:(NSString *_Nonnull)videoUrl;
- (void)SYActivityVideoPlayViewDeleteVideo;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SYActivityVideoPlayView : UIView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id <SYActivityVideoPlayViewDelegate>)delegate;

- (void)configueVideo:(NSString *)video videoCover:(UIImage *)cover;

@end

NS_ASSUME_NONNULL_END
