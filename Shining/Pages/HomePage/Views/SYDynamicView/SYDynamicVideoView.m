//
//  SYDynamicVideoView.m
//  Shining
//
//  Created by yangxuan on 2019/10/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYDynamicVideoView.h"
#import "SYUserDynamicModel.h"

@interface SYDynamicVideoView ()

@property (nonatomic, copy) ClickVideo clickBlock;
@property (nonatomic, strong) NSDictionary *videoDic;

@end

@implementation SYDynamicVideoView

- (instancetype)initWithFrame:(CGRect)frame clickVideo:(ClickVideo)clickBlock {
    self = [super initWithFrame:frame];
    if (self) {
        self.clickBlock = clickBlock;
    }
    return self;
}

- (void)configueVideoView:(NSDictionary *)videoDic {
    _videoDic = videoDic;
    [self removeAllSubViews];
    if (videoDic) {
        NSString *videoCover = [videoDic objectForKey:SYDynamicVideoCover];
        CGFloat width = [self calculateVideoViewWidth:videoDic];
        CGFloat height = [SYDynamicVideoView calculateVideoViewHeight:videoDic];
        CGRect frame = CGRectMake(0, 0, width, height);
        UIImageView *imageView = [self createImageWithFrame:frame imageUrl:videoCover];
        [self addSubview:imageView];
    }
}

- (CGFloat)calculateVideoViewWidth:(NSDictionary *)videoDic {
    if (videoDic) {
        NSString *videoUrl = [videoDic objectForKey:SYDynamicVideoUrl];
        NSString *videoCover = [videoDic objectForKey:SYDynamicVideoCover];
        if (videoUrl.length > 0 && videoCover.length > 0) {
            return 110;
        }
    }
    return 0;
}

+ (CGFloat)calculateVideoViewHeight:(NSDictionary *)videoDic {
    if (videoDic) {
        NSString *videoUrl = [videoDic objectForKey:SYDynamicVideoUrl];
        NSString *videoCover = [videoDic objectForKey:SYDynamicVideoCover];
        if (videoUrl.length > 0 && videoCover.length > 0) {
            return 195;
        }
    }
    return 0;
}

#pragma mark - Private

- (UIImageView *)createImageWithFrame:(CGRect)frame imageUrl:(NSString *)imageUrl {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.backgroundColor = [UIColor blackColor];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    imageView.layer.cornerRadius = 4;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    UIImageView *playIcon = [UIImageView new];
    playIcon.image = [UIImage imageNamed_sy:@"homepage_dynamic_video_play"];
    [imageView addSubview:playIcon];
    [playIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.center.equalTo(imageView);
    }];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickVideo)];
    [imageView addGestureRecognizer:gesture];
    return imageView;
}

- (void)clickVideo {
    if (self.clickBlock) {
        self.clickBlock([self.videoDic objectForKey:SYDynamicVideoUrl]);
    }
}

- (void)removeAllSubViews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end
