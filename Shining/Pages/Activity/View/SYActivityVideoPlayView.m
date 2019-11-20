//
//  SYActivityVideoPlayView.m
//  Shining
//
//  Created by yangxuan on 2019/11/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYActivityVideoPlayView.h"

@interface SYActivityVideoPlayView ()

@property (nonatomic, weak) id <SYActivityVideoPlayViewDelegate> delegate;

@property (nonatomic, strong) NSString *videoUrl;
@property (nonatomic, strong) UIImage *videoCover;

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIImageView *playIcon;

@end

@implementation SYActivityVideoPlayView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SYActivityVideoPlayViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        self.delegate = delegate;
    }
    return self;
}

- (void)configueVideo:(NSString *)video videoCover:(UIImage *)cover {
    self.videoUrl = video;
    self.videoCover = cover;
    self.coverImageView.image = cover;
}

// playVideo
- (void)playVideo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SYActivityVideoPlayViewPlayVideo:)]) {
        [self.delegate SYActivityVideoPlayViewPlayVideo:self.videoUrl];
    }
}

// 删除此视频
- (void)handleDeleteVideo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SYActivityVideoPlayViewDeleteVideo)]) {
        [self.delegate SYActivityVideoPlayViewDeleteVideo];
    }
}

- (void)initSubViews {
    [self addSubview:self.coverImageView];
    [self.coverImageView addSubview:self.playIcon];
    [self addSubview:self.deleteBtn];
    [self mas_makeContraints];
}

- (void)mas_makeContraints {
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(110, 195));
        make.left.equalTo(self);
        make.bottom.equalTo(self);
    }];
    [self.playIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.center.equalTo(self.coverImageView);
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.top.equalTo(self.coverImageView).with.offset(-9);
        make.right.equalTo(self.coverImageView).with.offset(9);
    }];
}

#pragma mark - LazyLoad {

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [UIImageView new];
        _coverImageView.clipsToBounds = YES;
        _coverImageView.layer.cornerRadius = 4;
        _coverImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo)];
        [_coverImageView addGestureRecognizer:gesture];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        _coverImageView.backgroundColor = [UIColor blackColor];
    }
    return _coverImageView;
}

- (UIImageView *)playIcon {
    if (!_playIcon) {
        _playIcon = [UIImageView new];
        _playIcon.image = [UIImage imageNamed_sy:@"homepage_dynamic_video_play"];
    }
    return _playIcon;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton new];
        [_deleteBtn setImage:[UIImage imageNamed_sy:@"createActivity_delete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(handleDeleteVideo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

@end
