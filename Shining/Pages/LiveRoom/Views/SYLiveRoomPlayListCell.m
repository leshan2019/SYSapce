//
//  SYLiveRoomPlayListCell.m
//  Shining
//
//  Created by mengxiangjian on 2019/11/13.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomPlayListCell.h"

@interface SYLiveRoomPlayListCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIVisualEffectView *blurView;

@end

@implementation SYLiveRoomPlayListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.coverImageView];
        [self addSubview:self.blurView];
    }
    return self;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverImageView;
}

- (UIVisualEffectView *)blurView {
    if (!_blurView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        //  毛玻璃view 视图
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.frame = self.bounds;
        _blurView = effectView;
    }
    return _blurView;
}

- (void)showWithRoomCoverURL:(NSString *)url {
    [self.coverImageView setImageWithURL:[NSURL URLWithString:url]];
}

@end
