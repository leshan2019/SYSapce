//
//  SYCreateActivityImageCell.m
//  Shining
//
//  Created by mengxiangjian on 2019/10/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYCreateActivityImageCell.h"

@interface SYCreateActivityImageCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation SYCreateActivityImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.closeButton];
    }
    return self;
}

- (void)showWithImageData:(NSData *)data
               plusButton:(BOOL)plusButton {
    self.imageView.image = [UIImage imageWithData:data];
    self.closeButton.hidden = plusButton;
    if (plusButton) {
//        self.imageView.backgroundColor = [UIColor lightGrayColor];
        self.imageView.image = [UIImage imageNamed_sy:@"createActivity_add"];
    }
}

- (UIImageView *)getClickImageView {
    return self.imageView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        CGFloat width = 80.f;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.sy_height - width, width, width)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        CGFloat width = 18.f;
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(self.sy_width - width, 0, width, width);
        [_closeButton setImage:[UIImage imageNamed_sy:@"createActivity_delete"]
                      forState:UIControlStateNormal];
        [_closeButton addTarget:self
                         action:@selector(cancel:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (void)cancel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(createActivityImageCellDidCancelWithCell:)]) {
        [self.delegate createActivityImageCellDidCancelWithCell:self];
    }
}

@end
